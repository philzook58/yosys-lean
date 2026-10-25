#!/usr/bin/env python3
"""Check Lean files sequentially with OS memory and wall-time limits (Linux/Unix)."""
import argparse
import os
from pathlib import Path
import resource
import signal
import subprocess
import time

ROOT = Path(__file__).resolve().parent.parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("files", nargs="+", type=Path)
    parser.add_argument("--output", type=Path, help="Save an olean; requires exactly one input")
    parser.add_argument("--heartbeats", type=int,
                        help="Override Lean's per-declaration heartbeat budget; OS limits stay fixed")
    parser.add_argument("--run", action="store_true", help="Run main after checking; keeps all limits")
    parser.add_argument("--deps", action="store_true",
                        help="Build the selected files and their local imports sequentially")
    args = parser.parse_args()

    def interrupted(signum, frame):
        # Explicit handlers also work when a launcher inherited SIGINT ignored.
        raise KeyboardInterrupt

    signal.signal(signal.SIGINT, interrupted)
    signal.signal(signal.SIGTERM, interrupted)
    if args.heartbeats is not None and args.heartbeats <= 0:
        parser.error("--heartbeats must be positive")
    if args.output and args.run:
        parser.error("--output and --run are mutually exclusive")
    if args.output and len(args.files) != 1:
        parser.error("--output requires one input file")

    def limits():
        signal.pthread_sigmask(signal.SIG_UNBLOCK, {signal.SIGINT, signal.SIGTERM})
        # Bound virtual memory as well as Lean's own allocation accounting.
        maximum = 4 * 1024 * 1024 * 1024
        resource.setrlimit(resource.RLIMIT_AS, (maximum, maximum))
        resource.setrlimit(resource.RLIMIT_CPU, (120, 120))

    lean_path = str(ROOT / ".lake/build/lib/lean")
    if os.environ.get("LEAN_PATH"):
        lean_path += os.pathsep + os.environ["LEAN_PATH"]
    source_path = str(ROOT)
    if os.environ.get("LEAN_SRC_PATH"):
        source_path += os.pathsep + os.environ["LEAN_SRC_PATH"]
    env = dict(os.environ, LEAN_PATH=lean_path, LEAN_SRC_PATH=source_path)
    lean = ["lean", "-M1024", "-j1", "-s8192", "-DmaxErrors=1",
            "-DmaxRecDepth=4096", "-DElab.async=false"]
    if args.heartbeats is not None:
        lean += [f"-DmaxHeartbeats={args.heartbeats}"]
    print("Limits: one Lean process, 1 GiB Lean memory, 4 GiB address space, 120 s", flush=True)

    def check(path, output=None, run=False):
        full_path = (ROOT / path).resolve()
        label = full_path.relative_to(ROOT) if ROOT in full_path.parents else full_path
        print(f"Checking {label}", flush=True)
        command = lean.copy()
        if output:
            (ROOT / output).parent.mkdir(parents=True, exist_ok=True)
            command += ["-o", str(output)]
        if run:
            command += ["--run"]
        start = time.monotonic()
        # Defer cancellation until the child is assigned and cleanup is active.
        mask = signal.pthread_sigmask(signal.SIG_BLOCK, {signal.SIGINT, signal.SIGTERM})
        try:
            proc = subprocess.Popen(
                command + [str(path)], cwd=ROOT, env=env,
                preexec_fn=limits, start_new_session=True)
        except BaseException:
            signal.pthread_sigmask(signal.SIG_SETMASK, mask)
            raise
        try:
            signal.pthread_sigmask(signal.SIG_SETMASK, mask)
            while True:
                pid, status, usage = os.wait4(proc.pid, os.WNOHANG)
                if pid:
                    proc.returncode = os.waitstatus_to_exitcode(status)
                    break
                if time.monotonic() - start > 120:
                    os.killpg(proc.pid, signal.SIGKILL)
                    _, status, _ = os.wait4(proc.pid, 0)
                    proc.returncode = os.waitstatus_to_exitcode(status)
                    raise SystemExit(f"Timed out checking {path}; process group stopped")
                time.sleep(0.05)
        except BaseException:
            # Lean runs in its own process group; cancelling this checker must
            # stop it too, rather than leaving a proof consuming memory unseen.
            if proc.returncode is None:
                try:
                    os.killpg(proc.pid, signal.SIGKILL)
                except ProcessLookupError:
                    pass
                proc.wait()
            raise
        code = proc.returncode
        print(f"{'FAIL' if code else 'CHECKED'} {label}: {time.monotonic()-start:.2f} s, "
              f"peak {usage.ru_maxrss // 1024} MiB", flush=True)
        if code:
            raise SystemExit(code)

    roots = [(ROOT / path).resolve() for path in args.files]
    if args.deps:
        order, visiting, visited = [], set(), set()

        def visit(path):
            if path in visiting:
                raise SystemExit(f"Import cycle at {path}")
            if path in visited:
                return
            visiting.add(path)
            # Use Lean's import parser, not a second parser for Lean source.
            deps = subprocess.run(lean + ["--src-deps", str(path)], cwd=ROOT, env=env,
                                  text=True, capture_output=True, preexec_fn=limits, timeout=15)
            if deps.returncode:
                raise SystemExit(deps.stdout + deps.stderr)
            for line in deps.stdout.splitlines():
                dependency = (ROOT / line).resolve()
                if ROOT in dependency.parents:
                    visit(dependency)
            visiting.remove(path)
            visited.add(path)
            order.append(path)

        for path in roots:
            if ROOT not in path.parents:
                parser.error("--deps requires source files inside this project")
            visit(path)
        print(f"Building {len(order)} local modules sequentially (toolchain imports are prebuilt)",
              flush=True)
        for path in order:
            output = ROOT / ".lake/build/lib/lean" / path.relative_to(ROOT).with_suffix(".olean")
            if args.output and path in roots:
                output = args.output
            check(path, output=output)
        if args.run:
            for path in roots:
                check(path, run=True)
    else:
        for path in args.files:
            check(path, output=args.output, run=args.run)


if __name__ == "__main__":
    main()
