#!/usr/bin/env python3
"""Reproduce checked-in circuit exports; no network or source rewriting."""
import argparse
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

EXTRA_CIRCUITS = {
    "Prefix32": ("sklansky_adder_32", "examples/bird/upstream/sklansky_adder_32.v"),
    "Ripple32": ("Ripple32", "examples/bird/ripple.v"),
    "CrcSerial": ("crc8_sync", "examples/bird/crc8_sync.sv"),
    "CrcByte": ("CrcByte", "examples/bird/crc_byte.v"),
    "Elastic": ("Elastic", "examples/elastic/Pipeline.v"),
}


def quote(value):
    return '"' + str(value).replace('\\', '\\\\').replace('"', '\\"') + '"'


def export_hack(yosys, plugin, dest=None):
    dest = dest or ROOT / "Examples/Generated"
    dest.mkdir(parents=True, exist_ok=True)
    for name, cpu, top in [
        ("Original", "original", "CPU"), ("Hack", "repaired", "Hack"),
        ("TwoCycle", "two-cycle", "HackTwoCycle")
    ]:
        paths = [ROOT / f"examples/hack/{cpu}/CPU.v"]
        paths += [ROOT / f"examples/hack/original/{p}.v" for p in ("PC", "alu")]
        script = "read_verilog " + " ".join(quote(p.relative_to(ROOT)) for p in paths)
        script += f"; hierarchy -check -top {top}; lean_prepare; write_lean {quote(dest / (name + '.lean'))}"
        subprocess.run([str(yosys), "-Q", "-T", "-m", str(plugin), "-p", script], check=True,
                       stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=ROOT)


def export_divider(yosys, plugin, dest=None):
    dest = dest or ROOT / "Examples/Generated"
    dest.mkdir(parents=True, exist_ok=True)
    for name, width, logwidth, formal in [
        ("ZipDiv4", 4, 2, False), ("ZipDiv32", 32, 5, False),
        ("ZipDivFormal", 32, 5, True)
    ]:
        script = "read_verilog " + ("-formal -D DIV " if formal else "")
        script += "examples/zipcpu/upstream/div.v; "
        script += f"hierarchy -check -top div -chparam BW {width} -chparam LGBW {logwidth}; "
        script += f"rename div {name}; lean_prepare; write_lean {quote(dest / (name + '.lean'))}"
        subprocess.run([str(yosys), "-Q", "-T", "-m", str(plugin), "-p", script], check=True,
                       stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=ROOT)


def export_extra(yosys, plugin, dest=None):
    dest = dest or ROOT / "Examples/Generated"
    dest.mkdir(parents=True, exist_ok=True)
    for name, (top, path) in EXTRA_CIRCUITS.items():
        script = f"read_verilog -sv {quote(path)}; hierarchy -check -top {top}; "
        if name != top:
            script += f"rename {top} {name}; "
        script += f"lean_prepare; write_lean {quote(dest / (name + '.lean'))}"
        subprocess.run([str(yosys), "-Q", "-T", "-m", str(plugin), "-p", script], check=True,
                       stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=ROOT)
    export_wire_views(dest)


def export_multiplier(yosys, plugin, dest=None):
    dest = dest or ROOT / "Examples/Generated"
    dest.mkdir(parents=True, exist_ok=True)
    for name in ("ShiftAdd", "BarrelMul"):
        script = (f'read_verilog examples/multiplier/{name}.v; hierarchy -check -top {name}; '
                  + f'lean_prepare; write_lean {quote(dest / (name + ".lean"))}')
        subprocess.run([str(yosys), "-Q", "-T", "-m", str(plugin), "-p", script], check=True,
                       stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=ROOT)



def bug_scripts():
    scripts = {}
    for short, top in (("Counter", "Counter"), ("Stall", "StallBuffer"),
                       ("Shift", "ShiftWidth")):
        for fixed in (False, True):
            name = ("Fixed" if fixed else "Bug") + short
            define = "-D REPAIRED " if fixed else ""
            scripts[name] = (f"read_verilog -formal -sv {define}examples/bugs/{top}.v; "
                             + f"hierarchy -check -top {top}; rename {top} {name}; ")
    return scripts


def formal_scripts():
    """Input preparation shared by the two independent export/lowering paths in tests."""
    scripts = {}
    for name, top, source in (
        ("SMTIncrement", "demo1", "examples/formal/upstream/smtbmc/demo1.v"),
        ("SBYCounter", "demo", "examples/formal/upstream/sby/demo.sv"),
        ("SBYCover", "top", "examples/formal/upstream/sby/cover.sv"),
        ("SBYAccumulator", "testbench", "examples/formal/upstream/sby/prove.sv"),
    ):
        scripts[name] = (f"read_verilog -formal -sv {quote(source)}; "
                         + f"hierarchy -check -top {top}; rename {top} {name}; ")
    for name, define in (("EQYFSM", ""), ("EQYFSMBad", "-D NEGATIVE_CONTROL")):
        source = "examples/formal/upstream/eqy/fsm.sv"
        script = f"read_verilog -formal -sv -D GOLD {source}; rename top EQYGold; "
        script += f"read_verilog -formal -sv -D GATE {source}; rename top EQYGate; "
        script += f"read_verilog -formal -sv {define} examples/formal/EqyFSMHarness.v; "
        scripts[name] = script + f"hierarchy -check -top EqyFSMHarness; rename EqyFSMHarness {name}; "
    scripts.update(bug_scripts())
    return scripts


def export_formal(yosys, plugin, dest=None):
    dest = dest or ROOT / "Examples/Generated"
    dest.mkdir(parents=True, exist_ok=True)
    for name, script in formal_scripts().items():
        script += f"lean_prepare; write_lean {quote(dest / (name + '.lean'))}"
        subprocess.run([str(yosys), "-Q", "-T", "-m", str(plugin), "-p", script], check=True,
                       stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=ROOT)


def bus_scripts():
    scripts = {}
    directory = "examples/bus/upstream/"
    for formal in (False, True):
        suffix = "Formal" if formal else ""
        flags = "-formal -D SKIDBUFFER " if formal else ""
        scripts["ZipSkid" + suffix] = (
            f"read_verilog {flags}{directory}skidbuffer.v; "
            "hierarchy -check -top skidbuffer -chparam DW 32 -chparam OPT_OUTREG 0; "
            f"rename skidbuffer ZipSkid{suffix}; ")
        files = " ".join(directory + f for f in
                         (("skidbuffer.v", "faxil_slave.v", "faxil_register.v", "easyaxil.v")
                          if formal else ("easyaxil.v",)))
        scripts["ZipAXIL" + suffix] = (
            f"read_verilog {'-formal ' if formal else ''}{files}; "
            f"hierarchy -check -top easyaxil; rename easyaxil ZipAXIL{suffix}; ")
    # Keep tiny mutation recipes rather than duplicating entire upstream files.
    mutants = ROOT / "build/bus-mutants"
    mutants.mkdir(parents=True, exist_ok=True)
    for short, top, filename, before, after in (
        ("Skid", "skidbuffer", "skidbuffer.v", "r_data <= i_data;", "r_data <= 0;"),
        ("AXIL", "easyaxil", "easyaxil.v", "= wstrb[k] ?", "= 1'b1 ?"),
    ):
        original = (ROOT / directory / filename).read_text()
        assert original.count(before) == 1
        relative = mutants.relative_to(ROOT) / filename
        (ROOT / relative).write_text(original.replace(before, after))
        for formal in (False, True):
            name = "Zip" + short + "Bad" + ("Formal" if formal else "")
            good = "Zip" + short + ("Formal" if formal else "")
            scripts[name] = scripts[good].replace(directory + filename, str(relative)).replace(
                f"rename {top} {good}", f"rename {top} {name}")
    return scripts


def export_bus(yosys, plugin, dest=None):
    dest = dest or ROOT / "Examples/Generated"
    dest.mkdir(parents=True, exist_ok=True)
    for name, script in bus_scripts().items():
        # Preserve don't-care behavior; turn complete case decoders into indexed muxes.
        script += "lean_prepare; opt -keepdc; pmux2shiftx; opt -keepdc; "
        script += f"write_lean {quote(dest / (name + '.lean'))}"
        subprocess.run([str(yosys), "-Q", "-T", "-m", str(plugin), "-p", script], check=True,
                       stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=ROOT)



def cpu_scripts():
    scripts = {"IbexALU": (
        "read_verilog examples/ibex/converted/ibex_alu.v; "
        "hierarchy -check -top ibex_alu; rename ibex_alu IbexALU; ")}
    directory = "examples/riscv/upstream/riscv-formal/"
    for op in ("Addi", "Add"):
        flags = "-D CHECK_ADDI " if op == "Addi" else ""
        scripts["Nerv" + op] = (
            f"read_verilog -formal -sv -I{directory} -D NERV_RVFI {flags}"
            "-D RISCV_FORMAL_NRET=1 -D RISCV_FORMAL_XLEN=32 -D RISCV_FORMAL_ILEN=32 "
            f"-D RISCV_FORMAL_CHANNEL_IDX=0 -D RISCV_FORMAL_INSN_MODEL=rvfi_insn_{op.lower()} "
            f"{directory}rvfi_macros.vh examples/riscv/upstream/nerv/nerv.sv "
            f"{directory}insn_{op.lower()}.v {directory}rvfi_insn_check.sv "
            f"examples/riscv/NervHarness.sv; hierarchy -check -top NervHarness; "
            f"rename NervHarness Nerv{op}; ")
    scripts["NervFetch"] = scripts["NervAdd"].replace(
        "examples/riscv/NervHarness.sv", "examples/riscv/NervFetchHarness.sv").replace(
        "-top NervHarness; rename NervHarness NervAdd;",
        "-top NervFetchHarness; rename NervFetchHarness NervFetch;")
    mutants = ROOT / "build/cpu-mutants"
    mutants.mkdir(parents=True, exist_ok=True)
    source = "examples/riscv/upstream/nerv/nerv.sv"
    original = (ROOT / source).read_text()
    before = "next_rd = rs1_value + imm_i_sext;"
    assert original.count(before) == 1
    mutant = mutants / "nerv.sv"
    mutant.write_text(original.replace(before, "next_rd = rs1_value + imm_i_sext + 1;"))
    scripts["NervAddiBad"] = scripts["NervAddi"].replace(source, str(mutant.relative_to(ROOT))).replace(
        "rename NervHarness NervAddi;", "rename NervHarness NervAddiBad;")
    # Leave RVFI untouched while corrupting the real register-file write address.
    before = "regfile[mem_rd_enable_q ? mem_rd_reg_q : insn_rd]"
    assert original.count(before) == 1
    mutant = mutants / "nerv_write.sv"
    mutant.write_text(original.replace(before,
        "regfile[mem_rd_enable_q ? mem_rd_reg_q : (insn_rd ^ 5'b00001)]"))
    scripts["NervWriteBad"] = scripts["NervAdd"].replace(source, str(mutant.relative_to(ROOT))).replace(
        "rename NervHarness NervAdd;", "rename NervHarness NervWriteBad;")
    return scripts



def cpu_lowering(name):
    # Explicit memory lowering; retain don't-cares until every lowering pass has run.
    script = "proc; flatten; opt -keepdc; memory_map; opt -keepdc; "
    script += "lean_prepare; opt -keepdc; pmux2shiftx; opt -keepdc; "
    if name.startswith("Nerv"):
        script += "setundef -anyseq; "  # Arbitrary choices, never fixed zeroes.
    return script

def export_cpu(yosys, plugin, dest=None):
    dest = dest or ROOT / "Examples/Generated"
    dest.mkdir(parents=True, exist_ok=True)
    for name, script in cpu_scripts().items():
        script += cpu_lowering(name)
        compact = script + f"write_lean {quote(dest / (name + '.lean'))}"
        subprocess.run([str(yosys), "-Q", "-T", "-m", str(plugin), "-p", compact], check=True,
                       stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=ROOT)
        if name in ("NervAdd", "NervFetch"):
            export_named_view(yosys, plugin, name, script, dest)

    from nerv_fetch import export_bridge
    export_bridge(dest)


def export_named_view(yosys, plugin, name, script, dest):
    """A named view using the compact export's types, checked equal by Lean rfl."""
    raw = dest / (name + "View.lean")
    subprocess.run([str(yosys), "-Q", "-T", "-m", str(plugin), "-p",
                    script + f"write_lean -named {quote(raw)}"], check=True,
                   stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=ROOT)
    body = raw.read_text().split("namespace Signals\n", 1)[1].split(
        "-- Only specified initial bits", 1)[0]
    raw.write_text(f"import Examples.Generated.{name}\n\n"
                  + "-- Generated named view; do not edit. Types come from the original export.\n"
                  + f"namespace v_{name}.Named\nnamespace Signals\n" + body
                  + f"theorem agrees (i : Inputs) (s : State) : eval i s = v_{name}.eval i s := by rfl\n"
                  + f"end v_{name}.Named\n")

def export_wire_views(dest):
    """Proof-only wire views; a Lean rfl theorem checks the preserved original evaluation."""
    rtl = (ROOT / "examples/bird/upstream/sklansky_adder_32.v").read_text()
    wires = dict(re.findall(r"wire (w\d+) = ([^;]+);", rtl))
    sums = dict((int(i), w) for i, w in re.findall(r"assign sum\[(\d+)\] = (w\d+)", rtl))
    prefix = ["v_cin"] + ["v_" + wires[sums[i]].split(" ^ ")[1] for i in range(1, 32)]
    prefix += ["v_cout"]
    ripple = ["v_cin"] + [f"v_column_{i}__carry_in" for i in range(1, 32)] + ["v_cout"]
    for name, carries in (("Prefix32", prefix), ("Ripple32", ripple)):
        text = (dest / (name + ".lean")).read_text()
        lets, result = text.split("def eval (inputs : Inputs) (state : State) : Outputs × State :=\n")[1].split("  ({\n", 1)
        result = "  ({\n" + result.split("\n\n-- Only specified initial bits")[0]
        declarations = "\n".join(f"  c{i} : BitVec 1" for i in range(33))
        observations = ",\n".join(f"     c{i} := {wire}" for i, wire in enumerate(carries))
        view = f"{name}Wires"
        body = (f"import Examples.Generated.{name}\n\n"
                + "-- Generated proof instrumentation; do not edit.\n"
                + f"namespace v_{view}\n\nstructure Carries where\n{declarations}\n\n"
                + f"def eval (inputs : v_{name}.Inputs) (state : v_{name}.State) :\n"
                + f"    (v_{name}.Outputs × v_{name}.State) × Carries :=\n"
                + lets + "  (" + result.strip() + ", {\n" + observations + "\n   })\n\n"
                + f"theorem projection (i : v_{name}.Inputs) (s : v_{name}.State) :\n"
                + f"    (eval i s).1 = v_{name}.eval i s := by rfl\n\nend v_{view}\n")
        (dest / (view + ".lean")).write_text(body)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--yosys", type=Path, default=ROOT / "build/yosys/yosys")
    parser.add_argument("--plugin", type=Path, default=ROOT / "build/yosys_lean.so")
    args = parser.parse_args()
    export_hack(args.yosys.resolve(), args.plugin.resolve())
    export_divider(args.yosys.resolve(), args.plugin.resolve())
    export_extra(args.yosys.resolve(), args.plugin.resolve())
    export_multiplier(args.yosys.resolve(), args.plugin.resolve())
    export_formal(args.yosys.resolve(), args.plugin.resolve())
    export_bus(args.yosys.resolve(), args.plugin.resolve())
    export_cpu(args.yosys.resolve(), args.plugin.resolve())
    from nerv_faults import export_faults
    export_faults(args.yosys.resolve(), args.plugin.resolve())
