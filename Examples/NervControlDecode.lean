import YosysLean.BitVec
import Examples.NervArithmetic

/-! RISC-V control-flow decoding. Data operands and branch decisions remain symbolic. -/
namespace NervControlDecode
open YosysLean.Bits v_NervAdd NervRegisters NervArchitecture
set_option maxRecDepth 4096
set_option maxHeartbeats 800000
set_option exponentiation.threshold 2048

def displacement (branch : Bool) (w : BitVec 32) : BitVec 32 :=
  if branch then
    (w.extractLsb' 31 1 ++ (w.extractLsb' 7 1 ++
      (w.extractLsb' 25 6 ++ (w.extractLsb' 8 4 ++ (0#1))))).signExtend 32
  else
    (w.extractLsb' 31 1 ++ (w.extractLsb' 12 8 ++
      (w.extractLsb' 20 1 ++ (w.extractLsb' 21 10 ++ (0#1))))).signExtend 32

private def rawDisplacement (branch : Bool) (i : Inputs) (s : State) : BitVec 32 :=
  if branch then Named.Signals.v_n774 i s else Named.Signals.v_n718 i s

private theorem displacement_encoding (branch : Bool) (i : Inputs) (s : State) :
    rawDisplacement branch i s = displacement branch i.v_imem_data := by
  cases branch
  all_goals
    simp only [rawDisplacement, displacement, Bool.false_eq_true, ↓reduceIte]
    unfold_nodes v_NervAdd.Named except []
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

def aligned (pc : BitVec 32) : Prop := pc.extractLsb' 0 2 = 0

def isJal (w : BitVec 32) : Prop := w.extractLsb' 0 7 = 0x6f

def isJalr (w : BitVec 32) : Prop :=
  w.extractLsb' 0 7 = 0x67 ∧ w.extractLsb' 12 3 = 0

/-- JALR clears the low bit after adding the sign-extended immediate. -/
def clearLowBit (w : BitVec 32) : BitVec 32 := w &&& ~~~(1#32)

private theorem clear_low_bit (w : BitVec 32) :
    w.extractLsb' 1 31 ++ (0#1) = clearLowBit w := by
  unfold clearLowBit
  apply BitVec.eq_of_getLsbD_eq
  intro k hk
  simp only [BitVec.getLsbD_append, BitVec.getLsbD_extractLsb', BitVec.getLsbD_and,
    BitVec.getLsbD_not, BitVec.getLsbD_one]
  cases k with
  | zero => simp
  | succ k => simp [show k < 31 by omega, show k + 1 < 32 by omega, Nat.add_comm]

def branchFunction (f : BitVec 3) : Prop := f = 0 ∨ f = 1 ∨ f = 4 ∨ f = 5 ∨ f = 6 ∨ f = 7

def isBranch (w : BitVec 32) : Prop :=
  w.extractLsb' 0 7 = 0x63 ∧ branchFunction (w.extractLsb' 12 3)

/-- BEQ, BNE, BLT, BGE, BLTU, and BGEU, with signed and unsigned comparisons distinct. -/
def taken (f : BitVec 3) (a b : BitVec 32) : Bool :=
  match f.toNat with
  | 0 => a == b
  | 1 => a != b
  | 4 => a.slt b
  | 5 => b.sle a
  | 6 => a.ult b
  | 7 => b.ule a
  | _ => false

/-- Independent control-flow target; arithmetic opcodes advance by four. -/
def target (w : BitVec 32) (a : Architecture) : BitVec 32 :=
  if w.extractLsb' 0 7 = 0x6f then a.pc + displacement false w
  else if w.extractLsb' 0 7 = 0x67 then
    clearLowBit (a.regs (w.extractLsb' 15 5) + NervImmediate.immediate w)
  else if w.extractLsb' 0 7 = 0x63 ∧
      taken (w.extractLsb' 12 3) (a.regs (w.extractLsb' 15 5)) (a.regs (w.extractLsb' 20 5)) then
    a.pc + displacement true w
  else a.pc + 4


private theorem shifted_slice (x : BitVec n) (shift width : Nat) :
    (x >>> shift).extractLsb' 0 width = x.extractLsb' shift width := by
  apply BitVec.eq_of_getLsbD_eq
  intro k hk
  simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_ushiftRight, Nat.zero_add]

theorem jal_decode (i : Inputs) (s : State)
    (hr : i.v_reset = 0) (hq : s.v_cpu_reset_q = 0) (hm : s.v_cpu_mem_rd_enable_q = 0)
    (ha : isJal i.v_imem_data) (alignment : aligned (target i.v_imem_data (project s))) :
    Named.Signals.v_cpu_next_rd i s = s.v_cpu_pc + 4 ∧
    Named.Signals.v_cpu_next_wr i s = 1 ∧ Named.Signals.v_n880 i s = 0 ∧
    Named.Signals.v_cpu_mem_rd_enable i s = 0 ∧
    Named.Signals.v_n931 i s = target i.v_imem_data (project s) := by
  change i.v_imem_data.extractLsb' 0 7 = 0x6f at ha
  have h0 := NervSafety.known_slice ha (by decide : 0 + 2 ≤ 7)
  have h2 := NervSafety.known_slice ha (by decide : 2 + 2 ≤ 7)
  have h4 := NervSafety.known_slice ha (by decide : 4 + 1 ≤ 7)
  have h5 := NervSafety.known_slice ha (by decide : 5 + 2 ≤ 7)
  have imm : Named.Signals.v_n718 i s = displacement false i.v_imem_data :=
    displacement_encoding false i s
  simp at h0 h2 h4 h5
  have low : (s.v_cpu_pc + displacement false i.v_imem_data).extractLsb' 0 2 = 0 := by
    simpa [aligned, target, ha, project] using alignment
  repeat' apply And.intro
  all_goals unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_cpu_rs1_value, v_NervAdd.Named.Signals.v_cpu_rs2_value,
     v_NervAdd.Named.Signals.v_n718]
  all_goals simp [hr, hq, hm, ha, h0, h2, h4, h5, imm, low, target, project]
  all_goals simp (disch := decide)
    [HAppend.hAppend, -BitVec.append_eq, shifted_slice, slice_low, slice_high]

private theorem flag_one (b : Bool) : BitVec.ofBool b = (1#1) ↔ b = true := by
  cases b <;> decide

private theorem branch_target (i : Inputs) (s : State) (ha : isBranch i.v_imem_data) :
    Named.Signals.v_n799 i s = target i.v_imem_data (project s) := by
  rcases ha with ⟨hop, functions⟩
  rcases functions with hf | hf | hf | hf | hf | hf
  all_goals
    have imm : Named.Signals.v_n774 i s = displacement true i.v_imem_data :=
      displacement_encoding true i s
    unfold_nodes v_NervAdd.Named except
      [v_NervAdd.Named.Signals.v_cpu_rs1_value, v_NervAdd.Named.Signals.v_cpu_rs2_value,
       v_NervAdd.Named.Signals.v_n774]
    simp [hop, hf, imm, target, taken, project, ←rs1_read, ←rs2_read, flag_one]
    simp (disch := decide)
      [HAppend.hAppend, -BitVec.append_eq, shifted_slice, slice_low, slice_high]

theorem branch_decode (i : Inputs) (s : State)
    (hr : i.v_reset = 0) (hq : s.v_cpu_reset_q = 0) (hm : s.v_cpu_mem_rd_enable_q = 0)
    (ha : isBranch i.v_imem_data) (alignment : aligned (target i.v_imem_data (project s))) :
    Named.Signals.v_cpu_next_wr i s = 0 ∧ Named.Signals.v_n880 i s = 0 ∧
    Named.Signals.v_cpu_mem_rd_enable i s = 0 ∧
    Named.Signals.v_n931 i s = target i.v_imem_data (project s) := by
  have expected := branch_target i s ha
  have low : (target i.v_imem_data (project s)).extractLsb' 0 2 = 0 := alignment
  rcases ha with ⟨hop, functions⟩
  rcases functions with hf | hf | hf | hf | hf | hf
  all_goals
    have h0 := NervSafety.known_slice hop (by decide : 0 + 2 ≤ 7)
    have h2 := NervSafety.known_slice hop (by decide : 2 + 2 ≤ 7)
    have h4 := NervSafety.known_slice hop (by decide : 4 + 1 ≤ 7)
    have h5 := NervSafety.known_slice hop (by decide : 5 + 2 ≤ 7)
    simp at h0 h2 h4 h5
    repeat' apply And.intro
  all_goals unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_cpu_rs1_value, v_NervAdd.Named.Signals.v_cpu_rs2_value,
     v_NervAdd.Named.Signals.v_n799]
  all_goals simp [hr, hq, hm, hop, hf, h0, h2, h4, h5, expected, low]
  all_goals simp (disch := decide)
    [HAppend.hAppend, -BitVec.append_eq, slice_low, slice_high]

private theorem jalr_target (i : Inputs) (s : State) (ha : isJalr i.v_imem_data) :
    Named.Signals.v_n731 i s = target i.v_imem_data (project s) := by
  rcases ha with ⟨hop, hf⟩
  have imm := NervImmediate.immediate_word i s
  unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_cpu_rs1_value, v_NervAdd.Named.Signals.v_cpu_rs2_value,
     v_NervAdd.Named.Signals.v_n212]
  simp [hop, hf, imm, target, project, ←rs1_read]
  exact clear_low_bit _

theorem jalr_decode (i : Inputs) (s : State)
    (hr : i.v_reset = 0) (hq : s.v_cpu_reset_q = 0) (hm : s.v_cpu_mem_rd_enable_q = 0)
    (ha : isJalr i.v_imem_data) (alignment : aligned (target i.v_imem_data (project s))) :
    Named.Signals.v_cpu_next_rd i s = s.v_cpu_pc + 4 ∧
    Named.Signals.v_cpu_next_wr i s = 1 ∧ Named.Signals.v_n880 i s = 0 ∧
    Named.Signals.v_cpu_mem_rd_enable i s = 0 ∧
    Named.Signals.v_n931 i s = target i.v_imem_data (project s) := by
  have expected := jalr_target i s ha
  have low : (target i.v_imem_data (project s)).extractLsb' 0 2 = 0 := alignment
  rcases ha with ⟨hop, hf⟩
  have h0 := NervSafety.known_slice hop (by decide : 0 + 2 ≤ 7)
  have h2 := NervSafety.known_slice hop (by decide : 2 + 2 ≤ 7)
  have h4 := NervSafety.known_slice hop (by decide : 4 + 1 ≤ 7)
  have h5 := NervSafety.known_slice hop (by decide : 5 + 2 ≤ 7)
  simp at h0 h2 h4 h5
  repeat' apply And.intro
  all_goals unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_cpu_rs1_value, v_NervAdd.Named.Signals.v_cpu_rs2_value,
     v_NervAdd.Named.Signals.v_n731]
  all_goals simp [hr, hq, hm, hop, hf, h0, h2, h4, h5, expected, low]
  all_goals simp (disch := decide)
    [HAppend.hAppend, -BitVec.append_eq, shifted_slice, slice_low, slice_high]

private theorem packed_nonzero (x : BitVec 2) (h : x ≠ 0) :
    BitVec.ofBool ((0#30) ++ x != (0#32)) = (1#1) := by
  have nz : (0#30) ++ x ≠ 0 := by
    intro zero
    have low := congrArg (fun y : BitVec 32 ↦ y.extractLsb' 0 2) zero
    simp only [BitVec.extractLsb'_append_eq_right] at low
    exact h low
  exact congrArg BitVec.ofBool (bne_iff_ne.mpr nz)

/-- Legal control-flow encodings raise NERV's illegal/trap flag for a misaligned selected PC. -/
theorem misaligned_flag (i : Inputs) (s : State)
    (hr : i.v_reset = 0) (hq : s.v_cpu_reset_q = 0) (hm : s.v_cpu_mem_rd_enable_q = 0)
    (ha : isJal i.v_imem_data ∨ isJalr i.v_imem_data ∨ isBranch i.v_imem_data)
    (bad : ¬aligned (target i.v_imem_data (project s))) : Named.Signals.v_n880 i s = 1 := by
  have raised := packed_nonzero ((target i.v_imem_data (project s)).extractLsb' 0 2) bad
  have selected :
      (i.v_imem_data.extractLsb' 0 7 = 0x6f ∧ Named.Signals.v_n723 i s = 1) ∨
      (i.v_imem_data.extractLsb' 0 7 = 0x67 ∧ Named.Signals.v_n734 i s = 1) ∨
      (i.v_imem_data.extractLsb' 0 7 = 0x63 ∧ Named.Signals.v_n802 i s = 1) := by
    rcases ha with jal | jalr | branch
    · refine Or.inl ⟨jal, ?_⟩
      have imm : Named.Signals.v_n718 i s = displacement false i.v_imem_data :=
        displacement_encoding false i s
      unfold_nodes v_NervAdd.Named except [v_NervAdd.Named.Signals.v_n718]
      have hop : i.v_imem_data.extractLsb' 0 7 = 0x6f := jal
      simpa [target, hop, project, imm] using raised
    · refine Or.inr (Or.inl ⟨jalr.1, ?_⟩)
      have expected := jalr_target i s jalr
      unfold_nodes v_NervAdd.Named except [v_NervAdd.Named.Signals.v_n731]
      rw [expected]
      exact raised
    · refine Or.inr (Or.inr ⟨branch.1, ?_⟩)
      have expected := branch_target i s branch
      unfold_nodes v_NervAdd.Named except [v_NervAdd.Named.Signals.v_n799]
      rw [expected]
      exact raised
  rcases selected with ⟨hop, fire⟩ | ⟨hop, fire⟩ | ⟨hop, fire⟩
  all_goals
    unfold_nodes v_NervAdd.Named except
      [v_NervAdd.Named.Signals.v_cpu_rs1_value, v_NervAdd.Named.Signals.v_cpu_rs2_value,
       v_NervAdd.Named.Signals.v_n723, v_NervAdd.Named.Signals.v_n734,
       v_NervAdd.Named.Signals.v_n802]
    simp [hr, hq, hm, hop, fire]
    simp (disch := decide) [HAppend.hAppend, -BitVec.append_eq, slice_low, slice_high]

/-- On an executing edge, that flag sets the physical trap register. No precise-trap ISA claim. -/
theorem misaligned_traps (i : Inputs) (s : State) (ready : running s)
    (hr : i.v_reset = 0) (hs : i.v_stall = 0)
    (ha : isJal i.v_imem_data ∨ isJalr i.v_imem_data ∨ isBranch i.v_imem_data)
    (bad : ¬aligned (target i.v_imem_data (project s))) : (eval i s).2.v_cpu_trap = 1 := by
  have hill := misaligned_flag i s hr ready.1 ready.2.2 ha bad
  rcases ready with ⟨hq, ht, hm⟩
  have hg : Named.Signals.v_n478 i s = 1 := by
    simp [NervSafety.execution_gate, hr, hq, hs, ht]
  change (Named.eval i s).2.v_cpu_trap = 1
  dsimp only [Named.eval]
  unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_n478, v_NervAdd.Named.Signals.v_n880]
  simp [hr, hq, hg, hill]

#check_claim jal_decode, jalr_decode, branch_decode, misaligned_traps
end NervControlDecode
