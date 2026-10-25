import Examples.NervFetch

/-! Stored-program execution: the actual request port drives a one-edge synchronous ROM. -/
namespace NervProgram
open NervArchitecture
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

abbrev Program := BitVec 32 → BitVec 32
abbrev Inputs := v_NervFetch.Inputs

/-- CPU state plus the registered instruction-memory response. The ROM is immutable. -/
structure Machine where
  cpu : v_NervFetch.State
  word : BitVec 32
  deriving Inhabited

def drive (i : Inputs) (s : Machine) : Inputs := { i with v_imem_data := s.word }

/-- Memory samples the CPU's actual fetch address, including on a stalled edge. -/
def eval (memory : Program) (i : Inputs) (s : Machine) : v_NervFetch.Outputs × Machine :=
  let (o, next) := v_NervFetch.eval (drive i s) s.cpu
  (o, ⟨next, memory o.v_imem_addr⟩)

def project (s : Machine) : Architecture :=
  NervArchitecture.project (NervFetchBridge.state s.cpu)

/-- The memory response and held request correspond to the current physical PC. -/
def coherent (memory : Program) (s : Machine) : Prop :=
  running (NervFetchBridge.state s.cpu) ∧
  s.cpu.v_cpu_imem_addr_q = s.cpu.v_cpu_pc ∧ s.word = memory s.cpu.v_cpu_pc

/-- The ISA fetches from its own PC, independently of the implementation's request port. -/
def reference (memory : Program) (i : Inputs) (a : Architecture) : Unit × Architecture :=
  ((), if i.v_stall = 1 then a else NervArithmetic.commit (memory a.pc) a)

/-- One real fetch/execute edge preserves memory coherence and the ISA relation. -/
theorem step_correct (memory : Program) (i : Inputs) (s : Machine)
    (h : coherent memory s) (reset : i.v_reset = 0)
    (legal : NervArithmetic.supported (memory s.cpu.v_cpu_pc)) :
    coherent memory (eval memory i s).2 ∧
    project (eval memory i s).2 = (reference memory i (project s)).2 := by
  rcases h with ⟨ready, held, word⟩
  have permit : NervArithmetic.allowed (NervFetchBridge.inputs (drive i s)) := by
    refine ⟨reset, Or.inr ?_⟩
    change NervArithmetic.supported s.word
    rw [word]
    exact legal
  have ⟨nextReady, next⟩ := NervArithmetic.step_refinement
    (NervFetchBridge.inputs (drive i s)) (NervFetchBridge.state s.cpu) ready permit
  have request := NervFetch.request_next_pc (drive i s) s.cpu ready reset held
  constructor
  · change running (NervFetchBridge.state (v_NervFetch.eval (drive i s) s.cpu).2) ∧ _
    refine ⟨?_, ?_, ?_⟩
    · rw [NervFetchBridge.next_agrees]
      exact nextReady
    · exact (NervFetch.held_request (drive i s) s.cpu).trans request
    · exact congrArg memory request
  · change NervArchitecture.project
      (NervFetchBridge.state (v_NervFetch.eval (drive i s) s.cpu).2) = _
    rw [NervFetchBridge.next_agrees, next]
    change (if i.v_stall = 1 then project s else NervArithmetic.commit s.word (project s)) = _
    rw [word]
    rfl

/-- Any-length execution of a ROM containing the supported subset agrees on all registers and PC.
Only reset is constrained in the control stream; stalls, data inputs, and choices are arbitrary. -/
theorem program_refinement (memory : Program)
    (legal : ∀ pc, NervArithmetic.supported (memory pc))
    (controls : List Inputs) (s : Machine) (h : coherent memory s)
    (reset : ∀ i ∈ controls, i.v_reset = 0) :
    coherent memory (YosysLean.run (eval memory) controls s) ∧
    project (YosysLean.run (eval memory) controls s) =
      YosysLean.run (reference memory) controls (project s) := by
  apply YosysLean.run_refinement (eval memory) (reference memory) (coherent memory) project
    (fun i _ ↦ i.v_reset = 0) (fun i s h reset ↦ step_correct memory i s h reset (legal _))
    controls s h
  exact YosysLean.admissible_of_invariant _ _ (fun _ ↦ True) controls
    (fun i hi _ _ ↦ ⟨reset i hi, trivial⟩) _ trivial

/-- Reset plus an unstalled recovery edge primes the ROM at PC=0, from any CPU/ROM state. -/
theorem reset_coherent (memory : Program) (i j : Inputs) (s : Machine)
    (reset : i.v_reset = 1) (release : j.v_reset = 0) (stall : j.v_stall = 0) :
    coherent memory (eval memory j (eval memory i s).2).2 ∧
    (project (eval memory j (eval memory i s).2).2).pc = 0 := by
  let first := (eval memory i s).2
  have ⟨hq, ht, hm⟩ := NervFetch.reset_control (drive i s) s.cpu reset
  have request : (v_NervFetch.eval (drive j first) first.cpu).1.v_imem_addr = 0 :=
    NervFetch.reset_request _ _ hq ht hm stall
  have recovery := NervArithmetic.reset_ready
    (NervFetchBridge.inputs (drive i s)) (NervFetchBridge.inputs (drive j first))
    (NervFetchBridge.state s.cpu) reset release
  have link : NervFetchBridge.state first.cpu =
      (v_NervAdd.eval (NervFetchBridge.inputs (drive i s)) (NervFetchBridge.state s.cpu)).2 :=
    NervFetchBridge.next_agrees _ _
  have ready : running (NervFetchBridge.state
      (v_NervFetch.eval (drive j first) first.cpu).2) := by
    rw [NervFetchBridge.next_agrees, link]
    exact recovery.1
  have pc : (v_NervFetch.eval (drive j first) first.cpu).2.v_cpu_pc = 0 := by
    change (NervFetchBridge.state (v_NervFetch.eval (drive j first) first.cpu).2).v_cpu_pc = 0
    rw [NervFetchBridge.next_agrees, link]
    exact recovery.2
  refine ⟨⟨ready, ?_, ?_⟩, pc⟩
  · change (v_NervFetch.eval (drive j first) first.cpu).2.v_cpu_imem_addr_q = _
    rw [NervFetch.held_request, request]
    exact pc.symm
  · change memory (v_NervFetch.eval (drive j first) first.cpu).1.v_imem_addr = _
    rw [request]
    exact congrArg memory pc.symm

/-- Transfer the next observation through the checked structural bridge. -/
theorem report_view (memory : Program) (i j : Inputs) (s : Machine) :
    NervFetchBridge.outputs (eval memory j (eval memory i s).2).1 =
      (v_NervAdd.eval (NervFetchBridge.inputs (drive j (eval memory i s).2))
        (v_NervAdd.eval (NervFetchBridge.inputs (drive i s))
          (NervFetchBridge.state s.cpu)).2).1 := by
  let first := (eval memory i s).2
  have observation : NervFetchBridge.outputs (v_NervFetch.eval (drive j first) first.cpu).1 =
      (v_NervAdd.eval (NervFetchBridge.inputs (drive j first))
        (NervFetchBridge.state first.cpu)).1 :=
    congrArg Prod.fst (NervFetchBridge.agrees (drive j first) first.cpu)
  change NervFetchBridge.outputs (v_NervFetch.eval (drive j first) first.cpu).1 = _
  have link : NervFetchBridge.state first.cpu =
      (v_NervAdd.eval (NervFetchBridge.inputs (drive i s)) (NervFetchBridge.state s.cpu)).2 :=
    NervFetchBridge.next_agrees _ _
  rw [observation, link]

/-- RVFI describes the instruction obtained from ROM at the actual pre-execution PC. -/
theorem retirement (memory : Program) (i j : Inputs) (s : Machine)
    (h : coherent memory s) (reset : i.v_reset = 0) (stall : i.v_stall = 0)
    (legal : NervArithmetic.supported (memory s.cpu.v_cpu_pc))
    (nextReset : j.v_reset = 0) (nextStall : j.v_stall = 0) :
    NervArithmetic.reportMatches
      (NervFetchBridge.outputs (eval memory j (eval memory i s).2).1)
      (memory (project s).pc) (project s) := by
  let first := (eval memory i s).2
  have legalInput : NervArithmetic.supported
      (NervFetchBridge.inputs (drive i s)).v_imem_data := by
    change NervArithmetic.supported s.word
    rw [h.2.2]
    exact legal
  have report := NervArithmetic.retirement (NervFetchBridge.inputs (drive i s))
    (NervFetchBridge.inputs (drive j first)) (NervFetchBridge.state s.cpu)
    h.1 reset stall legalInput nextReset nextStall
  rw [report_view]
  have word : memory (project s).pc = s.word := h.2.2.symm
  rw [word]
  exact report

/-- Entry claim: arbitrary initial hardware, reset/recovery, then any-length stored execution. -/
theorem from_reset (memory : Program) (legal : ∀ pc, NervArithmetic.supported (memory pc))
    (i j : Inputs) (s : Machine) (reset : i.v_reset = 1) (release : j.v_reset = 0)
    (stall : j.v_stall = 0) (controls : List Inputs)
    (resetLow : ∀ k ∈ controls, k.v_reset = 0) :
    let start := (eval memory j (eval memory i s).2).2
    (project start).pc = 0 ∧ coherent memory (YosysLean.run (eval memory) controls start) ∧
      project (YosysLean.run (eval memory) controls start) =
        YosysLean.run (reference memory) controls (project start) := by
  have ⟨coherence, pc⟩ := reset_coherent memory i j s reset release stall
  exact ⟨pc, program_refinement memory legal controls _ coherence resetLow⟩

#check_claim step_correct, program_refinement, reset_coherent, retirement, from_reset
end NervProgram
