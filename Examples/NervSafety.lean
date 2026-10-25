import YosysLean.BitVec
import YosysLean.Check
import YosysLean.Formal
import YosysLean.Tactic
import Examples.Generated.NervAddView
import Lean.Elab.Tactic.Omega

/-! An inductive certificate for the unchanged upstream ADD retirement checks. -/
namespace NervSafety
open YosysLean.Bits v_NervAdd
set_option maxRecDepth 4096
set_option maxHeartbeats 800000
set_option exponentiation.threshold 2048

private theorem bit_cases (b : BitVec 1) : b = 0 ∨ b = 1 := by revert b; decide

def isAdd (w : BitVec 32) : Prop :=
  w.extractLsb' 0 7 = 0x33 ∧ w.extractLsb' 12 3 = 0 ∧ w.extractLsb' 25 7 = 0

/-- Stored facts remain meaningful when an arbitrary stall delays observation. -/
def payload (s : State) : Prop :=
  s.v_cpu_trap = 0 ∧ s.v_cpu_mem_rd_enable_q = 0 ∧
  s.v_check_insn_rs1_addr = s.v_check_insn_insn.extractLsb' 15 5 ∧
  s.v_check_insn_rs2_addr = s.v_check_insn_insn.extractLsb' 20 5 ∧
  (s.v_check_insn_rs1_addr = 0 → s.v_check_insn_rs1_rdata = 0) ∧
  (s.v_check_insn_rs2_addr = 0 → s.v_check_insn_rs2_rdata = 0) ∧
  s.v_cpu_rvfi_pre_rd_addr = s.v_check_insn_insn.extractLsb' 7 5 ∧
  s.v_cpu_rvfi_pre_rd_wdata =
    (if s.v_check_insn_insn.extractLsb' 7 5 = 0 then 0
     else s.v_check_insn_rs1_rdata + s.v_check_insn_rs2_rdata) ∧
  s.v_check_insn_pc_wdata = s.v_check_insn_insn_spec_rvfi_pc_rdata + 4 ∧
  s.v_check_insn_rvfi_trap = 0 ∧ s.v_check_insn_mem_wmask = 0

def reportGood (s : State) : Prop :=
  s.v_cpu_rvfi_pre_valid = 1 → isAdd s.v_check_insn_insn → payload s

private theorem zero_good (s : State) (h : s.v_cpu_rvfi_pre_valid = 0) : reportGood s := by
  intro hv; simp [h] at hv

private theorem reset_step (i : Inputs) (s : State) (h : i.v_reset = 1) :
    reportGood (Named.eval i s).2 := by
  apply zero_good
  unfold_nodes v_NervAdd.Named except []
  rcases bit_cases s.v_cpu_reset_q with hq | hq <;> simp [h, hq]

private theorem recover_step (i : Inputs) (s : State)
    (h : i.v_reset = 0) (hq : s.v_cpu_reset_q = 1) :
    reportGood (Named.eval i s).2 := by
  apply zero_good
  unfold_nodes v_NervAdd.Named except []
  simp [h, hq]

private theorem pieces (w : BitVec 32) :
    w.extractLsb' 25 7 ++ (w.extractLsb' 20 5 ++ (w.extractLsb' 15 5 ++
      (w.extractLsb' 12 3 ++ (w.extractLsb' 7 5 ++ w.extractLsb' 0 7)))) = w := by
  have h1 := BitVec.extractLsb'_append_extractLsb'_eq_extractLsb'
    (x := w) (by decide : 7 = 0 + 7) (len₂ := 5)
  have h2 := BitVec.extractLsb'_append_extractLsb'_eq_extractLsb'
    (x := w) (by decide : 12 = 0 + 12) (len₂ := 3)
  have h3 := BitVec.extractLsb'_append_extractLsb'_eq_extractLsb'
    (x := w) (by decide : 15 = 0 + 15) (len₂ := 5)
  have h4 := BitVec.extractLsb'_append_extractLsb'_eq_extractLsb'
    (x := w) (by decide : 20 = 0 + 20) (len₂ := 5)
  have h5 := BitVec.extractLsb'_append_extractLsb'_eq_extractLsb'
    (x := w) (by decide : 25 = 0 + 25) (len₂ := 7)
  rw [h1, h2, h3, h4, h5]
  simp

theorem stored_word (i : Inputs) (s : State) :
    Named.Signals.v_rvfi_insn i s = s.v_check_insn_insn := by
  unfold_nodes v_NervAdd.Named except []
  have h := pieces s.v_check_insn_insn
  simp only [BitVec.append_eq]
  rw [h]
  exact pieces _

-- Yosys shares the execute enable as v_n478; establish its control meaning once.
theorem execution_gate (i : Inputs) (s : State) :
    Named.Signals.v_n478 i s =
      BitVec.ofBool (s.v_cpu_trap == 0 && i.v_stall == 0 &&
        i.v_reset == 0 && s.v_cpu_reset_q == 0) := by
  unfold_nodes v_NervAdd.Named except []
  rcases bit_cases i.v_reset with hr | hr <;>
    rcases bit_cases i.v_stall with hs | hs <;>
    rcases bit_cases s.v_cpu_trap with ht | ht <;>
    rcases bit_cases s.v_cpu_reset_q with hq | hq <;> simp [hr, hs, ht, hq]

theorem stalled_state (i : Inputs) (s : State)
    (hr : i.v_reset = 0) (hq : s.v_cpu_reset_q = 0) (hs : i.v_stall = 1) :
    (Named.eval i s).2 = { s with v_cpu_trapped_q := s.v_cpu_trap, v_started := 1 } := by
  have hg : Named.Signals.v_n478 i s = 0 := by simp [execution_gate, hs]
  have hp : BitVec.ofBool (BitVec.append (Named.Signals.v_n880 i s) (0#1) ==
      ~~~(0 : BitVec 2)) = 0 := by
    rcases bit_cases (Named.Signals.v_n880 i s) with h | h <;> simp [h]
  simp only [BitVec.append_eq] at hp
  change BitVec.ofBool (Named.Signals.v_n880 i s ++ (0#1) == (3#2)) = 0 at hp
  dsimp only [Named.eval]
  simp only [State.mk.injEq]
  repeat' apply And.intro
  all_goals unfold_nodes v_NervAdd.Named except
      [v_NervAdd.Named.Signals.v_n478, v_NervAdd.Named.Signals.v_rvfi_insn,
       v_NervAdd.Named.Signals.v_n880, v_NervAdd.Named.Signals.v_cpu_next_rd,
       v_NervAdd.Named.Signals.v_cpu_next_wr, v_NervAdd.Named.Signals.v_cpu_mem_rdata,
       v_NervAdd.Named.Signals.v_cpu_rs1_value, v_NervAdd.Named.Signals.v_cpu_rs2_value,
       v_NervAdd.Named.Signals.v_cpu_mem_rd_enable]
  all_goals simp [hr, hq, hs, hg, hp, stored_word]


theorem known_slice {w : BitVec 32} {base total off len : Nat} {v : BitVec total}
    (h : w.extractLsb' base total = v) (hb : off + len ≤ total) :
    w.extractLsb' (base + off) len = v.extractLsb' off len := by
  have hc : w.extractLsb' (base + off) len = (w.extractLsb' base total).extractLsb' off len := by
    apply BitVec.eq_of_getLsbD_eq
    intro k hk
    simp only [BitVec.getLsbD_extractLsb']
    simp [hk, show off + k < total by omega, Nat.add_assoc]
  exact hc.trans (congrArg (·.extractLsb' off len) h)

-- Keep register reads opaque: decoding ADD needs no case split over 32 registers.
-- v_n880 is the illegal-instruction flag; v_n931 is the next-PC value.
theorem add_decode (i : Inputs) (s : State)
    (hr : i.v_reset = 0) (hq : s.v_cpu_reset_q = 0)
    (hm : s.v_cpu_mem_rd_enable_q = 0) (ha : isAdd i.v_imem_data) :
    Named.Signals.v_cpu_next_rd i s =
      Named.Signals.v_cpu_rs1_value i s + Named.Signals.v_cpu_rs2_value i s ∧
    Named.Signals.v_cpu_next_wr i s = 1 ∧
    Named.Signals.v_n880 i s = 0 ∧
    Named.Signals.v_cpu_mem_rd_enable i s = 0 ∧
    Named.Signals.v_cpu_dmem_valid i s = 0 ∧
    Named.Signals.v_n931 i s = s.v_cpu_pc + 4 := by
  rcases ha with ⟨hop, hf3, hf7⟩
  have h31 := known_slice hf7 (by decide : 6 + 1 ≤ 7)
  have h30 := known_slice hf7 (by decide : 5 + 1 ≤ 7)
  have h25 := known_slice hf7 (by decide : 0 + 5 ≤ 7)
  have h0 := known_slice hop (by decide : 0 + 2 ≤ 7)
  have h2 := known_slice hop (by decide : 2 + 2 ≤ 7)
  have h4 := known_slice hop (by decide : 4 + 1 ≤ 7)
  have h5 := known_slice hop (by decide : 5 + 2 ≤ 7)
  simp at h31 h30 h25 h0 h2 h4 h5
  repeat' apply And.intro
  all_goals unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_cpu_rs1_value, v_NervAdd.Named.Signals.v_cpu_rs2_value]
  all_goals simp [hr, hq, hm, hop, hf3, hf7, h31, h30, h25, h0, h2, h4, h5]
  all_goals simp (disch := decide) [HAppend.hAppend, -BitVec.append_eq, slice_low, slice_high]
  all_goals simp

private theorem instruction_step (i : Inputs) (s : State) :
    (Named.eval i s).2.v_check_insn_insn =
      if Named.Signals.v_n478 i s == 1 then i.v_imem_data else s.v_check_insn_insn := by
  simp only [Named.eval, Named.Signals.v_n978, Named.Signals.v_imem_data, stored_word]

private theorem valid_step (i : Inputs) (s : State) :
    (Named.eval i s).2.v_cpu_rvfi_pre_valid =
      if (i.v_reset ||| s.v_cpu_reset_q) == 1 then 0
      else if Named.Signals.v_n478 i s == 1 then ~~~s.v_cpu_mem_rd_enable_q
      else s.v_cpu_rvfi_pre_valid := by rfl

private theorem stalled_good (i : Inputs) (s : State) (g : reportGood s)
    (hr : i.v_reset = 0) (hq : s.v_cpu_reset_q = 0) (hs : i.v_stall = 1) :
    reportGood (Named.eval i s).2 := by
  rw [stalled_state i s hr hq hs]
  exact g

private theorem trapped_good (i : Inputs) (s : State) (g : reportGood s)
    (hr : i.v_reset = 0) (hq : s.v_cpu_reset_q = 0) (ht : s.v_cpu_trap = 1) :
    reportGood (Named.eval i s).2 := by
  have hg : Named.Signals.v_n478 i s = 0 := by simp [execution_gate, ht]
  intro hv ha
  have hp : s.v_cpu_rvfi_pre_valid = 1 := by simpa [valid_step, hg, hr, hq] using hv
  have hi : isAdd s.v_check_insn_insn := by simpa [instruction_step, hg] using ha
  have ht0 := (g hp hi).1
  simp [ht] at ht0

private theorem rs1_zero (i : Inputs) (s : State)
    (h : i.v_imem_data.extractLsb' 15 5 = 0) : Named.Signals.v_cpu_rs1_value i s = 0 := by
  unfold_nodes v_NervAdd.Named except []
  simp [h]

private theorem rs2_zero (i : Inputs) (s : State)
    (h : i.v_imem_data.extractLsb' 20 5 = 0) : Named.Signals.v_cpu_rs2_value i s = 0 := by
  unfold_nodes v_NervAdd.Named except []
  simp [h]

private theorem issued_payload (i : Inputs) (s : State)
    (hr : i.v_reset = 0) (hq : s.v_cpu_reset_q = 0)
    (hs : i.v_stall = 0) (ht : s.v_cpu_trap = 0)
    (hm : s.v_cpu_mem_rd_enable_q = 0) (ha : isAdd i.v_imem_data) :
    payload (Named.eval i s).2 := by
  have hg : Named.Signals.v_n478 i s = 1 := by simp [execution_gate, hr, hq, hs, ht]
  rcases add_decode i s hr hq hm ha with ⟨hdata, hwr, hill, hrd, hmem, hpc⟩
  unfold payload
  dsimp only [Named.eval]
  repeat' apply And.intro
  all_goals unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_n478, v_NervAdd.Named.Signals.v_rvfi_insn,
     v_NervAdd.Named.Signals.v_n880, v_NervAdd.Named.Signals.v_cpu_next_rd,
     v_NervAdd.Named.Signals.v_cpu_next_wr, v_NervAdd.Named.Signals.v_cpu_mem_rd_enable,
     v_NervAdd.Named.Signals.v_cpu_dmem_valid, v_NervAdd.Named.Signals.v_n931,
     v_NervAdd.Named.Signals.v_cpu_rs1_value, v_NervAdd.Named.Signals.v_cpu_rs2_value]
  all_goals simp [hr, hq, hs, ht, hg, hdata, hwr, hill, hrd, hmem, hpc]
  · exact rs1_zero i s
  · exact rs2_zero i s
  · by_cases hz : i.v_imem_data.extractLsb' 7 5 = (0#5) <;> simp [hz, BitVec.ofBool]

/-- The stored-report invariant survives every input edge, including stalls and memory traffic. -/
theorem report_step (i : Inputs) (s : State) (g : reportGood s) :
    reportGood (Named.eval i s).2 := by
  rcases bit_cases i.v_reset with hr | hr
  · rcases bit_cases s.v_cpu_reset_q with hq | hq
    · rcases bit_cases s.v_cpu_trap with ht | ht
      · rcases bit_cases i.v_stall with hs | hs
        · have hg : Named.Signals.v_n478 i s = 1 := by
            simp [execution_gate, hr, hq, hs, ht]
          rcases bit_cases s.v_cpu_mem_rd_enable_q with hm | hm
          · intro _ ha
            apply issued_payload i s hr hq hs ht hm
            simpa [instruction_step, hg] using ha
          · apply zero_good
            simp [valid_step, hr, hq, hg, hm]
        · exact stalled_good i s g hr hq hs
      · exact trapped_good i s g hr hq ht
    · exact recover_step i s hr hq
  · exact reset_step i s hr

private theorem checker_word (i : Inputs) (s : State) :
    Named.Signals.v_check_insn_insn i s = s.v_check_insn_insn := by
  unfold_nodes v_NervAdd.Named except []
  exact pieces _

private theorem payload_sound (i : Inputs) (s : State)
    (good : payload s) (selected : isAdd s.v_check_insn_insn) :
    assertions (Named.eval i s).1 := by
  rcases good with ⟨ht, hm, hra, hrb, hza, hzb, hrd, hdata, hpc, htrap, hmask⟩
  rcases selected with ⟨hop, hf3, hf7⟩
  by_cases h1 : s.v_check_insn_insn.extractLsb' 15 5 = (0#5) <;>
    by_cases h2 : s.v_check_insn_insn.extractLsb' 20 5 = (0#5) <;>
    by_cases hd : s.v_check_insn_insn.extractLsb' 7 5 = (0#5)
  all_goals
    unfold assertions
    dsimp only [Named.eval]
    unfold_nodes v_NervAdd.Named except
      [v_NervAdd.Named.Signals.v_rvfi_insn, v_NervAdd.Named.Signals.v_check_insn_insn,
       v_NervAdd.Named.Signals.v_rvfi_valid]
    simp_all [checker_word, BitVec.ofBool]

private theorem and_one (a b : BitVec 1) :
    a &&& b = (1#1) ↔ a = (1#1) ∧ b = (1#1) := by revert a b; decide

private theorem not_one (a : BitVec 1) : ~~~a = (1#1) ↔ a = (0#1) := by
  revert a; decide

private theorem ofBool_one (b : Bool) : BitVec.ofBool b = (1#1) ↔ b = true := by
  cases b <;> decide

private theorem ofBool_zero (b : Bool) : BitVec.ofBool b = (0#1) ↔ b = false := by
  cases b <;> decide

private theorem check_live (i : Inputs) (s : State) :
    Named.Signals.v_check_insn_check i s = 1 →
      s.v_cpu_rvfi_pre_valid = 1 ∧ isAdd s.v_check_insn_insn := by
  unfold isAdd
  unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_rvfi_insn, v_NervAdd.Named.Signals.v_check_insn_insn]
  simp only [checker_word, BitVec.ofNat_eq_ofNat,
    and_one, not_one, ofBool_one, ofBool_zero]
  simp only [beq_iff_eq]
  intro h
  simp_all

private theorem disabled_sound (i : Inputs) (s : State)
    (h : Named.Signals.v_check_insn_check i s = 0) : assertions (Named.eval i s).1 := by
  unfold assertions
  dsimp only [Named.eval]
  unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_check_insn_check, v_NervAdd.Named.Signals.v_rvfi_insn,
     v_NervAdd.Named.Signals.v_check_insn_insn, v_NervAdd.Named.Signals.v_rvfi_valid]
  simp [h]

/-- The invariant establishes every imported ADD checker assertion at the current edge. -/
theorem report_sound (i : Inputs) (s : State) (g : reportGood s) :
    assertions (Named.eval i s).1 := by
  rcases bit_cases (Named.Signals.v_check_insn_check i s) with h | h
  · exact disabled_sound i s h
  · rcases check_live i s h with ⟨hv, selected⟩
    exact payload_sound i s (g hv selected) selected

private theorem first_reset (i : Inputs) (s : State) (init : initial s)
    (assumed : assumptions (Named.eval i s).1) : i.v_reset = 1 := by
  have started : s.v_started = 0 := by
    rcases bit_cases s.v_started with hs | hs
    · exact hs
    · simp [initial, hs] at init
  rcases bit_cases i.v_reset with hr | hr
  · have disabled : (Named.eval i s).1.v__examples_riscv_NervHarness_sv_20_assume_254 = 0 := by
      unfold_nodes v_NervAdd.Named except []
      simp [started, hr]
    have contrad := assumed.2.1
    rw [disabled] at contrad
    contradiction
  · exact hr

private theorem initial_sound (i : Inputs) (s : State) (hr : i.v_reset = 1) :
    assertions (Named.eval i s).1 := by
  apply disabled_sound
  unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_rvfi_insn, v_NervAdd.Named.Signals.v_check_insn_insn]
  simp [hr]

/-- Initial states need the harness's first reset; thereafter the stored-report facts suffice. -/
def invariant (s : State) : Prop := initial s ∨ reportGood s

/-- Every imported ADD assertion holds on every allowed finite execution of arbitrary length. -/
theorem safe : YosysLean.Safety eval initial assumptions assertions := by
  change YosysLean.Safety Named.eval initial assumptions assertions
  apply YosysLean.safety_of_invariant Named.eval initial invariant assumptions assertions
  · intro s init; exact Or.inl init
  · intro i s inv assumed
    apply Or.inr
    rcases inv with init | good
    · exact reset_step i s (first_reset i s init assumed)
    · exact report_step i s good
  · intro i s inv assumed
    rcases inv with init | good
    · exact initial_sound i s (first_reset i s init assumed)
    · exact report_sound i s good

#check_claim safe
end NervSafety
