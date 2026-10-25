# ZipCPU iterative divider

`upstream/div.v` is unchanged from ZipCPU commit
[`42606d2d6ef55df313772232977621b2d72f0159`](https://github.com/ZipCPU/zipcpu/tree/42606d2d6ef55df313772232977621b2d72f0159).
Its Git blob is `5e5f5ef0d06c9fa071b624ca85278b109cda5528`.
`upstream/div.sby` is the accompanying formal configuration, blob
`1d78c23c09a98e6de8527008310d9ded36faa1f5`; its relative source path refers to
the upstream repository layout. It is retained as a reference, not used by our build.
The RTL is copyright Gisselquist Technology, LLC, GPL-3.0-or-later; see its
header and `upstream/COPYING`. The project's ISC license does not relicense
this upstream material. No ZipCPU toolchain or CPU core is needed.

`scripts/export.py` elaborates three instances from this same source:

| Lean module | Parameters | Purpose |
| --- | --- | --- |
| `Examples.Generated.ZipDiv4` | `BW=4`, `LGBW=2` | Exhaustive arithmetic proof |
| `Examples.Generated.ZipDiv32` | `BW=32`, `LGBW=5` | Full-width interface proofs and execution |
| `Examples.Generated.ZipDivFormal` | 32 bits, `FORMAL`, `DIV` | Upstream assertions and assumptions |

All use `OPT_LOWPOWER=0`. Width is changed through Yosys parameters, without
editing the RTL. `LGBW` matches these power-of-two widths. The generated source
comments identify original registers, property cells, and source locations.

## Completed Lean proofs

`Examples/DividerProofs.lean` establishes:

- `arithmetic4`: all 512 combinations of four-bit numerator, denominator, and
  signed/unsigned mode complete within six processing edges after acceptance.
  The first valid sample has busy low and the correct error bit. For a nonzero
  denominator, its quotient equals unsigned division or signed division truncated
  toward zero. Signed minimum divided by minus one retains the wrapped bit pattern.
  The next valid bit is zero. No quotient is specified on divide-by-zero error.
- `reset32`: reset clears the full-width interface and busy/sign control for
  arbitrary prior state, including interrupted operations.
- `accepts32`: an idle request latches both full-width operands and sets busy.
- `valid_pulse32` and `trace_pulses32`: valid self-clears, and no finite trace has
  two consecutive high valid samples, even with arbitrary requests and resets.

The exhaustive theorem launches from the concrete all-zero idle state, which
satisfies the RTL's initial predicate. It does not quantify over every assignment
to unspecified initial register bits or arbitrary intervening inputs. The full-width
acceptance/reset/pulse theorems do quantify over arbitrary state under their stated
conditions. All proofs use the Lean kernel and enforce the project's standard-axiom audit.

### Universal 32-bit arithmetic and completion

[Divider32Proofs.lean](../../Examples/Divider32Proofs.lean) and
[DividerSignedProofs.lean](../../Examples/DividerSignedProofs.lean) prove the actual
32-bit exported transition function correct for arbitrary operand values. The
four-bit exhaustive proof is retained as an independent small-instance check;
the new proofs do not enumerate operands or expand all processing cycles at once.

- `unsigned_outputs`: after acceptance and exactly 32 processing edges, the
  physical quotient output equals `a / b`, busy is low, valid is high, and error is low.
- `unsigned_in_progress`: every shorter processing prefix has busy high, valid low,
  and error low. Operand buses and signed mode may change arbitrarily after acceptance.
- `signed_completed`: the physical quotient equals `a.sdiv b`, including the
  wrapped minimum-signed / -1 case. There are 32 divide edges, plus one preprocessing
  edge if either operand is negative, plus one final correction edge if signs differ.
- `transaction_execution` connects the staged signed proof to an ordinary execution
  of the original export; `processing_latency` counts its 32, 33, or 34 processing edges.
  `signed_in_progress` proves that every shorter magnitude-loop prefix remains busy.
- `divide_by_zero` and `signed_divide_by_zero`: zero denominators complete with error
  after one processing edge, regardless of sign preprocessing. No quotient is specified.
- `reset_ready`: reset aborts any prior phase and produces a state ready for a new
  request. The existing universal valid-pulse proof applies to completed transactions.

Arithmetic transactions start from `Ready`: internal busy, preprocessing, sign,
and valid are low. `initial_ready` proves that **every** state satisfying the RTL's
actual initialization satisfies this condition, including arbitrary unspecified
data registers. Reset also establishes it. Reset and new write requests must stay
low during processing; operand values and signed mode need not be held steady.
The proof does not claim that a new request while busy is ignored.

[DividerArithmetic.lean](../../Examples/DividerArithmetic.lean) defines the small
natural-number recurrence. At decision count `n`, its balance is

```text
workspace + denominator * 2^32 * partial_quotient = 2^n * numerator
```

An accompanying remainder bound establishes division, and size bounds justify
the RTL truncations. The 63-bit workspace can wrap after the final decision; the
proof models that explicitly, since only the quotient is returned. Sign
preprocessing can append a quotient bit before the divide loop. The general
alignment relation carries those seed bits and proves that 32 decisions shift
them out, rather than incorrectly assuming preprocessing leaves quotient zero.

These are fixed 32-bit proofs, not proofs for all parameter values. Arithmetic
flags are still checked by execution, rather than fully proved. The new theorems
state transaction contracts over physical signals; they do not claim an unbounded
proof of every assertion in the upstream `FORMAL` section. All final theorems
enforce the standard-axiom audit and use the existing sequential resource limits.

### Independent SMTBMC transaction benchmark

[UnsignedContract.v](UnsignedContract.v) encodes the unsigned request, first-valid
timing, quotient equality, and valid clearing as Verilog assumptions/assertions.
It makes one request from the specified initial state, assumes its denominator is
nonzero, and leaves operand buses unconstrained afterwards. This matches the
nonzero unsigned theorem's transaction behavior. Lean additionally proves the
contract from arbitrary `Ready` states, signed operation, and zero-divisor error.

```sh
python3 scripts/benchmark_divider.py
python3 scripts/benchmark_divider.py --widths 32 --timeout 30 --work build/divider-benchmark-30s
```

The script runs BMC and temporal induction sequentially with Z3, a 1 GiB address-space
limit per process, and explicit timeouts. Logs, per-run wall time, peak child RSS,
tool versions, and statuses are saved in `results.json` in the work directory.
The four-bit case must pass both checks; a bit-flipped arithmetic assertion must
fail, so the arithmetic check is exercised rather than disabled by the harness.
CTest runs this small positive/negative control. Larger measurements are optional.

Measured with pinned Yosys `3718f7f13` and Z3 4.13.4 on this workspace:

| Width | Solver timeout | BMC | Induction |
| ---: | ---: | --- | --- |
| 4 | 10 s | passed, 0.12 s | passed, 0.12 s |
| 8 | 10 s | passed, 0.37 s | passed, 0.17 s |
| 16 | 10 s | timeout | passed, 0.52 s |
| 32 | 30 s | timeout | passed, 13.25 s |

The four-bit negative control fails as expected. Neither the 16-bit nor 32-bit
row establishes full safety in SMTBMC, because its base check did not complete
within the chosen budget. Lean's universal 32-bit theorem includes initialization,
preservation, arithmetic, and completion; it is not just an induction-step check.
Proof discovery required manual mathematical work, so checking time alone is not
a measure of total verification effort.

The benchmark reads the core as plain RTL and only the wrapper with `-formal`,
matching the plain export used by the arithmetic proof. The core's separate
formal section switches environment assumptions into assertions unless `DIV` is
defined; it is not part of this transaction benchmark. Its existing independent
execution checks remain in the regression suite.

A timeout is an inconclusive result, not evidence that SMTBMC cannot prove the
property. Induction alone is also insufficient without a passing base case.
This measures the chosen harness, solver, and settings; it is not a comparison
against every SBY strategy or EQY partitioning.

## Execution and translation checks

Tests compare both plain exports against `write_smt2` symbolically for arbitrary
inputs and register states. Actual Lean execution is also compared with Icarus for
2,338 four-bit edges and 9,436 full-width edges, checking all output and internal
register values. Each width includes 228 transactions checked against an independent
integer division and latency oracle, with boundary cases and seeded random cases.
Inputs change after acceptance, and resets abort operations at different phases.
These are execution checks, not universal arithmetic proofs.

The full-width samples also execute the exported upstream formal harness: every
sample must satisfy both its assumptions and assertions. These checks do not claim
to reproduce an unbounded SBY proof. The upstream formal section itself describes
its arithmetic verification as incomplete.

## Formal properties in generated Lean

Property cells appear as named one-bit fields in `Outputs`, alongside physical
outputs, with their kind and source location in comments:

- Assertions and assumptions report `EN → A`; disabled properties are true.
- Covers report `EN ∧ A`; a disabled cover is false.
- `assertions` and `assumptions` conjoin their respective fields.
- `covers` disjoins cover fields; individual fields remain separately addressable.

These predicates do not constrain `eval` or `initial`. A safety proof must explicitly
state when assumptions hold and establish assertions on those executions. A cover
requires an actual reachable witness. Initial-only assumptions are enabled by a
one-bit state flag that starts high and becomes low after the first edge.

Edge-triggered properties must use the same direct rising-edge clock as the RTL.
Their predicates observe the pre-edge state, consistent with Verilog nonblocking
assignments and the exporter interface. `$past` history becomes ordinary explicit
register state. Nondeterministic generators, liveness/fairness properties, and
formatted property messages remain unsupported.
