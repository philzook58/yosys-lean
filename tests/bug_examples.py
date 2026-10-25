"""Replay Lean-certified witnesses against actual RTL, including repaired controls."""
import csv
import re
import sys
from smt import read_model


def check_bug_examples(args, run, root):
    result = run([sys.executable, root / "scripts/check_lean.py", "--run",
                  root / "Examples/ReplayCounterexamples.lean"])
    (args.work / "CounterexampleReplay.txt").write_text(result.stdout)
    sections, current = {}, None
    for line in result.stdout.splitlines():
        if line.startswith("CASE "):
            current = line.split()[1]
            sections[current] = []
        elif current and (line.startswith("sample,") or re.match(r"^\d+,", line)):
            sections[current].append(line)
    assert len(sections) == 6
    for short, top, csv_name, outputs, initialize, failing_sample in [
        ("Counter", "Counter", "counter.csv", ["count"], "dut.count=0;", 11),
        ("Stall", "StallBuffer", "stall.csv", ["in_ready", "out_valid", "out_data"],
         "dut.full=0; dut.data=0;", 3),
        ("Shift", "ShiftWidth", "shift.csv", ["result"], "", 0),
    ]:
        with (root / "examples/bugs" / csv_name).open() as file:
            inputs = list(csv.DictReader(file))
        for fixed in (False, True):
            name = ("Fixed" if fixed else "Bug") + short
            rows = list(csv.DictReader(sections[name]))
            assert len(rows) == len(inputs)
            assert all(row["assumptions"] == "1" for row in rows)
            failures = [int(row["sample"]) for row in rows if row["assertions"] == "0"]
            assert failures == ([] if fixed else [failing_sample]), (name, failures)
            for row, sample in zip(rows, inputs):
                assert all(row[key] == value for key, value in sample.items())
            fields = read_model((root / f"Examples/Generated/{name}.lean").read_text())[0]
            widths = {field.removeprefix("v_"): width for field, width in fields["Inputs"]}
            widths.update({field.removeprefix("v_"): width for field, width in fields["Outputs"]})
            declarations = " ".join(f"reg [{widths[key]-1}:0] {key};" for key in inputs[0])
            declarations += " " + " ".join(f"wire [{widths[key]-1}:0] {key};" for key in outputs)
            clocked = short != "Shift"
            ports = [f".{key}({key})" for key in [*inputs[0], *outputs]]
            if clocked:
                ports.append(".clk(clk)")
            observations = ",".join(outputs)
            fmt = ",".join(["%0d"] * len(outputs))
            stimuli = []
            for sample in inputs:
                assign = " ".join(f"{key}={widths[key]}'d{value};" for key, value in sample.items())
                stimuli.append(f'clk=0; {assign} #1; $display("ROW,{fmt}",{observations}); '
                               + ("clk=1; #1; " if clocked else ""))
            tb = args.work / (name + "Witness_tb.v")
            wave = args.work / (name + "Witness.vcd")
            tb.write_text(f"module tb; reg clk; {declarations}\n{top} dut({','.join(ports)});\n"
                + f'initial begin $dumpfile("{wave}"); $dumpvars(0,tb); clk=0; #1; {initialize}\n'
                + "\n".join(stimuli) + "\n$finish; end endmodule\n")
            binary = args.work / (name + "Witness.vvp")
            run([args.iverilog, "-g2012", "-s", "tb", *(["-DREPAIRED"] if fixed else []),
                 "-o", binary, root / f"examples/bugs/{top}.v", tb])
            rtl = [line.split(",")[1:] for line in run([args.vvp, binary]).stdout.splitlines()
                   if line.startswith("ROW,")]
            assert rtl == [[row[key] for key in outputs] for row in rows], (name, rtl, rows)
        print(f"PASS: {short} certified counterexample, assumptions, first failure, repaired replay, "
              "and actual RTL/VCD", flush=True)
