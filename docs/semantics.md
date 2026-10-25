# Exported model and supported semantics

`lean_prepare` lowers processes, flattens hierarchy, checks the actual clocks,
unmaps synchronous resets/enables, and converts registers to global-step FFs.
It does not apply `async2sync`, replace undefined bits, or run gate-level
technology mapping. `write_lean` requires this preparation and a full selection.
It validates the generated representation before opening the output file, so
semantic rejection preserves an existing destination. Normal I/O failures are
not an atomic-file replacement guarantee.

For each top module, the output has a namespace prefixed with `v_` and:

```lean
structure Inputs where -- one BitVec field per data input; the clock is metadata
structure State where  -- one BitVec field per lowered register
structure Outputs where
def eval (inputs : Inputs) (state : State) : Outputs × State
def initial (state : State) : Prop
```

One `eval` represents one rising clock edge. Its outputs observe the current
state and inputs, and its second result contains simultaneous register updates.
The validated physical clock is omitted from `Inputs` and identified in a source
comment. Each call supplies the edge itself, so there is no clock value to provide.
Clock identification follows register connectivity, not the port's name; ordinary
data inputs named `clk` remain data inputs. Use the returned state in a second call
if you want post-edge combinational outputs.

The exporter emits native `BitVec` operators and shared, typed local bindings.
Signals of width one remain `BitVec 1`. Comparisons/reductions convert Booleans
explicitly. Metadata comments identify nodes, source locations when retained,
and register aliases; missing metadata is identified rather than reconstructed.
Names are deterministic, ASCII, prefixed to avoid Lean keywords, and disambiguated
after sanitization. Generated definitions are checked in for the examples;
handwritten specifications and proofs are separate.

For manual or AI-assisted proofs, use `write_lean -named build/Top.lean`.
This exposes each intermediate expression as an ordinary typed definition under
`Signals`, and `eval` references those definitions. A proof can address a named
signal directly and reuse a lemma about it downstream. Node comments include
retained source locations where available. The default compact let-based output
is still available; both modes have the same transition and initial-state semantics.
`Next` exposes each register's update, and `eval_next_<field>` proves its projection
from `eval` by reflexivity. These definitions are proof boundaries, not extra axioms.
See [the general proof workflow](proving.md) for usage, assumptions, and
composing local facts into invariants or refinement proofs. Circuit-specific
tactics remain example code, independent of the exporter.

## Supported circuits

V1 supports combinational word-level operations and single-clock synchronous
registers with synchronous resets/enables. All non-memory FunctionalIR operations
are handled: arithmetic, bitwise operations, comparisons, reductions, extension,
extraction, concatenation, shifts, and muxes. Yosys performs RTL width/sign lowering;
the backend translates its explicit operations. Signed source division, if lowered
by Yosys, is consequently composed from supported operations.

Initial register values are predicates: only specified bits constrain the state.
Uninitialized bits are arbitrary initial values that persist until written.
Combinational X/Z constants are rejected. An explicit Yosys `setundef -anyseq`
step may abstract them as unconstrained choices instead; this is never automatic.
`$anyseq` generators become distinct `Inputs` fields, labeled arbitrary per-edge
choices in comments. Each edge may supply new values. Safety theorems must quantify
over all such inputs; a concrete witness fixes one sequence of choices. This is a two-state formal model, not
a four-state Verilog simulator. Division by zero follows the SMT encoding:
unsigned quotient is all ones and remainder is the dividend. Simulation comparisons
check that case separately because Icarus produces X for those RTL outputs.

Asynchronous resets, latches, falling/gated/multiple clocks, clocks used as data or
exposed as data outputs in sequential designs, memories, black boxes,
`$anyconst`, `$allconst`, and `$allseq` generators, liveness/fairness properties, formatted property
messages, combinational loops, and undriven/multiply-driven signals are rejected.
Instructions and memory data are ordinary inputs in the first CPU proof; RAM is
modeled in a handwritten environment.

Assertions, assumptions, and covers are emitted as named one-bit observations with
source locations and aggregate Lean predicates. Assumptions remain explicit obligations;
they do not silently restrict execution. Disabled assertions/assumptions are true,
while disabled covers are false. See the [divider notes](../examples/zipcpu/README.md)
for edge sampling, initialization, and the formal harness example.

