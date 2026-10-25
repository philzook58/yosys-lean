import YosysLean.Check
import YosysLean.Formal
import Examples.Generated.FixedCounter
import Examples.Generated.FixedStall
import Examples.Generated.FixedShift

/-! Arbitrary-length safety proofs of the repaired RTL's imported assertions.
Unspecified initial registers remain arbitrary; only the exported assumptions constrain inputs. -/
namespace RepairProofs
set_option maxRecDepth 4096
set_option maxHeartbeats 200000

private theorem bit_cases (b : BitVec 1) : b = 0 ∨ b = 1 := by revert b; decide

namespace Counter
open v_FixedCounter

/-- Count is unconstrained before the required first reset, and below ten afterwards. -/
def invariant (s : State) : Prop := s.v_past_valid = 0 ∨ s.v_count.toNat < 10

theorem base (s : State) (h : initial s) : invariant s := by
  rcases s with ⟨past, count⟩
  revert past count
  unfold initial invariant
  decide

theorem step (i : Inputs) (s : State) (h : invariant s)
    (a : assumptions (eval i s).1) : invariant (eval i s).2 := by
  rcases i with ⟨reset, enable⟩
  rcases s with ⟨past, count⟩
  revert reset enable past count
  unfold invariant assumptions eval
  decide

theorem sound (i : Inputs) (s : State) (h : invariant s)
    (a : assumptions (eval i s).1) : assertions (eval i s).1 := by
  rcases i with ⟨reset, enable⟩
  rcases s with ⟨past, count⟩
  revert reset enable past count
  unfold invariant assumptions assertions eval
  decide

/-- The imported count-range assertion holds on every execution allowed by the reset assumption. -/
theorem safe : YosysLean.Safety eval initial assumptions assertions :=
  YosysLean.safety_of_invariant eval initial invariant assumptions assertions base step sound
end Counter

namespace Stall
open v_FixedStall

/-- The `$past` registers record the previous stalled flag (41) and data (42).
After a stalled sample, the pending word is still valid and equals the recorded data. -/
def invariant (s : State) : Prop :=
  s.v_past_valid = 0 ∨
    (s.v__procdff_41 = 1 → s.v_full = 1 ∧ s.v_data = s.v__procdff_42)

theorem base (s : State) (h : initial s) : invariant s := by
  have past : s.v_past_valid &&& (1 : BitVec 1) = 0 := by simpa [initial] using h
  exact Or.inl ((BitVec.and_allOnes).symm.trans past)

theorem step (i : Inputs) (s : State) (_ : invariant s)
    (_ : assumptions (eval i s).1) : invariant (eval i s).2 := by
  rcases bit_cases i.v_reset with reset | reset <;>
    rcases bit_cases s.v_full with full | full <;>
    rcases bit_cases i.v_out_ready with ready | ready <;>
    simp [invariant, eval, reset, full, ready]

theorem sound (i : Inputs) (s : State) (h : invariant s)
    (_ : assumptions (eval i s).1) : assertions (eval i s).1 := by
  rcases bit_cases i.v_reset with reset | reset <;>
    rcases bit_cases s.v_past_valid with past | past <;>
    rcases bit_cases s.v__procdff_41 with stalled | stalled <;>
    simp_all [invariant, assertions, eval]

/-- The actual `$past` stability assertion holds for arbitrary inputs and execution lengths. -/
theorem safe : YosysLean.Safety eval initial assumptions assertions :=
  YosysLean.safety_of_invariant eval initial invariant assumptions assertions base step sound
end Stall

namespace Shift
open v_FixedShift

/-- Every 32-bit input and amount satisfies the imported combinational shift assertion. -/
theorem correct (i : Inputs) (s : State) : assertions (eval i s).1 := by
  simp [assertions, eval]

/-- The combinational assertion holds on every finite sequence of inputs without assumptions. -/
theorem safe : YosysLean.Safety eval initial (fun _ ↦ True) assertions :=
  YosysLean.safety_of_invariant eval initial (fun _ ↦ True) (fun _ ↦ True) assertions
    (fun _ _ ↦ trivial) (fun _ _ _ _ ↦ trivial) (fun i s _ _ ↦ correct i s)
end Shift

#check_claim Counter.safe, Stall.safe, Shift.correct, Shift.safe
end RepairProofs
