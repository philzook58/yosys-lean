"""Actual Lean/RTL traces plus independent multiplication and protocol checks."""
import random
import re
from smt import read_model


def check_multiplier(args, run, model, env, root, *, name="ShiftAdd", latency=32):
    rng = random.Random(32064)
    edges = [0, 1, 2, 0x7fffffff, 0x80000000, 0xffffffff, 0x55555555, 0xaaaaaaaa]
    operands = [(a, b) for a in edges for b in edges]
    operands += [(rng.getrandbits(32), rng.getrandbits(32)) for _ in range(128)]
    samples = [(1, 0, 0, 0)]
    for a, b in operands:
        samples.append((0, 1, a, b))
        # Noise deliberately includes starts on the final busy edge.
        samples.extend((0, rng.randrange(2), rng.getrandbits(32), rng.getrandbits(32))
                       for _ in range(latency))
        samples.append((0, 0, 0, 0))
    # Abort at several points, then accept a fresh request without a reset gap.
    for delay in (0, 1, latency // 2 - 1, latency - 1):
        samples.append((0, 1, 0xffffffff, 0xffffffff))
        samples.extend((0, 1, 7, 11) for _ in range(delay))
        samples.append((1, 1, 17, 19))
    samples += [(0, 1, 123456789, 987654321)] + [(0, 1, 3, 5)] * latency
    samples += [(0, 0, 0, 0)] * 2
    fields, _, _, _ = read_model(model.read_text())
    observations = [("o", f) for f, _ in fields["Outputs"]]
    observations += [("next", f) for f, _ in fields["State"]]
    csv = args.work / (name + ".csv")
    csv.write_text("\n".join(",".join(map(str, row)) for row in samples) + "\n")
    display = ",".join("{" + obj + "." + field + ".toNat}" for obj, field in observations)
    runner = args.work / ("Run" + name + ".lean")
    runner.write_text(f"import {name}\nopen v_{name}\n"
        + "def main (args : List String) : IO Unit := do\n"
        + "  let lines ← IO.FS.lines args[0]!\n  let mut state : State := default\n"
        + "  for line in lines do\n    let n := (line.splitOn \",\").map String.toNat!\n"
        + "    let i : Inputs := ⟨BitVec.ofNat 1 n[0]!, BitVec.ofNat 1 n[1]!,\n"
        + "      BitVec.ofNat 32 n[2]!, BitVec.ofNat 32 n[3]!⟩\n"
        + "    let (o, next) := eval i state\n"
        + f'    IO.println s!"{display}"\n    state := next\n')
    run([args.lake, "env", "lean", "-o", args.work / (name + ".olean"), model], env=env)
    actual = run([args.lake, "env", "lean", "--run", runner, csv], env=env).stdout.splitlines()
    outs = [field.removeprefix("v_") for field, _ in fields["Outputs"]]
    states = ["dut." + field.removeprefix("v_") for field, _ in fields["State"]]
    outfmt = ",".join(["%0d"] * len(outs))
    statefmt = ",".join(["%0d"] * len(states))
    initialize = " ".join(name + "=0;" for name in states)
    tb = args.work / (name + "_tb.v")
    tb.write_text("module tb; reg clk,reset,start; reg [31:0] a,b;\n"
        + "wire busy,done; wire [63:0] product;\n"
        + f"{name} dut(clk,reset,start,a,b,busy,done,product);\n"
        + "integer fd,status; initial begin clk=0; #1; " + initialize
        + f' fd=$fopen("{csv}","r"); while(!$feof(fd)) begin\n'
        + 'status=$fscanf(fd,"%d,%d,%d,%d\\n",reset,start,a,b);\n'
        + f'if(status==4) begin clk=0; #1; $write("{outfmt},",{",".join(outs)});\n'
        + f'clk=1; #1; $display("{statefmt}",{",".join(states)}); end end\n'
        + "$finish; end endmodule\n")
    binary = args.work / (name + ".vvp")
    run([args.iverilog, "-g2012", "-s", "tb", "-o", binary,
         root / f"examples/multiplier/{name}.v", tb])
    expected = [line for line in run([args.vvp, binary]).stdout.splitlines()
                if re.match(r"^\d+,", line)]
    assert len(actual) == len(expected) == len(samples)
    busy, done, cycles, target, completed, aborted = 0, 0, 0, 0, 0, 0
    previous_product = 0
    request_a, request_b, position = 0, 0, 0
    for k, (sample, row, rtl) in enumerate(zip(samples, actual, expected)):
        assert row == rtl, (k, sample, row, rtl)
        values = list(map(int, row.split(",")))
        out = dict(zip((f for f, _ in fields["Outputs"]), values))
        nxt = dict(zip((f for f, _ in fields["State"]), values[len(outs):]))
        reset, start, a, b = sample
        assert out["v_busy"] == busy and out["v_done"] == done, (k, sample)
        assert out["v_product"] == previous_product
        done = 0
        if reset:
            aborted += busy
            busy, cycles, position = 0, 0, 0
            assert nxt["v_product"] == 0
        elif busy:
            cycles -= 1
            position += 32 // latency
            # Closed-form partial product, independent of the shift/add recurrence.
            assert nxt["v_product"] == request_a * (request_b & ((1 << position) - 1))
            if cycles == 0:
                busy, done = 0, 1
                completed += 1
                assert nxt["v_product"] == target, (k, target, nxt)
        elif start:
            busy, cycles, target, position = 1, latency, a * b, 0
            request_a, request_b = a, b
            assert nxt["v_product"] == 0
        else:
            assert nxt["v_product"] == previous_product
        assert nxt["v_busy"] == busy and nxt["v_done"] == done
        assert nxt["v_remaining"] == cycles
        if name == "BarrelMul":
            assert nxt["v_position"] == position
        previous_product = nxt["v_product"]
    assert completed == len(operands) + 1 and aborted == 4
    print(f"PASS: {name} multiplier, {len(samples)} Lean/RTL edges, {completed} full-width products, "
          f"{aborted} reset aborts; exact latency, busy input noise, and done pulses", flush=True)
