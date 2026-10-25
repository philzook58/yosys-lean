#!/usr/bin/env python3
"""Reproduce pinned Ibex Verilog with an explicitly supplied sv2v v0.0.13 executable."""
import argparse
import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('sv2v', type=Path)
parser.add_argument('--check', action='store_true', help='Compare without rewriting the checked-in output')
args = parser.parse_args()
sv2v = args.sv2v.resolve()
version = subprocess.run([sv2v, '--version'], check=True, capture_output=True, text=True).stdout.strip()
if version != 'sv2v v0.0.13':
    parser.error(f'Expected sv2v v0.0.13, got {version!r}')
manifest = json.loads((ROOT / 'examples/ibex/sources.json').read_text())
command = manifest['conversion']['command'].split()[1:]
converted = subprocess.run([sv2v, *command], cwd=ROOT, check=True, capture_output=True).stdout
output = ROOT / 'examples/ibex' / manifest['conversion']['output']
if args.check:
    assert converted == output.read_bytes(), 'Stale converted Ibex ALU'
    print('PASS: pinned sv2v conversion reproduces the checked-in Verilog')
else:
    output.write_bytes(converted)
