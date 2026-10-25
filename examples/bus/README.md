# ZipCPU bus examples

Pinned, unchanged RTL and checkers from
[ZipCPU/wb2axip](https://github.com/ZipCPU/wb2axip/tree/2e8d3bc2d26ddc33d1881022a2a2b9d3f0c16b9b).
`sources.json` records the revision and SHA-256 hashes. Upstream copyright and
Apache-2.0 notices remain in each file; these files are not relicensed under ISC.

| Configuration | Lean result | Upstream property bundle |
| --- | --- | --- |
| `skidbuffer`: `DW=32`, `OPT_OUTREG=0`; other parameters at defaults | Ordered stream conservation; reset flush; all 9 imported assertions under all 3 imported assumptions | Also checked with SMTBMC base + induction |
| `easyaxil`: default 32-bit data, 4-bit address, no skid buffers or low-power option | Every next register equals a readable model; lifted to arbitrary finite executions; read/write and stall contracts | All 60 assertions under 22 assumptions checked with SMTBMC base + induction; **not yet universally proved in Lean** |

These are fixed configurations, not proofs for every upstream parameter choice.

## Read the proofs

- [SkidProofs.lean](../../Examples/SkidProofs.lean): buffered words plus accepted
  inputs equal delivered words plus remaining buffered words, for every reset-free
  epoch. This includes combinational bypass and capture on a downstream stall.
  Reset discards pending work. Permanent stalls do not imply eventual delivery.
- [SkidFormalProofs.lean](../../Examples/SkidFormalProofs.lean): `YosysLean.Safety`
  for the actual imported upstream assertion bundle, including the cover sequencer's
  default-branch assertion. The invariant records one edge of history and bounds
  that sequencer; unspecified initial monitor bits stay arbitrary.
- [AXILProofs.lean](../../Examples/AXILProofs.lean): four address-selected registers,
  per-byte write enables, response state, and backpressure. A read samples the old
  register value if a read and write share an edge. AXI-Lite's default implementation
  waits for both write channels before asserting their common ready signal.

The AXI-Lite model theorem holds for arbitrary inputs and states. Interpreting
writes as accepted bus transactions requires the master to retain valid requests,
addresses, data, and strobes until handshake. The unchanged formal harness makes
its environment assumptions explicit; its limits and reset requirements are part
of that separate contract.

```sh
python3 scripts/check_lean.py --deps Examples/SkidFormalProofs.lean
python3 scripts/check_lean.py --deps Examples/AXILProofs.lean
python3 scripts/check_lean.py --deps Examples/BusCounterexamples.lean
```

## Implementation bugs as controls

`bus_scripts()` in [export.py](../../scripts/export.py) applies two one-line
mutations into ignored `build/bus-mutants/`; no second copy of the upstream RTL
is maintained. One mutation stores zero instead of the stalled word. The other
ignores byte strobes and overwrites every byte. Assertions are unchanged.

[BusCounterexamples.lean](../../Examples/BusCounterexamples.lean) certifies initialized,
assumption-respecting failing executions of both mutants and checks the same
traces against the originals. The AXI-Lite start state includes the checkers'
required initial-one bits; blindly using an all-zero state would be invalid.
SMTBMC independently finds failures and saves VCDs in the test build directory.

## Validation and translation

CTest regenerates every export, checks upstream hashes, compares the plain and
mutated circuits symbolically with ordinary `write_smt2`, and runs the original
circuits through Lean and Icarus against Python stream/register models. Samples
include partial and zero-byte writes, independent channel arrival, simultaneous
reads/writes, stalls, and reset. Tests retain SMTBMC logs and require both base
and induction success; a timeout is a failure of the test, not a proof.

The export recipe uses `opt -keepdc`, `pmux2shiftx`, then `opt -keepdc` after
`lean_prepare`. This removes redundant logic and turns complete case decoders
into indexed muxes without substituting arbitrary constants for unknown bits.
No `setundef`, reset adaptation, source patch, or exporter special case is used
for the original circuits. The existing bounded runner uses a higher elaborator
recursion limit for the large AXI-Lite harness, with the same memory/time caps.

Next useful extensions: prove the full AXI-Lite harness in Lean, enable its skid
buffers and prove transaction equivalence, then connect a verified master to the
slave and discharge the component assumptions. These remain future work.
