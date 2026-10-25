import Examples.NervSafety

/-! Architectural register reads from NERV's lowered register file. -/
namespace NervRegisters
open v_NervAdd
set_option maxRecDepth 4096
set_option maxHeartbeats 800000
set_option exponentiation.threshold 2048

/-- Architectural reads ignore the physical x0 storage, which NERV may write. -/
def registers (s : State) (r : BitVec 5) : BitVec 32 :=
  match r.toNat with
  | 1 => s.v_cpu_regfile_1_
  | 2 => s.v_cpu_regfile_2_
  | 3 => s.v_cpu_regfile_3_
  | 4 => s.v_cpu_regfile_4_
  | 5 => s.v_cpu_regfile_5_
  | 6 => s.v_cpu_regfile_6_
  | 7 => s.v_cpu_regfile_7_
  | 8 => s.v_cpu_regfile_8_
  | 9 => s.v_cpu_regfile_9_
  | 10 => s.v_cpu_regfile_10_
  | 11 => s.v_cpu_regfile_11_
  | 12 => s.v_cpu_regfile_12_
  | 13 => s.v_cpu_regfile_13_
  | 14 => s.v_cpu_regfile_14_
  | 15 => s.v_cpu_regfile_15_
  | 16 => s.v_cpu_regfile_16_
  | 17 => s.v_cpu_regfile_17_
  | 18 => s.v_cpu_regfile_18_
  | 19 => s.v_cpu_regfile_19_
  | 20 => s.v_cpu_regfile_20_
  | 21 => s.v_cpu_regfile_21_
  | 22 => s.v_cpu_regfile_22_
  | 23 => s.v_cpu_regfile_23_
  | 24 => s.v_cpu_regfile_24_
  | 25 => s.v_cpu_regfile_25_
  | 26 => s.v_cpu_regfile_26_
  | 27 => s.v_cpu_regfile_27_
  | 28 => s.v_cpu_regfile_28_
  | 29 => s.v_cpu_regfile_29_
  | 30 => s.v_cpu_regfile_30_
  | 31 => s.v_cpu_regfile_31_
  | _ => 0

-- Enumerate only five address bits; operand values stay symbolic.
theorem rs1_read (i : Inputs) (s : State) :
    Named.Signals.v_cpu_rs1_value i s = registers s (i.v_imem_data.extractLsb' 15 5) := by
  suffices ∀ r : BitVec 5, i.v_imem_data.extractLsb' 15 5 = r →
      Named.Signals.v_cpu_rs1_value i s = registers s r from this _ rfl
  rintro ⟨r⟩
  revert r
  simp only [Fin.forall_fin_succ, Fin.forall_fin_zero, and_true]
  repeat' apply And.intro
  all_goals
    intro h
    have h0 := NervSafety.known_slice h (by decide : 0 + 1 ≤ 5)
    have h1 := NervSafety.known_slice h (by decide : 1 + 1 ≤ 5)
    have h2 := NervSafety.known_slice h (by decide : 2 + 1 ≤ 5)
    have h3 := NervSafety.known_slice h (by decide : 3 + 1 ≤ 5)
    have h4 := NervSafety.known_slice h (by decide : 4 + 1 ≤ 5)
    unfold_nodes v_NervAdd.Named except []
    simp [h, h0, h1, h2, h3, h4, registers]

theorem rs2_read (i : Inputs) (s : State) :
    Named.Signals.v_cpu_rs2_value i s = registers s (i.v_imem_data.extractLsb' 20 5) := by
  suffices ∀ r : BitVec 5, i.v_imem_data.extractLsb' 20 5 = r →
      Named.Signals.v_cpu_rs2_value i s = registers s r from this _ rfl
  rintro ⟨r⟩
  revert r
  simp only [Fin.forall_fin_succ, Fin.forall_fin_zero, and_true]
  repeat' apply And.intro
  all_goals
    intro h
    have h0 := NervSafety.known_slice h (by decide : 0 + 1 ≤ 5)
    have h1 := NervSafety.known_slice h (by decide : 1 + 1 ≤ 5)
    have h2 := NervSafety.known_slice h (by decide : 2 + 1 ≤ 5)
    have h3 := NervSafety.known_slice h (by decide : 3 + 1 ≤ 5)
    have h4 := NervSafety.known_slice h (by decide : 4 + 1 ≤ 5)
    unfold_nodes v_NervAdd.Named except []
    simp [h, h0, h1, h2, h3, h4, registers]

theorem and_one (a b : BitVec 1) :
    a &&& b = (1#1) ↔ a = (1#1) ∧ b = (1#1) := by revert a b; decide

theorem not_one (a : BitVec 1) : ~~~a = (1#1) ↔ a = (0#1) := by
  revert a; decide

theorem eq_bits (a b : BitVec 5) : a = b ↔
    a.extractLsb' 0 1 = b.extractLsb' 0 1 ∧
    a.extractLsb' 1 1 = b.extractLsb' 1 1 ∧
    a.extractLsb' 2 1 = b.extractLsb' 2 1 ∧
    a.extractLsb' 3 1 = b.extractLsb' 3 1 ∧
    a.extractLsb' 4 1 = b.extractLsb' 4 1 := by
  constructor
  · intro h; subst b; simp
  · rintro ⟨h0, h1, h2, h3, h4⟩
    apply BitVec.eq_of_getLsbD_eq
    intro k hk
    have cases : k = 0 ∨ k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 4 := by omega
    rcases cases with rfl | rfl | rfl | rfl | rfl
    · simpa using congrArg (fun v : BitVec 1 ↦ v.getLsbD 0) h0
    · simpa using congrArg (fun v : BitVec 1 ↦ v.getLsbD 0) h1
    · simpa using congrArg (fun v : BitVec 1 ↦ v.getLsbD 0) h2
    · simpa using congrArg (fun v : BitVec 1 ↦ v.getLsbD 0) h3
    · simpa using congrArg (fun v : BitVec 1 ↦ v.getLsbD 0) h4

#check_claim rs1_read, rs2_read
end NervRegisters
