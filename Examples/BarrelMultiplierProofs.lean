import YosysLean.Check
import Examples.Generated.BarrelMul
import Examples.MultiplierProofs

/-! A two-bit-per-edge multiplier using a variable-position barrel shifter.
Arithmetic correctness is composed from two one-bit invariant steps. -/
namespace BarrelMultiplierProofs
set_option maxRecDepth 4096
set_option maxHeartbeats 200000

def accumulate (p l r : BitVec 64) :=
  (p + if r.getLsbD 0 then l else 0) + if r.getLsbD 1 then l <<< 1 else 0

theorem pair_invariant (p l r : BitVec 64) :
    accumulate p l r + (l <<< 2) * (r >>> 2) = p + l * r := by
  have first := MultiplierProofs.invariant_step p l r
  have second := MultiplierProofs.invariant_step
    (p + if r.getLsbD 0 then l else 0) (l <<< 1) (r >>> 1)
  simpa [accumulate, ← BitVec.shiftLeft_add, ← BitVec.shiftRight_add] using second.trans first

def shifted (s : v_BarrelMul.State) := s.v_multiplicand <<< s.v_position.toNat

def advance (s : v_BarrelMul.State) : v_BarrelMul.State :=
  { v_multiplicand := s.v_multiplicand
    v_position := s.v_position + 2
    v_rhs := s.v_rhs >>> 2
    v_remaining := s.v_remaining - 1
    v_busy := if s.v_remaining == 1 then 0 else 1
    v_done := if s.v_remaining == 1 then 1 else 0
    v_product := accumulate s.v_product (shifted s) s.v_rhs }

private theorem left_wire (x : BitVec 64) :
    BitVec.append (x.extractLsb' 0 63) (0#1) = x <<< 1 :=
  (BitVec.shiftLeft_eq_concat_of_lt (x := x) (n := 1) (by decide)).symm

private theorem right_wire (x : BitVec 64) :
    BitVec.append (0#2) (x.extractLsb' 2 62) = x >>> 2 :=
  (BitVec.ushiftRight_eq_extractLsb'_of_lt (x := x) (n := 2) (by decide)).symm

private theorem bit_wire (x : BitVec 64) (i : Nat) :
    (x.extractLsb' i 1 == 1) = x.getLsbD i := by
  rw [← BitVec.setWidth_ushiftRight_eq_extractLsb, BitVec.setWidth_one]
  simp only [BitVec.getLsbD_ushiftRight, Nat.add_zero]
  cases x.getLsbD i <;> rfl

theorem active_step (i : v_BarrelMul.Inputs) (s : v_BarrelMul.State)
    (reset : i.v_reset = 0) (busy : s.v_busy = 1) :
    (v_BarrelMul.eval i s).2 = advance s := by
  simp [v_BarrelMul.eval, advance, accumulate, shifted, reset, busy]
  refine ⟨right_wire _, ?_, ?_, ?_⟩
  · cases h : s.v_remaining == 1 <;> simp_all [BitVec.ofBool]
  · cases h : s.v_remaining == 1 <;> simp_all [BitVec.ofBool]
  · have lo := bit_wire s.v_rhs 0
    have hi := bit_wire s.v_rhs 1
    have left := left_wire (shifted s)
    cases hl : s.v_rhs.getLsbD 0 <;> cases hh : s.v_rhs.getLsbD 1 <;>
      simp_all [shifted]

theorem shifted_advance (s : v_BarrelMul.State) (bound : s.v_position.toNat ≤ 30) :
    shifted (advance s) = shifted s <<< 2 := by
  have index : (s.v_position + 2).toNat = s.v_position.toNat + 2 := by
    simp [BitVec.toNat_add]
    omega
  simp only [shifted, advance, index, BitVec.shiftLeft_add]

def idle : v_BarrelMul.Inputs := ⟨0, 0, 0, 0⟩
def drain (n : Nat) (s : v_BarrelMul.State) :=
  YosysLean.run v_BarrelMul.eval (List.replicate n idle) s

theorem drain_correct (n : Nat) (s : v_BarrelMul.State) (hn : n ≤ 16)
    (count : s.v_remaining = BitVec.ofNat 6 n)
    (busy : s.v_busy = if n = 0 then 0 else 1)
    (position : s.v_position.toNat + 2*n ≤ 32)
    (bound : s.v_rhs.toNat < 2^(2*n)) :
    (drain n s).v_product = s.v_product + shifted s * s.v_rhs ∧
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
      have next_position : (advance s).v_position.toNat + 2*n ≤ 32 := by
        simp [advance, BitVec.toNat_add]
        omega
      have next_bound : (advance s).v_rhs.toNat < 2^(2*n) := by
        simp only [advance, BitVec.toNat_ushiftRight]
        simp only [Nat.mul_add, Nat.mul_one, Nat.pow_add] at bound
        omega
      have result := ih (advance s) (by omega) next_count next_busy next_position next_bound
      have step : drain (n+1) s = drain n (advance s) := by
        simp only [drain, List.replicate_succ, YosysLean.run]
        rw [active_step idle s rfl active]
      rw [step]
      refine ⟨?_, result.2.1, ?_⟩
      · calc
          _ = (advance s).v_product + shifted (advance s) * (advance s).v_rhs := result.1
          _ = _ := by
            rw [shifted_advance s (by omega)]
            exact pair_invariant _ _ _
      · intro _
        by_cases h : n = 0
        · subst n
          change (advance s).v_done = 1
          simp [advance, count]
        · exact result.2.2 (by omega)


def loaded (a b : BitVec 32) : v_BarrelMul.State :=
  { v_remaining := 16, v_multiplicand := a.setWidth 64, v_position := 0,
    v_rhs := b.setWidth 64,
    v_busy := 1, v_done := 0, v_product := 0 }

def request (a b : BitVec 32) : v_BarrelMul.Inputs := ⟨0, 1, a, b⟩

private theorem widen (x : BitVec 32) :
    BitVec.append (0#32) x = x.setWidth 64 := by
  apply BitVec.eq_of_toNat_eq
  have bound := x.isLt
  have bits := BitVec.toNat_append (0#32) x
  simp at bits
  simp only [BitVec.toNat_setWidth]
  exact bits.trans (Nat.mod_eq_of_lt (by omega)).symm

theorem accepts (a b : BitVec 32) (s : v_BarrelMul.State) (ready : s.v_busy = 0) :
    (v_BarrelMul.eval (request a b) s).2 = loaded a b := by
  simp [v_BarrelMul.eval, request, loaded, ready]
  exact ⟨widen a, widen b⟩


def transaction (a b : BitVec 32) (s : v_BarrelMul.State) :=
  drain 16 (v_BarrelMul.eval (request a b) s).2

/-- One accepted request and 16 processing edges complete with the full 64-bit product. -/
theorem completed (a b : BitVec 32) (s : v_BarrelMul.State) (ready : s.v_busy = 0) :
    (transaction a b s).v_product.toNat = a.toNat * b.toNat ∧
    (transaction a b s).v_busy = 0 ∧ (transaction a b s).v_done = 1 := by
  have bound : (loaded a b).v_rhs.toNat < 2^32 := by
    dsimp only [loaded]
    have h := b.isLt
    simp [BitVec.toNat_setWidth]
    omega
  have result := drain_correct 16 (loaded a b) (by decide) rfl rfl (by simp [loaded]) bound
  unfold transaction
  rw [accepts a b s ready]
  refine ⟨?_, result.2.1, result.2.2 (by decide)⟩
  rw [result.1]
  simpa [loaded, shifted] using MultiplierProofs.widened_product a b

/-- Reset aborts an in-flight transaction and clears the visible result. -/
theorem reset_flush (i : v_BarrelMul.Inputs) (s : v_BarrelMul.State)
    (reset : i.v_reset = 1) : (v_BarrelMul.eval i s).2 = default := by
  simp [v_BarrelMul.eval, reset]
  rfl

/-- Busy cycles ignore operand changes and new start requests. -/
theorem busy_ignores_requests (i j : v_BarrelMul.Inputs) (s : v_BarrelMul.State)
    (ri : i.v_reset = 0) (rj : j.v_reset = 0) (busy : s.v_busy = 1) :
    (v_BarrelMul.eval i s).2 = (v_BarrelMul.eval j s).2 :=
  (active_step i s ri busy).trans (active_step j s rj busy).symm

/-- In idle, the next edge clears done, including when a new request is accepted. -/
theorem done_clears (i : v_BarrelMul.Inputs) (s : v_BarrelMul.State)
    (busy : s.v_busy = 0) : (v_BarrelMul.eval i s).2.v_done = 0 := by
  simp [v_BarrelMul.eval, busy]

/-- Idle data and counters hold; only the done pulse clears. -/
theorem idle_holds (s : v_BarrelMul.State) (busy : s.v_busy = 0) :
    (v_BarrelMul.eval idle s).2 = { s with v_done := 0 } := by
  simp [v_BarrelMul.eval, idle, busy]

/-- Both exported implementations agree at their respective completion boundaries. -/
theorem implementations_agree (a b : BitVec 32) (serial : v_ShiftAdd.State)
    (barrel : v_BarrelMul.State) (sr : serial.v_busy = 0) (br : barrel.v_busy = 0) :
    (transaction a b barrel).v_product =
      (MultiplierProofs.transaction a b serial).v_product := by
  apply BitVec.eq_of_toNat_eq
  exact (completed a b barrel br).1.trans (MultiplierProofs.completed a b serial sr).1.symm

#check_claim active_step, drain_correct, accepts, completed, reset_flush, busy_ignores_requests,
  done_clears, idle_holds, implementations_agree, pair_invariant
end BarrelMultiplierProofs
