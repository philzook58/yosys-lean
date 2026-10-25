# yosys-lean

**Goal: prove that a real Verilog CPU faithfully executes programs according to
an independent RISC-V specification—from instruction fetch through register updates
and memory effects—for arbitrarily long executions.**

Start with NERV and an explicit instruction subset. Correct fetch, register and
memory effects, control flow, traps, and progress under stated environment
assumptions are the obligations. The same small exporter and proof workflow should
then apply to another implementation, eventually a pipelined CPU.

**Current claim:** NERV executes stored programs using ADD/ADDI/LUI/AUIPC,
JAL/JALR, and all six conditional branches from an immutable, one-edge instruction
ROM. Actual fetches, registers, PC, and retirement agree with an independent ISA
model for arbitrary-length runs with stalls, provided executed PCs and selected
targets are aligned. A countdown loop has a CPU-level completion proof.
**Still open:** remaining instructions, data memory, precise traps, and general progress.
[Exact theorem and assumptions](examples/riscv/README.md#current-claim).

The supporting examples establish individual parts of this goal or exercise the
exporter. Evaluate a milestone by its claim and assumptions, not its theorem count.

A small external Yosys plugin emits ordinary `BitVec` functions. You supply the
specification and proof; Lean checks it. [Supported semantics](docs/semantics.md).
Currently this covers combinational and single-clock synchronous RTL with two-state
semantics. Memories and asynchronous resets are unsupported.

## A small example

This assertion is written in [Verilog](examples/bugs/Counter.v):

```verilog
if (!reset) count_in_range: assert(count < 10);
```

The buggy counter reaches ten. Lean certifies a failing execution and proves the
repaired implementation satisfies the **imported assertion on every allowed
execution**, under the imported first-reset assumption:

```lean
import Examples.RepairProofs
open v_FixedCounter

example : YosysLean.Safety eval initial assumptions assertions :=
  RepairProofs.Counter.safe
```

See [the counterexample and repair proofs](examples/bugs/README.md).

## Try it

Install the [build prerequisites](docs/build.md), including the pinned Lean toolchain.
Then:

```sh
cmake -S . -B build
cmake --build build -j3
python3 scripts/check_lean.py --deps Examples/RepairProofs.lean
```

The checker builds the selected proof's local imports sequentially under memory
and time limits. No prior full regression run is needed.

For a substantial example, start with the [32-bit divider walkthrough](docs/divider.md).
It proves signed and unsigned division for unchanged ZipCPU RTL using an invariant.

## Use your own RTL

```sh
build/yosys/yosys -m build/yosys_lean.so -p '
  read_verilog -formal design.v
  hierarchy -check -top Top
  lean_prepare
  write_lean -named build/Top.lean
'
```

The output contains `Inputs`, `State`, `Outputs`, `eval`, and `initial`, plus any
imported assertions, assumptions, and covers. One `eval` samples pre-edge outputs
and computes simultaneous register updates. Named signals and register updates
provide small proof targets. [Writing a proof](docs/proving.md).

## Examples

| Example | Proved in Lean |
| --- | --- |
| [Bug and repair pairs](examples/bugs/README.md) | Counterexamples and universal repair safety |
| [ZipCPU divider](examples/zipcpu/README.md) | Full 32-bit signed/unsigned quotient and completion |
| [ZipCPU bus components](examples/bus/README.md) | Skid stream conservation and imported safety; AXI-Lite register model and bug counterexamples |
| [Multipliers](examples/multiplier/README.md) | Full 32×32→64 result and serial/barrel equivalence |
| [NERV + RVFI](examples/riscv/README.md) | Stored arithmetic and control-flow execution, unbounded ADD checker safety, and injected fault workloads |
| [Ibex ALU](examples/ibex/README.md) | Full-width ADD/SUB/XOR/OR/AND on the real default ALU |
| [Hack CPUs](examples/hack/README.md) | Instruction refinement and two-cycle retirement correspondence |
| [Adder and CRC](examples/bird/README.md) | Arithmetic equivalence and serial/byte CRC correspondence |
| [Elastic stage](examples/elastic/README.md) | Transaction conservation and ordering under stalls |
| [SMTBMC/SBY/EQY examples](examples/formal/README.md) | Imported assertions, covers, and an FSM equivalence harness |

Each example documents its assumptions and limits. Proving a written assertion
does not establish behaviors that assertion leaves unspecified.

## Validation

```sh
ctest --test-dir build --output-on-failure
```

Tests check proofs sequentially, compare exports against `write_smt2`, and replay
circuits in Lean and Icarus. The translation trusts Yosys and this exporter;
this is not a certified Verilog compiler. [Checks and trust boundary](docs/validation.md).
Read [how passing proofs can give false confidence, and our improvement plan](docs/confidence.md).

# AI Disclosure
The code is heavily agent produced


[Installation options](docs/build.md) · [Semantics](docs/semantics.md) ·
[Proof workflow](docs/proving.md) · [Next benchmarks](ROADMAP.md)
