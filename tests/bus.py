"""Pinned bus RTL: export identity, independent SMT lowering, and upstream property controls."""
import hashlib
import json
import os
import re
from pathlib import Path
import shutil
import sys
from export import bus_scripts, quote
from smt import comparison


def check_bus(args, run, yosys, generated, root):
    manifest = json.loads((root / 'examples/bus/sources.json').read_text())
    for relative, digest in manifest['sha256'].items():
        assert hashlib.sha256((root / 'examples/bus' / relative).read_bytes()).hexdigest() == digest
    solver_env = dict(os.environ)
    solver_env['PATH'] = str(Path(shutil.which(str(args.z3)) or args.z3).resolve().parent) + os.pathsep + solver_env['PATH']
    candidates = [Path(args.yosys).parent / 'yosys-smtbmc',
                  root / 'vendor/yosys/backends/smt2/smtbmc.py']
    smtbmc = next(p for p in candidates if p.exists())
    command = [sys.executable, smtbmc] if smtbmc.suffix == '.py' else [smtbmc]
    for name, prefix in bus_scripts().items():
        checked_in = root / 'Examples/Generated' / (name + '.lean')
        def content(path):
            return re.sub(r'^-- Yosys:.*\n', '', path.read_text(), flags=re.M)
        assert content(generated / (name + '.lean')) == content(checked_in), name
        smt = args.work / (name + 'Reference.smt2')
        if not name.endswith('Formal'):
            yosys(prefix + f'proc; flatten; opt_clean; dffunmap; write_smt2 -stdt -wires {quote(smt)}')
            query = args.work / (name + 'Compare.smt2')
            query.write_text(comparison(checked_in.read_text(), smt.read_text(), name))
            assert run([args.z3, '-T:20', query]).stdout.strip() == 'unsat', name
            continue
        yosys(prefix + f'prep -top {name}; async2sync; chformal -lower; dffunmap; write_smt2 -wires {quote(smt)}')
        options = ['-s', 'z3', '-t', '8', '--timeout', '20']
        for mode in ([[]] if 'Bad' in name else [[], ['-i']]):
            result = run(command + options + mode + ['--dump-vcd', args.work / (name + '.vcd'), smt],
                         env=solver_env, ok=False)
            label = 'Induction' if mode else 'BMC'
            (args.work / (name + label + '.log')).write_text(result.stdout + result.stderr)
            if 'Bad' in name:
                assert result.returncode != 0 and 'Status: FAILED' in result.stdout, result.stdout
            else:
                # Timeouts and a successful induction step alone are never a pass.
                assert result.returncode == 0 and 'Status: PASSED' in result.stdout, result.stdout
        print(f'PASS: {name} upstream assertions ({"counterexample" if "Bad" in name else "base + induction"})', flush=True)
    print('PASS: bus export regeneration and arbitrary-state SMT agreement', flush=True)
