# Ibex ALU: first larger-core component

The real Ibex ALU, default `RV32BNone`, now imports through sv2v and Yosys.
[IbexALUProofs.lean](../../Examples/IbexALUProofs.lean) proves **ADD, SUB, XOR,
OR, and AND** for every pair of 32-bit operands, with the multiplier/divider bypass
disabled. ADD/SUB include modular wraparound. Other opcodes and auxiliary outputs
have translation checks, but no functional correctness theorem yet.

```sh
python3 scripts/check_lean.py --deps Examples/IbexALUProofs.lean
```

The original package and ALU are pinned unchanged in [sources.json](sources.json).
Their Apache license and copyright notices are retained under `upstream/`; the
converted file is derived from those sources. Checked-in converted Verilog keeps
normal builds and tests offline. No Yosys patch or Ibex-specific exporter code is
needed. Yosys's inferred constant lookup table is explicitly mapped before export.

To reproduce the conversion with an existing **sv2v v0.0.13** executable:

```sh
python3 scripts/convert_ibex.py /path/to/sv2v --check
```

The manifest records the upstream revision, conversion command, release archive
hash, and output hash. Conversion is not a certified elaboration step. Tests
compare actual Lean with converted Verilog in Icarus over 325 boundary/random
vectors and all output ports. When Verilator is available, the same vectors and
bench also run against the **original SystemVerilog** to check the conversion.
The suite reports an explicit skip when that optional check is unavailable.
Independent `write_smt2` comparisons cover arbitrary inputs, including bypass
inputs and opcodes beyond the five proved operations.

## Toward whole Ibex

Next: shifts/comparisons, register-file behavior, and an explicit core configuration.
Whole-core work still needs SystemVerilog elaboration, asynchronous reset and clock
gating semantics, and memory/environment contracts. Then connect retired RVFI
observations to instruction semantics, register/PC consistency, and fetch/memory
behavior. RVFI is an observation interface, not a CPU correctness theorem.

The existing [Ibex formal flow](https://github.com/lowRISC/ibex/tree/master/dv/formal)
is a useful reference for decomposition and assumptions. This example imports only
the ALU; it does not reproduce that flow or establish correctness of Ibex, its
pipeline, CSRs, interrupts, or software execution.
