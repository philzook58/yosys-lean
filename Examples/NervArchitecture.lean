import Examples.NervRegisters

/-! ADD's register/PC effect and the connection from its report to pre-edge state. -/
namespace NervArchitecture
open v_NervAdd NervRegisters
set_option maxRecDepth 4096
set_option maxHeartbeats 800000
set_option exponentiation.threshold 2048

-- Decode only the write address. Keep the data, including any arithmetic, opaque.
private theorem register_write (i : Inputs) (s : State) (rd : BitVec 5) (data : BitVec 32)
    (enable : Named.Signals.v_n529 i s = 1)
    (addr : Named.Signals.v_n486 i s = rd) (value : Named.Signals.v_n479 i s = data) :
    ∀ r, registers (Named.eval i s).2 r =
      if r = (0#5) then 0 else if rd = r then data else registers s r := by
  rintro ⟨r⟩
  revert r
  simp only [Fin.forall_fin_succ, Fin.forall_fin_zero, and_true]
  repeat' apply And.intro
  all_goals
    dsimp only [registers, Named.eval]
    unfold_nodes v_NervAdd.Named except
      [v_NervAdd.Named.Signals.v_n478, v_NervAdd.Named.Signals.v_n529,
       v_NervAdd.Named.Signals.v_n486, v_NervAdd.Named.Signals.v_n479]
    simp [enable, addr, value, eq_bits, and_one, not_one, and_assoc]

/-- A small architectural state, independent of NERV's retirement-report registers. -/
structure Architecture where
  regs : BitVec 5 → BitVec 32
  pc : BitVec 32

def project (s : State) : Architecture := ⟨registers s, s.v_cpu_pc⟩

def addResult (w : BitVec 32) (a : Architecture) : BitVec 32 :=
  a.regs (w.extractLsb' 15 5) + a.regs (w.extractLsb' 20 5)

/-- The ISA effect of ADD: x0 reads zero; only rd changes; PC advances by four. -/
def add (w : BitVec 32) (a : Architecture) : Architecture :=
  ⟨fun r ↦ if r = (0#5) then 0
           else if w.extractLsb' 7 5 = r then addResult w a else a.regs r,
   a.pc + 4⟩

/-- Past reset recovery, untrapped, and without a pending load response. -/
def running (s : State) : Prop :=
  s.v_cpu_reset_q = 0 ∧ s.v_cpu_trap = 0 ∧ s.v_cpu_mem_rd_enable_q = 0

def executesAdd (i : Inputs) (s : State) : Prop :=
  running s ∧ i.v_reset = 0 ∧ i.v_stall = 0 ∧ NervSafety.isAdd i.v_imem_data

/-- Physical writeback with an arbitrary next PC, shared by arithmetic and jumps. -/
theorem write_effect_to (i : Inputs) (s : State) (data nextPC : BitVec 32)
    (ready : running s) (hr : i.v_reset = 0) (hs : i.v_stall = 0)
    (hdata : Named.Signals.v_cpu_next_rd i s = data)
    (hwr : Named.Signals.v_cpu_next_wr i s = 1)
    (hpc : Named.Signals.v_n931 i s = nextPC) :
    project (eval i s).2 =
      ⟨fun r ↦ if r = (0#5) then 0 else if i.v_imem_data.extractLsb' 7 5 = r then data
               else (project s).regs r, nextPC⟩ := by
  rcases ready with ⟨hq, ht, hm⟩
  have hg : Named.Signals.v_n478 i s = 1 := by
    simp [NervSafety.execution_gate, hr, hq, hs, ht]
  have enable : Named.Signals.v_n529 i s = 1 := by
    unfold_nodes v_NervAdd.Named except
      [v_NervAdd.Named.Signals.v_n478, v_NervAdd.Named.Signals.v_cpu_next_wr]
    simp [hg, hm, hwr]
  have addr : Named.Signals.v_n486 i s = i.v_imem_data.extractLsb' 7 5 := by
    unfold_nodes v_NervAdd.Named except
      [v_NervAdd.Named.Signals.v_n478, v_NervAdd.Named.Signals.v_cpu_next_wr]
    simp [hg, hm, hwr]
  have value : Named.Signals.v_n479 i s = data := by
    unfold_nodes v_NervAdd.Named except
      [v_NervAdd.Named.Signals.v_n478, v_NervAdd.Named.Signals.v_cpu_next_wr,
       v_NervAdd.Named.Signals.v_cpu_next_rd]
    simp [hg, hm, hwr, hdata]
  change project (Named.eval i s).2 = _
  simp only [project, Architecture.mk.injEq]
  constructor
  · funext r
    exact register_write i s _ _ enable addr value r
  · dsimp only [Named.eval]
    unfold_nodes v_NervAdd.Named except
      [v_NervAdd.Named.Signals.v_n478, v_NervAdd.Named.Signals.v_n931]
    simp [hg, hr, hq, hpc]


/-- Shared physical writeback/PC argument; instruction decoders supply the data and enables. -/
theorem write_effect (i : Inputs) (s : State) (data : BitVec 32)
    (ready : running s) (hr : i.v_reset = 0) (hs : i.v_stall = 0)
    (hdata : Named.Signals.v_cpu_next_rd i s = data)
    (hwr : Named.Signals.v_cpu_next_wr i s = 1)
    (hpc : Named.Signals.v_n931 i s = s.v_cpu_pc + 4) :
    project (eval i s).2 =
      ⟨fun r ↦ if r = (0#5) then 0 else if i.v_imem_data.extractLsb' 7 5 = r then data
               else (project s).regs r, s.v_cpu_pc + 4⟩ := by
  exact write_effect_to i s data _ ready hr hs hdata hwr hpc

private theorem register_hold (i : Inputs) (s : State)
    (enable : Named.Signals.v_n529 i s = 0) : registers (Named.eval i s).2 = registers s := by
  funext r
  rcases r with ⟨r⟩
  revert r
  simp only [Fin.forall_fin_succ, Fin.forall_fin_zero, and_true]
  repeat' apply And.intro
  all_goals
    dsimp only [registers, Named.eval]
    unfold_nodes v_NervAdd.Named except
      [v_NervAdd.Named.Signals.v_n478, v_NervAdd.Named.Signals.v_n529,
       v_NervAdd.Named.Signals.v_n486, v_NervAdd.Named.Signals.v_n479]
    simp [enable, and_one, not_one, and_assoc]

/-- An instruction without writeback changes only the architectural PC. -/
theorem no_write_effect_to (i : Inputs) (s : State) (nextPC : BitVec 32)
    (ready : running s) (hr : i.v_reset = 0) (hs : i.v_stall = 0)
    (hwr : Named.Signals.v_cpu_next_wr i s = 0)
    (hpc : Named.Signals.v_n931 i s = nextPC) :
    project (eval i s).2 = ⟨(project s).regs, nextPC⟩ := by
  rcases ready with ⟨hq, ht, hm⟩
  have hg : Named.Signals.v_n478 i s = 1 := by
    simp [NervSafety.execution_gate, hr, hq, hs, ht]
  have enable : Named.Signals.v_n529 i s = 0 := by
    unfold_nodes v_NervAdd.Named except
      [v_NervAdd.Named.Signals.v_n478, v_NervAdd.Named.Signals.v_cpu_next_wr]
    simp [hg, hm, hwr]
  change project (Named.eval i s).2 = _
  simp only [project, Architecture.mk.injEq]
  refine ⟨register_hold i s enable, ?_⟩
  dsimp only [Named.eval]
  unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_n478, v_NervAdd.Named.Signals.v_n931]
  simp [hg, hr, hq, hpc]

/-- A legal non-load instruction preserves the running phase. -/
theorem running_effect (i : Inputs) (s : State) (ready : running s)
    (hr : i.v_reset = 0) (hs : i.v_stall = 0)
    (hill : Named.Signals.v_n880 i s = 0)
    (hrd : Named.Signals.v_cpu_mem_rd_enable i s = 0) : running (eval i s).2 := by
  rcases ready with ⟨hq, ht, hm⟩
  have hg : Named.Signals.v_n478 i s = 1 := by
    simp [NervSafety.execution_gate, hr, hq, hs, ht]
  change running (Named.eval i s).2
  unfold running
  dsimp only [Named.eval]
  unfold_nodes v_NervAdd.Named except
    [v_NervAdd.Named.Signals.v_n478, v_NervAdd.Named.Signals.v_n880,
     v_NervAdd.Named.Signals.v_cpu_mem_rd_enable]
  simp [hg, hr, hq, hs, ht, hill, hrd]

/-- Every ADD encoding implements the architectural update, including rd/source aliasing. -/
theorem add_step (i : Inputs) (s : State) (h : executesAdd i s) :
    project (eval i s).2 = add i.v_imem_data (project s) := by
  rcases h with ⟨ready, hr, hs, ha⟩
  rcases NervSafety.add_decode i s hr ready.1 ready.2.2 ha with ⟨hd, hw, _, _, _, hp⟩
  have data : Named.Signals.v_cpu_next_rd i s = addResult i.v_imem_data (project s) := by
    simpa [rs1_read, rs2_read, addResult, project] using hd
  exact write_effect i s _ ready hr hs data hw hp

private theorem add_running (i : Inputs) (s : State) (h : executesAdd i s) :
    running (eval i s).2 := by
  rcases h with ⟨ready, hr, hs, ha⟩
  rcases NervSafety.add_decode i s hr ready.1 ready.2.2 ha with ⟨_, _, hi, hm, _, _⟩
  exact running_effect i s ready hr hs hi hm

/-- Reset stays low; instruction data is unrestricted on stalled edges. -/
def allowed (i : Inputs) : Prop :=
  i.v_reset = 0 ∧ (i.v_stall = 1 ∨ NervSafety.isAdd i.v_imem_data)

/-- Independent ADD-only architectural machine; a stalled edge changes nothing. -/
def spec (i : Inputs) (a : Architecture) : Unit × Architecture :=
  ((), if i.v_stall = 1 then a else add i.v_imem_data a)

private theorem step_refinement (i : Inputs) (s : State)
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
    have ha := permit.resolve_left hs
    have h : executesAdd i s := ⟨⟨hq, ht, hm⟩, hr, hs0, ha⟩
    exact ⟨add_running i s h, by simpa [spec, hs] using add_step i s h⟩

/-- Any finite ADD sequence, with arbitrary stalls, agrees on all registers and PC. -/
theorem program_refinement (inputs : List Inputs) (s : State) (ready : running s)
    (permit : ∀ i ∈ inputs, allowed i) :
    project (YosysLean.run eval inputs s) = YosysLean.run spec inputs (project s) := by
  induction inputs generalizing s with
  | nil => rfl
  | cons i rest ih =>
      have ⟨nextReady, next⟩ := step_refinement i s ready (permit i (by simp))
      simp only [YosysLean.run]
      rw [ih _ nextReady (fun j hj ↦ permit j (by simp [hj])), next]

/-- A retirement observation is tied to the pre-execution architecture, not just to itself. -/
def reportMatches (o : Outputs) (w : BitVec 32) (a : Architecture) : Prop :=
  o.v_rvfi_valid = 1 ∧ o.v_rvfi_insn = w ∧
  o.v_rvfi_rs1_addr = w.extractLsb' 15 5 ∧
  o.v_rvfi_rs2_addr = w.extractLsb' 20 5 ∧
  o.v_rvfi_rs1_rdata = a.regs (w.extractLsb' 15 5) ∧
  o.v_rvfi_rs2_rdata = a.regs (w.extractLsb' 20 5) ∧
  o.v_rvfi_rd_addr = w.extractLsb' 7 5 ∧
  o.v_rvfi_rd_wdata = (if w.extractLsb' 7 5 = (0#5) then 0 else addResult w a) ∧
  o.v_rvfi_pc_rdata = a.pc ∧ o.v_rvfi_pc_wdata = a.pc + 4

/-- On the next unstalled edge, RVFI reports the actual ADD read/write and PC effect. -/
theorem retirement (i j : Inputs) (s : State) (h : executesAdd i s)
    (reset : j.v_reset = 0) (stall : j.v_stall = 0) :
    reportMatches (eval j (eval i s).2).1 i.v_imem_data (project s) := by
  rcases h with ⟨⟨hq, ht, hm⟩, hr, hs, ha⟩
  have hg : Named.Signals.v_n478 i s = 1 := by
    simp [NervSafety.execution_gate, hr, hq, hs, ht]
  rcases NervSafety.add_decode i s hr hq hm ha with ⟨hdata, hwr, _, hrd, _, hpc⟩
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
    NervSafety.stored_word, rs1_read, rs2_read, project, addResult]
  by_cases hz : i.v_imem_data.extractLsb' 7 5 = (0#5) <;> simp [hz, BitVec.ofBool]

#check_claim add_step, program_refinement, retirement
end NervArchitecture
