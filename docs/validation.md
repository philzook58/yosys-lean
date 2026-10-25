# Proof checking and validation

For what these checks cannot establish, see
[false confidence and the improvement plan](confidence.md).

The adder, CRC, elastic, and multiplier examples use compositional proofs. The earlier
whole-SAT-certificate kernel reduction experiment exhausted machine memory and
has been disabled. Do not restore it. CTest checks every proof **sequentially**
in a fresh Lean process, with a 1 GiB Lean allocation limit, 4 GiB process address
space limit, one Lean worker, asynchronous elaboration disabled, and a 120-second
wall/CPU deadline. Timeouts stop the process group. The address-space limit is
larger because Lean reserves memory beyond its resident working set; these are
per-process limits, not a system-wide memory reservation.

For one example, including its local imports:

```sh
python3 scripts/check_lean.py --deps Examples/CrcProofs.lean
```

The new proof modules remain outside the default `Examples.lean` import tree to
avoid a normal parallel Lake build launching them together. CTest explicitly
checks their dependencies in order and prints peak child resident memory.
Opening them simultaneously in editor servers is outside the runner's limits.

## Regression coverage

The test suite:

- Uses Z3 to compare a symbolic interpretation of the emitted Lean expressions
  against ordinary `write_smt2`, over arbitrary inputs and register states.
  The test parser handles only the emitted grammar and is not part of the tool.
- Separately compares actual Lean execution with Icarus simulation over boundary
  and seeded random inputs, and clock sequences exercising reset and enable priority.
- Executes the two-cycle CPU through 311 clock edges, checking latched instructions,
  retirement-gated memory writes, PC wrap, and reset aborts against Icarus.
- Proves full-width signed/unsigned division and completion, compares both divider
  widths against `write_smt2`, and executes 11,774 Lean/RTL edges;
  independently checks 456 arithmetic/latency cases and the upstream formal predicates.
- Certifies three implementation counterexamples and unbounded safety of their repairs;
  replays their checked-in inputs against Icarus and independently checks SMTBMC results.
- Proves upstream imported assertions under their imported assumptions, checks both
  cover witnesses, and runs independent SMTBMC BMC/induction/negative baselines.
- Proves the ZipCPU skid buffer's nine imported assertions and stream conservation;
  proves the default AXI-Lite register model, checks its full upstream harness with
  SMTBMC, and certifies both implementation mutants' counterexamples in Lean.
- Proves unbounded NERV ADD checker safety; checks arbitrary-operand retirement, a stalled program,
  imported ADD/ADDI checker prefixes and covers, and an actual ADDI mutation;
  proves arithmetic, JAL/JALR, and six-branch register/PC simulation with stalls and ties
  retirement to pre-edge state; proves stored-program execution through an immutable
  one-edge ROM at the real request port, including reset entry and fetch coherence,
  under explicit reference-path support/alignment assumptions. Proves the stored
  countdown loop completes in eleven unstalled instructions and refines arbitrary
  runs with stalls; proves misaligned selected targets set the physical trap flag.
  All registers/PC/requests and valid RVFI reports are replayed against RTL and an
  independent ISA interpreter, including every branch taken/untaken and JALR corner
  cases; eight alignment cases check trap flags. A certified request-address mutant
  is the negative control.
  A wrong-write-address mutant passes RVFI checks
  but has a certified incorrect register-file result;
  proves five Ibex ALU operations and checks original SystemVerilog when Verilator is available.
- Checks five injected NERV faults against imported workload assertions and their
  unmodified-RTL controls, with finite Lean certificates, completion witnesses,
  independent SMTBMC, all-state printer comparisons, and actual Lean/Icarus replay.
  The upstream instruction-only checks deliberately pass these faulty designs.
- Checks independent `$anyseq` choices in both printers, including changing values
  across edges; fixed-value and universally quantified formal generators remain rejected.
- Checks property enable semantics, nonvacuous covers, initial-only assumptions,
  pre-edge assertion sampling, and rejection of unsupported property clocks.
- Checks exact partial-initialization constraints against `write_smt2`.
- Verifies that an intentionally corrupted result makes the comparison satisfiable.
- Checks named-expression output against compact output in Lean and independently
  against `write_smt2`, including operators, sequential state, and escaped names;
  checks generated register projection lemmas and their use with local signal facts.
- Checks selected-proof dependency discovery, execution, and rejection of a stale
  proof after an imported source changes.
- Checks deterministic output, name collisions, ascending buses, metadata escaping,
  unsupported designs, and preservation of an existing output on rejection.
- Checks 10,126 multiplier edges and 386 full-width results across both designs,
  including partial accumulators, busy input noise, exact latency, done pulses,
  and reset aborts.
- Checks 3,006 additional adder/CRC/elastic Lean/RTL samples against independent
  arithmetic, CRC, and queue references.
- Regenerates all circuit exports and adder wire views into the test directory and compares them against the
  checked-in examples; running tests does not rewrite source files. Update the
  examples explicitly with `python3 scripts/export.py` after a deliberate change.
- Checks generated circuits and completed proofs sequentially with resource limits;
  audits named theorems and tests rejection of admissions and extra axioms.

Lean checks proofs about the generated circuit. The C++ exporter, Yosys elaboration
and lowering, and the interpretation of the environment remain part of the trusted
translation boundary. Differential checks supply evidence about that boundary;
there is no certified Verilog-to-Lean compiler claim. The proofs use `simp`, `grind`,
induction, and kernel-evaluated `decide`, with no `sorry`, native-evaluation axioms,
or custom axioms. Example entry theorems use the shared `#check_claim` command,
rejecting dependencies beyond `propext`, `Classical.choice`, and `Quot.sound` and
reporting the actual statements. The generic file checker's `CHECKED` means
compilation succeeded; only explicitly audited theorems produce `CLAIM` reports.
There is no receipt binding these reports to the RTL build configuration yet.
