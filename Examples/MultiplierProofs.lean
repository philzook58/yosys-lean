import YosysLean.Check
import Examples.Generated.ShiftAdd
import Lean.Elab.Tactic.Omega
/-! Unsigned full-width multiplication for an original iterative RTL design.
The local invariant is modular at 64 bits; the final operand bound establishes
that the 32×32 result does not overflow. Checks need no SAT or exhaustive data cases. -/

namespace MultiplierProofs
set_option maxRecDepth 4096
set_option maxHeartbeats 200000

def low (r : BitVec 64) : BitVec 64 := if r.getLsbD 0 then 1 else 0

theorem split_bit (r : BitVec 64) : (r >>> 1) * 2 + low r = r := by
  apply BitVec.eq_of_toNat_eq
  have bound := r.isLt
  have bit : (low r).toNat = r.toNat % 2 := by
    simp only [low, BitVec.getLsbD, Nat.testBit_zero]
    split <;> simp_all <;> omega
  simp only [BitVec.toNat_add, BitVec.toNat_mul, BitVec.toNat_ushiftRight]
  rw [bit]
  simp
  omega

theorem invariant_step (p l r : BitVec 64) :
    (p + if r.getLsbD 0 then l else 0) + (l <<< 1) * (r >>> 1) = p + l * r := by
  have select : (if r.getLsbD 0 then l else 0) = l * low r := by
    unfold low
    split <;> simp_all
  rw [select, BitVec.shiftLeft_eq_mul_twoPow]
  have two : BitVec.twoPow 64 1 = 2 := by decide
  rw [two, BitVec.mul_assoc, BitVec.mul_comm 2]
  rw [BitVec.add_assoc, BitVec.add_comm (l * low r), ← BitVec.mul_add, split_bit]


def advance (s : v_ShiftAdd.State) : v_ShiftAdd.State :=
  { v_remaining := s.v_remaining - 1
    v_lhs := s.v_lhs <<< 1
    v_rhs := s.v_rhs >>> 1
    v_busy := if s.v_remaining == 1 then 0 else 1
    v_done := if s.v_remaining == 1 then 1 else 0
    v_product := s.v_product + if s.v_rhs.getLsbD 0 then s.v_lhs else 0 }

private theorem left_wire (x : BitVec 64) :
    BitVec.append (x.extractLsb' 0 63) (0#1) = x <<< 1 :=
  (BitVec.shiftLeft_eq_concat_of_lt (x := x) (n := 1) (by decide)).symm

private theorem right_wire (x : BitVec 64) :
    BitVec.append (0#1) (x.extractLsb' 1 63) = x >>> 1 :=
  (BitVec.ushiftRight_eq_extractLsb'_of_lt (x := x) (n := 1) (by decide)).symm

private theorem bit_wire (x : BitVec 64) : (x.extractLsb' 0 1 == 1) = x.getLsbD 0 := by
  rw [← BitVec.setWidth_eq_extractLsb' (by decide), BitVec.setWidth_one]
  cases x.getLsbD 0 <;> rfl

private theorem bool_wire (b : Bool) : (BitVec.ofBool b == 1) = b := by
  cases b <;> rfl

theorem active_step (i : v_ShiftAdd.Inputs) (s : v_ShiftAdd.State)
    (reset : i.v_reset = 0) (busy : s.v_busy = 1) :
    (v_ShiftAdd.eval i s).2 = advance s := by
  simp [v_ShiftAdd.eval, advance, reset, busy]
  refine ⟨left_wire _, right_wire _, ?_, ?_, ?_⟩
  · cases h : s.v_remaining == 1 <;> simp_all [BitVec.ofBool]
  · cases h : s.v_remaining == 1 <;> simp_all [BitVec.ofBool]
  · have bits := bit_wire s.v_rhs
    cases h : s.v_rhs.getLsbD 0 <;> simp_all


def idle : v_ShiftAdd.Inputs := ⟨0, 0, 0, 0⟩
def drain (n : Nat) (s : v_ShiftAdd.State) :=
  YosysLean.run v_ShiftAdd.eval (List.replicate n idle) s

theorem drain_correct (n : Nat) (s : v_ShiftAdd.State) (hn : n ≤ 32)
    (count : s.v_remaining = BitVec.ofNat 6 n)
    (busy : s.v_busy = if n = 0 then 0 else 1)
    (bound : s.v_rhs.toNat < 2^n) :
    (drain n s).v_product = s.v_product + s.v_lhs * s.v_rhs ∧
    (drain n s).v_busy = 0 ∧ (0 < n → (drain n s).v_done = 1) := by
  induction n generalizing s with
  | zero =>
      have zero : s.v_rhs = 0 := by apply BitVec.eq_of_toNat_eq; simp; simpa using bound
      simp [drain, YosysLean.run, zero, busy]
  | succ n ih =>
      have active : s.v_busy = 1 := by simpa using busy
      have next_count : (advance s).v_remaining = BitVec.ofNat 6 n := by
        simp only [advance, count]
        apply BitVec.eq_of_toNat_eq
        simp [BitVec.toNat_sub]
        omega
      have next_busy : (advance s).v_busy = if n = 0 then 0 else 1 := by
        dsimp only [advance]
        rw [count]
        by_cases h : n = 0
        · subst n; rfl
        · have ne : BitVec.ofNat 6 (n+1) ≠ 1 := by
            intro eq
            have nat := congrArg BitVec.toNat eq
            simp at nat
            omega
          simp [h]
          exact ne
      have next_bound : (advance s).v_rhs.toNat < 2^n := by
        simp only [advance, BitVec.toNat_ushiftRight]
        simp only [Nat.pow_succ] at bound
        omega
      have result := ih (advance s) (by omega) next_count next_busy next_bound
      have step : drain (n+1) s = drain n (advance s) := by
        simp only [drain, List.replicate_succ, YosysLean.run]
        rw [active_step idle s rfl active]
      rw [step]
      refine ⟨?_, result.2.1, ?_⟩
      · exact result.1.trans (invariant_step _ _ _)
      · intro _
        by_cases h : n = 0
        · subst n
          change (advance s).v_done = 1
          simp [advance, count]
        · exact result.2.2 (by omega)


def loaded (a b : BitVec 32) : v_ShiftAdd.State :=
  { v_remaining := 32, v_lhs := a.setWidth 64, v_rhs := b.setWidth 64,
    v_busy := 1, v_done := 0, v_product := 0 }

def request (a b : BitVec 32) : v_ShiftAdd.Inputs := ⟨0, 1, a, b⟩

private theorem widen (x : BitVec 32) :
    BitVec.append (0#32) x = x.setWidth 64 := by
  apply BitVec.eq_of_toNat_eq
  have bound := x.isLt
  have bits := BitVec.toNat_append (0#32) x
  simp at bits
  simp only [BitVec.toNat_setWidth]
  exact bits.trans (Nat.mod_eq_of_lt (by omega)).symm

theorem accepts (a b : BitVec 32) (s : v_ShiftAdd.State) (ready : s.v_busy = 0) :
    (v_ShiftAdd.eval (request a b) s).2 = loaded a b := by
  simp [v_ShiftAdd.eval, request, loaded, ready]
  exact ⟨widen a, widen b⟩

/-- The wide bitvector product is the exact unsigned natural-number product. -/
theorem widened_product (a b : BitVec 32) :
    (a.setWidth 64 * b.setWidth 64).toNat = a.toNat * b.toNat := by
  have a64 : a.toNat < 2^64 := by have h := a.isLt; omega
  have b64 : b.toNat < 2^64 := by have h := b.isLt; omega
  have product_bound : a.toNat * b.toNat < 2^64 := calc
    _ ≤ a.toNat * 2^32 := Nat.mul_le_mul_left _ (Nat.le_of_lt b.isLt)
    _ < 2^32 * 2^32 := Nat.mul_lt_mul_of_pos_right a.isLt (by decide)
    _ = _ := by decide
  simp [BitVec.toNat_mul, BitVec.toNat_setWidth,
    Nat.mod_eq_of_lt a64, Nat.mod_eq_of_lt b64, Nat.mod_eq_of_lt product_bound]

def transaction (a b : BitVec 32) (s : v_ShiftAdd.State) :=
  drain 32 (v_ShiftAdd.eval (request a b) s).2

/-- One accepted request and 32 processing edges complete with the full 64-bit product. -/
theorem completed (a b : BitVec 32) (s : v_ShiftAdd.State) (ready : s.v_busy = 0) :
    (transaction a b s).v_product.toNat = a.toNat * b.toNat ∧
    (transaction a b s).v_busy = 0 ∧ (transaction a b s).v_done = 1 := by
  have bound : (loaded a b).v_rhs.toNat < 2^32 := by
    dsimp only [loaded]
    have h := b.isLt
    simp [BitVec.toNat_setWidth]
    omega
  have result := drain_correct 32 (loaded a b) (by decide) rfl rfl bound
  unfold transaction
  rw [accepts a b s ready]
  refine ⟨?_, result.2.1, result.2.2 (by decide)⟩
  rw [result.1]
  simpa [loaded] using widened_product a b

/-- Reset aborts an in-flight transaction and clears the visible result. -/
theorem reset_flush (i : v_ShiftAdd.Inputs) (s : v_ShiftAdd.State)
    (reset : i.v_reset = 1) : (v_ShiftAdd.eval i s).2 = default := by
  simp [v_ShiftAdd.eval, reset]
  rfl

/-- Busy cycles ignore operand changes and new start requests. -/
theorem busy_ignores_requests (i j : v_ShiftAdd.Inputs) (s : v_ShiftAdd.State)
    (ri : i.v_reset = 0) (rj : j.v_reset = 0) (busy : s.v_busy = 1) :
    (v_ShiftAdd.eval i s).2 = (v_ShiftAdd.eval j s).2 :=
  (active_step i s ri busy).trans (active_step j s rj busy).symm

/-- In idle, the next edge clears done, including when a new request is accepted. -/
theorem done_clears (i : v_ShiftAdd.Inputs) (s : v_ShiftAdd.State)
    (busy : s.v_busy = 0) : (v_ShiftAdd.eval i s).2.v_done = 0 := by
  simp [v_ShiftAdd.eval, busy]

/-- Idle data and counters hold; only the done pulse clears. -/
theorem idle_holds (s : v_ShiftAdd.State) (busy : s.v_busy = 0) :
    (v_ShiftAdd.eval idle s).2 = { s with v_done := 0 } := by
  simp [v_ShiftAdd.eval, idle, busy]

#check_claim active_step, drain_correct, accepts, widened_product, completed, reset_flush,
  busy_ignores_requests, done_clears, idle_holds, invariant_step
end MultiplierProofs
