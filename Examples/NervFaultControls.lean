import Examples.NervFaults.ControlOperand
import Examples.NervFaults.ControlAlias
import Examples.NervFaults.ControlStall
import Examples.NervFaults.ControlLoad
import Examples.NervFaults.ControlFetch

/-! All five finite repair controls, checked in separate memory-capped processes. -/
namespace NervFaultControls
open v_NervFaultControl

theorem controls : passes 0 ∧ passes 1 ∧ passes 2 ∧ passes 3 ∧ passes 4 :=
  ⟨Operand.correct, Alias.correct, Stall.correct, Load.correct, Fetch.correct⟩

theorem completed :
    ∀ scenario ∈ ([0, 1, 2, 3, 4] : List (BitVec 3)),
      ∃ o ∈ YosysLean.trace eval (program scenario) default,
        o.v_phase = 12 ∧ o.v_progress_ok = 1 ∧ o.v_contract_ok = 1 ∧ covers o := by
  simp only [List.mem_cons, List.not_mem_nil, or_false]
  intro scenario h
  rcases h with rfl | rfl | rfl | rfl | rfl
  · exact Operand.completed
  · exact Alias.completed
  · exact Stall.completed
  · exact Load.completed
  · exact Fetch.completed

#check_claim controls, completed
end NervFaultControls
