"""Execute the real generated Lean and RTL through fetch, retire, and reset cycles."""
import random
import re


def check_two_cycle(args, run, model, env, root):
    rng = random.Random(40129)
    # The execute-edge instruction and fetch-edge memory deliberately disagree.
    samples = [
        (1, 7, 0x1111), (1, 999, 0x2222),
        (1, 0xfc10, 111), (1, 0, 222),       # D=M samples execute-edge memory.
        (1, 0xe308, 333), (1, 0x8000, 444),  # M=D retires only on execute.
        (1, 9, 0), (0, 0, 0),               # Abort a pending @9.
        (0, 0, 0), (1, 10, 0), (1, 11, 0),
    ]
    samples += [(int(rng.randrange(17) != 0), rng.randrange(65536), rng.randrange(65536))
                for _ in range(300)]
    records = ",\n".join(
        "{ v_reset := %d, v_instruction := %d, v_inM := %d }" % s for s in samples)
    runner = args.work / "RunTwoCycle.lean"
    runner.write_text("import HackTwoCycle\nopen v_HackTwoCycle\ndef main : IO Unit := do\n"
        + f"  let samples : List Inputs := [{records}]\n"
        + "  let mut state : State := { v_areg := 4660, v_dreg := 22136, v_PC := 65534, "
        + "v_ir := 43981, v_execute := 0 }\n"
        + "  for i in samples do\n    let (o, next) := eval i state\n"
        + '    IO.println s!"{o.v_PC.toNat},{o.v_addressM.toNat},{o.v_outM.toNat},'
        + '{o.v_writeM.toNat},{o.v_retire.toNat},{next.v_areg.toNat},{next.v_dreg.toNat},'
        + '{next.v_PC.toNat},{next.v_ir.toNat},{next.v_execute.toNat}"\n'
        + "    state := next\n")
    run([args.lake, "env", "lean", "-o", args.work / "HackTwoCycle.olean", model], env=env)
    actual = run([args.lake, "env", "lean", "--run", runner], env=env).stdout.splitlines()

    stimuli = "\n".join(
        f'clk=0; reset={reset}; instruction={insn}; inM={memory}; #1; '
        + '$write("%0d,%0d,%0d,%0d,%0d,",PC,addressM,outM,writeM,retire); clk=1; #1; '
        + '$display("%0d,%0d,%0d,%0d,%0d",dut.areg,dut.dreg,PC,dut.ir,dut.execute);'
        for reset, insn, memory in samples)
    tb = args.work / "TwoCycle_tb.v"
    tb.write_text("module tb; reg clk,reset; reg [15:0] instruction,inM; "
        + "wire [15:0] PC,outM; wire [14:0] addressM; wire writeM,retire;\n"
        + "HackTwoCycle dut(clk,reset,instruction,inM,outM,writeM,addressM,PC,retire);\n"
        + "initial begin clk=0; #1; dut.areg=4660; dut.dreg=22136; "
        + "dut.PC=65534; dut.ir=43981; dut.execute=0;\n"
        + stimuli + "\n$finish; end endmodule\n")
    binary = args.work / "two-cycle.vvp"
    run([args.iverilog, "-g2012", "-s", "tb", "-o", binary,
         root / "examples/hack/two-cycle/CPU.v", root / "examples/hack/original/alu.v", tb])
    expected = [line for line in run([args.vvp, binary]).stdout.splitlines()
                if re.match(r"^\d+,", line)]
    assert len(actual) == len(expected) == len(samples)
    for n, (a, e) in enumerate(zip(actual, expected)):
        assert a == e, ("two-cycle", n, samples[n], a, e)
    rows = [[int(n) for n in row.split(",")] for row in actual]
    assert rows[0][4] == 0 and rows[0][5] == 4660
    assert rows[1][4] == 1 and rows[1][5] == 7
    assert rows[3][6] == 222
    assert rows[4][3] == 0 and rows[5][3:5] == [1, 1] and rows[5][2] == 222
    for sample, row in zip(samples, rows):
        if sample[0] == 0:
            assert row[3:5] == [0, 0] and row[7] == row[9] == 0
    print(f"PASS: {len(samples)} two-cycle Lean/RTL steps, latched instructions, retirement, reset aborts",
          flush=True)
