import Std.Tactic

/-! The natural-number recurrence implemented by ZipCPU's unsigned divider.
The workspace may exceed 63 bits after the final step; only the quotient is observed then. -/
namespace DividerArithmetic
set_option maxRecDepth 16384
set_option maxHeartbeats 400000

structure Work where
  dividend : Nat
  quotient : Nat

def step (b : Nat) (w : Work) : Work :=
  if b * 2^31 ≤ w.dividend then
    ⟨2 * (w.dividend - b * 2^31), 2 * w.quotient + 1⟩
  else ⟨2 * w.dividend, 2 * w.quotient⟩

def work (a b : Nat) : Nat → Work
  | 0 => ⟨a, 0⟩
  | n + 1 => step b (work a b n)

/-- Scaled division balance and bounds; no operand enumeration is involved. -/
def Invariant (a b n : Nat) (w : Work) : Prop :=
  w.dividend + b * 2^32 * w.quotient = 2^n * a ∧
  w.dividend < b * 2^32 ∧ w.quotient < 2^n ∧ w.dividend < 2^(32+n)

theorem invariant_step (a b n : Nat) (w : Work) (h : Invariant a b n w) :
    Invariant a b (n+1) (step b w) := by
  rcases h with ⟨balance, remainder, quotient, size⟩
  unfold Invariant step
  split <;> dsimp only
  all_goals
    have doubled := congrArg (2 * ·) balance
    have pow : 2^(32+(n+1)) = 2 * 2^(32+n) := by
      rw [show 32+(n+1) = (32+n)+1 by omega, Nat.pow_succ, Nat.mul_comm]
    have power : 2^(n+1) * a = 2 * (2^n * a) := by rw [Nat.pow_succ]; ac_rfl
    rw [pow]
    constructor
    · rw [power]
      first
      | rw [show b * 2^32 * (2*w.quotient+1) =
          2*(b*2^32*w.quotient) + b*2^32 by
            simp only [Nat.mul_add, Nat.mul_one]; ac_rfl]
        omega
      | rw [show b * 2^32 * (2*w.quotient) = 2*(b*2^32*w.quotient) by ac_rfl]
        omega
    · constructor
      · omega
      · rw [Nat.pow_succ]
        constructor <;> omega

theorem invariant_zero (a b : Nat) (ha : a < 2^32) (hb : 0 < b) :
    Invariant a b 0 ⟨a, 0⟩ := by
  have bound : 2^32 ≤ b * 2^32 := by omega
  change a + b * 2^32 * 0 = 2^0 * a ∧
    a < b * 2^32 ∧ 0 < 2^0 ∧ a < 2^(32+0)
  exact ⟨by omega, by omega, by decide, ha⟩

theorem invariant (a b n : Nat) (ha : a < 2^32) (hb : 0 < b) :
    Invariant a b n (work a b n) := by
  induction n with
  | zero => exact invariant_zero a b ha hb
  | succ n ih => exact invariant_step a b n _ ih

theorem quotient_of_invariant (a b : Nat) (w : Work) (h : Invariant a b 32 w) :
    w.quotient = a / b := by
  rcases h with ⟨balance, remainder, _, _⟩
  apply Eq.symm
  apply Nat.div_eq_of_lt_le
  · have lo : (w.quotient * b) * 2^32 ≤ a * 2^32 := by
      calc
        _ = b * 2^32 * w.quotient := by ac_rfl
        _ ≤ 2^32 * a := by omega
        _ = _ := by ac_rfl
    exact Nat.le_of_mul_le_mul_right lo (by decide)
  · have hi : a * 2^32 < ((w.quotient + 1) * b) * 2^32 := by
      rw [show ((w.quotient+1)*b)*2^32 = b*2^32*w.quotient + b*2^32 by
        simp only [Nat.add_mul, Nat.one_mul]; ac_rfl]
      rw [Nat.mul_comm a]
      omega
    exact (Nat.mul_lt_mul_right (by decide : 0 < 2^32)).1 hi

/-- After exactly 32 decisions, the accumulated quotient is mathematical unsigned division. -/
theorem quotient (a b : Nat) (ha : a < 2^32) (hb : 0 < b) :
    (work a b 32).quotient = a / b :=
  quotient_of_invariant a b _ (invariant a b 32 ha hb)

end DividerArithmetic
