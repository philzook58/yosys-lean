"""Fault witnesses, repair controls, independent SMT checks, and actual Lean/RTL replay."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import sys

from run import ROOT, run
from export import cpu_lowering, quote
from nerv_faults import FAULTS, export_faults, fault_scripts, fault_sources
from smt import comparison

# Stable, public observations. Inactive RVFI payloads may contain Verilog X values.
PORTS = [('phase', 5), ('retired', 3), ('operands_ok', 1), ('result_ok', 1),
         ('sequence_ok', 1), ('fetch_ok', 1), ('progress_ok', 1), ('contract_ok', 1),
         ('rvfi_valid', 1)]
PAYLOAD = [('rvfi_insn', 32), ('rvfi_pc_rdata', 32), ('rvfi_pc_wdata', 32),
           ('rvfi_rs1_addr', 5), ('rvfi_rs2_addr', 5), ('rvfi_rs1_rdata', 32),
           ('rvfi_rs2_rdata', 32), ('rvfi_rd_addr', 5), ('rvfi_rd_wdata', 32)]


def replay(args, name, source, cases, env):
    folder = args.work
    runner = folder / 'FaultReplay.lean'
    base = ','.join('{o.v_' + key + '.toNat}' for key, _ in PORTS)
    payload = ','.join('{o.v_' + key + '.toNat}' for key, _ in PAYLOAD)
    runner.write_text(f'import Examples.Generated.{name}\nopen v_{name}\n'
        + 'def main : IO Unit := do\n'
        + '  for scenario in ([' + ','.join(map(str, cases)) + '] : List (BitVec 3)) do\n'
        + '    let input : Inputs := { (default : Inputs) with v_scenario := scenario }\n'
        + '    let mut state : State := default\n'
        + '    for _ in List.range 13 do\n'
        + '      let (o, next) := eval input state\n'
        + '      if o.v_phase.toNat >= 3 then\n'
        + f'        IO.println s!"R,{{scenario.toNat}},{base}"\n'
        + '        if o.v_rvfi_valid == 1 then\n'
        + f'          IO.println s!"P,{{scenario.toNat}},{payload}"\n'
        + '      state := next\n')
    actual = run([sys.executable, ROOT / 'scripts/check_lean.py', '--run', runner],
                 env=env).stdout.splitlines()
    expected = [line for line in actual if line.startswith(('R,', 'P,'))]
    observed = []
    for case in cases:
        wires = ' '.join(f'wire [{width-1}:0] {key};' for key, width in PORTS + PAYLOAD)
        connect = ','.join(f'.{key}({key})' for key, _ in PORTS + PAYLOAD)
        def display(prefix, ports):
            fmt = ','.join('%0d' for _ in ports)
            values = ','.join(key for key, _ in ports)
            return f'$display("{prefix},{case},{fmt}",{values});'
        bench = folder / 'FaultReplay_tb.sv'
        bench.write_text('module tb; reg clock=0; integer k; ' + wires + '\n'
            + f'NervFaultHarness dut(.clock(clock),.scenario(3\'d{case}),{connect});\n'
            # Match the Lean witness, not a claim that reset clears the register file.
            + 'initial begin for(k=0;k<32;k=k+1) dut.cpu.regfile[k]=0;\n'
            + 'repeat(13) begin #1; if(phase>=3) begin '
            + display('R', PORTS) + ' if(rvfi_valid) ' + display('P', PAYLOAD)
            + ' end clock=1; #1; clock=0; end $finish; end endmodule\n')
        binary = folder / 'FaultReplay.vvp'
        run([args.iverilog, '-g2012', '-D', 'NERV_RVFI', '-D', 'RISCV_FORMAL_NRET=1',
             '-D', 'RISCV_FORMAL_XLEN=32', '-D', 'RISCV_FORMAL_ILEN=32',
             '-Iexamples/riscv/upstream/riscv-formal', '-s', 'tb', '-o', binary,
             source, ROOT / 'examples/riscv/NervFaultHarness.sv', bench])
        observed += [line for line in run([args.vvp, binary]).stdout.splitlines()
                     if line.startswith(('R,', 'P,'))]
    assert observed == expected, (name, observed, expected)
    (folder / (name + 'Replay.csv')).write_text('\n'.join(observed) + '\n')
    rows = [line.split(',') for line in observed if line.startswith('R,')]
    contracts = [int(row[2 + [key for key, _ in PORTS].index('contract_ok')]) for row in rows]
    assert all(contracts) if name.endswith('Control') else not all(contracts), name
    print(f'PASS: {name} actual Lean/Icarus replay, scenarios {cases}', flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--yosys', type=Path, default=ROOT / 'build/yosys/yosys')
    parser.add_argument('--plugin', type=Path, default=ROOT / 'build/yosys_lean.so')
    parser.add_argument('--checks', choices=('all', 'symbolic', 'proofs', 'replay'), default='all')
    parser.add_argument('--work', type=Path, default=ROOT / 'build/nerv-fault-tests')
    for name in ('lake', 'z3', 'iverilog', 'vvp'):
        parser.add_argument('--' + name, default=name)
    args = parser.parse_args()
    args.work = args.work.resolve()
    args.work.mkdir(parents=True, exist_ok=True)
    manifest = json.loads((ROOT / 'examples/riscv/sources.json').read_text())
    for path, digest in manifest['sha256'].items():
        assert hashlib.sha256((ROOT / 'examples/riscv' / path).read_bytes()).hexdigest() == digest
    generated = args.work / 'Generated'
    export_faults(args.yosys, args.plugin, generated)
    candidates = [args.yosys.parent / 'yosys-smtbmc', ROOT / 'vendor/yosys/backends/smt2/smtbmc.py']
    smtbmc = next(p for p in candidates if p.exists())
    command = [sys.executable, smtbmc] if smtbmc.suffix == '.py' else [smtbmc]

    def yosys(script):
        return run([args.yosys, '-Q', '-T', '-m', args.plugin, '-p', script])

    solver_env = dict(os.environ)
    solver_env['PATH'] = str(Path(shutil.which(str(args.z3)) or args.z3).resolve().parent) + os.pathsep + solver_env['PATH']

    def bmc(path, tag, expect, cover=False):
        result = run(command + ['-s', 'z3', '-t', '14', '--timeout', '30']
                     + (['-c'] if cover else []) + [path], env=solver_env, ok=False)
        (args.work / (tag + '.log')).write_text(result.stdout + result.stderr)
        assert f'Status: {expect}' in result.stdout, (tag, result.stdout, result.stderr)
        assert (result.returncode == 0) == (expect == 'PASSED'), tag
        print(f'PASS: {tag} ({expect}, depth 14)', flush=True)

    if args.checks in ('all', 'symbolic'):
        for name, prefix in fault_scripts().items():
            def content(path):
                return re.sub(r'^-- Yosys:.*\n', '', path.read_text(), flags=re.M)
            checked = ROOT / 'Examples/Generated' / (name + '.lean')
            assert content(generated / (name + '.lean')) == content(checked), name
            smt = args.work / (name + '.smt2')
            yosys(prefix + cpu_lowering(name) + f'write_smt2 -stdt -wires {quote(smt)}')
            query = args.work / (name + 'Compare.smt2')
            def miter(corrupt=False):
                return comparison(checked.read_text(), smt.read_text(), name, corrupt=corrupt).replace(
                    '(check-sat)', '(check-sat-using (then simplify solve-eqs bit-blast sat))')
            # An explicit bit-blast checks the combinational word logic
            # without expensive general SMT search through the miter.
            query.write_text(miter())
            result = run([args.z3, '-T:30', query])
            assert result.stdout.strip() == 'unsat', (name, result.stdout, result.stderr)
            if name.endswith('Control'):
                negative = args.work / 'CorruptComparison.smt2'
                negative.write_text(comparison(checked.read_text(), smt.read_text(), name, corrupt=True))
                assert run([args.z3, '-T:30', negative]).stdout.strip() == 'sat'
            print(f'PASS: {name} regeneration and all-state SMT agreement', flush=True)
            # Independent upstream RTL lowering, not the FunctionalIR preparation above.
            preparation = prefix + f'prep -top {name}; '
            yosys(preparation + f'chformal -lower; dffunmap; write_smt2 -wires {quote(smt)}')
            control = name.endswith('Control')
            bmc(smt, name + 'Contracts', 'PASSED' if control else 'FAILED')
            if control:
                bmc(smt, name + 'Covers', 'PASSED', cover=True)
            else:
                # Keep upstream instruction checks; remove only this workload's assertions.
                yosys(preparation + 'chformal -assert -remove a:src=*NervFaultHarness.sv*; '
                      + f'chformal -lower; dffunmap; write_smt2 -wires {quote(smt)}')
                assertions = re.findall(r'^; yosys-smt2-assert .*', smt.read_text(), re.M)
                assert assertions and all('NervFaultHarness.sv' not in line for line in assertions)
                bmc(smt, name + 'InstructionOnly', 'PASSED')

    def check_module(name):
        result = run([sys.executable, ROOT / 'scripts/check_lean.py', '--heartbeats', '800000',
                      ROOT / (name + '.lean'),
                      '--output', ROOT / '.lake/build/lib/lean' / (name + '.olean')])
        print(result.stdout, end='', flush=True)

    if args.checks in ('all', 'proofs'):
        for name in ('YosysLean/Basic', 'YosysLean', 'YosysLean/Formal', 'YosysLean/Check',
                     'YosysLean/Trace'):
            check_module(name)
        for name in fault_scripts():
            check_module('Examples/Generated/' + name)
        check_module('Examples/NervFaults/Control')
        for fault in FAULTS:
            check_module('Examples/NervFaults/Control' + fault)
        for name in ('Controls', *FAULTS):
            check_module('Examples/NervFault' + name)
    env = dict(os.environ)
    env['LEAN_PATH'] = str(ROOT / '.lake/build/lib/lean')
    if args.checks in ('all', 'replay'):
        for name, source in fault_sources().items():
            cases = list(range(5)) if name.endswith('Control') else [list(FAULTS).index(name[9:])]
            replay(args, name, source, cases, env)
    print(f'PASS: NERV fault checks ({args.checks})', flush=True)


if __name__ == '__main__':
    main()
