import YosysLean.Check
import Examples.Divider32Proofs

/-! Signed preprocessing and final sign correction around the proved magnitude divider. -/
namespace DividerSignedProofs
open v_ZipDiv32 Divider32Proofs
set_option maxRecDepth 16384
set_option maxHeartbeats 400000

def magnitude (x : BitVec 32) : BitVec 32 := if x.msb then -x else x

private theorem top (x : BitVec 32) : x.extractLsb' 31 1 = BitVec.ofBool x.msb := by
  apply BitVec.eq_of_toNat_eq
  have bound := x.isLt
  simp only [BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow, BitVec.toNat_ofBool]
  rw [BitVec.msb_eq_decide]
  by_cases neg : 2^31 ≤ x.toNat <;> simp [neg] <;> omega

private theorem low32 (x : BitVec 32) : (x.setWidth 63).extractLsb' 0 32 = x := by
  rw [BitVec.extractLsb'_setWidth_of_le (by decide)]
  simp

private theorem high30 (x : BitVec 32) : (x.setWidth 63).extractLsb' 33 30 = 0 := by
  apply BitVec.eq_of_toNat_eq
  have bound := x.isLt
  simp [BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow]
  omega

private theorem bit32 (x : BitVec 32) : (x.setWidth 63).extractLsb' 32 1 = 0 := by
  apply BitVec.eq_of_toNat_eq
  have bound := x.isLt
  simp [BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow]
  omega

private theorem append_nat (a : BitVec n) (b : BitVec m) :
    (a ++ b).toNat = a.toNat * 2^m + b.toNat := by
  rw [BitVec.toNat_append, ← Nat.shiftLeft_add_eq_or_of_lt b.isLt, Nat.shiftLeft_eq]

private theorem negative_wide (x : BitVec 32) (neg : x.msb = true) :
    (0#30 ++ -(1#1 ++ x)) = (-x).setWidth 63 := by
  apply BitVec.eq_of_toNat_eq
  have bound := x.isLt
  have lower := BitVec.msb_eq_true_iff_two_mul_ge.mp neg
  simp only [append_nat, BitVec.toNat_neg, BitVec.toNat_setWidth]
  change 0 * 2^33 + ((2^33 - (1 * 2^32 + x.toNat)) % 2^33) =
    ((2^32 - x.toNat) % 2^32) % 2^63
  omega

theorem magnitude_nonzero (x : BitVec 32) (nonzero : x ≠ 0) : magnitude x ≠ 0 := by
  unfold magnitude
  split
  · intro eq
    exact nonzero (BitVec.neg_eq_zero_iff.mp eq)
  · exact nonzero

structure Preloaded (a b : BitVec 32) (s : State) : Prop where
  bit : s.v_r_bit = 0
  presign : s.v_pre_sign = 1
  dividend : s.v_r_dividend = a.setWidth 63
  last : s.v_last_bit = 0
  divisor : s.v_r_divisor = b
  sign : s.v_r_sign = 0
  zero : s.v_zero_divisor = 0
  busy : s.v_r_busy = 1
  external_busy : s.v_o_busy = 1
  valid : s.v_o_valid = 0

theorem preprocessing (a b : BitVec 32) (s : State) (i : Inputs)
    (h : Preloaded a b s) (reset : i.v_i_reset = 0) (write : i.v_i_wr = 0) :
    Aligned 0 (magnitude b) ⟨(magnitude a).toNat, 0⟩ (eval i s).2
      (a.msb ^^ b.msb) (eval i s).2.v_o_quotient.toNat := by
  have slices : (a.setWidth 63).extractLsb' 31 1 = BitVec.ofBool a.msb := by
    rw [BitVec.extractLsb'_setWidth_of_le (by decide), top]
  refine ⟨?_, ?_, ?_⟩
  · cases ha : a.msb <;> cases hb : b.msb <;> constructor <;>
      simp [eval, reset, write, h.bit, h.presign, h.dividend, h.last, h.divisor,
        h.sign, h.zero, h.busy, h.external_busy, h.valid, slices,
        low32, high30, bit32, top, ha, hb, magnitude, BitVec.ofBool]
  · cases ha : a.msb
    · simp [eval, h.presign, h.dividend, slices, low32, high30, bit32, ha,
        magnitude, BitVec.ofBool]
      have bound := a.isLt
      change ((0#30 ++ (0#1 ++ a)) : BitVec 63).toNat = a.toNat % 2^63
      simp only [append_nat]
      change 0 * 2^33 + (0 * 2^32 + a.toNat) = _
      omega
    · simp [eval, h.presign, h.dividend, slices, low32, ha, BitVec.ofBool]
      change (0#30 ++ ((-(1#1 ++ a)).extractLsb' 32 1 ++
        (-(1#1 ++ a)).extractLsb' 0 32)).toNat = _
      rw [BitVec.extractLsb'_append_extractLsb']
      rw [negative_wide a ha]
      simp [magnitude, ha, BitVec.toNat_setWidth]
  · have bound := (eval i s).2.v_o_quotient.isLt
    simpa using (Nat.mod_eq_of_lt bound).symm

theorem accepts_preloaded (a b : BitVec 32) (s : State) (ready : Ready s)
    (nonzero : b ≠ 0) (needs : (a.msb || b.msb) = true) :
    Preloaded a b (eval (DividerProofs.input32 a b true 0 1) s).2 := by
  rcases ready with ⟨busy, pre, sign, valid⟩
  have ne : (b != 0#32) = true := bne_iff_ne.mpr nonzero
  have data := (DividerProofs.accepts32 a b true s busy pre).2.2.2
  cases ha : a.msb <;> cases hb : b.msb <;> simp_all only [Bool.or_self, Bool.false_or,
    Bool.or_false, Bool.false_eq_true]
  all_goals
    constructor <;>
      first
      | exact data
      | simp [eval, DividerProofs.input32, busy, pre, sign, valid, ne, top, ha, hb, BitVec.ofBool]

theorem accepts_nonnegative (a b : BitVec 32) (s : State) (ready : Ready s)
    (nonzero : b ≠ 0) (ha : a.msb = false) (hb : b.msb = false) :
    Aligned 0 (magnitude b) ⟨(magnitude a).toNat, 0⟩
      (eval (DividerProofs.input32 a b true 0 1) s).2 (a.msb ^^ b.msb) := by
  have same : eval (DividerProofs.input32 a b true 0 1) s =
      eval (DividerProofs.input32 a b false 0 1) s := by
    simp [eval, DividerProofs.input32, top, ha, hb, BitVec.ofBool]
  rw [same]
  simpa [magnitude, ha, hb] using accepts a b s ready nonzero

theorem sign_correction (i : Inputs) (s : State) (b : BitVec 32)
    (phase : Phase 32 b s true) (reset : i.v_i_reset = 0) (write : i.v_i_wr = 0) :
    (eval i s).2.v_o_quotient = -s.v_o_quotient ∧
      (eval i s).2.v_o_busy = 0 ∧ (eval i s).2.v_o_valid = 1 ∧ (eval i s).2.v_o_err = 0 := by
  simp [eval, phase.busy, phase.sign, phase.presign, phase.last, phase.zero,
    phase.valid, reset, write, BitVec.ofBool]
  change ((-s.v_o_quotient).extractLsb' 1 31 ++ (-s.v_o_quotient).extractLsb' 0 1) = _
  exact BitVec.extractLsb'_append_extractLsb'

def prepared (a b : BitVec 32) (s : State) (i : Inputs) : State :=
  let loaded := (eval (DividerProofs.input32 a b true 0 1) s).2
  if a.msb || b.msb then (eval i loaded).2 else loaded

theorem prepared_aligned (a b : BitVec 32) (s : State) (i : Inputs)
    (ready : Ready s) (nonzero : b ≠ 0) (reset : i.v_i_reset = 0) (write : i.v_i_wr = 0) :
    ∃ seed, Aligned 0 (magnitude b) ⟨(magnitude a).toNat, 0⟩
      (prepared a b s i) (a.msb ^^ b.msb) seed := by
  unfold prepared
  split
  · rename_i needs
    exact ⟨_, preprocessing a b _ i (accepts_preloaded a b s ready nonzero needs) reset write⟩
  · rename_i needs
    have ha : a.msb = false := by cases h : a.msb <;> simp_all
    have hb : b.msb = false := by cases h : b.msb <;> simp_all
    exact ⟨0, accepts_nonnegative a b s ready nonzero ha hb⟩

def transaction (a b : BitVec 32) (s : State) (pre : Inputs)
    (inputs : List Inputs) (correction : Inputs) : State :=
  let done := YosysLean.run eval inputs (prepared a b s pre)
  if a.msb ^^ b.msb then (eval correction done).2 else done

def processing_inputs (a b : BitVec 32) (pre : Inputs)
    (inputs : List Inputs) (correction : Inputs) : List Inputs :=
  (if a.msb || b.msb then [pre] else []) ++ inputs ++
    (if a.msb ^^ b.msb then [correction] else [])

private theorem run_append (xs ys : List Inputs) (s : State) :
    YosysLean.run eval (xs ++ ys) s = YosysLean.run eval ys (YosysLean.run eval xs s) := by
  induction xs generalizing s with
  | nil => rfl
  | cons i rest ih => exact ih _

/-- The staged transaction is an ordinary execution of the original exported RTL. -/
theorem transaction_execution (a b : BitVec 32) (s : State) (pre correction : Inputs)
    (inputs : List Inputs) :
    transaction a b s pre inputs correction =
      YosysLean.run eval (processing_inputs a b pre inputs correction)
        (eval (DividerProofs.input32 a b true 0 1) s).2 := by
  cases ha : a.msb <;> cases hb : b.msb <;>
    simp [transaction, prepared, processing_inputs, ha, hb, run_append, YosysLean.run]

/-- Nonzero signed division takes 32, 33, or 34 processing edges, according to operand signs. -/
theorem processing_latency (a b : BitVec 32) (pre correction : Inputs) (inputs : List Inputs)
    (length : inputs.length = 32) :
    (processing_inputs a b pre inputs correction).length =
      32 + (if a.msb || b.msb then 1 else 0) + (if a.msb ^^ b.msb then 1 else 0) := by
  cases ha : a.msb <;> cases hb : b.msb <;> simp [processing_inputs, ha, hb, length]

theorem signed_formula (a b : BitVec 32) :
    a.sdiv b = if a.msb ^^ b.msb then -(magnitude a / magnitude b)
      else magnitude a / magnitude b := by
  cases ha : a.msb <;> cases hb : b.msb <;>
    simp [BitVec.sdiv_eq, magnitude, ha, hb]

/-- Full 32-bit signed division, including wrapped min-signed / -1.
There are 32 divide edges, plus one preprocessing edge if either operand is negative,
and one correction edge if their signs differ. No quotient is specified for division by zero. -/
theorem signed_completed (a b : BitVec 32) (s : State) (pre correction : Inputs)
    (inputs : List Inputs) (ready : Ready s) (nonzero : b ≠ 0)
    (length : inputs.length = 32) (quiet : Quiet inputs)
    (pre_reset : pre.v_i_reset = 0) (pre_write : pre.v_i_wr = 0)
    (correction_reset : correction.v_i_reset = 0) (correction_write : correction.v_i_wr = 0) :
    let done := transaction a b s pre inputs correction
    done.v_o_quotient = a.sdiv b ∧
      done.v_o_busy = 0 ∧ done.v_o_valid = 1 ∧ done.v_o_err = 0 := by
  obtain ⟨seed, start⟩ := prepared_aligned a b s pre ready nonzero pre_reset pre_write
  have nonzero_mag := magnitude_nonzero b nonzero
  have positive : 0 < (magnitude b).toNat := by
    have ne : (magnitude b).toNat ≠ 0 :=
      fun eq ↦ nonzero_mag (BitVec.eq_of_toNat_eq eq)
    omega
  have core := run_aligned inputs _ (magnitude a) (magnitude b) 0 start nonzero_mag (by omega) quiet
  simp only [Nat.zero_add, length] at core
  have result := aligned_result (magnitude a).toNat (magnitude b) _ _ core
    (DividerArithmetic.invariant _ _ _ (magnitude a).isLt positive)
  have quotient : (YosysLean.run eval inputs (prepared a b s pre)).v_o_quotient =
      magnitude a / magnitude b := by
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_udiv]
    exact result
  cases signs : a.msb ^^ b.msb
  · have phase : Phase 32 (magnitude b)
        (YosysLean.run eval inputs (prepared a b s pre)) false := by
      simpa only [signs] using core.phase
    simp only [transaction, signs, Bool.false_eq_true, ↓reduceIte]
    refine ⟨?_, ?_, ?_, phase.error⟩
    · rw [signed_formula, signs]
      exact quotient
    · simpa using phase.external_busy
    · simpa using phase.valid
  · have phase : Phase 32 (magnitude b)
        (YosysLean.run eval inputs (prepared a b s pre)) true := by
      simpa only [signs] using core.phase
    have corrected := sign_correction correction _ _ phase correction_reset correction_write
    simp only [transaction, signs, ↓reduceIte]
    refine ⟨?_, corrected.2⟩
    rw [corrected.1, quotient, signed_formula, signs]
    rfl

/-- Signed zero-divisor requests also return error after one edge, without sign-adjustment delay. -/
theorem signed_divide_by_zero (a : BitVec 32) (s : State) (i : Inputs) (ready : Ready s)
    (reset : i.v_i_reset = 0) (write : i.v_i_wr = 0) :
    let done := (eval i (eval (DividerProofs.input32 a 0 true 0 1) s).2).2
    done.v_o_busy = 0 ∧ done.v_o_valid = 1 ∧ done.v_o_err = 1 := by
  rcases ready with ⟨busy, pre, sign, valid⟩
  simp [eval, DividerProofs.input32, reset, write, busy, pre, sign, valid]

/-- Every strict magnitude-loop prefix remains busy and cannot report a result. -/
theorem signed_in_progress (a b : BitVec 32) (s : State) (pre : Inputs) (inputs : List Inputs)
    (ready : Ready s) (nonzero : b ≠ 0) (length : inputs.length < 32) (quiet : Quiet inputs)
    (pre_reset : pre.v_i_reset = 0) (pre_write : pre.v_i_wr = 0) :
    let current := YosysLean.run eval inputs (prepared a b s pre)
    current.v_o_busy = 1 ∧ current.v_o_valid = 0 ∧ current.v_o_err = 0 := by
  obtain ⟨seed, start⟩ := prepared_aligned a b s pre ready nonzero pre_reset pre_write
  have core := run_aligned inputs _ (magnitude a) (magnitude b) 0 start
    (magnitude_nonzero b nonzero) (by omega) quiet
  simp only [Nat.zero_add] at core
  exact ⟨by simpa [length] using core.phase.external_busy,
    by simpa [BitVec.ofBool, show inputs.length ≠ 32 by omega] using core.phase.valid,
    core.phase.error⟩

#check_claim signed_completed, preprocessing, sign_correction, signed_divide_by_zero,
  signed_in_progress, transaction_execution, processing_latency

end DividerSignedProofs
