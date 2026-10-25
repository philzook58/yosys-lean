import YosysLean.Check
import Examples.Generated.ZipDiv4
import Examples.Generated.ZipDiv32
import Examples.Generated.ZipDivFormal
import Std.Tactic

/-! ZipCPU's unchanged iterative divider, with explicit transaction boundaries.
The exhaustive arithmetic theorem concerns the four-bit parameter instance.
The reset and pulse theorems concern the full 32-bit circuit and arbitrary states. -/
namespace DividerProofs

set_option maxRecDepth 16384
set_option maxHeartbeats 0

private theorem or_one (x : BitVec 1) : x ||| 1 = 1 := by revert x; decide
private theorem one_or (x : BitVec 1) : 1 ||| x = 1 := by revert x; decide

def input4 (a b : BitVec 4) (signed : Bool) (reset write : BitVec 1 := 0) :
    v_ZipDiv4.Inputs :=
  ⟨reset, write, BitVec.ofBool signed, a, b⟩

def input32 (a b : BitVec 32) (signed : Bool) (reset write : BitVec 1 := 0) :
    v_ZipDiv32.Inputs :=
  ⟨reset, write, BitVec.ofBool signed, a, b⟩

/-- Sample the first valid state, with a finite timeout. Inputs have no further requests. -/
def await4 (i : v_ZipDiv4.Inputs) : Nat → v_ZipDiv4.State →
    Option (Nat × v_ZipDiv4.Outputs × v_ZipDiv4.State)
  | 0, _ => none
  | fuel + 1, s =>
      let (o, next) := v_ZipDiv4.eval i s
      if o.v_o_valid == 1 then some (0, o, next)
      else (await4 i fuel next).map (fun (n, o, s) ↦ (n + 1, o, s))

/-- One idle request followed by at most six processing edges (signed adjustment included). -/
def transaction4 (a b : BitVec 4) (signed : Bool) :=
  let start := (v_ZipDiv4.eval (input4 a b signed 0 1) default).2
  await4 (input4 0 0 false) 7 start

/-- Division truncates toward zero in signed mode; overflow retains the four-bit result. -/
def quotient4 (a b : BitVec 4) (signed : Bool) : BitVec 4 :=
  if signed then a.sdiv b else a / b

/-- Includes completion, error classification, quotient, idle/valid exclusion, and pulse clearing.
No quotient is specified when the hardware raises its divide-by-zero error. -/
def correct4 (a b : BitVec 4) (signed : Bool) : Prop :=
  match transaction4 a b signed with
  | none => False
  | some (n, o, next) =>
      n ≤ 6 ∧ o.v_o_busy = 0 ∧ o.v_o_valid = 1 ∧
      o.v_o_err = BitVec.ofBool (b == 0) ∧
      (b ≠ 0 → o.v_o_quotient = quotient4 a b signed) ∧ next.v_o_valid = 0

instance (a b : BitVec 4) (signed : Bool) : Decidable (correct4 a b signed) := by
  unfold correct4
  split <;> infer_instance

-- Split exhaustive checking by dividend to bound kernel reduction memory.
private theorem dividend_0 : ∀ (b : BitVec 4) (signed : Bool), correct4 0 b signed := by
  decide

private theorem dividend_1 : ∀ (b : BitVec 4) (signed : Bool), correct4 1 b signed := by
  decide

private theorem dividend_2 : ∀ (b : BitVec 4) (signed : Bool), correct4 2 b signed := by
  decide

private theorem dividend_3 : ∀ (b : BitVec 4) (signed : Bool), correct4 3 b signed := by
  decide

private theorem dividend_4 : ∀ (b : BitVec 4) (signed : Bool), correct4 4 b signed := by
  decide

private theorem dividend_5 : ∀ (b : BitVec 4) (signed : Bool), correct4 5 b signed := by
  decide

private theorem dividend_6 : ∀ (b : BitVec 4) (signed : Bool), correct4 6 b signed := by
  decide

private theorem dividend_7 : ∀ (b : BitVec 4) (signed : Bool), correct4 7 b signed := by
  decide

private theorem dividend_8 : ∀ (b : BitVec 4) (signed : Bool), correct4 8 b signed := by
  decide

private theorem dividend_9 : ∀ (b : BitVec 4) (signed : Bool), correct4 9 b signed := by
  decide

private theorem dividend_10 : ∀ (b : BitVec 4) (signed : Bool), correct4 10 b signed := by
  decide

private theorem dividend_11 : ∀ (b : BitVec 4) (signed : Bool), correct4 11 b signed := by
  decide

private theorem dividend_12 : ∀ (b : BitVec 4) (signed : Bool), correct4 12 b signed := by
  decide

private theorem dividend_13 : ∀ (b : BitVec 4) (signed : Bool), correct4 13 b signed := by
  decide

private theorem dividend_14 : ∀ (b : BitVec 4) (signed : Bool), correct4 14 b signed := by
  decide

private theorem dividend_15 : ∀ (b : BitVec 4) (signed : Bool), correct4 15 b signed := by
  decide

/-- All 512 operand/mode combinations of the real four-bit RTL instance. -/
theorem arithmetic4 (a b : BitVec 4) (signed : Bool) : correct4 a b signed := by
  have choices : ∀ x : BitVec 4, x = 0 ∨ x = 1 ∨ x = 2 ∨ x = 3 ∨ x = 4 ∨ x = 5 ∨ x = 6 ∨ x = 7 ∨ x = 8 ∨ x = 9 ∨ x = 10 ∨ x = 11 ∨ x = 12 ∨ x = 13 ∨ x = 14 ∨ x = 15 := by decide
  rcases choices a with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact dividend_0 b signed
  · exact dividend_1 b signed
  · exact dividend_2 b signed
  · exact dividend_3 b signed
  · exact dividend_4 b signed
  · exact dividend_5 b signed
  · exact dividend_6 b signed
  · exact dividend_7 b signed
  · exact dividend_8 b signed
  · exact dividend_9 b signed
  · exact dividend_10 b signed
  · exact dividend_11 b signed
  · exact dividend_12 b signed
  · exact dividend_13 b signed
  · exact dividend_14 b signed
  · exact dividend_15 b signed

/-- A synchronous reset clears the full-width interface, regardless of prior internal state. -/
theorem reset32 (i : v_ZipDiv32.Inputs) (s : v_ZipDiv32.State) (h : i.v_i_reset = 1) :
    let next := (v_ZipDiv32.eval i s).2
    next.v_o_busy = 0 ∧ next.v_o_valid = 0 ∧ next.v_o_err = 0 ∧
      next.v_o_quotient = 0 ∧ next.v_r_busy = 0 ∧ next.v_r_sign = 0 := by
  simp [v_ZipDiv32.eval, h]
  intro hn
  exact (hn (one_or _)).elim

/-- Valid self-clears on the next edge, even for otherwise arbitrary states and inputs. -/
theorem valid_pulse32 (i : v_ZipDiv32.Inputs) (s : v_ZipDiv32.State)
    (h : s.v_o_valid = 1) : (v_ZipDiv32.eval i s).2.v_o_valid = 0 := by
  simp [v_ZipDiv32.eval, h]
  intro hn
  exact (hn (or_one _)).elim

/-- An idle request latches both operands and marks the full-width unit busy. -/
theorem accepts32 (a b : BitVec 32) (signed : Bool) (s : v_ZipDiv32.State)
    (idle : s.v_r_busy = 0) (ready : s.v_pre_sign = 0) :
    let next := (v_ZipDiv32.eval (input32 a b signed 0 1) s).2
    next.v_r_busy = 1 ∧ next.v_o_busy = 1 ∧ next.v_r_divisor = b ∧
      next.v_r_dividend = a.setWidth 63 := by
  simp [v_ZipDiv32.eval, input32, idle, ready]
  apply BitVec.eq_of_toNat_eq
  have high := BitVec.toNat_append (0#30) (0#1 ++ a)
  have low := BitVec.toNat_append (0#1) a
  have widened := BitVec.toNat_setWidth 63 a
  have bound := a.isLt
  simp at high low
  rw [high, low, widened]
  omega

/-- Adjacent valid samples must be separated by a low-valid sample. -/
def pulses32 : List v_ZipDiv32.Outputs → Prop
  | a :: b :: rest => (a.v_o_valid = 1 → b.v_o_valid = 0) ∧ pulses32 (b :: rest)
  | _ => True

/-- Valid pulse clearing lifts to every finite trace, with arbitrary requests and resets. -/
theorem trace_pulses32 (inputs : List v_ZipDiv32.Inputs) (s : v_ZipDiv32.State) :
    pulses32 (YosysLean.trace v_ZipDiv32.eval inputs s) := by
  induction inputs generalizing s with
  | nil => trivial
  | cons i rest ih =>
      cases rest with
      | nil => trivial
      | cons j rest =>
          change (s.v_o_valid = 1 → (v_ZipDiv32.eval i s).2.v_o_valid = 0) ∧ _
          exact ⟨valid_pulse32 i s, ih _⟩

#check_claim arithmetic4, reset32, valid_pulse32, accepts32, trace_pulses32

end DividerProofs
