"""Actual Lean/RTL differential checks plus independent transaction arithmetic."""
import random
import re
from smt import read_model


def check_divider(args, run, model, env, root, width):
    top = f"ZipDiv{width}"
    fields, _, _, _ = read_model(model.read_text())
    mask = (1 << width) - 1
    rng = random.Random(641 + width)
    boundary = [0, 1, 2, 3, mask, mask - 1, 1 << (width - 1), (1 << (width - 1)) - 1]
    operands = [(a, b, signed) for a in boundary for b in boundary for signed in (0, 1)]
    operands += [(rng.randrange(mask + 1), rng.randrange(mask + 1), rng.randrange(2))
                 for _ in range(100)]
    samples = [(1, 0, 0, 0, 0), (0, 0, 0, 0, 0)]
    transactions = []
    for a, b, signed in operands:
        samples.append((0, 1, signed, a, b))
        start = len(samples)
        # Change all data inputs after acceptance: the divider must latch them.
        for _ in range(width + 5):
            samples.append((0, 0, rng.randrange(2), rng.randrange(mask + 1),
                            rng.randrange(mask + 1)))
        transactions.append((start, len(samples), a, b, signed))
    # Abort work in its middle, including sign preprocessing, then recover.
    for k in range(width + 3):
        samples += [(0, 1, 1, mask, 3)] + [(0, 0, 0, 17 & mask, 5)] * k
        samples += [(1, 0, 0, 0, 0), (0, 0, 0, 0, 0)] * 2
    stimuli_file = args.work / (top + ".csv")
    stimuli_file.write_text("\n".join(",".join(map(str, row)) for row in samples) + "\n")
    runner = args.work / ("Run" + top + ".lean")
    observations = [("o", f, w) for f, w in fields["Outputs"]]
    observations += [("next", f, w) for f, w in fields["State"]]
    display = ",".join("{" + obj + "." + f + ".toNat}" for obj, f, _ in observations)
    runner.write_text(f"import {top}\nopen v_{top}\n"
        + "def main (args : List String) : IO Unit := do\n"
        + "  let lines ← IO.FS.lines args[0]!\n  let mut state : State := default\n"
        + "  for line in lines do\n    let n := (line.splitOn \",\").map String.toNat!\n"
        + "    let i : Inputs := ⟨BitVec.ofNat 1 n[0]!, BitVec.ofNat 1 n[1]!, "
        + f"BitVec.ofNat 1 n[2]!, BitVec.ofNat {width} n[3]!, BitVec.ofNat {width} n[4]!⟩\n"
        + "    let (o, next) := eval i state\n"
        + f'    IO.println s!"{display}"\n    state := next\n')
    run([args.lake, "env", "lean", "-o", args.work / (top + ".olean"), model], env=env)
    actual = run([args.lake, "env", "lean", "--run", runner, stimuli_file], env=env).stdout.splitlines()
    names = [f.removeprefix("v_") for f, _ in fields["Outputs"]]
    declarations = " ".join(f"wire [{w-1}:0] {f.removeprefix('v_')};"
                            for f, w in fields["Outputs"])
    ports = ",".join(f".{f.removeprefix('v_')}({f.removeprefix('v_')})"
                     for f, _ in fields["Inputs"])
    ports += ",.i_clk(clk)," + ",".join(f".{n}({n})" for n in names)
    initialize = " ".join(f"dut.{f.removeprefix('v_')}=0;" for f, _ in fields["State"])
    all_signals = names + ["dut." + f.removeprefix("v_") for f, _ in fields["State"]]
    tb = args.work / (top + "_tb.v")
    tb.write_text(f"module tb; reg clk,i_reset,i_wr,i_signed; "
        + f"reg [{width-1}:0] i_numerator,i_denominator; {declarations}\n"
        + f"div #(.BW({width}),.LGBW({width.bit_length()-1})) dut({ports});\n"
        + "integer fd,status; initial begin clk=0; #1; " + initialize
        + f' fd=$fopen("{stimuli_file}","r");\n'
        + 'while (!$feof(fd)) begin status=$fscanf(fd,"%d,%d,%d,%d,%d\\n",'
        + 'i_reset,i_wr,i_signed,i_numerator,i_denominator);\n'
        + "if(status==5) begin clk=0; #1; "
        + f'$write("{",".join(["%0d"] * len(names))},",{",".join(names)}); '
        + "clk=1; #1; "
        + f'$display("{",".join(["%0d"] * len(fields["State"]))}",'
        + ",".join(all_signals[len(names):]) + "); end end\n$finish; end endmodule\n")
    binary = args.work / (top + ".vvp")
    run([args.iverilog, "-g2012", "-s", "tb", "-o", binary,
         root / "examples/zipcpu/upstream/div.v", tb])
    expected = [line for line in run([args.vvp, binary]).stdout.splitlines()
                if re.match(r"^\d+,", line)]
    assert len(actual) == len(expected) == len(samples)
    for n, (a, e) in enumerate(zip(actual, expected)):
        assert a == e, (top, n, samples[n], a, e)
    rows = [dict(zip(names, map(int, row.split(",")[:len(names)]))) for row in actual]
    for start, end, a, b, signed in transactions:
        valid = [(n, row) for n, row in enumerate(rows[start:end]) if row["o_valid"]]
        assert len(valid) == 1, (top, a, b, signed, valid)
        latency, result = valid[0]
        # A row samples the state before its processing edge, so index zero is acceptance+0.
        negative_a, negative_b = bool(a >> (width - 1)), bool(b >> (width - 1))
        wanted_latency = 1 if b == 0 else width + int(signed and (negative_a or negative_b))
        wanted_latency += int(b != 0 and signed and (negative_a != negative_b))
        assert latency == wanted_latency, (top, a, b, signed, latency, wanted_latency)
        assert result["o_busy"] == 0 and result["o_err"] == int(b == 0)
        if b:
            aa = a - (1 << width) if signed and negative_a else a
            bb = b - (1 << width) if signed and negative_b else b
            quotient = abs(aa) // abs(bb)
            if (aa < 0) != (bb < 0):
                quotient = -quotient
            assert result["o_quotient"] == quotient & mask, (top, a, b, signed, result)
            assert result["o_flags"] & 1 == int((quotient & mask) == 0)
            assert (result["o_flags"] >> 2) & 1 == (quotient & mask) >> (width - 1)
    print(f"PASS: {len(samples)} {width}-bit divider Lean/RTL edges, {len(transactions)} "
          "independent arithmetic/latency checks, input noise and reset aborts", flush=True)

    if width == 32:
        # Exercise the unchanged upstream FORMAL harness over exactly the same inputs.
        formal = model.parent / "ZipDivFormal.lean"
        run([args.lake, "env", "lean", "-o", args.work / "ZipDivFormal.olean", formal], env=env)
        formal_runner = args.work / "RunZipFormal.lean"
        formal_runner.write_text("""import ZipDivFormal
open v_ZipDivFormal
instance (o : Outputs) : Decidable (assertions o) := by unfold assertions; infer_instance
instance (o : Outputs) : Decidable (assumptions o) := by unfold assumptions; infer_instance
def main (args : List String) : IO Unit := do
  let lines ← IO.FS.lines args[0]!
  let mut state : State := { (default : State) with v__initstate := 1 }
  for line in lines do
    let n := (line.splitOn ",").map String.toNat!
    let i : Inputs := ⟨BitVec.ofNat 1 n[0]!, BitVec.ofNat 1 n[1]!, BitVec.ofNat 1 n[2]!,
                       BitVec.ofNat 32 n[3]!, BitVec.ofNat 32 n[4]!⟩
    let (o, next) := eval i state
    IO.println s!"{decide (assumptions o)},{decide (assertions o)}"
    state := next
""")
        properties = run([args.lake, "env", "lean", "--run", formal_runner, stimuli_file],
                         env=env).stdout.splitlines()
        assert len(properties) == len(samples)
        for n, row in enumerate(properties):
            assert row == "true,true", ("upstream property", n, samples[n], row)
        print(f"PASS: upstream divider assumptions and assertions on all {len(samples)} "
              "full-width trace samples (execution checks, not an unbounded proof)", flush=True)
