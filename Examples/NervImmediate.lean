import YosysLean.BitVec
import Examples.NervArchitecture

/-! Architectural refinement for mixed register and immediate instructions. -/
namespace NervImmediate
open YosysLean.Bits v_NervAdd NervRegisters NervArchitecture
set_option maxRecDepth 4096
set_option maxHeartbeats 800000
set_option exponentiation.threshold 2048

def isAddi (w : BitVec 32) : Prop :=
  w.extractLsb' 0 7 = 0x13 ∧ w.extractLsb' 12 3 = 0

def immediate (w : BitVec 32) : BitVec 32 := (w.extractLsb' 20 12).signExtend 32

private theorem immediate_encoding (i : Inputs) (s : State) :
    Named.Signals.v_n212 i s = immediate i.v_imem_data := by
  unfold_nodes v_NervAdd.Named except []
  unfold immediate
  simp only [BitVec.append_eq]
  apply BitVec.eq_of_getLsbD_eq
  intro k hk
  have cases : k = 0 ∨ k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 4 ∨ k = 5 ∨ k = 6 ∨ k = 7 ∨
      k = 8 ∨ k = 9 ∨ k = 10 ∨ k = 11 ∨ k = 12 ∨ k = 13 ∨ k = 14 ∨ k = 15 ∨ k = 16 ∨
      k = 17 ∨ k = 18 ∨ k = 19 ∨ k = 20 ∨ k = 21 ∨ k = 22 ∨ k = 23 ∨ k = 24 ∨
      k = 25 ∨ k = 26 ∨ k = 27 ∨ k = 28 ∨ k = 29 ∨ k = 30 ∨ k = 31 := by omega
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
    rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
    rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  all_goals
    simp only [BitVec.getLsbD_append, BitVec.getLsbD_extractLsb',
      BitVec.getLsbD_signExtend, BitVec.msb_eq_getLsbD_last]
    simp

/-- The shared I-immediate decoder, independent of the instruction opcode. -/
theorem immediate_word (i : Inputs) (s : State) :
    Named.Signals.v_n212 i s = immediate i.v_imem_data := immediate_encoding i s


private theorem append_ne_zero {a : BitVec m} {b : BitVec n} (h : b ≠ 0) : a ++ b ≠ 0 := by
  intro eq
  have low := congrArg (fun x : BitVec (m + n) ↦ x.extractLsb' 0 n) eq
  simp only [BitVec.extractLsb'_append_eq_right] at low
  exact h low

private theorem low_enable (a : BitVec m) (b : BitVec n) (h : b ≠ 0) :
    BitVec.ofBool (a ++ b != (0 : BitVec (m + n))) = (1#1) := by
  exact congrArg BitVec.ofBool (bne_iff_ne.mpr (append_ne_zero (a := a) h))

theorem addi_decode (i : Inputs) (s : State)
    (hr : i.v_reset = 0) (hq : s.v_cpu_reset_q = 0)
    (hm : s.v_cpu_mem_rd_enable_q = 0) (ha : isAddi i.v_imem_data) :
    Named.Signals.v_cpu_next_rd i s =
      Named.Signals.v_cpu_rs1_value i s + immediate i.v_imem_data ∧
    Named.Signals.v_cpu_next_wr i s = 1 ∧
    Named.Signals.v_n880 i s = 0 ∧
    Named.Signals.v_cpu_mem_rd_enable i s = 0 ∧
    Named.Signals.v_cpu_dmem_valid i s = 0 ∧
    Named.Signals.v_n931 i s = s.v_cpu_pc + 4 := by
  rcases ha with ⟨hop, hf3⟩
  have h0 := NervSafety.known_slice hop (by decide : 0 + 2 ≤ 7)
  have h2 := NervSafety.known_slice hop (by decide : 2 + 2 ≤ 7)
  have h4 := NervSafety.known_slice hop (by decide : 4 + 1 ≤ 7)
  have h5 := NervSafety.known_slice hop (by decide : 5 + 2 ≤ 7)
  simp at h0 h2 h4 h5
  repeat' apply And.intro
  all_goals unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_cpu_rs1_value, v_NervAdd.Named.Signals.v_cpu_rs2_value,
     v_NervAdd.Named.Signals.v_n212]
  all_goals simp [hr, hq, hm, hop, hf3, h0, h2, h4, h5, immediate_encoding]
  all_goals simp (disch := decide) [HAppend.hAppend, -BitVec.append_eq, slice_low, slice_high]
  all_goals
    apply low_enable
    repeat' apply append_ne_zero
    decide

private theorem upper_slice (hi : BitVec 20) (lo : BitVec 12) (rest : BitVec 160) :
    (hi ++ (lo ++ rest)).extractLsb' 160 32 = hi ++ lo := by
  rw [BitVec.append_assoc']
  exact BitVec.extractLsb'_append_eq_left

/-- Upper-immediate constant, with its low twelve bits cleared. -/
def upper (w : BitVec 32) : BitVec 32 := w.extractLsb' 12 20 ++ (0#12)

theorem upper_decode (i : Inputs) (s : State)
    (hr : i.v_reset = 0) (hq : s.v_cpu_reset_q = 0)
    (hm : s.v_cpu_mem_rd_enable_q = 0)
    (ha : i.v_imem_data.extractLsb' 0 7 = 0x37 ∨ i.v_imem_data.extractLsb' 0 7 = 0x17) :
    Named.Signals.v_cpu_next_rd i s =
      (if i.v_imem_data.extractLsb' 0 7 = 0x37 then upper i.v_imem_data
       else upper i.v_imem_data + s.v_cpu_pc) ∧
    Named.Signals.v_cpu_next_wr i s = 1 ∧
    Named.Signals.v_n880 i s = 0 ∧
    Named.Signals.v_cpu_mem_rd_enable i s = 0 ∧
    Named.Signals.v_cpu_dmem_valid i s = 0 ∧
    Named.Signals.v_n931 i s = s.v_cpu_pc + 4 := by
  rcases ha with hop | hop
  all_goals
    have h0 := NervSafety.known_slice hop (by decide : 0 + 2 ≤ 7)
    have h2 := NervSafety.known_slice hop (by decide : 2 + 2 ≤ 7)
    have h4 := NervSafety.known_slice hop (by decide : 4 + 1 ≤ 7)
    have h5 := NervSafety.known_slice hop (by decide : 5 + 2 ≤ 7)
    simp at h0 h2 h4 h5
    repeat' apply And.intro
  all_goals unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_cpu_rs1_value, v_NervAdd.Named.Signals.v_cpu_rs2_value]
  all_goals simp [hr, hq, hm, hop, h0, h2, h4, h5, upper]
  all_goals simp (disch := decide) [HAppend.hAppend, -BitVec.append_eq, slice_low, slice_high]
  exact upper_slice _ _ _

end NervImmediate
