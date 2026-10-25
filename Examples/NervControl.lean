import Examples.NervControlDecode

/-! Arithmetic, jumps, and all six RV32I branches refine an independent ISA step. -/
namespace NervControl
open v_NervAdd NervArchitecture NervControlDecode
set_option maxRecDepth 4096
set_option maxHeartbeats 800000
set_option exponentiation.threshold 2048

def supported (w : BitVec 32) : Prop :=
  NervArithmetic.supported w ∨ isJal w ∨ isJalr w ∨ isBranch w

/-- The normal-execution claim excludes misaligned current PCs and selected next PCs. -/
def valid (w : BitVec 32) (a : Architecture) : Prop :=
  aligned a.pc ∧ supported w ∧ aligned (target w a)

/-- Branches preserve registers; jumps write the link; arithmetic uses its existing ISA model. -/
def execute (w : BitVec 32) (a : Architecture) : Architecture :=
  if w.extractLsb' 0 7 = 0x63 then ⟨a.regs, target w a⟩
  else if w.extractLsb' 0 7 = 0x6f ∨ w.extractLsb' 0 7 = 0x67 then
    ⟨fun r ↦ if r = (0#5) then 0 else if w.extractLsb' 7 5 = r then a.pc + 4 else a.regs r,
     target w a⟩
  else NervArithmetic.commit w a

private theorem arithmetic_execute (w : BitVec 32) (a : Architecture)
    (h : NervArithmetic.supported w) : execute w a = NervArithmetic.commit w a := by
  rcases h with h | h | h | h
  · simp [execute, h.1]
  · simp [execute, h.1]
  · simp [execute, h]
  · simp [execute, h]

/-- Actual register/PC effects for every supported instruction and every operand value. -/
theorem instruction_step (i : Inputs) (s : State)
    (ready : running s) (hr : i.v_reset = 0) (hs : i.v_stall = 0)
    (permit : valid i.v_imem_data (project s)) :
    running (eval i s).2 ∧ project (eval i s).2 = execute i.v_imem_data (project s) := by
  rcases permit with ⟨_, ha, alignment⟩
  rcases ha with arithmetic | jal | jalr | branch
  · have step := NervArithmetic.instruction_step i s ready hr hs arithmetic
    simpa only [arithmetic_execute _ _ arithmetic] using step
  · have ⟨hd, hw, hi, hm, hp⟩ := jal_decode i s hr ready.1 ready.2.2 jal alignment
    refine ⟨running_effect i s ready hr hs hi hm, ?_⟩
    have hop : i.v_imem_data.extractLsb' 0 7 = 0x6f := jal
    simpa [execute, hop, project] using write_effect_to i s _ _ ready hr hs hd hw hp
  · have ⟨hd, hw, hi, hm, hp⟩ := jalr_decode i s hr ready.1 ready.2.2 jalr alignment
    refine ⟨running_effect i s ready hr hs hi hm, ?_⟩
    simpa [execute, jalr.1, project] using write_effect_to i s _ _ ready hr hs hd hw hp
  · have ⟨hw, hi, hm, hp⟩ := branch_decode i s hr ready.1 ready.2.2 branch alignment
    refine ⟨running_effect i s ready hr hs hi hm, ?_⟩
    simpa [execute, branch.1] using no_write_effect_to i s _ ready hr hs hw hp

/-- An arbitrary stalled edge stutters; an executing edge uses the decoded ISA instruction. -/
def spec (i : Inputs) (a : Architecture) : Unit × Architecture :=
  ((), if i.v_stall = 1 then a else execute i.v_imem_data a)

theorem step_refinement (i : Inputs) (s : State) (ready : running s)
    (reset : i.v_reset = 0)
    (permit : i.v_stall = 1 ∨ valid i.v_imem_data (project s)) :
    running (eval i s).2 ∧ project (eval i s).2 = (spec i (project s)).2 := by
  by_cases stall : i.v_stall = (1#1)
  · have ⟨nextReady, next⟩ := NervArithmetic.step_refinement i s ready ⟨reset, Or.inl stall⟩
    exact ⟨nextReady, by simpa [spec, NervArithmetic.spec, stall] using next⟩
  · have stall0 : i.v_stall = (0#1) := by
      have cases : ∀ b : BitVec 1, b = 0 ∨ b = 1 := by decide
      exact (cases i.v_stall).resolve_right stall
    have ⟨nextReady, next⟩ := instruction_step i s ready reset stall0 (permit.resolve_left stall)
    exact ⟨nextReady, by simpa [spec, stall] using next⟩

private def report (write : Bool) (value nextPC : BitVec 32)
    (o : Outputs) (w : BitVec 32) (a : Architecture) : Prop :=
  o.v_rvfi_valid = 1 ∧ o.v_rvfi_insn = w ∧
  o.v_rvfi_rs1_addr = w.extractLsb' 15 5 ∧ o.v_rvfi_rs2_addr = w.extractLsb' 20 5 ∧
  o.v_rvfi_rs1_rdata = a.regs (w.extractLsb' 15 5) ∧
  o.v_rvfi_rs2_rdata = a.regs (w.extractLsb' 20 5) ∧
  o.v_rvfi_rd_addr = (if write then w.extractLsb' 7 5 else 0) ∧
  o.v_rvfi_rd_wdata = (if write = false ∨ w.extractLsb' 7 5 = 0 then 0 else value) ∧
  o.v_rvfi_pc_rdata = a.pc ∧ o.v_rvfi_pc_wdata = nextPC

private def writes (w : BitVec 32) : Bool := w.extractLsb' 0 7 != 0x63

private def value (w : BitVec 32) (a : Architecture) : BitVec 32 :=
  if w.extractLsb' 0 7 = 0x6f ∨ w.extractLsb' 0 7 = 0x67 then a.pc + 4
  else NervArithmetic.result w a

/-- Reports describe actual pre-edge reads, optional writeback, and the selected next PC. -/
def reportMatches (o : Outputs) (w : BitVec 32) (a : Architecture) : Prop :=
  report (writes w) (value w a) (target w a) o w a

private theorem report_effect (i j : Inputs) (s : State) (ready : running s)
    (hr : i.v_reset = 0) (hs : i.v_stall = 0) (reset : j.v_reset = 0) (stall : j.v_stall = 0)
    (write : Bool) (data nextPC : BitVec 32)
    (hd : Named.Signals.v_cpu_next_rd i s = data)
    (hw : Named.Signals.v_cpu_next_wr i s = if write then 1 else 0)
    (hmRead : Named.Signals.v_cpu_mem_rd_enable i s = 0)
    (hp : Named.Signals.v_n931 i s = nextPC) :
    report write data nextPC (eval j (eval i s).2).1 i.v_imem_data (project s) := by
  rcases ready with ⟨hq, ht, hm⟩
  have hg : Named.Signals.v_n478 i s = 1 := by
    simp [NervSafety.execution_gate, hr, hq, hs, ht]
  change report write data nextPC (Named.eval j (Named.eval i s).2).1 _ _
  cases write
  all_goals
    unfold report
    dsimp only [Named.eval]
    repeat' apply And.intro
  all_goals unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_n478, v_NervAdd.Named.Signals.v_n880,
     v_NervAdd.Named.Signals.v_cpu_next_rd, v_NervAdd.Named.Signals.v_cpu_next_wr,
     v_NervAdd.Named.Signals.v_cpu_mem_rd_enable, v_NervAdd.Named.Signals.v_n931,
     v_NervAdd.Named.Signals.v_rvfi_insn, v_NervAdd.Named.Signals.v_cpu_rs1_value,
     v_NervAdd.Named.Signals.v_cpu_rs2_value]
  all_goals simp [hg, hr, hq, ht, hm, hs, reset, stall, hd, hw, hmRead, hp,
    NervSafety.stored_word, NervRegisters.rs1_read, NervRegisters.rs2_read, project]
  all_goals
    by_cases hz : i.v_imem_data.extractLsb' 7 5 = (0#5) <;> simp [hz, BitVec.ofBool]

theorem retirement (i j : Inputs) (s : State) (ready : running s)
    (hr : i.v_reset = 0) (hs : i.v_stall = 0)
    (permit : valid i.v_imem_data (project s)) (reset : j.v_reset = 0) (stall : j.v_stall = 0) :
    reportMatches (eval j (eval i s).2).1 i.v_imem_data (project s) := by
  rcases permit with ⟨_, ha, alignment⟩
  rcases ha with arithmetic | jal | jalr | branch
  · have observed := NervArithmetic.retirement i j s ready hr hs arithmetic reset stall
    rcases arithmetic with h | h | h | h
    all_goals
      simp_all [reportMatches, report, writes, value, target, NervArithmetic.reportMatches,
        NervSafety.isAdd, NervImmediate.isAddi]
  · have ⟨hd, hw, _, hm, hp⟩ := jal_decode i s hr ready.1 ready.2.2 jal alignment
    have hop : i.v_imem_data.extractLsb' 0 7 = 0x6f := jal
    have observed := report_effect i j s ready hr hs reset stall true _ _ hd hw hm hp
    simpa [reportMatches, writes, value, hop, project] using observed
  · have ⟨hd, hw, _, hm, hp⟩ := jalr_decode i s hr ready.1 ready.2.2 jalr alignment
    have observed := report_effect i j s ready hr hs reset stall true _ _ hd hw hm hp
    simpa [reportMatches, writes, value, jalr.1, project] using observed
  · have ⟨hw, _, hm, hp⟩ := branch_decode i s hr ready.1 ready.2.2 branch alignment
    have observed := report_effect i j s ready hr hs reset stall false _ _ rfl hw hm hp
    simpa [reportMatches, report, writes, branch.1] using observed

#check_claim instruction_step, step_refinement, retirement
end NervControl
