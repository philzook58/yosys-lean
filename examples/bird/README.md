# Adder and CRC examples

Upstream RTL is copied from [satnam6502/bird-meertens](https://github.com/satnam6502/bird-meertens)
at commit `64d238c04649f48529871664bcf633eb7a868b73`, under its Apache-2.0
license (included in `upstream/LICENSE`). The files are `Adder/sklansky_adder_32.v`
and `CRC/crc8.sv`; tests pin their Git blob hashes. We reuse the printed RTL,
not the upstream Lean proof or its proof dependencies.

The Sklansky adder is unchanged. `ripple.v` is an independent 32-column ripple
implementation. Both are proved equal to widened 33-bit addition for arbitrary
32-bit operands and carry-in, including overflow. Consequently their complete
sum/carry outputs agree. Gate depth and physical timing are not proved.

The adder proof exposes carry wires through generated `*Wires.lean` views.
Each view copies the exported evaluation and adds observations; its `projection`
theorem is checked by `rfl` against the original model. Carry lemmas use small
Boolean identities and the standard BitVec carry recurrence. Carry and output
proofs live in separate modules to bound kernel memory use. No SAT certificate
is reduced as a single giant kernel computation.

`crc8_sync.sv` explicitly adapts the upstream asynchronous active-low reset to
synchronous active-low reset and renames the module. The test suite checks that
these, plus the introductory comment, are its only changes. The original RTL's
asynchronous reset behavior is outside this exporter's supported semantics.
`crc_byte.v` is an independent eight-step, MSB-first implementation.

The CRC proof specifies one update by polynomial coefficient bits: reduce
`r*X + b*X^8` modulo `X^8 + X^2 + X + 1` using a degree-at-most-eight division
step. It connects the exported wiring to this independent recurrence, lifts it
to arbitrary finite messages, and proves one byte update equals eight serial
updates. Reset seeds `0xff`; valid-low holds the remainder. It does not claim a
separate theorem about dividing one whole-message polynomial, CRC reflection,
final XOR conventions, or asynchronous reset equivalence.

Run all exports, differential execution checks, and sequential bounded proof
checks with `ctest --test-dir build --output-on-failure`. See the top-level
README for the limits and individual-file checker.
