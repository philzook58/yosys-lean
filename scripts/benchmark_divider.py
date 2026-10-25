#!/usr/bin/env python3
"""Bounded, sequential SMTBMC baselines for the unsigned transaction proved in Lean."""
import argparse
import json
import math
import os
from pathlib import Path
import resource
import signal
import subprocess
import time

ROOT = Path(__file__).resolve().parent.parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--widths", nargs="+", type=int, default=[4, 8, 16, 32])
    parser.add_argument("--timeout", type=int, default=10, help="Seconds per solver run")
    parser.add_argument("--yosys", type=Path, default=ROOT / "build/yosys/yosys")
    parser.add_argument("--work", type=Path, default=ROOT / "build/divider-benchmark")
    args = parser.parse_args()
    if args.timeout < 1 or any(w < 4 or w > 32 or w & (w-1) for w in args.widths):
        parser.error("use positive timeouts and power-of-two widths between 4 and 32")
    args.work.mkdir(parents=True, exist_ok=True)
    smtbmc = args.yosys.parent / "yosys-smtbmc"

    def limits():
        resource.setrlimit(resource.RLIMIT_AS, (1024**3, 1024**3))
        resource.setrlimit(resource.RLIMIT_CPU, (args.timeout+5, args.timeout+5))

    def run(name, command):
        log = args.work / (name + ".log")
        usage = args.work / (name + ".usage")
        start = time.monotonic()
        with log.open("w") as output:
            proc = subprocess.Popen(["/usr/bin/time", "-f", "%e %M", "-o", usage, *map(str, command)],
                cwd=ROOT, stdout=output, stderr=subprocess.STDOUT,
                preexec_fn=limits, start_new_session=True)
            try:
                code = proc.wait(timeout=args.timeout+10)
            except subprocess.TimeoutExpired:
                os.killpg(proc.pid, signal.SIGKILL)
                proc.wait()
                code = None
        elapsed = round(time.monotonic()-start, 3)
        output = log.read_text()
        if "Status: PASSED" in output:
            status = "passed"
        elif "Status: FAILED" in output:
            status = "failed"
        elif code is None or "timeout" in output.lower():
            status = "timeout"
        else:
            status = "error"
        rss = None
        if usage.exists():
            lines = usage.read_text().splitlines()
            if lines and len(lines[-1].split()) == 2:
                rss = int(lines[-1].split()[1])
        result = dict(name=name, status=status, wall_seconds=elapsed,
                      peak_child_rss_kib=rss, returncode=code, log=str(log))
        print(json.dumps(result), flush=True)
        return result

    results = []
    for width in args.widths:
        for broken in ([False, True] if width == 4 else [False]):
            name = f"div{width}" + ("-negative" if broken else "")
            smt = args.work / (name + ".smt2")
            # Match the plain RTL used by the Lean arithmetic theorem. The core's
            # separate FORMAL section changes assume/assert roles with the DIV macro.
            script = ("read_verilog examples/zipcpu/upstream/div.v; read_verilog -formal "
                + ("-DBROKEN_PROPERTY " if broken else "")
                + "examples/zipcpu/UnsignedContract.v; "
                + f"chparam -set BW {width} -set LGBW {int(math.log2(width))} DividerUnsignedContract; "
                + "prep -top DividerUnsignedContract; async2sync; chformal -lower; dffunmap; "
                + f'write_smt2 -wires "{smt}"')
            subprocess.run([args.yosys, "-Q", "-T", "-p", script], cwd=ROOT,
                           stdout=subprocess.DEVNULL, check=True, timeout=30, preexec_fn=limits)
            for mode in (["bmc"] if broken else ["bmc", "induction"]):
                result = run(name + "-" + mode, [smtbmc, "-s", "z3", "--timeout", str(args.timeout),
                    "-t", str(width+4), *(["-i"] if mode == "induction" else []), smt])
                results.append(dict(width=width, mode=mode, negative_control=broken, **result))
    versions = {"yosys": subprocess.check_output([args.yosys, "-V"], text=True).strip(),
                "z3": subprocess.check_output(["z3", "--version"], text=True).strip()}
    (args.work / "results.json").write_text(json.dumps(dict(
        versions=versions, timeout_seconds=args.timeout, address_space_limit_mib=1024,
        cpu_limit_seconds=args.timeout+5, wall_limit_seconds=args.timeout+10,
        results=results), indent=2) + "\n")
    for row in results:
        if row["width"] == 4:
            expected = "failed" if row["negative_control"] else "passed"
            if row["status"] != expected:
                raise SystemExit(f"Four-bit baseline must be {expected}: {row['name']}")


if __name__ == "__main__":
    main()
