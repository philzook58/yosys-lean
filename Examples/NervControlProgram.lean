import Examples.NervProgram
import Examples.NervControl

/-! Stored-program control flow. Admission is checked on the independent ISA execution. -/
namespace NervControlProgram
open NervProgram NervArchitecture
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

/-- The ISA obtains its instruction from its own PC, including after jumps and branches. -/
def reference (memory : Program) (i : Inputs) (a : Architecture) : Unit × Architecture :=
  ((), if i.v_stall = 1 then a else NervControl.execute (memory a.pc) a)

/-- A reference execution stays in the supported, aligned subset. This mentions no CPU state.
Unsupported words in unvisited ROM locations are permitted. A stalled edge executes nothing. -/
def admitted (memory : Program) : List Inputs → Architecture → Prop :=
  YosysLean.Admissible (reference memory) (fun i a ↦ i.v_reset = 0 ∧
    (i.v_stall = 1 ∨ NervControl.valid (memory a.pc) a))

/-- Normal execution at the real fetch port agrees with a safe ISA step. -/
theorem step_correct (memory : Program) (i : Inputs) (s : Machine)
    (h : coherent memory s) (reset : i.v_reset = 0)
    (permit : i.v_stall = 1 ∨ NervControl.valid (memory (NervProgram.project s).pc)
      (NervProgram.project s)) :
    coherent memory (eval memory i s).2 ∧
    NervProgram.project (eval memory i s).2 =
      (reference memory i (NervProgram.project s)).2 := by
  rcases h with ⟨ready, held, word⟩
  have legal : (NervFetchBridge.inputs (drive i s)).v_stall = 1 ∨
      NervControl.valid (NervFetchBridge.inputs (drive i s)).v_imem_data
        (NervArchitecture.project (NervFetchBridge.state s.cpu)) := by
    rcases permit with stall | permit
    · exact Or.inl stall
    · apply Or.inr
      change NervControl.valid s.word (NervProgram.project s)
      rw [word]
      exact permit
  have ⟨nextReady, next⟩ := NervControl.step_refinement
    (NervFetchBridge.inputs (drive i s)) (NervFetchBridge.state s.cpu) ready reset legal
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
    change (if i.v_stall = 1 then NervProgram.project s
      else NervControl.execute s.word (NervProgram.project s)) = _
    rw [word]
    rfl

/-- Any-length safe ISA execution agrees with the physical CPU, through actual ROM requests. -/
theorem program_refinement (memory : Program) (controls : List Inputs) (s : Machine)
    (h : coherent memory s) (permit : admitted memory controls (NervProgram.project s)) :
    coherent memory (YosysLean.run (eval memory) controls s) ∧
    NervProgram.project (YosysLean.run (eval memory) controls s) =
      YosysLean.run (reference memory) controls (NervProgram.project s) := by
  exact YosysLean.run_refinement (eval memory) (reference memory)
    (coherent memory) NervProgram.project _
    (fun i s ready permit ↦ step_correct memory i s ready permit.1 permit.2)
    controls s h permit

/-- Retirement is tied to the fetched word, pre-execution registers, and selected next PC. -/
theorem retirement (memory : Program) (i j : Inputs) (s : Machine)
    (h : coherent memory s) (reset : i.v_reset = 0) (stall : i.v_stall = 0)
    (legal : NervControl.valid (memory (NervProgram.project s).pc) (NervProgram.project s))
    (nextReset : j.v_reset = 0) (nextStall : j.v_stall = 0) :
    NervControl.reportMatches
      (NervFetchBridge.outputs (eval memory j (eval memory i s).2).1)
      (memory (NervProgram.project s).pc) (NervProgram.project s) := by
  have word : memory (NervProgram.project s).pc = s.word := h.2.2.symm
  have legalInput : NervControl.valid
      (NervFetchBridge.inputs (drive i s)).v_imem_data
      (NervArchitecture.project (NervFetchBridge.state s.cpu)) := by
    change NervControl.valid s.word (NervProgram.project s)
    rw [← word]
    exact legal
  have report := NervControl.retirement (NervFetchBridge.inputs (drive i s))
    (NervFetchBridge.inputs (drive j (eval memory i s).2)) (NervFetchBridge.state s.cpu)
    h.1 reset stall legalInput nextReset nextStall
  rw [NervProgram.report_view, word]
  exact report

/-- Entry claim: reset establishes PC=0; the reference-program premise
is independent of hardware. -/
theorem from_reset (memory : Program) (controls : List Inputs)
    (permit : ∀ a : Architecture, a.pc = 0 → a.regs 0 = 0 → admitted memory controls a)
    (i j : Inputs) (s : Machine) (reset : i.v_reset = 1) (release : j.v_reset = 0)
    (stall : j.v_stall = 0) :
    let start := (eval memory j (eval memory i s).2).2
    (NervProgram.project start).pc = 0 ∧
      coherent memory (YosysLean.run (eval memory) controls start) ∧
      NervProgram.project (YosysLean.run (eval memory) controls start) =
        YosysLean.run (reference memory) controls (NervProgram.project start) := by
  have ⟨coherence, pc⟩ := NervProgram.reset_coherent memory i j s reset release stall
  exact ⟨pc, program_refinement memory controls _ coherence (permit _ pc rfl)⟩

#check_claim step_correct, program_refinement, retirement, from_reset
end NervControlProgram
