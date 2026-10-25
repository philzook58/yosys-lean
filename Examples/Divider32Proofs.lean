import YosysLean.Check
import Examples.DividerArithmetic
import Examples.DividerProofs

/-! Full-width unsigned arithmetic and completion for the unchanged ZipCPU divider. -/
namespace Divider32Proofs
open v_ZipDiv32
set_option maxRecDepth 16384
set_option maxHeartbeats 400000

def difference (s : State) : BitVec 33 :=
  (s.v_r_dividend.extractLsb' 31 32).setWidth 33 - s.v_r_divisor.setWidth 33

private theorem borrow (a b : BitVec 32) :
    ((a.setWidth 33 - b.setWidth 33).extractLsb' 32 1 = 1) ↔ a.toNat < b.toNat := by
  have ha := a.isLt
  have hb := b.isLt
  rw [BitVec.toNat_eq]
  simp [BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow]
  omega

private theorem high_word (d : BitVec 63) :
    (d.extractLsb' 31 32).toNat = d.toNat / 2^31 := by
  have bound := d.isLt
  simp only [BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow]
  omega

theorem decision (s : State) :
    (difference s).extractLsb' 32 1 = 1 ↔
      s.v_r_dividend.toNat < s.v_r_divisor.toNat * 2^31 := by
  rw [difference, borrow, high_word]
  exact Nat.div_lt_iff_lt_mul (by decide)

private theorem append_nat (a : BitVec n) (b : BitVec m) :
    (a ++ b).toNat = a.toNat * 2^m + b.toNat := by
  rw [BitVec.toNat_append, ← Nat.shiftLeft_add_eq_or_of_lt b.isLt, Nat.shiftLeft_eq]

/-- One active unsigned data update, expressed without the generated mux graph. -/
theorem dividend_step (i : Inputs) (s : State)
    (busy : s.v_r_busy = 1) (presign : s.v_pre_sign = 0) :
    (eval i s).2.v_r_dividend.toNat =
      if s.v_r_dividend.toNat < s.v_r_divisor.toNat * 2^31
      then (2 * s.v_r_dividend.toNat) % 2^63
      else (2 * (s.v_r_dividend.toNat - s.v_r_divisor.toNat * 2^31)) % 2^63 := by
  have d_bound := s.v_r_dividend.isLt
  have b_bound := s.v_r_divisor.isLt
  by_cases h : (difference s).extractLsb' 32 1 = 1
  · have less := (decision s).1 h
    dsimp only [difference] at h
    simp only [eval, busy, presign, h]
    change ((s.v_r_dividend.extractLsb' 32 30) ++
      ((s.v_r_dividend.extractLsb' 31 1) ++
        ((s.v_r_dividend.extractLsb' 0 31) ++ (0 : BitVec 1)))).toNat = _
    simp only [less, ↓reduceIte, append_nat, BitVec.extractLsb'_toNat,
      Nat.shiftRight_eq_div_pow, Nat.pow_zero, Nat.div_one]
    change (s.v_r_dividend.toNat / 2^32 % 2^30) * 2^33 +
      ((s.v_r_dividend.toNat / 2^31 % 2) * 2^32 +
        ((s.v_r_dividend.toNat % 2^31) * 2 + 0)) = _
    omega
  · have ge : s.v_r_divisor.toNat * 2^31 ≤ s.v_r_dividend.toNat := by
      exact Nat.le_of_not_gt (fun less ↦ h ((decision s).2 less))
    have subtract : (difference s).toNat =
        s.v_r_dividend.toNat / 2^31 - s.v_r_divisor.toNat := by
      unfold difference
      rw [BitVec.toNat_sub_of_le]
      · simp only [BitVec.toNat_setWidth, high_word]
        omega
      · simp only [BitVec.le_def, BitVec.toNat_setWidth, high_word]
        omega
    have no_borrow : ((difference s).extractLsb' 32 1 == 1) = false := by
      apply Bool.eq_false_iff.mpr
      intro eq
      exact h (beq_iff_eq.mp eq)
    dsimp only [difference] at no_borrow
    simp only [eval, busy, presign, no_borrow]
    change ((difference s).extractLsb' 1 30 ++
      ((difference s).extractLsb' 0 1 ++
        (s.v_r_dividend.extractLsb' 0 31 ++ (0 : BitVec 1)))).toNat = _
    simp only [show ¬s.v_r_dividend.toNat < s.v_r_divisor.toNat * 2^31 by omega,
      ↓reduceIte, append_nat, BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow,
      subtract, Nat.pow_zero, Nat.div_one]
    change (((s.v_r_dividend.toNat / 2^31 - s.v_r_divisor.toNat) / 2 % 2^30) * 2^33 +
      (((s.v_r_dividend.toNat / 2^31 - s.v_r_divisor.toNat) % 2) * 2^32 +
        ((s.v_r_dividend.toNat % 2^31) * 2 + 0))) = _
    omega

theorem quotient_step (i : Inputs) (s : State)
    (reset : i.v_i_reset = 0) (busy : s.v_r_busy = 1) :
    (eval i s).2.v_o_quotient.toNat =
      if s.v_r_dividend.toNat < s.v_r_divisor.toNat * 2^31
      then (2*s.v_o_quotient.toNat) % 2^32
      else (2*s.v_o_quotient.toNat+1) % 2^32 := by
  have bound := s.v_o_quotient.isLt
  by_cases h : (difference s).extractLsb' 32 1 = 1
  · have less := (decision s).1 h
    dsimp only [difference] at h
    simp only [eval, reset, busy, h]
    change ((s.v_o_quotient.extractLsb' 0 31) ++ (0 : BitVec 1)).toNat = _
    simp only [less, ↓reduceIte, append_nat, BitVec.extractLsb'_toNat,
      Nat.shiftRight_eq_div_pow, Nat.pow_zero, Nat.div_one]
    change s.v_o_quotient.toNat % 2^31 * 2 + 0 = _
    omega
  · have ge : ¬s.v_r_dividend.toNat < s.v_r_divisor.toNat * 2^31 :=
      fun less ↦ h ((decision s).2 less)
    have no_borrow : ((difference s).extractLsb' 32 1 == 1) = false := by
      apply Bool.eq_false_iff.mpr
      intro eq
      exact h (beq_iff_eq.mp eq)
    dsimp only [difference] at no_borrow
    simp only [eval, reset, busy, no_borrow]
    change ((s.v_o_quotient.extractLsb' 0 31) ++ (1 : BitVec 1)).toNat = _
    simp only [ge, ↓reduceIte, append_nat, BitVec.extractLsb'_toNat,
      Nat.shiftRight_eq_div_pow, Nat.pow_zero, Nat.div_one]
    change s.v_o_quotient.toNat % 2^31 * 2 + 1 = _
    omega

/-- Control state after n nonzero-divisor magnitude decisions; negative results need correction. -/
structure Phase (n : Nat) (b : BitVec 32) (s : State) (negative : Bool := false) : Prop where
  bit : s.v_r_bit = BitVec.ofNat 5 n
  presign : s.v_pre_sign = 0
  last : s.v_last_bit = BitVec.ofBool (n == 31)
  divisor : s.v_r_divisor = b
  sign : s.v_r_sign = BitVec.ofBool negative
  zero : s.v_zero_divisor = 0
  busy : s.v_r_busy = if n < 32 then 1 else 0
  external_busy : s.v_o_busy = if n < 32 ∨ negative = true then 1 else 0
  valid : s.v_o_valid = BitVec.ofBool ((n == 32) && !negative)
  error : s.v_o_err = 0

private theorem counter_increment (n : Nat) :
    BitVec.ofNat 5 n + 1 = BitVec.ofNat 5 (n+1) := by
  apply BitVec.eq_of_toNat_eq
  simp [BitVec.toNat_add]

theorem phase_step (i : Inputs) (s : State) (n : Nat) (b : BitVec 32)
    {negative : Bool} (h : Phase n b s negative) (hn : n < 32)
    (reset : i.v_i_reset = 0) (write : i.v_i_wr = 0) :
    Phase (n+1) b (eval i s).2 negative := by
  have busy : s.v_r_busy = 1 := by simpa [hn] using h.busy
  have not_done : s.v_o_valid = 0 := by
    simpa [BitVec.ofBool, show n ≠ 32 by omega] using h.valid
  have final : (n+1 < 32) ↔ n ≠ 31 := by omega
  have done : (n+1 == 32) = (n == 31) := by
    apply Bool.eq_iff_iff.mpr
    simp only [beq_iff_eq]
    omega
  have counter : BitVec.ofNat 5 n = 30#5 ↔ n = 30 := by
    rw [BitVec.toNat_eq]
    change n % 32 = 30 ↔ n = 30
    omega
  cases negative <;> by_cases last : n = 31 <;>
    constructor <;>
    simp [eval, reset, write, busy, not_done, h.presign, h.sign, h.zero,
      h.bit, h.last, h.divisor, h.external_busy, hn,
      final, done, BitVec.ofBool, last, counter]
  all_goals exact counter_increment n

/-- Alignment of the physical registers with one mathematical divide step count.
The final workspace may wrap. Seed quotient bits from preprocessing shift out after 32 steps. -/
structure Aligned (n : Nat) (b : BitVec 32) (w : DividerArithmetic.Work) (s : State)
    (negative : Bool := false) (seed : Nat := 0) : Prop where
  phase : Phase n b s negative
  dividend : s.v_r_dividend.toNat = w.dividend % 2^63
  quotient : s.v_o_quotient.toNat = (w.quotient + seed * 2^n) % 2^32

theorem aligned_step (i : Inputs) (s : State) (a n : Nat) (b : BitVec 32)
    (w : DividerArithmetic.Work) {negative : Bool} {seed : Nat}
    (aligned : Aligned n b w s negative seed)
    (inv : DividerArithmetic.Invariant a b.toNat n w) (hn : n < 32)
    (reset : i.v_i_reset = 0) (write : i.v_i_wr = 0) :
    Aligned (n+1) b (DividerArithmetic.step b.toNat w) (eval i s).2 negative seed := by
  have busy : s.v_r_busy = 1 := by simpa [hn] using aligned.phase.busy
  have d_bound : w.dividend < 2^63 :=
    Nat.lt_of_lt_of_le inv.2.2.2 (Nat.pow_le_pow_right (by decide) (by omega))
  have dividend : s.v_r_dividend.toNat = w.dividend := by
    simpa only [Nat.mod_eq_of_lt d_bound] using aligned.dividend
  refine ⟨phase_step i s n b aligned.phase hn reset write, ?_, ?_⟩
  · rw [dividend_step i s busy aligned.phase.presign, aligned.phase.divisor, dividend]
    by_cases ge : b.toNat * 2^31 ≤ w.dividend
    · simp [DividerArithmetic.step, ge, Nat.not_lt_of_ge ge]
    · simp [DividerArithmetic.step, ge, Nat.lt_of_not_ge ge]
  · rw [quotient_step i s reset busy, aligned.phase.divisor, dividend, aligned.quotient]
    have power : seed * 2^(n+1) = 2*(seed*2^n) := by rw [Nat.pow_succ]; ac_rfl
    rw [power]
    by_cases ge : b.toNat * 2^31 ≤ w.dividend
    · simp only [DividerArithmetic.step, ge, Nat.not_lt_of_ge ge, ↓reduceIte]
      omega
    · simp only [DividerArithmetic.step, ge, Nat.lt_of_not_ge ge, ↓reduceIte]
      omega

/-- The environment may change operand buses and signed mode after acceptance.
Only reset and new requests must remain deasserted during this transaction. -/
def Quiet (inputs : List Inputs) : Prop :=
  ∀ i ∈ inputs, i.v_i_reset = 0 ∧ i.v_i_wr = 0

theorem run_aligned (inputs : List Inputs) (s : State) (a b : BitVec 32) (n : Nat)
    {negative : Bool} {seed : Nat}
    (aligned : Aligned n b (DividerArithmetic.work a.toNat b.toNat n) s negative seed)
    (nonzero : b ≠ 0) (bound : n + inputs.length ≤ 32) (quiet : Quiet inputs) :
    Aligned (n + inputs.length) b (DividerArithmetic.work a.toNat b.toNat (n + inputs.length))
      (YosysLean.run eval inputs s) negative seed := by
  have positive : 0 < b.toNat := by
    have ne : b.toNat ≠ 0 := fun eq ↦ nonzero (BitVec.eq_of_toNat_eq eq)
    omega
  induction inputs generalizing n s with
  | nil => simpa [YosysLean.run] using aligned
  | cons i rest ih =>
      simp only [List.length_cons] at bound
      have first := quiet i (by simp)
      have next : Aligned (n+1) b (DividerArithmetic.work a.toNat b.toNat (n+1))
          (eval i s).2 negative seed :=
        aligned_step i s a.toNat n b _ aligned
          (DividerArithmetic.invariant _ _ _ a.isLt positive) (by omega) first.1 first.2
      have tail : Quiet rest := fun j hj ↦ quiet j (by simp [hj])
      have result := ih (eval i s).2 (n+1) next (by omega) tail
      simpa only [YosysLean.run, List.length_cons, Nat.add_right_comm, Nat.add_assoc] using result

/-- Idle unsigned acceptance does not require unspecified data registers to be zero. -/
def Ready (s : State) : Prop :=
  s.v_r_busy = 0 ∧ s.v_pre_sign = 0 ∧ s.v_r_sign = 0 ∧ s.v_o_valid = 0

theorem initial_ready (s : State) (h : initial s) : Ready s := by
  rcases h with ⟨_, _, pre, _, _, _, sign, _, busy, _, _, _, valid, _, _⟩
  exact ⟨(BitVec.and_allOnes).symm.trans busy,
    (BitVec.and_allOnes).symm.trans pre,
    (BitVec.and_allOnes).symm.trans sign,
    (BitVec.and_allOnes).symm.trans valid⟩

theorem accepts (a b : BitVec 32) (s : State) (ready : Ready s) (nonzero : b ≠ 0) :
    Aligned 0 b ⟨a.toNat, 0⟩ (eval (DividerProofs.input32 a b false 0 1) s).2 := by
  rcases ready with ⟨busy, pre, sign, valid⟩
  have ne : (b != 0#32) = true := by
    exact bne_iff_ne.mpr nonzero
  refine ⟨?_, ?_, ?_⟩
  · constructor <;> simp [eval, DividerProofs.input32, busy, pre, sign, valid, ne]
  · have accepted := (DividerProofs.accepts32 a b false s busy pre).2.2.2
    rw [accepted]
    simp [BitVec.toNat_setWidth]
  · simp [eval, DividerProofs.input32, busy, sign]

/-- Physical output observation in the pre-edge sampling convention of the exporter. -/
theorem output_equation (i : Inputs) (s : State) :
    (eval i s).1.v_o_quotient = s.v_o_quotient ∧
    (eval i s).1.v_o_busy = s.v_o_busy ∧
    (eval i s).1.v_o_valid = s.v_o_valid ∧
    (eval i s).1.v_o_err = s.v_o_err := by
  exact ⟨rfl, rfl, rfl, rfl⟩

/-- Any quotient bits accumulated before the 32 decisions have shifted out by completion. -/
theorem aligned_result (a : Nat) (b : BitVec 32) (w : DividerArithmetic.Work) (s : State)
    {negative : Bool} {seed : Nat} (aligned : Aligned 32 b w s negative seed)
    (inv : DividerArithmetic.Invariant a b.toNat 32 w) :
    s.v_o_quotient.toNat = a / b.toNat := by
  have quotient := aligned.quotient
  rw [Nat.add_mul_mod_self_right, Nat.mod_eq_of_lt inv.2.2.1] at quotient
  exact quotient.trans (DividerArithmetic.quotient_of_invariant a b.toNat w inv)

/-- One accepted unsigned request and 32 quiet processing edges return the exact quotient.
Operand buses and signed mode may change arbitrarily after the request. -/
theorem unsigned_completed (a b : BitVec 32) (s : State) (inputs : List Inputs)
    (ready : Ready s) (nonzero : b ≠ 0) (length : inputs.length = 32) (quiet : Quiet inputs) :
    let done := YosysLean.run eval inputs (eval (DividerProofs.input32 a b false 0 1) s).2
    done.v_o_quotient.toNat = a.toNat / b.toNat ∧
      done.v_o_busy = 0 ∧ done.v_o_valid = 1 ∧ done.v_o_err = 0 := by
  have aligned := run_aligned inputs _ a b 0 (accepts a b s ready nonzero)
    nonzero (by omega) quiet
  simp only [Nat.zero_add, length] at aligned
  have positive : 0 < b.toNat := by
    have ne : b.toNat ≠ 0 := fun eq ↦ nonzero (BitVec.eq_of_toNat_eq eq)
    omega
  exact ⟨aligned_result a.toNat b _ _ aligned
      (DividerArithmetic.invariant _ _ _ a.isLt positive),
    by simpa using aligned.phase.external_busy,
    by simpa using aligned.phase.valid, aligned.phase.error⟩

/-- No early completion: every strict processing prefix still reports busy, with valid low. -/
theorem unsigned_in_progress (a b : BitVec 32) (s : State) (inputs : List Inputs)
    (ready : Ready s) (nonzero : b ≠ 0) (length : inputs.length < 32) (quiet : Quiet inputs) :
    let current := YosysLean.run eval inputs (eval (DividerProofs.input32 a b false 0 1) s).2
    current.v_o_busy = 1 ∧ current.v_o_valid = 0 ∧ current.v_o_err = 0 := by
  have aligned := run_aligned inputs _ a b 0 (accepts a b s ready nonzero)
    nonzero (by omega) quiet
  simp only [Nat.zero_add] at aligned
  exact ⟨by simpa [length] using aligned.phase.external_busy,
    by simpa [BitVec.ofBool, show inputs.length ≠ 32 by omega] using aligned.phase.valid,
    aligned.phase.error⟩

/-- The completed quotient and handshake are the actual exported output observations. -/
theorem unsigned_outputs (a b : BitVec 32) (s : State) (inputs : List Inputs) (sample : Inputs)
    (ready : Ready s) (nonzero : b ≠ 0) (length : inputs.length = 32) (quiet : Quiet inputs) :
    let done := YosysLean.run eval inputs (eval (DividerProofs.input32 a b false 0 1) s).2
    let output := (eval sample done).1
    output.v_o_quotient = a / b ∧
      output.v_o_busy = 0 ∧ output.v_o_valid = 1 ∧ output.v_o_err = 0 := by
  have result := unsigned_completed a b s inputs ready nonzero length quiet
  refine ⟨?_, result.2⟩
  rw [(output_equation sample _).1]
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_udiv]
  exact result.1

/-- A zero denominator completes with error after one edge; its quotient is unspecified. -/
theorem divide_by_zero (a : BitVec 32) (s : State) (i : Inputs) (ready : Ready s)
    (reset : i.v_i_reset = 0) (write : i.v_i_wr = 0) :
    let done := (eval i (eval (DividerProofs.input32 a 0 false 0 1) s).2).2
    done.v_o_busy = 0 ∧ done.v_o_valid = 1 ∧ done.v_o_err = 1 := by
  rcases ready with ⟨busy, pre, sign, valid⟩
  simp [eval, DividerProofs.input32, reset, write, busy, pre, sign, valid]

/-- Reset aborts any phase and returns a state from which a new request can be accepted. -/
theorem reset_ready (i : Inputs) (s : State) (reset : i.v_i_reset = 1) :
    Ready (eval i s).2 := by
  have one_or (x : BitVec 1) : 1#1 ||| x = 1#1 := by revert x; decide
  simp [Ready, eval, reset, one_or]

#check_claim unsigned_completed, unsigned_outputs, unsigned_in_progress, divide_by_zero,
  reset_ready, initial_ready

end Divider32Proofs
