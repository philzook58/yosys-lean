"""CPU milestones: source identity, SMT agreement, RVFI baselines, and frontend checks."""
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import sys
from export import cpu_scripts, cpu_lowering, quote
from smt import comparison, read_model


def check_cpu(args, run, yosys, generated, root):
    for directory in ('ibex', 'riscv'):
        folder = root / 'examples' / directory
        manifest = json.loads((folder / 'sources.json').read_text())
        for relative, digest in manifest['sha256'].items():
            assert hashlib.sha256((folder / relative).read_bytes()).hexdigest() == digest
    candidates = [Path(args.yosys).parent / 'yosys-smtbmc',
                  root / 'vendor/yosys/backends/smt2/smtbmc.py']
    smtbmc = next(p for p in candidates if p.exists())
    command = [sys.executable, smtbmc] if smtbmc.suffix == '.py' else [smtbmc]
    solver_env = dict(os.environ)
    solver_env['PATH'] = str(Path(shutil.which(str(args.z3)) or args.z3).resolve().parent) + os.pathsep + solver_env['PATH']
    for name, prefix in cpu_scripts().items():
        checked_in = root / 'Examples/Generated' / (name + '.lean')
        def content(path):
            return re.sub(r'^-- Yosys:.*\n', '', path.read_text(), flags=re.M)
        assert content(generated / (name + '.lean')) == content(checked_in), name
        if name in ('NervAdd', 'NervFetch'):
            view = name + 'View.lean'
            assert content(generated / view) == content(root / 'Examples/Generated' / view), view
        if name == 'NervFetch':
            bridge = 'NervFetchBridge.lean'
            assert (generated / bridge).read_text() == (
                root / 'Examples/Generated' / bridge).read_text(), bridge
        smt = args.work / (name + 'Reference.smt2')
        # NERV has explicit arbitrary inputs for undef bits. Compare both printers
        # after the same lowering; the BMC path below independently lowers the RTL.
        # Map Ibex's constant ROM too: arbitrary SMT memory contents would not
        # represent the fixed combinational lookup table of the RTL.
        lowering = cpu_lowering(name) if name.startswith('Nerv') else 'proc; flatten; opt_clean; memory_map; opt_clean; dffunmap; '
        yosys(prefix + lowering + f'write_smt2 -stdt -wires {quote(smt)}')
        query = args.work / (name + 'Compare.smt2')
        def miter(corrupt=False):
            text = comparison(checked_in.read_text(), smt.read_text(), name, corrupt=corrupt)
            # These are combinational word equations. Use the same explicit
            # bit-blast as the fault tests, avoiding general SMT search timeouts.
            return text.replace('(check-sat)',
                                '(check-sat-using (then simplify solve-eqs bit-blast sat))')
        query.write_text(miter())
        compared = run([args.z3, '-T:30', query])
        assert compared.stdout.strip() == 'unsat', (name, compared.stdout, compared.stderr)
        if name == 'NervFetch':
            negative = args.work / 'NervFetchCorruptCompare.smt2'
            # Finding a model also needs the datatype theory for SMT state.
            negative.write_text(comparison(checked_in.read_text(), smt.read_text(),
                                           name, corrupt=True))
            assert run([args.z3, '-T:30', negative]).stdout.strip() == 'sat'
        if name == 'IbexALU':
            continue
        yosys(prefix + f'prep -top {name}; chformal -lower; dffunmap; write_smt2 -wires {quote(smt)}')
        result = run(command + ['-s', 'z3', '-t', '8', '--timeout', '20',
                     '--dump-vcd', args.work / (name + '.vcd'), smt], env=solver_env, ok=False)
        (args.work / (name + 'BMC.log')).write_text(result.stdout + result.stderr)
        # The wrong-write mutant deliberately passes these instruction-local checks.
        # Its Lean witness checks the architectural storage obligation they omit.
        fails_rvfi = name == 'NervAddiBad'
        if fails_rvfi:
            assert result.returncode != 0 and 'Status: FAILED' in result.stdout, result.stdout
        else:
            assert result.returncode == 0 and 'Status: PASSED' in result.stdout, result.stdout
            cover = run(command + ['-s', 'z3', '-c', '-t', '8', '--timeout', '20', smt],
                        env=solver_env, ok=False)
            assert cover.returncode == 0 and 'Status: PASSED' in cover.stdout, cover.stdout
        print(f'PASS: {name} imported RVFI checks ({"counterexample" if fails_rvfi else "BMC depth 8 + covers"})', flush=True)
    print('PASS: CPU source hashes, export regeneration, and arbitrary-state SMT agreement', flush=True)


def check_choices(args, run, yosys, symbolic, check_named, env, root):
    source = root / 'tests/choices.v'
    model, smt = args.work / 'Choices.lean', args.work / 'Choices.smt2'
    prefix = f'read_verilog -formal {quote(source)}; hierarchy -check -top Choices; '
    yosys(prefix + f'lean_prepare; write_lean {quote(model)}')
    yosys(prefix + f'proc; opt_clean; dffunmap; write_smt2 -stdt -wires {quote(smt)}')
    symbolic('Choices', model, smt)
    run([args.lake, 'env', 'lean', '-o', args.work / 'Choices.olean', model], env=env)
    check_named(args, run, yosys, quote, symbolic, env, [('Choices', source, True)])
    fields, _, nodes, result = read_model(model.read_text())
    expressions = {name: expr for name, _, expr in nodes}
    first = expressions[result[0]['v_choice']].removeprefix('inputs.')
    second = expressions[result[0]['v_other']].removeprefix('inputs.')
    assert first != second and dict(fields['Inputs'])[first] == dict(fields['Inputs'])[second] == 8
    proof = args.work / 'ChoiceSemantics.lean'
    proof.write_text('import Choices\nopen v_Choices\n'
        + f'def input (a b : BitVec 8) : Inputs := {{ {first} := a, {second} := b, v_en := 1 }}\n'
        + f'example (i : Inputs) (s : State) : (eval i s).1.v_choice = i.{first} := by rfl\n'
        + f'example (i : Inputs) (s : State) : (eval i s).1.v_other = i.{second} := by rfl\n'
        + 'example : (eval (input 2 0) (eval (input 1 0) { v_last := 0 }).2).2.v_last = 2 := by decide\n')
    run([args.lake, 'env', 'lean', proof], env=env)
    print('PASS: independent arbitrary choices, changing across edges, in both printer modes', flush=True)


def check_ibex_frontend(args, run, root):
    verilator = shutil.which('verilator')
    if not verilator:
        print('SKIP: original Ibex SystemVerilog replay (optional Verilator unavailable)', flush=True)
        return
    # Reuse the exact vectors/bench checked against actual Lean and converted RTL.
    folder = args.work / 'ibex-verilator'
    run([verilator, '--binary', '--timing', '-j', '1', '-Wno-fatal', '-Wno-ENUMVALUE',
         '--top-module', 'tb', '--Mdir', folder,
         root / 'examples/ibex/upstream/ibex_pkg.sv',
         root / 'examples/ibex/upstream/ibex_alu.sv', args.work / 'IbexALU_tb.v'])
    original = [line for line in run([folder / 'Vtb']).stdout.splitlines() if re.match(r'^\d+,', line)]
    converted = [line for line in run([args.vvp, args.work / 'IbexALU.vvp']).stdout.splitlines()
                 if re.match(r'^\d+,', line)]
    assert len(original) == len(converted) == 325, (len(original), len(converted))
    for n, (a, b) in enumerate(zip(original, converted)):
        assert a == b, ('Ibex original/converted mismatch', n,
                        (args.work / 'IbexALU.csv').read_text().splitlines()[n], a, b)
    print('PASS: original Ibex SystemVerilog vs converted Verilog, 325 vectors, all output ports', flush=True)


def check_nerv_replay(args, run, env, root):
    # Use the proof's own inputs, rather than maintaining a second program list.
    ports = [('rvfi_valid', 1), ('rvfi_insn', 32), ('rvfi_trap', 1),
             ('rvfi_rs1_addr', 5), ('rvfi_rs2_addr', 5), ('rvfi_rs1_rdata', 32),
             ('rvfi_rs2_rdata', 32), ('rvfi_rd_addr', 5), ('rvfi_rd_wdata', 32),
             ('rvfi_pc_rdata', 32), ('rvfi_pc_wdata', 32)]
    runner = args.work / 'NervReplay.lean'
    display = ','.join('{o.v_' + name + '.toNat}' for name, _ in ports)
    runner.write_text('import Examples.NervProofs\nopen v_NervAddi\n'
        + 'def main : IO Unit := do\n  let mut state : State := default\n'
        + '  for i in NervProofs.Addi.program do\n'
        + '    IO.println s!"I,{i.v_reset.toNat},{i.v_stall.toNat},{i.v_imem_data.toNat},{i.v_dmem_rdata.toNat}"\n'
        + '    let (o, next) := eval i state\n'
        + f'    if o.v_rvfi_valid == 1 then IO.println s!"R,{display}"\n'
        + '    state := next\n')
    actual = run([args.lake, 'env', 'lean', '--run', runner], env=env).stdout.splitlines()
    csv = args.work / 'NervReplay.csv'
    csv.write_text('\n'.join(line[2:] for line in actual if line.startswith('I,')) + '\n')
    expected = [line for line in actual if line.startswith('R,')]
    assert len(expected) == 4  # No duplicate report on the stalled edge.
    declarations = ' '.join(f'wire [{width-1}:0] {name};' for name, width in ports)
    connections = ','.join(f'.{name}({name})' for name, _ in ports)
    bench = args.work / 'NervReplay_tb.v'
    fmt = ','.join('%0d' for _ in ports)
    bench.write_text('module tb; reg clock=0; reg reset,stall; reg [31:0] imem_data,dmem_rdata; '
        + declarations + '\nnerv dut(.clock(clock),.reset(reset),.stall(stall),'
        + '.imem_data(imem_data),.dmem_rdata(dmem_rdata),' + connections + ');\n'
        + f'integer fd,n,k; initial begin for(k=0;k<32;k=k+1) dut.regfile[k]=0; '
        + f'fd=$fopen("{csv}","r"); while (!$feof(fd)) begin\n'
        + 'clock=0; n=$fscanf(fd,"%d,%d,%d,%d\\n",reset,stall,imem_data,dmem_rdata);\n'
        + f'if(n==4) begin #1; if(rvfi_valid) $display("R,{fmt}",{",".join(name for name,_ in ports)}); '
        + '#1; clock=1; #1; end end $finish; end endmodule\n')
    for name, source in [('Nerv', root / 'examples/riscv/upstream/nerv/nerv.sv'),
                         ('NervBad', root / 'build/cpu-mutants/nerv.sv')]:
        binary = args.work / (name + 'Replay.vvp')
        run([args.iverilog, '-g2012', '-D', 'NERV_RVFI', '-s', 'tb', '-o', binary, source, bench])
        rows = [line for line in run([args.vvp, binary]).stdout.splitlines() if line.startswith('R,')]
        if name == 'Nerv':
            assert rows == expected, (rows, expected)
        else:
            first = rows[0].split(',')
            assert int(first[1 + [n for n, _ in ports].index('rvfi_rd_wdata')]) == 6
            assert rows != expected
    print('PASS: proof program replay in unchanged NERV RTL; actual ADDI mutant writes 6 instead of 5', flush=True)
