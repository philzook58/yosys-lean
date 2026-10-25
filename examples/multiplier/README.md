# Shift-and-add multiplier

`ShiftAdd.v` is an original ISC-licensed unsigned 32×32→64 design. It uses
one conditional addition per busy edge, shifts the multiplicand left, shifts the
remaining multiplier right, and counts down from 32. It contains no Verilog `*`.
This is an arithmetic/refinement example rather than an optimized multiplier.

A start request is accepted when `busy=0` and reset is inactive. That edge loads
the operands and clears the accumulator. The following 32 rising edges process
the bits; after the last edge `busy=0`, `done=1`, and `product` holds the result.
`done` clears on the next edge, including when another request is accepted.
Busy edges ignore start and operand changes. Reset is synchronous, clears all
registers, and aborts pending work. Initial busy/done bits are zero; other initial
registers are unconstrained. Product may change while busy; consume it on done.
Outputs in exported Lean are sampled before each modeled edge, as elsewhere in
this project.

`Examples/MultiplierProofs.lean` proves:

- Every exported active step matches the handwritten shift/add recurrence.
- Each step preserves `accumulator + lhs * rhs`, modulo 2^64.
- A counter-based induction consumes all remaining bits and establishes completion.
- From any idle state, an accepted request followed by 32 processing edges has
  `busy=0`, `done=1`, and a result whose natural-number value is exactly `a*b`.
  The operand bounds prove there is no 64-bit overflow for 32-bit inputs.
- Reset flushing, idle holding, busy input independence, and done clearing.

The completion theorem uses inactive reset and idle input samples during the
processing phase. The separate busy-step theorem establishes independence from
start and operand noise on active edges. It does not claim an unbounded temporal
property for arbitrary interleavings of reset and requests. Exact cycle latency,
including absence of early done, is additionally checked by execution tests.

The proof uses small BitVec identities and induction, with no exhaustive operand
enumeration, native evaluation axiom, SAT certificate, or custom axiom. It is
checked with the same standard-axiom audit and resource limits as the other demos.

Tests compare the generated circuit symbolically with `write_smt2`, then compare
actual Lean execution and Icarus over 6,619 edges. An independent scoreboard checks
193 complete full-width products, fixed latency, busy request noise, done pulses,
and four reset aborts. Regenerated exports are compared with the checked-in model.

The barrel-shift-and-add variant and its completion-equivalence proof are described below.

## Barrel-shift implementation

`BarrelMul.v` retains the original multiplicand and advances a six-bit position
register by two per busy edge. A variable shift selects `multiplicand << position`;
the low two remaining multiplier bits select that value and its one-bit shift.
Two additions accumulate those contributions. Sixteen processing edges cover the
32 multiplier bits. Acceptance, reset, and done behavior follow the same contract.

| Implementation | Processing edges after acceptance | Accumulation per edge | Shift selection |
| --- | ---: | --- | --- |
| `ShiftAdd` | 32 | One conditional addition | Constant one-bit register shifts |
| `BarrelMul` | 16 | Two conditional contributions | Variable-position barrel shift |

`Examples/BarrelMultiplierProofs.lean` proves the exported active-step equation,
composes two serial arithmetic invariant steps, and proves the shift-position
counter does not wrap during the transaction. Induction establishes the exact
full-width product, idle completion, and asserted done after 16 processing edges.
Its `implementations_agree` theorem relates completed barrel and serial products
for arbitrary operands and arbitrary idle starting states at their respective
16- and 32-edge completion boundaries. Reset, idle holding, busy request
independence, and done clearing are also proved and audited for axioms.

The same test harness checks another 3,507 barrel-multiplier Lean/RTL edges,
193 complete products, and four reset aborts. It independently checks each partial
accumulator against `a * (b mod 2^processed_bits)` for both implementations,
as well as barrel positions, latency, and handshakes. Both exports are compared
with `write_smt2`. Physical timing and area remain outside the proof scope.
