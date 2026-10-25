import YosysLean.Check
import YosysLean.Trace
import YosysLean.Formal
import Examples.Generated.NervFaultLoad

/-! An initialized execution refutes an imported Verilog harness assertion. -/
namespace NervFaultLoad
open v_NervFaultLoad
set_option maxRecDepth 4096
set_option synthInstance.maxSize 16384

def input : Inputs := { (default : Inputs) with v_scenario := 3 }
def program : List Inputs := List.replicate 13 input

instance : DecidablePred assumptions := by unfold assumptions; infer_instance
instance : DecidablePred assertions := by unfold assertions; infer_instance

theorem counterexample :
    YosysLean.Counterexample eval initial assumptions assertions program default := by
  refine ⟨by unfold initial; decide, ?_, ?_⟩ <;> check_trace

/-- The failure is observable at phase 6, with a valid retirement report. -/
theorem detected :
    ∃ o ∈ YosysLean.trace eval program default,
      o.v_phase = 6 ∧ o.v_rvfi_valid = 1 ∧ o.v_operands_ok = 0 ∧ o.v_contract_ok = 0 := by
  apply YosysLean.exists_of_not_along_not
  check_trace

#check_claim counterexample, detected
end NervFaultLoad
