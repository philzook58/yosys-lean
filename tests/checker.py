"""Selected-proof checks must discover imports and rebuild changed source files."""
from pathlib import Path
import os
import signal
import subprocess
import time
import re
import sys
import tempfile


def check_checker(args, run, root):
    with tempfile.TemporaryDirectory(prefix="Checker_", dir=root / "tests") as directory:
        source = Path(directory)
        leaf, main = source / "Leaf.lean", source / "Main.lean"
        module = ".".join(leaf.relative_to(root).with_suffix("").parts)
        leaf.write_text("def checkerAnswer : Nat := 42\n")
        main.write_text(f"import {module}\n"
                        "example : checkerAnswer = 42 := by rfl\n"
                        "def main : IO Unit := IO.println checkerAnswer\n")
        command = [sys.executable, root / "scripts/check_lean.py", "--deps", main]
        result = run(command + ["--run"])
        assert "Building 2 local modules" in result.stdout
        assert "\n42\n" in result.stdout
        # A cached successful root must not hide an incompatible dependency edit.
        leaf.write_text("def checkerAnswer : Nat := 43\n")
        result = run(command, ok=False)
        assert result.returncode != 0 and "FAIL " in result.stdout, result.stdout

        # A successful compilation and an audited theorem are different results.
        main.write_text('import YosysLean.Check\ndef answer : Nat := 42\n')
        result = run(command)
        assert "CHECKED " in result.stdout and "CLAIM " not in result.stdout
        main.write_text('import YosysLean.Check\nnamespace AuditTest\n'
                        'theorem good (p : Prop) : p ∨ ¬p := Classical.em p\n'
                        '#check_claim good\nend AuditTest\n')
        result = run(command)
        assert "CLAIM AuditTest.good :" in result.stdout and "Classical.choice" in result.stdout

        cases = [
            ('theorem bad : False := by sorry\n#check_claim bad\n', 'sorryAx'),
            ('axiom extra : False\ntheorem bad : False := extra\n#check_claim bad\n', 'extra'),
            ('theorem bad : 2 + 2 = 4 := by native_decide\n#check_claim bad\n',
             'nonstandard axiom'),
            ('#check_claim missing\n', 'Unknown constant'),
            ('def answer : Nat := 42\n#check_claim answer\n', 'not a theorem'),
        ]
        for body, diagnostic in cases:
            main.write_text('import Lean.Elab.Tactic.Decide\nimport YosysLean.Check\n' + body)
            result = run(command, ok=False)
            assert result.returncode != 0 and diagnostic in result.stdout, result.stdout

        # An admission hidden in a compiled import must also be rejected.
        leaf.write_text('theorem hiddenAdmission : False := by sorry\n')
        main.write_text(f'import {module}\nimport YosysLean.Check\n'
                        'theorem bad : False := hiddenAdmission\n#check_claim bad\n')
        result = run(command, ok=False)
        assert result.returncode != 0 and 'sorryAx' in result.stdout, result.stdout
        # Interrupts must stop Lean's separate process group, including when a
        # launcher inherited SIGINT ignored. /proc matches the checker's Linux scope.
        main.write_text('def main : IO Unit := IO.sleep 60000\n')
        for cancellation in (signal.SIGINT, signal.SIGTERM):
            child = None
            checker = subprocess.Popen(
                [sys.executable, root / "scripts/check_lean.py", "--run", main],
                cwd=root, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
            try:
                deadline = time.monotonic() + 5
                children = Path(f"/proc/{checker.pid}/task/{checker.pid}/children")
                while time.monotonic() < deadline:
                    pids = children.read_text().split()
                    if pids and os.getpgid(int(pids[0])) == int(pids[0]):
                        child = int(pids[0])
                        break
                    time.sleep(.01)
                assert child is not None, "Checker did not start Lean"
                checker.send_signal(cancellation)
                output, _ = checker.communicate(timeout=5)
                assert checker.returncode != 0, output
                assert not Path(f"/proc/{child}").exists(), "Lean survived checker cancellation"
            finally:
                if checker.poll() is None:
                    checker.kill()
                    checker.wait()
                if child is not None and Path(f"/proc/{child}").exists():
                    os.killpg(child, signal.SIGKILL)
    print("PASS: checker cancellation kills and reaps Lean (SIGINT and SIGTERM)", flush=True)
    print("PASS: selected-proof dependency discovery, execution, and changed-import rejection", flush=True)
    print("PASS: shared claim audit accepts standard proofs and rejects admissions/extra trust", flush=True)


def check_readme(args, run, root):
    snippet = re.search(r"```lean\n(.*?)```", (root / "README.md").read_text(), re.S)[1]
    source = args.work / "ReadmeExample.lean"
    source.write_text(snippet)
    run([args.lake, "env", "lean", source])
    print("PASS: README proof example compiles verbatim", flush=True)
