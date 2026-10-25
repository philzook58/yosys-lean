# Proving properties imported from formal-verification examples

For concrete implementation defects and readable failure traces, see the
[bug examples](../bugs/README.md).

The assertions in this directory originate in upstream RTL or in an explicit
Verilog equivalence harness. Lean's final theorems target the exporter's
`assertions` predicates. Imported `assumptions` constrain allowed input traces;
they are not replaced with separately stated Lean environment assumptions.

Sources are copied unchanged and pinned by repository commit and Git blob hash
in [sources.json](sources.json). Each upstream directory includes its license.
Tests verify every pinned file. The `.sby` and `.eqy` files are provenance and
configuration references; this project does not interpret those configuration
languages or run the SBY/EQY drivers.

## Imported properties and checked results

| Upstream example | Property source | Result in Lean |
| --- | --- | --- |
| Yosys SMTBMC `examples/smtbmc/demo1.v` | Original `assert property(cnt != 15)` and initial `assume(!cnt[2])` | Safety for every finite execution satisfying the imported assumption |
| SBY `docs/examples/quickstart/demo.sv` | Original clocked `assert(counter < 32)` | Safety for arbitrary execution length, using the stronger invariant `counter <= 15` |
| SBY `docs/examples/quickstart/prove.sv` | Original testbench assumes reset initially and asserts `!dout[1:0]` while reset is inactive | Safety for arbitrary input bytes and resets, under the imported assumption |
| SBY `docs/examples/quickstart/cover.sv` | Two original clocked covers, for decimal 12345678 and hexadecimal 0x12345678 | Concrete exported executions reaching each individual cover |
| EQY `examples/simple/fsm.sv` | Original one-hot GOLD and binary GATE implementations, instantiated in [EqyFSMHarness.v](EqyFSMHarness.v) | The imported miter assertion holds on every execution after the first edge |

The EQY FSM's output registers have unspecified initial values. The harness gates
comparison with an initialized `started` bit so both outputs have been assigned.
This is an explicit defined-output comparison, not a claim to reproduce EQY's
complete safe-replacement/X-propagation semantics or its partition algorithm.
Its state relation follows the encoding map in the unchanged upstream `.eqy` file.

Two negative controls make the imported properties operational:

- A build-time flag changes the *Verilog miter assertion* to compare against a
  bit-flipped gate output. Lean certifies an initial state and one transition
  whose next sampled assertion fails; SMTBMC also reports failure.
- Without the SMTBMC demo's imported initial assumption, an otherwise valid
  initial state with `cnt=15` fails its assertion immediately. Lean checks both
  the failed assumption and failed assertion in that state.

The cover byte sequences were discovered by SMTBMC, then checked independently
by Lean against the generated transition function. The decimal target is reached
after five state updates and the hexadecimal target after six. The independent
SMTBMC path lowers clocked property monitors to extra registers, so its reported
cover step numbers include that monitor delay. The Lean exporter samples the
validated edge's pre-state directly.

Proof modules:

- [FormalTutorialProofs.lean](../../Examples/FormalTutorialProofs.lean): counter
  invariants, initial assumptions, FSM encoding, and negative controls.
- [SBYAccumulatorProofs.lean](../../Examples/SBYAccumulatorProofs.lean): exported
  mux network correspondence and the strengthening invariant needed by the
  original testbench assertion. The accumulator remains a multiple of four;
  state 2 can add only a multiple-of-four buffer.
- [SBYCoverProofs.lean](../../Examples/SBYCoverProofs.lean): both concrete cover witnesses.

## General safety interface

[YosysLean/Formal.lean](../../YosysLean/Formal.lean) supplies a small reusable judgment:

```lean
YosysLean.Safety eval initial assumptions assertions
```

It states that, for every finite input sequence and every state satisfying
`initial`, if every sampled output satisfies `assumptions`, every sampled output
also satisfies `assertions`. It includes the initial sampled output. The
`safety_of_invariant` theorem takes an initial-state proof, an assumption-guarded
preservation proof, and a proof that the invariant plus current assumptions imply
the assertion. It does not assume assertions while proving them.

No circuit-specific proof tactic was added. The small counters use finite local
checks plus induction over arbitrary trace length. The accumulator uses arithmetic
and case analysis; the FSM uses a relation between its two encodings. All final
theorems enforce the standard-axiom audit. The cover proofs are finite witnesses,
not safety or liveness claims.

## Independent baselines and running

Run `ctest --test-dir build --output-on-failure`. Tests regenerate exports,
verify source hashes, check all Lean modules sequentially under resource caps,
and run the configured Yosys's SMTBMC with Z3 against a separate ordinary-FF
`write_smt2` lowering path. Safety examples get both BMC and temporal induction;
the cover example must reach both targets, and the bad miter must fail.
The default CMake-built Yosys includes the SMTBMC script. An installed Yosys
configuration needs `yosys-smtbmc` available beside Yosys or on PATH.

The same regression also checks the separately documented original buggy/repair
pairs in `examples/bugs`; these are not pinned upstream tutorial sources.

The baseline uses `async2sync` to lower clocked property monitors. These selected
circuits have no asynchronous-reset RTL; the Lean export path does not use that
pass. SMTBMC is a comparison tool, not a trusted oracle used by the Lean proofs.
The SMTBMC check at induction depth 12 was insufficient for the SBY counter;
the regression uses depth 20. This is a tutorial compatibility exercise, not a
claim of a scaling advantage over the existing tools.

## Survey and current boundaries

Inspected upstream sources and tutorials:

- [Yosys SMTBMC examples](https://github.com/YosysHQ/yosys/tree/3718f7f135dc25381c50f18e550bdc5f48663ec3/examples/smtbmc):
  counter/initial-assumption demo; memory/trace demos; external `.smtc`
  constraints; `$anyconst`, `$anyseq`, and existential/universal examples;
  `assertpmux`-generated checks. Demo1 is proved here. External `.smtc` files
  are not Verilog assertions and are not imported. Symbolic generator cells,
  memories, and mixed rising/falling edges remain unsupported.
- [SBY current getting-started tutorial](https://yosyshq.readthedocs.io/projects/sby/en/latest/quickstart.html)
  uses a FIFO with overflow, count-step, and pointer-distance assertions. Its
  address generators use asynchronous reset and its storage is a memory. The
  exporter currently rejects those constructs. We have not silently made that
  FIFO synchronous or removed its data storage. The older, still-shipped
  [quickstart examples](https://github.com/YosysHQ/sby/tree/79fc9eddca5e33a28cc2f2cd19c9825efd9a7255/docs/examples/quickstart)
  provide the unchanged cases proved above.
- [SBY inductive-invariant example](https://github.com/YosysHQ/sby/tree/79fc9eddca5e33a28cc2f2cd19c9825efd9a7255/docs/examples/indinv)
  demonstrates strengthening a nonzero-state property. Its `let`/`inside`
  syntax needs a compatible frontend; it has been surveyed, not ported here.
- [SBY Fibonacci demo](https://github.com/YosysHQ/sby/blob/79fc9eddca5e33a28cc2f2cd19c9825efd9a7255/docs/examples/demos/fib.sv)
  combines `$past`, `$stable`, arithmetic assertions, covers, and eventuality.
  `$past`/`$stable` can lower to explicit history registers, but its liveness and
  fairness properties are outside our safety-only semantics. No property is
  dropped to claim the full demo passes.
- [EQY getting-started tutorial](https://yosyshq.readthedocs.io/projects/eqy/en/latest/quickstart.html)
  refactors NERV's RISC-V shifter and includes an intentional shift-width bug.
  It explicitly maps the register file with `memory_map`; its CPU equivalence
  proof is not done here. The
  [simple examples](https://github.com/YosysHQ/eqy/tree/fb8b21160297b3e66bf94f3c24f8a8bf1cd3fd51/examples/simple)
  include counter synthesis, aliases, hierarchy, grouping, and FSM recoding;
  the FSM is the selected sequential equivalence case. Other example directories
  contain NERV, PicoRV32, RISC16F84, and a mapped serial-parallel multiplier.

The next broadening steps suggested by this survey are explicit finite-memory
lowering or native memory support, well-defined asynchronous reset semantics,
and symbolic-input/state generators with their quantifiers preserved. Those are
semantic features, independent of which particular benchmark motivates them.
