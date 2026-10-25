# NERV and imported RISC-V checks

## Current claim

**After reset recovery, unchanged NERV executes stored arithmetic, jumps, and
branches correctly for any finite number of edges, including arbitrary stalls.**
The program resides in an immutable, one-edge synchronous ROM connected to the
CPU's actual `imem_addr` output.

| Review question | Answer |
| --- | --- |
| Main result | [`NervControlProgram.from_reset`](../../Examples/NervControlProgram.lean): every architectural register and PC agree with an independent ISA machine that fetches from its own PC |
| Instructions | ADD, ADDI, LUI, AUIPC, JAL, JALR, BEQ, BNE, BLT, BGE, BLTU, BGEU |
| What is arbitrary? | Initial registers, operand values, immediates, register aliasing, run length, stalls, data inputs, and undefined-value choices |
| Assumptions | Immutable total ROM with one-edge latency; reset stays low; the independent reference execution visits only supported instructions with aligned current PCs and selected targets. Unvisited ROM words are unrestricted |
| Starting state | `NervProgram.reset_coherent` establishes PC=0 and fetch coherence from any CPU/ROM state after a reset edge and an unstalled recovery edge; reset does not clear registers |
| Retirement | `retirement` ties a report on the immediately following unstalled edge to the fetched instruction, actual source registers, optional writeback, and selected next PC |
| Concrete positive result | [`NervControlExample.cpu_completes`](../../Examples/NervControlExample.lean): a stored countdown loop reaches PC=12 and x1=0 after eleven unstalled instructions, from arbitrary initial registers; `loop_from_reset` covers arbitrary run lengths and stalls |
| Not established | Other instructions, loads/stores, precise exceptions, variable memory latency, writable code, or progress when the environment can stall forever |

```sh
python3 scripts/check_lean.py --deps Examples/NervControlExample.lean
```

The [Verilog wrapper](NervFetchHarness.sv) exposes the real request port without
modifying upstream NERV. A generated [structural connection](../../Examples/Generated/NervFetchBridge.lean)
is checked by Lean `rfl` for every input and state. The Lean composition registers
`ROM(actual request)` each edge; the ISA reference fetches separately using its own
PC. Fetch coherence is proved, including after jumps and branches.

[`NervControlDecode`](../../Examples/NervControlDecode.lean) proves signed and
unsigned branch comparisons, link writes, and JALR's clearing of target bit zero.
A misaligned selected target sets the physical trap flag. This is **not a proof
of precise exception semantics**: register and PC effects on trapping instructions
are outside the normal-execution claim. An untaken branch's displacement need not
be aligned; its selected fall-through PC must be.

Regression replay compares 386 sampled edges against unchanged Verilog using
synchronous-ROM wiring: all registers, PC, requests, and valid RVFI reports. A
separate Python ISA interpreter checks architectural states. Workloads include
arithmetic, a countdown loop, every branch taken and untaken, call/return, JALR
aliasing and low-bit clearing, stalls, and mid-run resets. Eight additional cases
compare selected-target trap flags. An injected request-address fault leaves
arithmetic and RVFI generation unchanged; RTL replay and a Lean certificate detect
the CPU advancing to PC=4 while requesting address 8. Replays supplement the
universal proofs; they do not prove the exporter correct.

## Other proof layers

- [`NervSafety.safe`](../../Examples/NervSafety.lean) proves every imported upstream
  ADD checker assertion on arbitrary-length executions under its harness assumptions:
  first-edge reset and the checker's `spec_valid` requirement on selected reports.
  This theorem permits unrestricted instruction, memory, reset, and stall inputs.
- [`NervArithmetic.program_refinement`](../../Examples/NervArithmetic.lean) proves
  mixed ADD/ADDI/LUI/AUIPC register/PC effects when instruction words are supplied
  externally. It quantifies over all registers, encodings, aliasing, and choices.
- The ADDI arithmetic and wrong-register-write mutants have finite certificates
  and independent RTL replay. The write-address mutant passes instruction-local
  RVFI checks while physically writing the wrong architectural register.

The ISA specification is handwritten; this is not a full upstream `riscv-formal`
or CPU/ISA proof. The unbounded imported-checker result remains ADD-only. See
[translation choices](#translation-choices) and [the trust boundary](../../docs/confidence.md).

## Deliberately injected faults

These are **test copies**, not bugs found in upstream NERV. Recipes in
[`scripts/nerv_faults.py`](../../scripts/nerv_faults.py) generate each change under
`build/cpu-faults/`; the pinned upstream source stays unchanged.

| Fault | Trigger and observed error | Harness obligation |
| --- | --- | --- |
| Operand | ADD reads x2 for rs1; reports 3+3=6 instead of 2+3=5 | Operand values match the workload's architectural state |
| Alias | ADD x1,x1,x2 reports 5 but loses its write; the following ADD gets 5 instead of 8 | A later consumer observes the earlier write |
| Stall | First execution after stall release is suppressed; an old report repeats | Retirement follows the expected instruction/PC sequence |
| Load | The first dependent instruction uses the old x1=2 despite a load of 9; reports 11 instead of 18 | A load consumer sees the memory result |
| Fetch | JAL reports the correct target, but fetches the fall-through word; x2 becomes 99 instead of 7 | Retired instruction matches ROM at its reported PC |

[`NervFaultHarness.sv`](NervFaultHarness.sv) contains the actual assertions. Its ROM
responds to the CPU's **actual fetch address** with one-edge latency; data memory
returns 9. A deadline checks completion, so suppressing all reports cannot pass.
The unchanged CPU is the repair control for all five workloads.

```sh
ctest --test-dir build -R '^nerv-faults$' --output-on-failure
python3 scripts/check_lean.py --deps --heartbeats 800000 Examples/NervFaultLoad.lean
```

Each `Examples/NervFault*.lean` certificate proves an initialized execution violates
an imported assertion and identifies a valid report at the failing phase. The
[repair controls](../../Examples/NervFaultControls.lean) prove the same finite
workloads pass and reach completion. These use 13 samples, zero initial register
contents, and zero choices for inactive undefined values; reset does not clear the
register file. RTL replay uses the same initialization and compares actual Lean
execution against Icarus, including the named contract outputs.

Independent SMTBMC checks run through depth 14. Removing **only the workload
assertions** leaves the upstream ADD instruction checks passing for every mutant;
the extra contracts expose the bugs they miss. This is a set of finite fault and
repair certificates, not an unbounded load, stall, or fetch correctness proof.

## Translation choices

[sources.json](sources.json) pins NERV's small 2020 implementation and the checker
revision and hashes. This deliberately starts with the original compact RV32I core,
not the current, larger NERV implementation. The harness connects ordinary data
inputs rather than using a testbench's hidden nondeterministic registers.

The export script explicitly maps the register file to registers and muxes. NERV
and memory lowering contain undefined inactive values. After lowering, an explicit
`setundef -anyseq` replaces those values with arbitrary **per-edge input choices**;
none are silently fixed to zero. The unbounded ADD theorem quantifies over these choices.
Concrete execution witnesses choose zero and establish only those executions.
The ADDI/ADD program witness starts with zero register contents; its Icarus replay
explicitly initializes the register file to match. Reset itself does not clear it.
This is a two-state nondeterministic abstraction, not Verilog's four-state X semantics.
A counterexample involving only an inactive X could be spurious. The ADDI mutant's
observable arithmetic error is separately reproduced in RTL simulation.

The SMT comparison checks every exported register and port, including imported
properties and choice inputs, against `write_smt2` after the same preparation.
Independent SMTBMC lowering and Icarus replay provide additional checks. None
certifies the Verilog-to-Lean translation.

## Next useful CPU proof

Extend the stored-program simulation to control flow: first jumps, then conditional
branches, with alignment and trap behavior stated explicitly. Loads, stores,
traps, and progress need their own contracts. The [Ibex ALU](../ibex/README.md)
is the parallel leaf-module milestone toward a larger implementation.
