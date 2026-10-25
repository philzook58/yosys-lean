import Examples.NervFaults.Control

namespace NervFaultControls.Stall
open v_NervFaultControl
set_option maxRecDepth 4096
set_option synthInstance.maxSize 16384

theorem correct : passes 2 := by
  unfold passes
  refine ⟨by unfold initial; decide, ?_, ?_⟩ <;> check_trace

theorem completed :
    ∃ o ∈ YosysLean.trace eval (program 2) default,
      o.v_phase = 12 ∧ o.v_progress_ok = 1 ∧ o.v_contract_ok = 1 ∧ covers o := by
  apply YosysLean.exists_of_not_along_not
  check_trace

#check_claim correct, completed
end NervFaultControls.Stall
