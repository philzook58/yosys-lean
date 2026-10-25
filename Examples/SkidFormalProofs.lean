import YosysLean.Check
import YosysLean.Formal
import Examples.Generated.ZipSkidFormal
import Lean.Elab.Tactic.Omega

/-! Safety of the unchanged upstream skid-buffer assertions, including its cover monitor. -/
namespace SkidFormalProofs
open v_ZipSkidFormal
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

private theorem bit_cases (b : BitVec 1) : b = 0 ∨ b = 1 := by revert b; decide

private theorem counter_cases (b : BitVec 4) (h : b.toNat ≤ 12) :
    b = 0 ∨ b = 1 ∨ b = 2 ∨ b = 3 ∨ b = 4 ∨ b = 5 ∨ b = 6 ∨
    b = 7 ∨ b = 8 ∨ b = 9 ∨ b = 10 ∨ b = 11 ∨ b = 12 := by
  have : ∀ b : BitVec 4, b.toNat ≤ 12 →
      b = 0 ∨ b = 1 ∨ b = 2 ∨ b = 3 ∨ b = 4 ∨ b = 5 ∨ b = 6 ∨
      b = 7 ∨ b = 8 ∨ b = 9 ∨ b = 10 ∨ b = 11 ∨ b = 12 := by decide
  exact this b h

/-- The exercise's cover sequencer cannot reach its default `assert(0)` branch. -/
theorem counter_step (i : Inputs) (s : State)
    (h : s.v_genblk4_cvr_steps.toNat ≤ 12 ∨ i.v_i_reset = 1) :
    (eval i s).2.v_genblk4_cvr_steps.toNat ≤ 12 := by
  rcases bit_cases i.v_i_reset with hr | hr
  · have bound : s.v_genblk4_cvr_steps.toNat ≤ 12 := h.resolve_right (by simp [hr])
    rcases bit_cases i.v_i_valid with hv | hv <;>
      rcases bit_cases i.v_i_ready with hd | hd <;>
      rcases bit_cases s.v_LOGIC_r_valid with hf | hf <;>
      rcases counter_cases _ bound with hc | hc | hc | hc | hc | hc | hc |
      hc | hc | hc | hc | hc | hc <;>
      simp [eval, hr, hc, hv, hd, hf]
  · simp [eval, hr]

private theorem counter_assert (i : Inputs) (s : State)
    (h : s.v_genblk4_cvr_steps.toNat ≤ 12 ∨ i.v_i_reset = 1) :
    (eval i s).1.v__examples_bus_upstream_skidbuffer_v_478_assert_352 = 1 := by
  rcases h with hc | hr
  · rcases counter_cases _ hc with hc | hc | hc | hc | hc | hc | hc |
      hc | hc | hc | hc | hc | hc <;> simp [eval, hc]
  · simp [eval, hr]

/-- One sampled history edge supplies the `$past` relationships used by the upstream checks. -/
theorem following (p : State) (i j : Inputs)
    (range : (eval i p).2.v_genblk4_cvr_steps.toNat ≤ 12)
    (assumed : assumptions (eval j (eval i p).2).1) :
    assertions (eval j (eval i p).2).1 := by
  have counter := counter_assert j (eval i p).2 (Or.inl range)
  unfold assertions
  refine ⟨trivial, ?_, ?_, ?_, counter, ?_, ?_, ?_, ?_, ?_⟩
  all_goals
    clear counter range
    dsimp only [eval, assumptions] at assumed ⊢
  all_goals
    rcases bit_cases i.v_i_reset with hi | hi <;>
    rcases bit_cases i.v_i_valid with hv | hv <;>
    rcases bit_cases i.v_i_ready with hr | hr <;>
    rcases bit_cases p.v_LOGIC_r_valid with hf | hf <;>
    rcases bit_cases j.v_i_reset with hj | hj <;>
    rcases bit_cases j.v_i_valid with hjv | hjv <;>
    simp_all [BitVec.ofBool]

/-- Initial states or states with a concrete predecessor and a bounded cover sequencer. -/
def invariant (s : State) : Prop :=
  initial s ∨ ∃ p i, s = (eval i p).2 ∧ s.v_genblk4_cvr_steps.toNat ≤ 12

private theorem initial_sound (i : Inputs) (s : State) (init : initial s)
    (assumed : assumptions (eval i s).1) : assertions (eval i s).1 := by
  rcases bit_cases s.v_f_past_valid with hf | hf <;>
    rcases bit_cases s.v_LOGIC_r_valid with hv | hv <;>
    rcases bit_cases i.v_i_reset with hr | hr <;>
    rcases bit_cases i.v_i_valid with hi | hi <;>
    simp_all [initial, eval, assumptions, assertions]

/-- Every upstream assertion holds on all initialized executions satisfying the imported assumptions. -/
theorem safe : YosysLean.Safety eval initial assumptions assertions := by
  apply YosysLean.safety_of_invariant eval initial invariant assumptions assertions
  · intro s h; exact Or.inl h
  · intro i s inv assumed
    have reset : s.v_f_past_valid = 0 → i.v_i_reset = 1 := by
      intro first
      simpa [eval, first] using assumed.2.1
    have range : (eval i s).2.v_genblk4_cvr_steps.toNat ≤ 12 := by
      apply counter_step
      rcases inv with init | ⟨p, j, _, bound⟩
      · right
        apply reset
        rcases bit_cases s.v_f_past_valid with hf | hf
        · exact hf
        · simp [initial, hf] at init
      · exact Or.inl bound
    exact Or.inr ⟨s, i, rfl, range⟩
  · intro j s inv assumed
    rcases inv with init | ⟨p, i, rfl, bound⟩
    · exact initial_sound j s init assumed
    · exact following p i j bound assumed

#check_claim safe
end SkidFormalProofs
