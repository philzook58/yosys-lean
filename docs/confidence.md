# What a passing proof does not establish

**A proof establishes a particular formal statement about a particular model,
under particular assumptions. It does not establish that a device is foolproof.**

For `YosysLean.Safety`, the statement is: every finite execution of the exported
transition function, starting in an allowed initial state and satisfying the
assumptions, satisfies the assertions. Other theorems have different scopes:
the divider theorem concerns accepted transactions; a cover proves one reachable
execution. Read the theorem's type, not just its name or a successful check.

## Limits of the idea

These remain even with a correct exporter and a complete proof:

- **The specification can be wrong or incomplete.** A counter stuck at zero
  satisfies `count < 10`. A buffer that never produces valid output can satisfy
  stalled-output stability. Neither is sufficient functional correctness.
- **Assumptions need justification outside the theorem.** A divider proved correct
  when requests never arrive while busy can still fail in a system that violates
  that protocol. Two components cannot justify circular assumptions merely by
  assuming each other's guarantees.
- **A model leaves things out.** Ideal clock edges and bitvectors do not describe
  metastability, timing violations, power loss, or every fault in a physical device.
  Adding fault models proves more conditional statements, not immunity to all faults.
- **The chain of trust does not disappear.** Logic, axioms, checker implementation,
  executable, and computing platform remain involved. Smaller or independent
  checkers reduce particular risks; they do not establish that the requirements
  describe everything the user needs.

This does not make mathematical proof merely a confidence score. Within its
stated foundations, a checked proof establishes a precise implication. Judgment
is still needed to connect that implication to the intended system.

## Where this project can mislead us today

| Risk | How everything can pass | Existing protection and remaining gap |
| --- | --- | --- |
| Vacuity | No initial state satisfies `initial`; assumptions exclude useful executions; an assertion's enable never fires | Imported assumptions/enables are explicit, with some witnesses and negative controls. There is no general assumption-satisfiability or per-property activation check. |
| Wrong claim | A proof establishes range, a single trace, one width, or equality with a buggy reference, then gets described as complete correctness | Example notes state scopes. There is no enforced claim inventory. Equivalence alone does not validate either implementation's intended behavior. |
| Admissions or extra axioms | A file containing `sorry` or an unapproved axiom can compile successfully | Shared `#check_claim` audits named theorems' transitive axioms. The runner reports file compilation as `CHECKED`; a file without explicit claim audits still compiles. |
| Wrong artifact or configuration | The proof checks an old export, another top, different parameters, or different preprocessor flags | Pins and regeneration checks exist in CTest. `--deps` rebuilds Lean imports, not RTL exports, and produces no receipt binding the claim to all build inputs. |
| Translation errors | Lean proves the emitted function, but elaboration, lowering, or printing mistranslates the RTL or a property | `write_smt2` comparisons and Icarus replay provide evidence. Both formal backends share Yosys; simulation samples are finite. This is not a compiler-correctness proof. |
| Semantic mismatch | Pre-edge sampling, reset assumptions, overflow, or arbitrary initial bits mean something different to the reader | Unsupported features fail explicitly. The accepted model is two-state and single-clock, not full simulation semantics or EQY's X-aware safe-replacement relation. |
| Missing progress or integration | Data is correct whenever valid, but valid never arrives; a local contract is incompatible with its caller | Some examples prove exact latency and conservation. `Safety` alone proves neither eventual completion nor a complete system contract. |
| Changed implementation | Proved RTL is subsequently synthesized, constrained, integrated, or deployed differently | Current proofs stop at the RTL export. They do not certify synthesis, timing closure, clock/reset crossing behavior, or an FPGA bitstream. |

Lean documents that `sorry` introduces an axiom capable of inhabiting any type;
a successful compilation must not be confused with an audited finished proof.
[Lean axiom reference](https://lean-lang.org/doc/reference/latest/Axioms/).
Property activation checks address a known vacuity problem, but a reachable
trigger does not show that the assumptions are realistic or the specification
complete. [YosysHQ witness-cover discussion](https://yosyshq.readthedocs.io/projects/ap120/en/latest/).
Our two-state comparisons should not be presented as reproducing
[EQY's safe-replacement semantics](https://github.com/YosysHQ/eqy/blob/main/docs/source/xprop.rst).

Project examples make these distinctions concrete:

- The CRC proof uses an explicitly synchronous-reset adaptation. It does not
  prove the original asynchronous-reset design equivalent to that adaptation.
- The divider proves quotient and completion with explicit request/reset conditions.
  It does not prove all flags or every assertion in the upstream formal harness.
  Its unsigned SMTBMC benchmark excludes zero denominators; separate Lean theorems
  handle the error case.

Also distinguish evidence types: BMC is bounded; an induction step without its
base case is insufficient; a timeout is inconclusive; a cover is existential.
A counterexample proves a model violation, whose physical relevance still depends
on the model and environment. Passing tests are not universal translation proofs.

- NERV's unbounded ADD theorem proves imported instruction-checker safety under
  its harness assumptions. `NervControlProgram.from_reset` separately proves
  stored arithmetic/jump/branch execution through an immutable one-edge ROM at the
  real request port. Its admission premise is about the independent ISA execution:
  executed instructions must be supported and selected targets aligned, with reset
  low after recovery. The countdown example discharges this premise for arbitrary
  run lengths and stalls and proves finite completion without stalls. These results
  do not prove data memory, other instructions, precise exceptions, or general
  progress. The misalignment theorem proves only the physical trap flag. The wider
  simulation uses a handwritten ISA specification; it does not establish every
  upstream instruction-checker assertion. The write-address mutant passes
  instruction-local RVFI checks while writing the wrong physical register;
  `NervArchitectureCounterexample.wrong_write` certifies the missing obligation.

The [injected NERV faults](../examples/riscv/README.md#deliberately-injected-faults)
exercise wrong operand reads, register aliasing, stall release, load dependencies,
and fetch/report disagreement. Each has a finite Lean counterexample and an
unmodified-RTL repair control. Passing instruction-local checks is deliberately
insufficient for these cases; completion witnesses also guard against vacuity.

## Improvement plan

The shared axiom audit is implemented; the remaining work below is **planned**.
Start with reporting and claim review before expanding supported semantics.

1. **P0 — Bind claim reports to the build.** Extend the explicit theorem names,
   types, and axiom reports with reviewed assumptions and exclusions. Record
   source/include hashes, top, parameters, defines, preparation commands, generated
   Lean and proof hashes, dependency identities, and tool versions in a small receipt.
   Distinguish `file checked`, `claim proved`, `witness checked`, and solver statuses.
   **Acceptance:** changing the top, configuration, RTL, or claimed theorem invalidates
   the receipt; an arbitrary compiled file cannot acquire a `claim proved` label.

2. **P0 — Shared axiom audit implemented; clean claim rechecks remain.**
   `#check_claim` replaces the examples' repeated audit code, reports theorem types,
   and enforces the standard axiom allowlist within the existing resource limits.
   Regression checks reject direct/imported `sorry`, custom axioms, native-evaluation
   dependencies, missing names, and non-theorems. File compilation has a separate
   status. **Remaining acceptance:** recheck all registered claims from clean local
   dependencies as part of the configuration-bound receipt, rather than trusting
   whichever compiled imports are available.

3. **P1 — Exercise the contract, not just the proof.** Inventory assertions,
   assumptions, covers, and enables through lowering. Add assumption-respecting
   witnesses for request, activation, reset recovery, and relevant error paths.
   Mutate implementations as well as assertions. Have someone other than the proof
   author review the statement, especially when AI writes both specification and proof.
   **Acceptance:** regression cases with contradictory assumptions or permanently
   disabled checks are exposed; each chosen mutant is caught or its survival is
   recorded as a contract gap.
   Covers and mutation results are diagnostics, not completeness certificates.

4. **P1 — Strengthen translation evidence.** Generate small RTL cases covering
   widths, signedness, reset/enable priority, partial initialization, and property
   sampling. Compare independent execution paths and retain minimized disagreements.
   Pursue per-design translation validation with explicit semantics before a larger
   verified-compiler project. **Acceptance:** seeded lowering/printer defects are
   detected, unsupported constructs still fail, and shared dependencies are named.

5. **P2 — Discharge system assumptions and follow the built artifact.** Prove callers
   satisfy component contracts; add completion/fairness claims where required.
   Tie selected RTL to post-synthesis equivalence, timing and crossing analyses,
   and deployment tests appropriate to the target. Consider independent proof-term
   checking for stronger assurance. **Acceptance:** a system-level example identifies
   which assumptions are discharged and which remain external, with a traceable
   path to the tested build. Physical and specification limits remain explicit.

Use the phrase **“property P proved for configuration C under assumptions A”**
instead of an unqualified “formally verified.” No planned milestone removes the
need to review P, C, A, and the connection to the real application.
