#!/usr/bin/env python3
"""End-to-end export, symbolic comparison, real Lean/RTL execution, and proof checks."""
import argparse
import hashlib
import os
import random
import re
import resource
import signal
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))
from export import export_hack, export_divider, export_extra, EXTRA_CIRCUITS, export_multiplier, export_formal, formal_scripts, export_bus, bus_scripts, export_cpu, cpu_scripts, quote
from smt import comparison, read_model
from two_cycle import check_two_cycle
from divider import check_divider
from properties import check_properties
from stream_examples import check_examples
from multiplier import check_multiplier
from named import check_named
from formal_tutorials import check_formal_tutorials
from bug_examples import check_bug_examples
from checker import check_checker, check_readme
from bus import check_bus
from cpu import check_cpu, check_choices, check_ibex_frontend, check_nerv_replay
from nerv_program import check_nerv_program


def run(cmd, *, env=None, ok=True):
    command = list(map(str, cmd))
    # Every Lean subprocess, including --run, shares the same bounded policy.
    if "lean" in command:
        at = command.index("lean") + 1
        command[at:at] = ["-M1024", "-j1", "-s8192", "-DmaxErrors=1",
                          "-DmaxRecDepth=4096", "-DElab.async=false"]
    def limits():
        cap = 4 * 1024**3
        resource.setrlimit(resource.RLIMIT_AS, (cap, cap))
        resource.setrlimit(resource.RLIMIT_CPU, (240, 240))
    proc = subprocess.Popen(command, cwd=ROOT, env=env, text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                            preexec_fn=limits, start_new_session=True)
    try:
        stdout, stderr = proc.communicate(timeout=240)
    except subprocess.TimeoutExpired:
        os.killpg(proc.pid, signal.SIGKILL)
        proc.communicate()
        raise AssertionError(f"Timed out; stopped process group: {cmd}")
    p = subprocess.CompletedProcess(command, proc.returncode, stdout, stderr)
    if ok and p.returncode:
        raise AssertionError(f"Command failed: {cmd}\n{p.stdout}\n{p.stderr}")
    return p


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--yosys", type=Path, default=ROOT / "build/yosys/yosys")
    p.add_argument("--plugin", type=Path, default=ROOT / "build/yosys_lean.so")
    p.add_argument("--work", type=Path, default=ROOT / "build/tests")
    for name in ("lake", "z3", "iverilog", "vvp"):
        p.add_argument("--" + name, default=name)
    args = p.parse_args()
    args.work = args.work.resolve()
    args.work.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, LEAN_PATH=str(args.work))

    for filename, sha in {
        "CPU.v": "24012cc1f7d46f33acf80fee135fe56c6874d9cb",
        "PC.v": "76e00c6bd735962808b1a40fd968aa6bf4faeeeb",
        "alu.v": "9a717fae5b0b104222ce66279dd861a26a968452",
    }.items():
        data = (ROOT / "examples/hack/original" / filename).read_bytes()
        assert hashlib.sha1(b"blob " + str(len(data)).encode() + b"\0" + data).hexdigest() == sha
    for filename, sha in {
        "div.v": "5e5f5ef0d06c9fa071b624ca85278b109cda5528",
        "div.sby": "1d78c23c09a98e6de8527008310d9ded36faa1f5",
    }.items():
        data = (ROOT / "examples/zipcpu/upstream" / filename).read_bytes()
        assert hashlib.sha1(b"blob " + str(len(data)).encode() + b"\0" + data).hexdigest() == sha

    for filename, sha in {
        "sklansky_adder_32.v": "4eebd81b5944c36a77543103cdda1747e9a81223",
        "crc8.sv": "011275628265122dee6227e385be5a84d4755481",
    }.items():
        data = (ROOT / "examples/bird/upstream" / filename).read_bytes()
        assert hashlib.sha1(b"blob " + str(len(data)).encode() + b"\0" + data).hexdigest() == sha
    crc = (ROOT / "examples/bird/upstream/crc8.sv").read_text()
    adapted = (ROOT / "examples/bird/crc8_sync.sv").read_text().split("\n", 1)[1]
    assert adapted == crc.replace("module crc8", "module crc8_sync").replace(
        "@(posedge clk or negedge rst_n)", "@(posedge clk)")

    def yosys(script, ok=True):
        return run([args.yosys, "-Q", "-T", "-m", args.plugin, "-p", script], ok=ok)

    def export(top, source):
        lean = args.work / (top + ".lean")
        smt = args.work / (top + ".smt2")
        initial = f"read_verilog {quote(source)}; hierarchy -check -top {top}; "
        yosys(initial + f"lean_prepare; write_lean {quote(lean)}")
        # Independent lowering path for the established backend, with ordinary clocked FFs.
        yosys(initial + f"proc; flatten; opt_clean; dffunmap; write_smt2 -stdt -wires {quote(smt)}")
        return lean, smt

    def solve(script, expected):
        query = args.work / "query.smt2"
        query.write_text(script)
        out = run([args.z3, "-T:60", query]).stdout.strip()
        assert out == expected, out

    def symbolic(top, lean, smt):
        solve(comparison(lean.read_text(), smt.read_text(), top), "unsat")

    def check_module(name):
        result = run([sys.executable, ROOT / "scripts/check_lean.py",
                      ROOT / (name + ".lean"), "--output",
                      ROOT / ".lake/build/lib/lean" / (name + ".olean")])
        print(result.stdout, end="", flush=True)

    for name in ("YosysLean/Basic", "YosysLean/BitVec", "YosysLean", "YosysLean/Formal", "YosysLean/Check", "YosysLean/Tactic"):
        check_module(name)
    check_checker(args, run, ROOT)
    check_properties(args, run, yosys, quote, env)
    check_choices(args, run, yosys, symbolic, check_named, env, ROOT)
    ops, ops_smt = export("Ops", ROOT / "tests/ops.v")
    symbolic("Ops", ops, ops_smt)
    # A negative control verifies the equivalence query actually detects a wrong result.
    solve(comparison(ops.read_text(), ops_smt.read_text(), "Ops", corrupt=True), "sat")
    print("PASS: all operation outputs symbolically agree with write_smt2; mutation detected", flush=True)

    seq = args.work / "Seq.v"
    seq.write_text("""module Seq(input clk, reset, enable, input [7:0] data,
      output reg [7:0] q, output reg [7:0] previous);
      initial q = 8'b1x0x10x1;
      always @(posedge clk) begin
        if (reset) q <= 8'h35; else if (enable) q <= data + q;
        previous <= q;
      end
      endmodule
    """)
    seq_lean, seq_smt = export("Seq", seq)
    symbolic("Seq", seq_lean, seq_smt)
    # Check exact initial-state constraints, including unspecified bits.
    lean_text = seq_lean.read_text()
    fields, prov, _, _ = read_model(lean_text)
    constraints = []
    for field, mask, width, value in re.findall(
            r"\(state\.(\w+) &&& \(0b([01]+) : BitVec (\d+)\)\) = \(0b([01]+) : BitVec \d+\)", lean_text):
        signal = f"(|Seq_n {prov['State', field]}| curr)"
        constraints.append(f"(= (bvand {signal} #b{mask}) #b{value})")
    assert len(constraints) == len(fields["State"]) == 2
    solve(seq_smt.read_text() + "\n(declare-const curr |Seq_s|)\n"
          + "(assert (not (= (Seq_i curr) (and " + " ".join(constraints) + "))))\n(check-sat)", "unsat")
    print("PASS: arbitrary-state register updates and exact partial initialization", flush=True)

    # Determinism is a byte-for-byte property, independent of execution checks.
    before = ops.read_bytes()
    export("Ops", ROOT / "tests/ops.v")
    assert ops.read_bytes() == before

    # Real Lean execution vs four-state RTL simulation, including oversized shifts.
    rng = random.Random(82731)
    cases = [(a, b, sh, sel) for a in (0, 1, 127, 128, 255)
             for b in (0, 1, 128, 255) for sh in (0, 7, 8, 15) for sel in (0, 1)]
    cases += [tuple(rng.randrange(n) for n in (256, 256, 16, 2)) for _ in range(100)]
    fields, _, _, _ = read_model(ops.read_text())
    outputs = fields["Outputs"]
    runner = args.work / "RunOps.lean"
    records = ",\n".join("{ v_a := %d, v_b := %d, v_sh := %d, v_sel := %d }" % c for c in cases)
    display = ",".join("{o." + f + ".toNat}" for f, _ in outputs)
    runner.write_text('import Ops\nopen v_Ops\ndef main : IO Unit := do\n'
                      + f'  let cases : List Inputs := [{records}]\n'
                      + '  for i in cases do\n    let o := (eval i {}).1\n'
                      + f'    IO.println s!"{display}"\n')
    run([args.lake, "env", "lean", "-o", args.work / "Ops.olean", ops], env=env)
    actual = run([args.lake, "env", "lean", "--run", runner], env=env).stdout.splitlines()
    assert len(actual) == len(cases)
    tb = args.work / "Ops_tb.v"
    names = [f.removeprefix("v_") for f, _ in outputs]
    declarations = "\n".join(f"wire [{w-1}:0] {name};" for name, (_, w) in zip(names, outputs))
    ports = ",".join([".a(a)", ".b(b)", ".sh(sh)", ".sel(sel)"] + [f".{n}({n})" for n in names])
    fmt = ",".join("%0d" for _ in names)
    stimuli = "\n".join(f'a=8\'d{a}; b=8\'d{b}; sh=4\'d{sh}; sel={sel}; #1; '
                         + f'$display("{fmt}", {",".join(names)});' for a, b, sh, sel in cases)
    tb.write_text(f"module tb; reg [7:0] a,b; reg [3:0] sh; reg sel; {declarations}\n"
                  + f"Ops dut({ports}); initial begin {stimuli} $finish; end endmodule\n")
    binary = args.work / "ops.vvp"
    run([args.iverilog, "-g2012", "-s", "tb", "-o", binary, ROOT / "tests/ops.v", tb])
    expected = [line for line in run([args.vvp, binary]).stdout.splitlines() if re.match(r"^[0-9x]+,", line)]
    assert len(expected) == len(cases)
    for c, lean_row, rtl_row in zip(cases, actual, expected):
        for name, l, r in zip(names, lean_row.split(","), rtl_row.split(",")):
            if "x" in r:
                assert c[1] == 0 and name in ("div_", "mod_"), (c, name, r)
                assert int(l) == (255 if name == "div_" else c[0])
            else:
                assert l == r, (c, name, l, r)
    print(f"PASS: actual Lean vs Icarus for {len(cases)} operation vectors", flush=True)

    samples = [(0, 0, 255), (0, 1, 255), (1, 1, 77), (0, 0, 0)]
    samples += [tuple(rng.randrange(n) for n in (2, 2, 256)) for _ in range(100)]
    seq_runner = args.work / "RunSeq.lean"
    seq_records = ",\n".join(
        "{ v_reset := %d, v_enable := %d, v_data := %d }" % c for c in samples)
    seq_runner.write_text("import Seq\nopen v_Seq\ndef main : IO Unit := do\n"
        + f"  let samples : List Inputs := [{seq_records}]\n"
        + "  let mut state : State := { v_q := 137, v_previous := 90 }\n"
        + "  for i in samples do\n    let (o, next) := eval i state\n"
        + '    IO.println s!"{o.v_q.toNat},{o.v_previous.toNat},{next.v_q.toNat},{next.v_previous.toNat}"\n'
        + "    state := next\n")
    run([args.lake, "env", "lean", "-o", args.work / "Seq.olean", seq_lean], env=env)
    seq_actual = run([args.lake, "env", "lean", "--run", seq_runner], env=env).stdout.splitlines()
    seq_stimuli = "\n".join(
        f'clk=0; reset={reset}; enable={enable}; data={data}; #1; '
        + '$write("%0d,%0d,",q,previous); clk=1; #1; $display("%0d,%0d",q,previous);'
        for reset, enable, data in samples)
    seq_tb = args.work / "Seq_tb.v"
    seq_tb.write_text("module tb; reg clk, reset, enable; reg [7:0] data; wire [7:0] q,previous;\n"
        + "Seq dut(clk,reset,enable,data,q,previous); initial begin clk=0; #1; dut.q=137; dut.previous=90;\n"
        + seq_stimuli + "\n$finish; end endmodule\n")
    seq_binary = args.work / "seq.vvp"
    run([args.iverilog, "-g2012", "-s", "tb", "-o", seq_binary, seq, seq_tb])
    seq_expected = [line for line in run([args.vvp, seq_binary]).stdout.splitlines()
                    if re.match(r"^\d+,", line)]
    assert len(seq_expected) == len(samples)
    assert seq_actual == seq_expected
    print(f"PASS: {len(samples)} real Lean/RTL clock steps, reset/enable priority and simultaneous updates", flush=True)

    # Identify the physical clock by connectivity, not by its spelling. Ordinary
    # data called `clk` stays an input, including in a purely combinational module.
    for top, source, expected_inputs in [
        ("NamedClock", "module NamedClock(input tick, clk, output reg q); "
         "always @(posedge tick) q <= clk; endmodule", [("v_clk", 1)]),
        ("ClockOnly", "module ClockOnly(input tick, output reg q); "
         "always @(posedge tick) q <= ~q; endmodule", []),
        ("ClockData", "module ClockData(input clk, output q); assign q = ~clk; endmodule",
         [("v_clk", 1)]),
    ]:
        source_path = args.work / (top + ".v")
        source_path.write_text(source)
        model, oracle = export(top, source_path)
        assert read_model(model.read_text())[0]["Inputs"] == expected_inputs
        assert ("Clock port omitted from Inputs: tick" in model.read_text()) == (top != "ClockData")
        symbolic(top, model, oracle)
        run([args.lake, "env", "lean", "-o", args.work / (top + ".olean"), model], env=env)
    clock_proofs = args.work / "ClockInterface.lean"
    clock_proofs.write_text("import NamedClock\nimport ClockOnly\nimport ClockData\n"
        + "example (c : BitVec 1) (s : v_NamedClock.State) :\n"
        + "    (v_NamedClock.eval { v_clk := c } s).2.v_q = c := by rfl\n"
        + "example : (v_ClockOnly.eval {} { v_q := 0 }).2.v_q = 1 := by decide\n"
        + "example : (v_ClockData.eval { v_clk := 0 } {}).1.v_q = 1 := by decide\n")
    run([args.lake, "env", "lean", clock_proofs], env=env)
    assert all(field != "v_clk" for field, _ in read_model(seq_lean.read_text())[0]["Inputs"])
    print("PASS: clock-free logical inputs, clock-only circuits, ordinary data named clk", flush=True)

    bad = {
        "formal_falling": "module Bad(input clk,p); always @(negedge clk) assert(p); endmodule",
        "formal_otherclock": "module Bad(input clk,other,p,output reg q); always @(posedge clk) q<=p; always @(posedge other) assert(q); endmodule",
        "formal_anyconst": "module Bad(output p); assign p=$anyconst; endmodule",
        "async": "module Bad(input clk,r,d,output reg q); always @(posedge clk or posedge r) if(r) q<=0; else q<=d; endmodule",
        "latch": "module Bad(input e,d,output reg q); always @* if(e) q=d; endmodule",
        "falling": "module Bad(input clk,d,output reg q); always @(negedge clk) q<=d; endmodule",
        "clocks": "module Bad(input c,d,x,output reg q,z); always @(posedge c) q<=x; always @(posedge d) z<=x; endmodule",
        "gated": "module Bad(input clk,e,d,output reg q); wire c=clk&e; always @(posedge c) q<=d; endmodule",
        "clockdata": "module Bad(input clk,output reg q); always @(posedge clk) q<=clk; endmodule",
        "clockoutput": "module Bad(input clk,d,output reg q,output c); always @(posedge clk) q<=d; assign c=clk; endmodule",
        "unknown": "module Bad(output [1:0] q); assign q=2'bx1; endmodule",
        "loop": "module Bad(input x,output a,b); assign a=b&x; assign b=~a; endmodule",
        "memory": "module Bad(input clk, input [3:0] a, input [7:0] d, output [7:0] q); reg [7:0] m[0:15]; always @(posedge clk) m[a]<=d; assign q=m[a]; endmodule",
        "blackbox": "(* blackbox *) module Box(input d,output q); endmodule module Bad(input d,output q); Box b(d,q); endmodule",
    }
    for name, text in bad.items():
        src, dest = args.work / "Bad.v", args.work / "Bad.lean"
        src.write_text(text)
        dest.write_text("sentinel\n")
        for mode in ("", "-named "):
            result = yosys(f"read_verilog -formal {quote(src)}; hierarchy -top Bad; "
                          + f"lean_prepare; write_lean {mode}{quote(dest)}", ok=False)
            assert result.returncode != 0, (name, mode, result.stdout)
            assert dest.read_text() == "sentinel\n", (name, mode)
    names_source = args.work / "Names.v"
    names_source.write_text('module Names(input [0:7] \\if , input [7:0] a_b, input [7:0] \\a.b , output [0:7] \\end );\n'
                            '(* src = "escaped\\nend Injected\\n/-" *) wire [0:7] intermediate;\n'
                            'assign intermediate = \\if ^ a_b ^ \\a.b ; assign \\end = intermediate; endmodule\n')
    name_lean, name_smt = export("Names", names_source)
    run([args.lake, "env", "lean", name_lean], env=env)
    assert "v_a_b_1" in name_lean.read_text()
    print("PASS: deterministic names, ascending buses, escaped metadata, unsupported-design rejection", flush=True)
    # Independent concrete fixtures exercise all operators, state/initialization,
    # escaping, and source names through both printer modes.
    run([args.lake, "env", "lean", "-o", args.work / "Names.olean", name_lean], env=env)
    check_named(args, run, yosys, quote, symbolic, env,
                [("Ops", ROOT / "tests/ops.v", False), ("Seq", seq, False),
                 ("Names", names_source, False)])

    for top, directory in (("CPU", "original"), ("Hack", "repaired"),
                           ("HackTwoCycle", "two-cycle")):
        bundle = args.work / (top + "Bundle.v")
        bundle.write_text("\n".join(path.read_text() for path in [
            ROOT / f"examples/hack/{directory}/CPU.v",
            ROOT / "examples/hack/original/PC.v", ROOT / "examples/hack/original/alu.v"]))
        circuit, oracle = export(top, bundle)
        symbolic(top, circuit, oracle)
    print("PASS: all three Hack circuit exports symbolically agree with write_smt2", flush=True)
    check_two_cycle(args, run, args.work / "HackTwoCycle.lean", env, ROOT)
    generated = args.work / "generated"
    export_hack(args.yosys, args.plugin, generated)
    export_divider(args.yosys, args.plugin, generated)
    export_extra(args.yosys, args.plugin, generated)
    export_multiplier(args.yosys, args.plugin, generated)
    export_formal(args.yosys, args.plugin, generated)
    check_formal_tutorials(args, run, yosys, ROOT)
    export_bus(args.yosys, args.plugin, generated)
    check_bus(args, run, yosys, generated, ROOT)
    export_cpu(args.yosys, args.plugin, generated)
    check_cpu(args, run, yosys, generated, ROOT)
    check_examples(args, run, generated, env, ROOT, {
        "IbexALU": ("ibex_alu", "examples/ibex/converted/ibex_alu.v"),
        "ZipSkid": ("skidbuffer #(.DW(32), .OPT_OUTREG(0))", "examples/bus/upstream/skidbuffer.v"),
        "ZipAXIL": ("easyaxil", "examples/bus/upstream/easyaxil.v"),
    })
    check_ibex_frontend(args, run, ROOT)
    for name, (top, source) in EXTRA_CIRCUITS.items():
        smt = args.work / (name + ".smt2")
        script = f"read_verilog -sv {quote(source)}; hierarchy -check -top {top}; "
        if name != top:
            script += f"rename {top} {name}; "
        yosys(script + "proc; flatten; opt_clean; dffunmap; "
              + f"write_smt2 -stdt -wires {quote(smt)}")
        symbolic(name, generated / (name + ".lean"), smt)
    check_examples(args, run, generated, env, ROOT, EXTRA_CIRCUITS)
    for name, latency in (("ShiftAdd", 32), ("BarrelMul", 16)):
        mult, mult_smt = export(name, ROOT / f"examples/multiplier/{name}.v")
        symbolic(name, mult, mult_smt)
        check_multiplier(args, run, generated / (name + ".lean"), env, ROOT,
                         name=name, latency=latency)
    for width, logwidth in ((4, 2), (32, 5)):
        top = f"ZipDiv{width}"
        smt = args.work / (top + ".smt2")
        yosys("read_verilog examples/zipcpu/upstream/div.v; "
              + f"hierarchy -top div -chparam BW {width} -chparam LGBW {logwidth}; "
              + f"rename div {top}; proc; flatten; opt_clean; dffunmap; "
              + f"write_smt2 -stdt -wires {quote(smt)}")
        symbolic(top, generated / (top + ".lean"), smt)
        check_divider(args, run, generated / (top + ".lean"), env, ROOT, width)
    for name in ("Hack", "Original", "TwoCycle", "ZipDiv4", "ZipDiv32", "ZipDivFormal",
                 *EXTRA_CIRCUITS, "Prefix32Wires", "Ripple32Wires", "ShiftAdd", "BarrelMul", *formal_scripts()):
        # Compiler identity in the provenance comment is not circuit semantics.
        def content(path):
            return re.sub(r"^-- Yosys:.*\n", "", path.read_text(), flags=re.M)
        checked_in = ROOT / "Examples/Generated" / (name + ".lean")
        assert content(generated / (name + ".lean")) == content(checked_in), (
            f"Stale circuit export: {checked_in}. Regenerate with scripts/export.py.")
    # Dependency order is explicit so even a clean proof check starts one Lean
    # process at a time. Never run the new proof modules concurrently.
    for name in [*("Generated/" + n for n in
                   ("Hack", "Original", "TwoCycle", "ZipDiv4", "ZipDiv32", "ZipDivFormal",
                    *EXTRA_CIRCUITS, "Prefix32Wires", "Ripple32Wires", "ShiftAdd", "BarrelMul", *formal_scripts(), *bus_scripts(), *cpu_scripts(), "NervAddView", "NervFetchView", "NervFetchBridge")),
                 "HackSpec", "HackProofs", "TwoCycleProofs", "DividerProofs",
                 "AdderSupport", "Prefix32Carries", "Prefix32Proofs",
                 "Ripple32Carries", "Ripple32Proofs", "AdderProofs",
                 "CrcProofs", "ElasticProofs", "MultiplierProofs", "BarrelMultiplierProofs", "FormalTutorialProofs",
                 "SBYAccumulatorProofs", "SBYCoverProofs", "BugCounterexamples", "ReplayCounterexamples",
                 "RepairProofs", "DividerArithmetic", "Divider32Proofs", "DividerSignedProofs",
                 "SkidProofs", "AXILProofs", "BusCounterexamples", "SkidFormalProofs",
                 "IbexALUProofs", "NervProofs", "NervCounterexamples", "NervSafety", "NervRegisters", "NervArchitecture",
                 "NervImmediate", "NervArithmetic", "NervControlDecode", "NervControl",
                 "NervFetch", "NervProgram", "NervControlProgram", "NervControlExample",
                 "NervArchitectureCounterexample"]:
        check_module("Examples/" + name)
    check_nerv_replay(args, run, env, ROOT)
    check_nerv_program(args, run, env, ROOT)
    check_module("Examples")
    check_readme(args, run, ROOT)
    check_bug_examples(args, run, ROOT)
    baseline = run([sys.executable, ROOT / "scripts/benchmark_divider.py", "--widths", "4",
                    "--timeout", "10", "--yosys", args.yosys,
                    "--work", args.work / "divider-benchmark"])
    print(baseline.stdout, end="", flush=True)
    print("PASS: Hack original counterexample, repaired refinement, unbounded lifting, program execution", flush=True)
    print("PASS: exhaustive four-bit and universal 32-bit signed/unsigned divider proofs; "
          "transaction SMTBMC baseline and negative control", flush=True)


if __name__ == "__main__":
    main()
