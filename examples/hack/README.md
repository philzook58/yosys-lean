# Hack example provenance and repairs

`original/CPU.v`, `original/PC.v`, and `original/alu.v` are verbatim from
[philzook58/nand2coq](https://github.com/philzook58/nand2coq/tree/c62c6e093cff428a86ce071e4d352c60a1dba471/verilog),
commit `c62c6e093cff428a86ce071e4d352c60a1dba471`. The author is Philip Zucker.
The upstream repository does not supply a separate license file in that tree;
these sources are not relicensed by this project's ISC license.

`repaired/CPU.v` keeps the original ascending Verilog buses, 16-bit PC,
active-low synchronous PC reset, and uninitialized A/D registers. It reuses
the original `PC.v` and `alu.v`. Its differences are:

- Rename the top module to `Hack` and explicitly declare destination wires.
- Load an A-instruction from the instruction word; load a C-instruction's
  A destination from the ALU output. The original mux selected the reverse.
- Select memory for `a=1` and the A register for `a=0` at the ALU Y input.
- Use `j3` for positive-result jumps and exclude zero from positive results.

The independent [instruction specification](../../Examples/HackSpec.lean)
uses a 15-bit architectural PC and address. The relation projects the RTL's
16-bit PC to its low 15 bits. It does not assert equality of the extra bit.
Reset changes the PC only: the RTL can still update A and D during reset.
All encodings whose top bit is set use the C control fields, even when the
other two prefix bits are not `11`. This documents the implemented extension
of the assembler's encoding space instead of excluding it from the theorem.

The original counterexample starts with A=D=PC=0 and supplies `@1`, `inM=0`,
and inactive reset. The original leaves A=0; the instruction specification
requires A=1. This is a concrete, kernel-checked disagreement, not a universal
correctness claim about the rest of the original design.

The repaired proof covers arbitrary initial A/D/PC, arbitrary input sequences,
all next architectural registers, and every output (projecting PC as above).
The instruction/data-memory inputs are supplied by the environment. A separate
closed ROM/RAM example executes `@2; D=A; @3; D=D+A; @0; M=D` and certifies
that RAM[0] becomes 5 after six circuit steps.

## Two-cycle implementation

`two-cycle/CPU.v` is a new fetch/execute implementation that reuses the original
ALU. Fetch latches the external instruction and preserves A, D, and PC. Execute
uses that latched instruction and the current `inM` value, then returns to fetch.
The execute-edge external instruction and fetch-edge memory data are unrestricted.

`retire` marks an execute step with reset inactive. `writeM` is gated by retirement,
so a fetch edge cannot write memory. PC, address, and ALU buses are observed as
architectural events only when `retire` is asserted. Other bus values can change
during silent steps; the proof does not require cycle-by-cycle bus equality.

Only the phase register is initialized (to fetch). A, D, PC, and the instruction
latch remain unconstrained initially. Active-low synchronous reset clears PC and
returns to fetch, aborting any pending instruction and suppressing retirement
and memory writes. It preserves A, D, and the instruction latch. This reset
behavior is proved separately; the instruction-refinement theorems assume reset
is inactive throughout their input sequence. In the older single-cycle RTL,
A/D can update during reset, so reset edges are not compared as ISA instructions.

[TwoCycleProofs.lean](../../Examples/TwoCycleProofs.lean) proves:

- The exact intermediate fetch state, architectural stuttering, and no fetch write.
- Execution of the latched instruction, return to fetch, and retirement.
- One fetch/execute pair matches the existing generated single-cycle CPU,
  using the same low-15-bit PC relation as the earlier example.
- For every finite cycle sequence, the final architectural state and retirement
  trace match the specification after removing fetch edges. An odd final fetch
  leaves architectural state unchanged and contributes no retirement event.
- Exactly `floor(cycles / 2)` instructions retire from an initial fetch phase
  with reset inactive, ruling out an implementation that silently stalls forever.
- The same six-instruction ROM/RAM program writes RAM[0]=5 after twelve edges;
  RAM[0] is still zero after the eleventh edge.

The tests also compare generated Lean with ordinary `write_smt2`, and execute
311 physical clock steps through actual Lean and Icarus. These include PC wrap,
different fetch/execute inputs, memory writes, reset in either phase, and seeded
random inputs. The exporter itself needs no new operations for this example.
