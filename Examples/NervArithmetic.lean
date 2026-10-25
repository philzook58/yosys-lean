import Examples.NervImmediate

/-! Positive architectural simulation for arbitrary mixed arithmetic programs. -/
namespace NervArithmetic
open v_NervAdd NervRegisters NervArchitecture NervImmediate
set_option maxRecDepth 4096
set_option maxHeartbeats 800000
set_option exponentiation.threshold 2048

/-- Supported instruction words; all operand, destination, and immediate bits remain arbitrary. -/
def supported (w : BitVec 32) : Prop :=
  NervSafety.isAdd w ∨ isAddi w ∨ w.extractLsb' 0 7 = 0x37 ∨ w.extractLsb' 0 7 = 0x17

/-- Independent ISA arithmetic, including signed 12-bit immediate extension. -/
def result (w : BitVec 32) (a : Architecture) : BitVec 32 :=
  if w.extractLsb' 0 7 = 0x33 then addResult w a
  else if w.extractLsb' 0 7 = 0x13 then a.regs (w.extractLsb' 15 5) + immediate w
  else if w.extractLsb' 0 7 = 0x37 then upper w else upper w + a.pc

private theorem decode (i : Inputs) (s : State)
    (hr : i.v_reset = 0) (hq : s.v_cpu_reset_q = 0)
    (hm : s.v_cpu_mem_rd_enable_q = 0) (ha : supported i.v_imem_data) :
    Named.Signals.v_cpu_next_rd i s = result i.v_imem_data (project s) ∧
    Named.Signals.v_cpu_next_wr i s = 1 ∧
    Named.Signals.v_n880 i s = 0 ∧
    Named.Signals.v_cpu_mem_rd_enable i s = 0 ∧
    Named.Signals.v_cpu_dmem_valid i s = 0 ∧
    Named.Signals.v_n931 i s = s.v_cpu_pc + 4 := by
  rcases ha with ha | ha | ha
  · have hd := NervSafety.add_decode i s hr hq hm ha
    simpa [result, ha.1, addResult, project, rs1_read, rs2_read] using hd
  · have hd := addi_decode i s hr hq hm ha
    simpa [result, ha.1, project, rs1_read] using hd
  · have hd := upper_decode i s hr hq hm ha
    rcases ha with hop | hop <;> simpa [result, hop, project] using hd

/-- The supported instructions write only rd and advance the architectural PC by four. -/
def commit (w : BitVec 32) (a : Architecture) : Architecture :=
  ⟨fun r ↦ if r = (0#5) then 0
           else if w.extractLsb' 7 5 = r then result w a else a.regs r,
   a.pc + 4⟩

/-- One arbitrary supported instruction implements its ISA effect on actual CPU registers. -/
theorem instruction_step (i : Inputs) (s : State)
    (ready : running s) (hr : i.v_reset = 0) (hs : i.v_stall = 0)
    (ha : supported i.v_imem_data) :
    running (eval i s).2 ∧ project (eval i s).2 = commit i.v_imem_data (project s) := by
  rcases decode i s hr ready.1 ready.2.2 ha with ⟨hd, hw, hi, hm, _, hp⟩
  exact ⟨running_effect i s ready hr hs hi hm, write_effect i s _ ready hr hs hd hw hp⟩

/-- Reset stays low; a stalled edge may carry any instruction word. -/
def allowed (i : Inputs) : Prop :=
  i.v_reset = 0 ∧ (i.v_stall = 1 ∨ supported i.v_imem_data)

/-- Independent mixed-instruction ISA machine, with explicit stuttering on a stall. -/
def spec (i : Inputs) (a : Architecture) : Unit × Architecture :=
  ((), if i.v_stall = 1 then a else commit i.v_imem_data a)

theorem step_refinement (i : Inputs) (s : State)
    (ready : running s) (permit : allowed i) :
    running (eval i s).2 ∧ project (eval i s).2 = (spec i (project s)).2 := by
  rcases ready with ⟨hq, ht, hm⟩
  rcases permit with ⟨hr, permit⟩
  by_cases hs : i.v_stall = (1#1)
  · change running (Named.eval i s).2 ∧ project (Named.eval i s).2 = _
    rw [NervSafety.stalled_state i s hr hq hs]
    exact ⟨⟨hq, ht, hm⟩, by simp [spec, hs]; rfl⟩
  · have hs0 : i.v_stall = (0#1) := by
      have cases : ∀ b : BitVec 1, b = 0 ∨ b = 1 := by decide
      exact (cases i.v_stall).resolve_right hs
    have ⟨nextReady, next⟩ := instruction_step i s ⟨hq, ht, hm⟩ hr hs0
      (permit.resolve_left hs)
    exact ⟨nextReady, by simpa [spec, hs] using next⟩

/-- Arbitrarily long mixed ADD/ADDI/LUI/AUIPC programs agree on all registers and PC,
with arbitrary stalls. -/
theorem program_refinement (inputs : List Inputs) (s : State) (ready : running s)
    (permit : ∀ i ∈ inputs, allowed i) :
    project (YosysLean.run eval inputs s) = YosysLean.run spec inputs (project s) := by
  induction inputs generalizing s with
  | nil => rfl
  | cons i rest ih =>
      have ⟨nextReady, next⟩ := step_refinement i s ready (permit i (by simp))
      simp only [YosysLean.run]
      rw [ih _ nextReady (fun j hj ↦ permit j (by simp [hj])), next]

/-- Each report is tied to the actual pre-execution registers and ISA result. -/
def reportMatches (o : Outputs) (w : BitVec 32) (a : Architecture) : Prop :=
  o.v_rvfi_valid = 1 ∧ o.v_rvfi_insn = w ∧
  o.v_rvfi_rs1_addr = w.extractLsb' 15 5 ∧
  o.v_rvfi_rs2_addr = w.extractLsb' 20 5 ∧
  o.v_rvfi_rs1_rdata = a.regs (w.extractLsb' 15 5) ∧
  o.v_rvfi_rs2_rdata = a.regs (w.extractLsb' 20 5) ∧
  o.v_rvfi_rd_addr = w.extractLsb' 7 5 ∧
  o.v_rvfi_rd_wdata = (if w.extractLsb' 7 5 = (0#5) then 0 else result w a) ∧
  o.v_rvfi_pc_rdata = a.pc ∧ o.v_rvfi_pc_wdata = a.pc + 4

/-- On the next unstalled observation, RVFI reports the same architectural effect. -/
theorem retirement (i j : Inputs) (s : State)
    (ready : running s) (hr : i.v_reset = 0) (hs : i.v_stall = 0)
    (ha : supported i.v_imem_data) (reset : j.v_reset = 0) (stall : j.v_stall = 0) :
    reportMatches (eval j (eval i s).2).1 i.v_imem_data (project s) := by
  rcases ready with ⟨hq, ht, hm⟩
  have hg : Named.Signals.v_n478 i s = 1 := by
    simp [NervSafety.execution_gate, hr, hq, hs, ht]
  rcases decode i s hr hq hm ha with ⟨hdata, hwr, _, hrd, _, hpc⟩
  change reportMatches (Named.eval j (Named.eval i s).2).1 _ _
  unfold reportMatches
  dsimp only [Named.eval]
  repeat' apply And.intro
  all_goals unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_n478, v_NervAdd.Named.Signals.v_n880,
     v_NervAdd.Named.Signals.v_cpu_next_rd, v_NervAdd.Named.Signals.v_cpu_next_wr,
     v_NervAdd.Named.Signals.v_cpu_mem_rd_enable, v_NervAdd.Named.Signals.v_n931,
     v_NervAdd.Named.Signals.v_rvfi_insn, v_NervAdd.Named.Signals.v_cpu_rs1_value,
     v_NervAdd.Named.Signals.v_cpu_rs2_value]
  all_goals simp [hg, hr, hq, ht, hm, hs, reset, stall, hdata, hwr, hrd, hpc,
    NervSafety.stored_word, rs1_read, rs2_read, project]
  by_cases hz : i.v_imem_data.extractLsb' 7 5 = (0#5) <;> simp [hz, BitVec.ofBool]

private theorem reset_control (i : Inputs) (s : State) (reset : i.v_reset = 1) :
    (eval i s).2.v_cpu_reset_q = 1 ∧ (eval i s).2.v_cpu_mem_rd_enable_q = 0 := by
  change (Named.eval i s).2.v_cpu_reset_q = 1 ∧
    (Named.eval i s).2.v_cpu_mem_rd_enable_q = 0
  dsimp only [Named.eval]
  constructor
  all_goals unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_cpu_mem_rd_enable]
  all_goals simp [reset]

private theorem recovery_control (i : Inputs) (s : State)
    (reset : i.v_reset = 0) (hq : s.v_cpu_reset_q = 1) (hm : s.v_cpu_mem_rd_enable_q = 0) :
    running (eval i s).2 ∧ (eval i s).2.v_cpu_pc = 0 := by
  have hg : Named.Signals.v_n478 i s = 0 := by simp [NervSafety.execution_gate, hq]
  change running (Named.eval i s).2 ∧ (Named.eval i s).2.v_cpu_pc = 0
  unfold running
  dsimp only [Named.eval]
  repeat' apply And.intro
  all_goals unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_n478, v_NervAdd.Named.Signals.v_n880,
     v_NervAdd.Named.Signals.v_n931]
  all_goals simp [reset, hq, hm, hg]

/-- A reset edge followed by a recovery edge establishes the theorem's running-phase premise. -/
theorem reset_ready (i j : Inputs) (s : State) (reset : i.v_reset = 1)
    (release : j.v_reset = 0) :
    running (eval j (eval i s).2).2 ∧ (eval j (eval i s).2).2.v_cpu_pc = 0 := by
  have ⟨hq, hm⟩ := reset_control i s reset
  exact recovery_control j (eval i s).2 release hq hm

#check_claim instruction_step, program_refinement, retirement, reset_ready

end NervArithmetic
