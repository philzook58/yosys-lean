"""Unchanged upstream assertions, explicit Verilog miters, and independent SMTBMC baselines."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import sys
from export import formal_scripts, quote


def check_formal_tutorials(args, run, yosys, root):
    manifest = json.loads((root / "examples/formal/sources.json").read_text())
    for relative, item in manifest["files"].items():
        data = (root / "examples/formal" / relative).read_bytes()
        blob = hashlib.sha1(b"blob " + str(len(data)).encode() + b"\0" + data).hexdigest()
        assert blob == item["git_blob"], f"Changed upstream source: {relative}"
    # The CMake-built script lives next to the configured Yosys executable.
    candidates = [Path(args.yosys).parent / "yosys-smtbmc",
                  root / "vendor/yosys/backends/smt2/smtbmc.py"]
    smtbmc = next((path for path in candidates if path.exists()), shutil.which("yosys-smtbmc"))
    if not smtbmc:
        raise AssertionError("Formal tutorial baselines require yosys-smtbmc or the pinned source checkout")
    for name, prefix in formal_scripts().items():
        smt = args.work / (name + "Reference.smt2")
        # Independent ordinary FF path. async2sync lowers clocked property monitors;
        # these fixtures contain no asynchronous-reset RTL. The Lean path does not use it.
        yosys(prefix + f"prep -top {name}; async2sync; chformal -lower; dffunmap; "
              + f"write_smt2 -wires {quote(smt)}")
        command = ([sys.executable, smtbmc] if str(smtbmc).endswith(".py") else [smtbmc])
        # Respect a custom Z3 selected by CMake, as the SMTBMC solver is found through PATH.
        solver_env = dict(os.environ)
        solver_env["PATH"] = str(Path(shutil.which(str(args.z3)) or args.z3).resolve().parent) + os.pathsep + solver_env["PATH"]
        options = ["-s", "z3", "-t", "20", "--timeout", "20"]
        if name == "SBYCover":
            result = run(command + options + ["-c", smt], env=solver_env)
            assert "Status: PASSED" in result.stdout and result.stdout.count("Reached cover") == 2
        elif name == "EQYFSMBad" or name.startswith("Bug"):
            result = run(command + options + ["--dump-vcd",
                         args.work / (name + "SMTBMC.vcd"), smt], env=solver_env, ok=False)
            assert result.returncode != 0 and "Status: FAILED" in result.stdout
        else:
            for mode in ([], ["-i"]):
                result = run(command + options + mode + [smt], env=solver_env)
                assert "Status: PASSED" in result.stdout
        print(f"PASS: {name} imported property baseline (SMTBMC/Z3)", flush=True)
