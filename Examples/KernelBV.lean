import Lean.Elab.Tactic

/-! Disabled experiment. Reducing complete SAT certificates in the kernel consumed
excessive memory on the adder and CRC examples. Keep this fail-fast definition so
old experimental imports cannot restart that work.
The completed examples use compositional proofs instead.
Use small compositional lemmas for subsequent proofs; do not restore the old tactic. -/
open Lean Elab Tactic

elab "bv_decide_kernel" : tactic => do
  throwError "Disabled: whole-certificate kernel reduction exceeded practical memory limits. \
    Use the compositional AdderProofs and CrcProofs modules instead."
