# Roadmap

The [top-level goal](README.md) is end-to-end execution of stored RISC-V programs
by actual Verilog, with an independent ISA specification. Arithmetic, jumps, and
branches now execute through the real synchronous-ROM fetch port, with explicit
alignment assumptions and a positive countdown-loop completion proof. The next
milestone is loads/stores through an explicit data-memory contract: byte lanes,
sign extension, latency, and dependencies. Precise traps and broader progress follow.
Other demonstrations support this work.

Before broadening the benchmark set, prioritize the
[confidence improvement plan](docs/confidence.md#improvement-plan): explicit claim
receipts and clean claim rechecks (P0; shared axiom enforcement is implemented),
contract activation/mutation checks and stronger translation evidence (P1), then
system and deployment connections (P2).
These improvements reduce particular risks; none makes an unqualified correctness claim sound.

- **ZipCPU bus components — implemented for selected configurations.** The 32-bit
  unregistered-output skid buffer has stream conservation and a Lean proof of all
  imported upstream assertions. Default Easy AXI-Lite has a complete register-step
  model proof; its full upstream harness is currently proved with SMTBMC, not Lean.
  Both have implementation mutants and certified counterexamples. See
  [proof scopes and next extensions](examples/bus/README.md).

- **Shift-and-add and barrel-shift multiplication — implemented.**
  The serial 32-edge design and two-bit 16-edge barrel-shift design have full
  unsigned 32×32→64 correctness proofs and a theorem equating completed results.
  See [multiplier notes](examples/multiplier/README.md). Their proofs use loop
  invariants and counter induction; reset and busy input behavior are explicit.
  Signed multiplication, pipelining, and structural area/timing comparisons remain
  possible extensions.
  Kôika's [shift-and-add implementation](https://github.com/mit-plv/koika/blob/master/examples/rv/Multiplier.v)
  and [32-bit correctness development](https://github.com/mit-plv/koika/blob/master/examples/rv/MultiplierCorrectness.v)
  remain useful related work; these examples are original Verilog and Lean proofs.
- **Full-width ZipCPU divider arithmetic — implemented.** Universal 32-bit unsigned
  and signed transaction proofs cover the restoring-division invariant, completion,
  preprocessing, final sign correction, wrapped overflow, and zero-divisor error.
  Operand buses may change after acceptance; no reset or new request is allowed
  during a transaction. See the [contract and SMTBMC benchmark](examples/zipcpu/README.md).
  Architectural flag correctness and a proof of every upstream FORMAL assertion
  remain separate obligations.
- **NERV RVFI and Ibex ALU — first milestones implemented.**
  [NERV](examples/riscv/README.md) has unbounded imported ADD checker safety,
  stored arithmetic/jump/branch execution with stalls through an immutable
  one-edge ROM, retirement grounded in actual register/PC state, and fault controls.
  [Ibex ALU](examples/ibex/README.md) has five full-width operation proofs.
  Next: extend stored-program execution to loads and stores;
  establish explicit Ibex reset/gating/environment semantics before any whole-core claim.
- NERV shifter refactoring: prove the complete EQY tutorial's CPU comparison,
  starting with explicit register-file lowering and a readable relation at the
  shifter boundary. Keep the original and buggy variants as controls. This is the
  next CPU-scale equivalence case; the current shift-width reproducer is much smaller.
- fpga4fun UART transmitter: accepted-byte to serial-frame trace specification,
  with explicit baud-tick and data-stability contracts.
- Cornell fixed-point integrator: exact machine recurrence first, then a separate
  theorem relating rounding/overflow assumptions to a numerical model.

## Concrete sources inspected

The adder, CRC, and original one-entry elastic stage are now implemented; see
the top-level README for proof scopes. The remaining rows are candidate experiments.

| Candidate | Source | Proposed proof about exported Verilog | Current fit |
| --- | --- | --- | --- |
| Ripple versus Sklansky adder | [Bird–Meertens adder](https://github.com/satnam6502/bird-meertens/tree/main/Adder) already includes a generated 32-bit Verilog netlist | Sum and carry equal widened addition; both implementations agree | Implemented: arbitrary-input arithmetic and equivalence; gate depth remains separate |
| CRC-8, then serial versus byte-parallel CRC | [Bird–Meertens CRC](https://github.com/satnam6502/bird-meertens/tree/main/CRC) includes `crc8.sv` and a polynomial specification | Arbitrary-message fold correspondence; eight serial updates equal one byte update; valid-low holds state | Implemented with an explicit synchronous reset adaptation; original RTL pinned unchanged |
| Four-/eight-lane sorting network, then a pipelined version | [Bird–Meertens sorters](https://github.com/satnam6502/bird-meertens/tree/main/Sorters) relates four Lava-style networks | Output is sorted and a permutation, including duplicates; pipelined transaction order matches the combinational sorter | New Verilog implementation needed; start with fixed lane count and arbitrary word values |
| Round-robin arbiter | [Sparkle implementation](https://github.com/Verilean/sparkle/blob/main/IP/Arbiter/RoundRobin.lean) and [abstract FSM proofs](https://github.com/Verilean/sparkle/blob/main/Sparkle/Verification/ArbiterProps.lean) | Emitted RTL refines the FSM; mutual exclusion and bounded waiting under persistent requests | Generate and pin Verilog, then audit reset and grant sampling; the inspected implementation file does not itself prove the RTL/spec connection |
| Elastic pipeline / small FIFO | [Kôika pipeline tutorial](https://github.com/mit-plv/koika/blob/master/examples/pipeline_tutorial.v), [Sparkle FIFO](https://github.com/Verilean/sparkle/blob/main/Sparkle/Library/Queue/SyncFIFO.lean) | Accepted outputs equal an ordered prefix of transformed accepted inputs; no loss/duplication; occupancy conservation | Original register-based one-entry stage implemented; Sparkle's memory-based FIFO remains outside scope |
| PWM / Gray counter / UART | [hw-cbmc benchmarks](https://github.com/diffblue/hw-cbmc/tree/main/examples/Benchmarks) already provide SystemVerilog and properties | PWM high-count over a complete fixed-duty period; one-bit Gray transitions including wrap; accepted UART frame and completion | Inspect individually: sampled files contain temporal liveness SVA; `gray_1.sv` also has asynchronous reset |
| Floating-point adder | [hw-cbmc fp_adder](https://github.com/diffblue/hw-cbmc/tree/main/examples/fp_adder) includes Verilog, C, and a comparison harness | Bit-exact correspondence under an explicit rounding/NaN/subnormal contract | Later: a substantially larger specification task |
| Small matrix multiplier | [cocotb RTL and tests](https://github.com/cocotb/cocotb/tree/master/examples/matrix_multiplier) | At 2×2 first, each valid output equals the dot product at the stated width, one edge after input; specify truncation | Unpacked array ports need frontend support or an explicit flattening translation; Python simulation tests provide a reference, not a universal proof |
| UART transmitter | [Amaranth basic UART](https://github.com/amaranth-lang/amaranth/blob/main/examples/basic/uart.py) | At a fixed divisor, an accepted byte produces the correct start/data/stop bits and exact duration | Export and pin generated Verilog with synchronous reset; inspect TX first. RX additionally needs explicit sampled-input timing assumptions |
| Configurable CRC | [Amaranth CRC library](https://amaranth-lang.org/docs/amaranth/latest/stdlib/crc.html) provides software and hardware computations | Generated Verilog agrees with a polynomial fold, including initialization, reflection, and final XOR | A useful cross-language extension of our existing CRC proof; choose one fixed configuration before generalizing |

The adder is already Verilog: reuse it before implementing another copy. Its upstream
Lean derivation proves a symbolic netlist, while the printer is explicitly unverified;
importing the printed Verilog would establish a useful additional connection.
The CRC's upstream RTL model is handwritten, and its documented proof dependencies
include a native `bv_decide` axiom. Any reuse must respect our own axiom audit rather
than assuming the upstream proof has the same trust boundary.

For sorters, prove both order and permutation, not just order. Existing algebraic
identities between networks are useful, but must be distinguished from a general
sorting-correctness theorem. A pipelined version should expose validity explicitly
and compare accepted transactions, including bubbles and backpressure.

For a cross-language experiment, use `Sparkle → Verilog → Yosys → Lean` or
`Kôika/Bluespec → Verilog → Yosys → Lean`, then prove a relation to the original
model. This validates the selected emitted artifact without claiming a general
compiler-correctness theorem or transporting a Rocq proof automatically into Lean.
Kôika's examples ending in `.v` are Rocq source, not necessarily Verilog files.
[Kami](https://github.com/mit-plv/kami) is another relevant source for modular
hardware refinement through Bluespec, particularly for the Murali line of work.
