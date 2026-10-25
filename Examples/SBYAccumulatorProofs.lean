import YosysLean.Check
import YosysLean.Formal
import Examples.Generated.SBYAccumulator
import Lean.Elab.Tactic.Omega

/-! Prove the unchanged upstream Verilog assertion under its initial-reset assumption. -/
namespace SBYAccumulatorProofs
open v_SBYAccumulator
set_option maxRecDepth 4096
set_option maxHeartbeats 200000

def update (i : Inputs) (s : State) : State :=
  { v_uut_buffer := if i.v_reset == 1 then s.v_uut_buffer else
      if s.v_uut_state == 0 then i.v_din else
      if s.v_uut_state == 1 && s.v_uut_buffer.extractLsb' 0 2 != 0
        then s.v_uut_buffer + 1 else s.v_uut_buffer
    v_uut_state := if i.v_reset == 1 then 0 else
      if s.v_uut_state == 0 then 1 else
      if s.v_uut_state == 1 && s.v_uut_buffer.extractLsb' 0 2 == 0 then 2 else
      if s.v_uut_state == 2 then 0 else s.v_uut_state
    v_init := 0
    v_dout := if i.v_reset == 1 then 0 else
      if s.v_uut_state == 2 then s.v_dout + s.v_uut_buffer else s.v_dout }

private theorem bit_cases (b : BitVec 1) : b = 0 ∨ b = 1 := by revert b; decide
private theorem state_cases (b : BitVec 2) : b = 0 ∨ b = 1 ∨ b = 2 ∨ b = 3 := by
  revert b; decide

private theorem narrow_inc (b : BitVec 8) :
    (b.setWidth 32 + 1).extractLsb' 0 8 = b + 1 := by
  change (b.setWidth 32 + 1).setWidth 8 = _
  rw [BitVec.setWidth_add _ _ (by decide)]
  simp

private theorem take_low (a : BitVec n) (b : BitVec m) :
    (BitVec.append a b).extractLsb' 0 m = b := BitVec.extractLsb'_append_eq_right
private theorem take_high (a : BitVec n) (b : BitVec m) :
    (BitVec.append a b).extractLsb' m n = a := BitVec.extractLsb'_append_eq_left
private theorem take_middle (a b c : BitVec 2) :
    (BitVec.append a (BitVec.append b c)).extractLsb' 2 2 = b := by
  calc
    _ = (BitVec.append b c).extractLsb' 2 2 :=
      BitVec.extractLsb'_append_eq_of_add_le (by decide)
    _ = b := BitVec.extractLsb'_append_eq_left

/-- A compact semantic view of the exported mux network, proved for all inputs and states. -/
theorem step_equation (i : Inputs) (s : State) : (eval i s).2 = update i s := by
  dsimp only [eval, update]
  simp only [take_low, take_high, take_middle, narrow_inc]
  rcases bit_cases i.v_reset with reset | reset <;>
    rcases state_cases s.v_uut_state with state | state | state | state <;>
    by_cases low : s.v_uut_buffer.extractLsb' 0 2 = 0 <;>
    simp [reset, state, low, BitVec.ofBool]


/-- Before the required reset, data is arbitrary. Afterwards dout is a multiple of four,
and an accumulator update is allowed only with a multiple-of-four buffer. -/
def invariant (s : State) : Prop :=
  s.v_init = 1 ∨ (s.v_dout.extractLsb' 0 2 = 0 ∧
    (s.v_uut_state = 2 → s.v_uut_buffer.extractLsb' 0 2 = 0))

theorem assumption_equation (i : Inputs) (s : State) :
    assumptions (eval i s).1 ↔ (s.v_init = 1 → i.v_reset = 1) := by
  rcases bit_cases i.v_reset with r | r <;> rcases bit_cases s.v_init with h | h <;>
    simp [assumptions, eval, r, h]

theorem assertion_equation (i : Inputs) (s : State) :
    assertions (eval i s).1 ↔ (i.v_reset = 0 → s.v_dout.extractLsb' 0 2 = 0) := by
  rcases bit_cases i.v_reset with r | r <;>
    by_cases low : s.v_dout.extractLsb' 0 2 = 0 <;>
    simp_all [assertions, eval, BitVec.ofBool]

private theorem low_add (a b : BitVec 8) (ha : a.extractLsb' 0 2 = 0)
    (hb : b.extractLsb' 0 2 = 0) : (a + b).extractLsb' 0 2 = 0 := by
  change a.setWidth 2 = 0 at ha
  change b.setWidth 2 = 0 at hb
  change (a+b).setWidth 2 = 0
  rw [BitVec.setWidth_add _ _ (by decide), ha, hb]
  rfl

theorem base (s : State) (h : initial s) : invariant s := by
  simp [initial] at h
  exact Or.inl ((BitVec.and_allOnes).symm.trans h)

theorem step (i : Inputs) (s : State) (h : invariant s)
    (a : assumptions (eval i s).1) : invariant (eval i s).2 := by
  rw [step_equation]
  rcases bit_cases i.v_reset with reset | reset
  · have not_first : s.v_init ≠ 1 := by
      intro first
      have impossible := (assumption_equation i s).1 a first
      simp_all
    rcases h with first | ⟨out, buffer⟩
    · exact (not_first first).elim
    · rcases state_cases s.v_uut_state with state | state | state | state <;>
        by_cases low : s.v_uut_buffer.extractLsb' 0 2 = 0 <;>
        simp_all [invariant, update, low_add]
  · simp [invariant, update, reset]

theorem sound (i : Inputs) (s : State) (h : invariant s)
    (a : assumptions (eval i s).1) : assertions (eval i s).1 := by
  apply (assertion_equation i s).2
  intro reset
  rcases h with first | ⟨out, _⟩
  · have impossible := (assumption_equation i s).1 a first
    simp_all
  · exact out

/-- The actual upstream harness assertion, under its actual imported reset assumption. -/
theorem safe : YosysLean.Safety eval initial assumptions assertions :=
  YosysLean.safety_of_invariant eval initial invariant assumptions assertions base step sound

#check_claim safe
end SBYAccumulatorProofs
