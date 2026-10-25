# Concrete counterexamples to buggy RTL

These are three original small implementation defects with meaningful assertions
written in Verilog. `REPAIRED` changes only the implementation; the assertion and
assumptions stay the same. These are separate from the earlier negative-control
example that deliberately changed an assertion.

Run from the project root:

```sh
ctest --test-dir build --output-on-failure
python3 scripts/check_lean.py --run Examples/ReplayCounterexamples.lean
```

CTest builds imports in dependency order. The second command prints the exact
Lean-certified witnesses for all buggy and repaired designs, with input values,
physical outputs, and imported assumption/assertion results at each sample.
It uses the same sequential memory/time limits as proof checking.

## Counter: terminal-count off-by-one

[Counter.v](Counter.v) intends to count modulo ten. The buggy comparison resets
at 10; the repaired comparison resets at 9. Both retain:

```verilog
if (!reset) count_in_range: assert(count < 10);
```

An imported assumption requires reset on the first sampled edge. The
[counter.csv](counter.csv) witness supplies that reset, then ten enabled edges,
and finally samples without reset or enable:

| Sample | reset | enable | Buggy count | Repaired count | Buggy assertion |
| ---: | ---: | ---: | ---: | ---: | --- |
| 0 | 1 | 0 | 0 | 0 | disabled / true |
| 1 | 0 | 1 | 0 | 0 | true |
| … | … | … | … | … | … |
| 10 | 0 | 1 | 9 | 9 | true |
| 11 | 0 | 0 | **10** | **0** | **false** |

Sample 11 is the first failed assertion on this execution.

## Buffer: overwriting a stalled valid word

[StallBuffer.v](StallBuffer.v) implements a one-entry ready/valid buffer. The
buggy data write is guarded by `in_valid`, while the repair requires
`in_valid && in_ready`. The shared Verilog property uses actual history:

```verilog
if (past_valid && !reset && $past(!reset && out_valid && !out_ready))
  stable_while_stalled: assert(out_valid && out_data == $past(out_data));
```

The [stall.csv](stall.csv) witness first resets, accepts 42, offers 99 while the
buffer is full and its consumer is stalled, then samples again:

| Sample | in_valid | in_data | out_ready | in_ready | Buggy out_data | Repaired out_data |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 1 | 42 | 0 | 1 | 0, invalid | 0, invalid |
| 2 | 1 | 99 | 0 | **0** | 42 | 42 |
| 3 | 0 | 0 | 0 | 0 | **99** | **42** |

At sample 3, the imported assertion compares against the previous stalled word,
42, and fails on the buggy implementation. Every imported assumption holds.
Yosys lowers `$past` to explicit history registers in the exported circuit.

## RV32 shift: six amount bits instead of five

[ShiftWidth.v](ShiftWidth.v) is a minimal original reproduction of the shift-width
bug described in the [EQY NERV tutorial](https://yosyshq.readthedocs.io/projects/eqy/en/latest/quickstart.html).
The buggy datapath shifts by `amount[5:0]`; the repair uses `amount[4:0]`.
An unchanged Verilog assertion compares the result against RV32's five-bit amount.
The [shift.csv](shift.csv) witness is one combinational sample:

| value | amount | Required shift | Buggy shift | Buggy result | Repaired result |
| --- | --- | ---: | ---: | --- | --- |
| `0xe0000000` | `0x1fffffe2` | 2 | 34 | **`0x00000000`** | **`0x80000000`** |

This is a reproducer of that defect, not a proof about the entire NERV CPU.

## What is proved and independently checked

[BugCounterexamples.lean](../../Examples/BugCounterexamples.lean) proves for each witness:

- The chosen initial state satisfies the exported `initial` predicate.
- Every sample satisfies the actual imported assumptions.
- At least one sample violates the actual imported assertion predicate.
- Therefore the implementation does not satisfy the general `Safety` judgment.
- The same inputs satisfy the imported assertions on the repaired implementation.

The two sequential witnesses also have Lean proofs that every earlier sample
satisfies its assertions. The witnesses select zero for unspecified initial
registers, and Lean verifies that this is permitted by the RTL initialization.
It does not assume that unspecified registers universally start at zero.
The first-reset assumption and assertion enables remain explicit in the exports.

The generic `Counterexample` definition and its `not_safe` theorem live in
[YosysLean/Formal.lean](../../YosysLean/Formal.lean). No circuit-specific tactic
or exporter logic is needed. All proof results enforce the standard-axiom audit.

[RepairProofs.lean](../../Examples/RepairProofs.lean) additionally proves `Safety`
for **all three repaired implementations**, over every finite input sequence and
every initial state allowed by the exported `initial` predicate. These proofs
target the actual imported assertions, under the actual imported assumptions:

- Counter: before the required first reset the count may be arbitrary; afterwards
  the invariant keeps it below ten, including across later resets and disabled edges.
- Buffer: the explicit `$past` registers record the previous stall flag and data.
  If that flag is set, the current buffer remains full and its data equals the
  recorded word. Input data and handshake signals remain arbitrary; no assumption
  requires the producer to hold its input steady while blocked.
- Shift: the combinational assertion holds for every pair of 32-bit operands,
  without assumptions or a bound on the number of input samples.

The counter and buffer retain their imported first-reset assumptions. Unspecified
registers, including history registers before `past_valid`, are not assumed zero
in these universal proofs. All three use the generic invariant rule and standard
Lean axioms; the exporter needs no circuit-specific changes.

Here, correctness means the stated assertions: counter range, stalled-word
stability, and shift-result equality. The first two are partial specifications;
they do not establish every behavior expected of a modulo-ten counter or a buffer
(for example, counting progress or eventual delivery).

The regression suite additionally:

- Uses SMTBMC/Z3 to find failures for all three buggy designs and runs BMC plus
  temporal induction on all three repairs.
- Replays the exact checked-in CSVs through actual Lean execution and Icarus RTL,
  checking the physical outputs agree on every sample.
- Checks assumption results, first-failure indices, and repaired assertion results
  from the Lean replay. It also checks the CSVs match the theorem input sequences.
- Produces `build/tests/CounterexampleReplay.txt` and native simulation waveforms
  `build/tests/BugCounterWitness.vcd`, `BugStallWitness.vcd`, and `BugShiftWitness.vcd`,
  plus corresponding repaired waveforms. Separate `*SMTBMC.vcd` files show the
  solver-discovered traces, which can differ from the hand-selected witnesses.

Outputs are sampled before each modeled edge. The input row at a failed sample
is included so its assertion and assumptions are evaluated; the failure is in
that sample's pre-edge state/output. The combinational shift example needs no edge.
