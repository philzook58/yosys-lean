# Proving properties of exported RTL

The exporter produces a transition function, not a verification procedure.
The intended workflow is to identify useful intermediate facts and invariants,
prove them against that function, and compose them into the desired result.
The same output can support safety, refinement, arithmetic, or protocol proofs.
There is no circuit-specific proof strategy in the exporter.
Review [false-confidence risks](confidence.md) when choosing the statement and assumptions.

For a complete worked example, read the [divider walkthrough](divider.md).
Check any project example and its local imports with one command:

```sh
python3 scripts/check_lean.py --deps Examples/DividerSignedProofs.lean
```

Lean discovers the imports; the checker rebuilds the local dependency closure
sequentially, prints each file's time and peak memory, and leaves toolchain imports
prebuilt. Proof modules report and audit their named claims. Add `--run` for examples with
a `main` function. This does not regenerate RTL exports or run differential tests.

Import `YosysLean.Check` and name the claims to audit. For example:

```lean
import YosysLean.Check
import Examples.RepairProofs

#check_claim RepairProofs.Counter.safe
```

`#check_claim` reports the theorem's type and transitive axioms, rejecting `sorry`,
custom axioms, and native-evaluation trust dependencies. Only `propext`,
`Classical.choice`, and `Quot.sound` are allowed. Missing names and non-theorems
fail too. The runner's `CHECKED` means the file compiled; `CLAIM` lines identify
audited statements. Neither checks whether the statement captures your intent.

## Export expressions with names

After building the plugin and Lean support library:

```sh
build/yosys/yosys -m build/yosys_lean.so -p '
  read_verilog -formal design.v
  hierarchy -check -top Top
  lean_prepare
  write_lean -named build/Top.lean
'
python3 scripts/check_lean.py build/Top.lean --output build/Top.olean
LEAN_PATH=build python3 scripts/check_lean.py MyProof.lean
```

The default printer keeps intermediate values as shared local lets. `-named`
instead gives each FunctionalIR node a definition in `v_Top.Signals`:

```lean
namespace Signals
def v_data (inputs : Inputs) (state : State) : BitVec 8 := inputs.v_data
-- Further typed definitions reference earlier definitions with inputs and state.
end Signals
```

`eval` references those definitions to construct the same `Outputs × State`.
`Inputs`, `State`, `Outputs`, `initial`, clock sampling, and formal property
predicates have the same meanings in both modes. The named definitions are ordinary
transparent Lean functions. They are not automatically registered as simp rules.

Each register also has a definition in `Next` and a checked projection lemma:

```lean
-- Generated for a register named q:
theorem eval_next_v_q (i : Inputs) (s : State) :
    (eval i s).2.v_q = Next.v_q i s := by rfl
```

Use `rw [eval_next_v_q]` to isolate that update. Prove a fact about `Next.v_q`
and its signal dependencies, then reuse it in the invariant proof. The projection
adds no assumptions or circuit-specific reasoning.

For larger cones, `import YosysLean.Tactic` provides explicit unfolding with cuts:

```lean
unfold_nodes v_Top.Signals except [v_Top.Signals.v_operand]
```

This unfolds definitions under the namespace while leaving the listed definitions
opaque. Prove their properties separately and reuse them at that boundary.
[The NERV invariant](../Examples/NervSafety.lean) applies this to decode and report
updates without expanding every register-file mux into each goal.

Each node has its operation kind and retained RTL name in a comment; source locations
are included when Yosys retains a matching wire/cell attribute. Flattened hierarchical
names can survive as names such as `Signals.v_stage_bumped`. Yosys may merge aliases
or eliminate unused wires, so this is not a promise to reproduce every source wire
or preserve module hierarchy. Synthetic `v_n...` identifiers depend on the lowered
netlist; source names are more useful landmarks when available.

## Build the proof around a specification

Write the mathematical state or behavior you intend to establish separately from
the generated module. For a CPU that might be architectural register/PC state;
for a queue it might be an accepted/emitted word sequence; for an arithmetic unit
it might be an equation describing the remaining computation.

Start with local facts about named intermediate expressions. The test fixture
`build/tests/ProofInterface.lean`, produced by CTest, supports this ordinary proof:

```lean
import ProofInterface
open v_ProofInterface

theorem local_arithmetic (i : Inputs) (s : State) :
    Signals.v_stage_bumped i s = i.v_data + 1 := by rfl
```

Larger local facts can require arithmetic reasoning, case analysis, or a subsidiary
invariant. Unfold the definitions needed for that fact, then reuse the proved
statement in downstream mux/register equations. A proved signal equation provides
a place to stop expanding the expression graph. Names alone do not bound proof
cost if every dependency is unfolded at once.

Next prove that a single exported transition preserves your invariant, or simulates
one specification transition. Keep reset, enable, input protocol, and sampling
assumptions explicit. `initial` constrains only specified initial register bits;
arbitrary remaining bits must be handled by the argument or an explicit reset epoch.
Assertions and assumptions are observations, not automatically enforced hypotheses.

For properties already written in RTL, use the imported `assertions` and
`assumptions` predicates as the final proof target. `YosysLean.Formal` defines
`Safety eval initial assumptions assertions` and `safety_of_invariant` for exactly
this purpose. Assumptions must hold on every sampled output of the trace, including
the first. The invariant can distinguish an uninitialized/reset-required epoch
from the ordinary operating epoch; the imported assumption then supplies the
required initial reset. See [the upstream tutorial proofs](../examples/formal/README.md).

Finally use induction. `YosysLean.Basic` supplies `run_invariant`,
`reachable_invariant`, and `run_simulation` for finite executions and reachability.
`run_refinement` additionally carries an implementation invariant and per-step
`Admissible` conditions on the reference execution. `admissible_of_invariant`
establishes those conditions from a reference invariant; see the
[stored countdown proof](../Examples/NervControlExample.lean).
`YosysLean.BitVec` supplies explicit slice rewrites without global simp rules.

Different implementation latencies need a relation on architectural or completion
events, with a separate argument that those events occur. Exact latency, liveness,
and arithmetic correctness are distinct obligations.

The [32-bit divider proofs](../examples/zipcpu/README.md) show this on unchanged
external RTL. Local signal lemmas connect the generated subtraction and slices to
a natural-number recurrence; an invariant proves its arithmetic and bounds; a
clock-state relation establishes the exact completion point. The signed wrapper
then reuses that magnitude-loop proof. Its alignment relation carries quotient
bits produced during preprocessing until they shift out, and permits the final
workspace to wrap when it is no longer observable. Model such artifacts explicitly
instead of assuming internal registers have cleaner values than the RTL guarantees.

For a candidate counterexample, `YosysLean.Counterexample` requires a legal initial
state, imported assumptions along the entire finite trace, and a failed imported
assertion somewhere on it. Its `not_safe` theorem refutes `Safety`. A solver, AI,
or manual inspection can supply the input sequence; Lean checks the concrete
witness. See [the buggy RTL examples and replay command](../examples/bugs/README.md).
The paired [repair proofs](../Examples/RepairProofs.lean) use the same imported
assertion predicates to establish `Safety` for all allowed executions. Passing a
counterexample's inputs on a repair is a useful regression check; the universal
proof separately requires an invariant, its initialization and preservation, and
an argument that it implies the assertion. This establishes the written property;
an incomplete property still leaves some intended behaviors unspecified.

## Keep checking bounded and the trust boundary explicit

Use `scripts/check_lean.py` for sequential, resource-limited checks. Its memory and
time caps apply to the checker process; ordinary editor servers are independent.
Break expensive proofs into declarations or modules that can be checked separately.
Avoid reducing an entire large SAT certificate in the kernel: that approach
exhausted memory in this project. Favor local lemmas and inductive arguments.

The existing example proofs illustrate possible approaches; their tactics and
specifications are not required interfaces for other circuits. A proof of the Lean
transition function still trusts Yosys lowering and this exporter. Differential
checks against `write_smt2` and Icarus supply translation evidence, not a certified
Verilog compiler theorem. Named output introduces no solver or additional axioms.

## Finite witnesses without large unrolled terms

`import YosysLean.Trace` provides `check_trace` for a closed `YosysLean.Along`
claim or its negation. It normalizes each next state into bitvector literals and
checks that transition and its property before continuing. The kernel checks every
checkpoint; there is no native-evaluation axiom. This is finite execution evidence,
not an induction tactic. Large generated functions may need `--heartbeats 800000`
when using `scripts/check_lean.py`; its OS memory and time limits stay fixed.
The NERV fault certificates show both passing workloads
and violations of imported assertions. Keep independent workloads in separate
modules so the sequential checker can enforce its limits per certificate.
