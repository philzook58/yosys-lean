import YosysLean.Check
import Examples.Generated.IbexALU
import Lean.Elab.Tactic.Omega

namespace IbexALUProofs
open v_IbexALU
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

/-- Base ALU inputs: multiplier/divider bypass disabled. -/
def inputs (op : BitVec 7) (a b : BitVec 32) : Inputs :=
  ⟨op, a, b, 0, 0, 0⟩

private theorem result_slice (h : BitVec 31) (c : BitVec 1) (x y z : BitVec 32) :
    (h ++ (c ++ (x ++ (y ++ z)))).extractLsb' 32 32 = y := by
  exact (BitVec.extractLsb'_append_eq_of_add_le (by decide : 32 + 32 ≤ 97)).trans
    ((BitVec.extractLsb'_append_eq_of_add_le (by decide : 32 + 32 ≤ 96)).trans
      ((BitVec.extractLsb'_append_eq_of_add_le (by decide : 32 + 32 ≤ 64)).trans
        BitVec.extractLsb'_append_eq_left))

private theorem append_nat (a : BitVec m) (b : BitVec n) :
    (BitVec.append a b).toNat = a.toNat * 2^n + b.toNat := by
  have h := BitVec.toNat_append a b
  rw [← Nat.shiftLeft_add_eq_or_of_lt b.isLt, Nat.shiftLeft_eq] at h
  exact h

theorem add (a b : BitVec 32) :
    (eval (inputs 0 a b) {}).1.v_result_o = a + b := by
  simp [eval, inputs]
  refine (result_slice _ _ _ _ _).trans ?_
  have ha := append_nat a (1#1)
  have hb := append_nat b (0#1)
  have ha' := append_nat (0#1) (BitVec.append a (1#1))
  have hb' := append_nat (0#1) (BitVec.append b (0#1))
  simp only [BitVec.append_eq] at ha hb ha' hb'
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.extractLsb'_toNat, BitVec.toNat_add, ha, hb, ha', hb',
    BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow]
  omega

private theorem low_slice (h : BitVec 31) (c : BitVec 1) (x y z : BitVec 32) :
    (h ++ (c ++ (x ++ (y ++ z)))).extractLsb' 0 32 = z := by
  exact (BitVec.extractLsb'_append_eq_of_add_le (by decide : 0 + 32 ≤ 97)).trans
    ((BitVec.extractLsb'_append_eq_of_add_le (by decide : 0 + 32 ≤ 96)).trans
      ((BitVec.extractLsb'_append_eq_of_add_le (by decide : 0 + 32 ≤ 64)).trans
        BitVec.extractLsb'_append_eq_right))

theorem bit_xor (a b : BitVec 32) :
    (eval (inputs 2 a b) {}).1.v_result_o = a ^^^ b := by
  simp [eval, inputs]
  exact low_slice _ _ _ _ _

theorem bit_or (a b : BitVec 32) :
    (eval (inputs 3 a b) {}).1.v_result_o = a ||| b := by
  simp [eval, inputs]
  refine (low_slice _ _ _ _ _).trans ?_
  exact BitVec.extractLsb'_append_eq_left

theorem bit_and (a b : BitVec 32) :
    (eval (inputs 4 a b) {}).1.v_result_o = a &&& b := by
  simp [eval, inputs]
  refine (low_slice _ _ _ _ _).trans ?_
  exact BitVec.extractLsb'_append_eq_right

theorem sub (a b : BitVec 32) :
    (eval (inputs 1 a b) {}).1.v_result_o = a - b := by
  simp [eval, inputs]
  refine (result_slice _ _ _ _ _).trans ?_
  have hn : (BitVec.append (0#33) (~~~BitVec.append b (0#1))).extractLsb' 0 33 =
      ~~~BitVec.append b (0#1) := BitVec.extractLsb'_append_eq_right
  simp only [BitVec.append_eq] at hn
  rw [hn]
  have ha := append_nat a (1#1)
  have hb := append_nat b (0#1)
  have ha' := append_nat (0#1) (BitVec.append a (1#1))
  have hb' := append_nat (0#1) (~~~BitVec.append b (0#1))
  simp only [BitVec.append_eq] at ha hb ha' hb'
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.extractLsb'_toNat, BitVec.toNat_add, BitVec.toNat_sub,
    ha, hb, ha', hb', BitVec.toNat_not, BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow]
  omega

#check_claim add, sub, bit_xor, bit_or, bit_and
end IbexALUProofs
