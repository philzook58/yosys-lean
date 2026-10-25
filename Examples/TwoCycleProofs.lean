import YosysLean.Check
import Examples.HackProofs
import Examples.Generated.TwoCycle

/-! Fetch steps stutter; execute steps retire one Hack instruction. -/
namespace TwoCycleProofs

abbrev Inputs := v_HackTwoCycle.Inputs
abbrev State := v_HackTwoCycle.State

def architectural (s : State) : HackSpec.State :=
  { a := s.v_areg, d := s.v_dreg, pc := s.v_PC.setWidth 15 }

def observe (o : v_HackTwoCycle.Outputs) : HackSpec.Outputs :=
  { value := o.v_outM, write := o.v_writeM == 1, address := o.v_addressM,
    pc := o.v_PC.setWidth 15 }

def instructionInput (instruction memory : BitVec 16) : HackSpec.Inputs :=
  { instruction, memory, resetN := true }

/-- The intermediate state records exactly the instruction supplied on the fetch edge. -/
def fetched (i : Inputs) (s : State) : State :=
  { s with v_ir := i.v_instruction, v_execute := 1 }

set_option maxRecDepth 8192
set_option maxHeartbeats 200000

private theorem bit_one (x : BitVec 1) : (x = 1#1) ↔ x.getLsbD 0 = true := by
  rw [BitVec.getLsbD_eq_extractLsb']
  simp

private theorem bit_one_bool (x : BitVec 1) : (x == 1) = x.getLsbD 0 := by
  simpa using (BitVec.getLsbD_eq_extractLsb' x 0).symm

private theorem extract_if (c : Prop) [Decidable c] (a b : BitVec w) (lo len : Nat) :
    (if c then a else b).extractLsb' lo len =
      if c then a.extractLsb' lo len else b.extractLsb' lo len := by
  split <;> rfl

private theorem width_if (c : Prop) [Decidable c] (a b : BitVec w) (len : Nat) :
    (if c then a else b).setWidth len =
      if c then a.setWidth len else b.setWidth len := by
  split <;> rfl

private theorem extract_append (a b : BitVec 16) :
    BitVec.extractLsb' 0 16 (BitVec.append a b) = b :=
  BitVec.extractLsb'_append_eq_right

/-- Initialization constrains only the phase; architectural registers and IR remain arbitrary. -/
theorem initial_iff (s : State) : v_HackTwoCycle.initial s ↔ s.v_execute = 0 := by
  have mask (x : BitVec 1) : x &&& 1#1 = x := BitVec.and_allOnes
  simp [v_HackTwoCycle.initial, mask]

/-- Fetch changes IR and phase, preserves architectural state, and produces no retirement/write. -/
theorem fetch_correct (i : Inputs) (s : State) (reset : i.v_reset = 1)
    (phase : s.v_execute = 0) :
    (v_HackTwoCycle.eval i s).2 = fetched i s ∧
    (v_HackTwoCycle.eval i s).1.v_retire = 0 ∧
    (v_HackTwoCycle.eval i s).1.v_writeM = 0 := by
  cases i
  cases s
  simp_all [v_HackTwoCycle.eval, fetched]

/-- Architectural equality at a fetch edge is the stuttering part of the simulation. -/
theorem fetch_stutters (i : Inputs) (s : State) (reset : i.v_reset = 1)
    (phase : s.v_execute = 0) :
    architectural (v_HackTwoCycle.eval i s).2 = architectural s := by
  rw [(fetch_correct i s reset phase).1]
  rfl

/-- Execute uses latched IR and current memory data; the external instruction is unrestricted. -/
theorem execute_correct (i : Inputs) (s : State) (reset : i.v_reset = 1)
    (phase : s.v_execute = 1) :
    architectural (v_HackTwoCycle.eval i s).2 =
      (HackSpec.eval (instructionInput s.v_ir i.v_inM) (architectural s)).2 ∧
    observe (v_HackTwoCycle.eval i s).1 =
      (HackSpec.eval (instructionInput s.v_ir i.v_inM) (architectural s)).1 ∧
    (v_HackTwoCycle.eval i s).2.v_execute = 0 ∧
    (v_HackTwoCycle.eval i s).1.v_retire = 1 := by
  rcases i with ⟨r, insn, memory⟩
  rcases s with ⟨d, ir, ex, a, pc⟩
  dsimp only at reset phase
  subst r
  subst ex
  simp only [v_HackTwoCycle.eval, architectural, observe, instructionInput,
    HackSpec.eval, HackSpec.alu]
  constructor
  · congr 1 <;>
      (try simp only [extract_if, extract_append, width_if]) <;>
      (try simp [bit_one, BitVec.setWidth_eq_extractLsb']) <;> grind
  · constructor
    · congr 1 <;>
        (try simp only [extract_if, extract_append, bit_one_bool]) <;>
        (try simp [Bool.and_comm]) <;> grind
    · constructor <;> rfl

/-- Reset aborts either phase without committing an instruction or touching A, D, or IR. -/
theorem reset_correct (i : Inputs) (s : State) (reset : i.v_reset = 0) :
    (v_HackTwoCycle.eval i s).2 = { s with v_PC := 0, v_execute := 0 } ∧
    (v_HackTwoCycle.eval i s).1.v_retire = 0 ∧
    (v_HackTwoCycle.eval i s).1.v_writeM = 0 := by
  cases i
  cases s
  simp_all [v_HackTwoCycle.eval]

/-- Complete fetch/execute pair, allowing different instructions and memory data on each edge. -/
theorem pair_correct (f e : Inputs) (s : State) (rf : f.v_reset = 1)
    (re : e.v_reset = 1) (phase : s.v_execute = 0) :
    let middle := (v_HackTwoCycle.eval f s).2
    let result := v_HackTwoCycle.eval e middle
    architectural result.2 =
      (HackSpec.eval (instructionInput f.v_instruction e.v_inM) (architectural s)).2 ∧
    observe result.1 =
      (HackSpec.eval (instructionInput f.v_instruction e.v_inM) (architectural s)).1 ∧
    result.2.v_execute = 0 ∧ result.1.v_retire = 1 := by
  rw [(fetch_correct f s rf phase).1]
  exact execute_correct e (fetched f s) re rfl

/-- Architectural registers for comparing with the existing single-cycle circuit. -/
def singleState (s : State) : v_Hack.State :=
  { v_areg := s.v_areg, v_dreg := s.v_dreg, v_PC := s.v_PC }

/-- Two physical edges match one step of the existing generated single-cycle CPU. -/
theorem pair_matches_single (f e : Inputs) (s : State) (rf : f.v_reset = 1)
    (re : e.v_reset = 1) (phase : s.v_execute = 0) :
    architectural (v_HackTwoCycle.eval e (v_HackTwoCycle.eval f s).2).2 =
      HackProofs.abstractState (v_Hack.eval
        { v_reset := 1, v_instruction := f.v_instruction, v_inM := e.v_inM }
        (singleState s)).2 := by
  rw [(pair_correct f e s rf re phase).1, HackProofs.next_correct]
  rfl

/-- The retirement event matches the single-cycle circuit's observable memory interface and PC. -/
theorem pair_outputs_match_single (f e : Inputs) (s : State) (rf : f.v_reset = 1)
    (re : e.v_reset = 1) (phase : s.v_execute = 0) :
    observe (v_HackTwoCycle.eval e (v_HackTwoCycle.eval f s).2).1 =
      HackProofs.observe (v_Hack.eval
        { v_reset := 1, v_instruction := f.v_instruction, v_inM := e.v_inM }
        (singleState s)).1 := by
  rw [(pair_correct f e s rf re phase).2.1, HackProofs.outputs_correct]
  rfl

/-- Completed instructions: take the fetch instruction and the following execute memory sample.
An unmatched final fetch is intentionally absent from the architectural execution. -/
def completed : List Inputs → List HackSpec.Inputs
  | f :: e :: rest => instructionInput f.v_instruction e.v_inM :: completed rest
  | _ => []

/-- Physical output trace with silent clock edges removed using the actual RTL retirement port. -/
def retiredTrace : List Inputs → State → List HackSpec.Outputs
  | [], _ => []
  | i :: rest, s =>
    let (o, next) := v_HackTwoCycle.eval i s
    if o.v_retire == 1 then observe o :: retiredTrace rest next else retiredTrace rest next

private theorem pairs_induction {P : List α → Prop} (empty : P [])
    (single : ∀ i, P [i]) (pair : ∀ i j rest, P rest → P (i :: j :: rest)) : ∀ xs, P xs
  | [] => empty
  | [i] => single i
  | i :: j :: rest => pair i j rest (pairs_induction empty single pair rest)

/-- Unbounded state correspondence, including an odd final fetch and arbitrary initial registers. -/
theorem run_correct (cycles : List Inputs) (s : State) (phase : s.v_execute = 0)
    (normal : ∀ i ∈ cycles, i.v_reset = 1) :
    architectural (YosysLean.run v_HackTwoCycle.eval cycles s) =
      YosysLean.run HackSpec.eval (completed cycles) (architectural s) := by
  induction cycles using pairs_induction generalizing s with
  | empty => rfl
  | single f =>
    simpa [YosysLean.run, completed] using fetch_stutters f s (normal f (by simp)) phase
  | pair f e rest ih =>
    have hp := pair_correct f e s (normal f (by simp)) (normal e (by simp)) phase
    have hr : ∀ i ∈ rest, i.v_reset = 1 := fun i hi ↦ normal i (by simp [hi])
    change architectural (YosysLean.run v_HackTwoCycle.eval rest
      (v_HackTwoCycle.eval e (v_HackTwoCycle.eval f s).2).2) =
      YosysLean.run HackSpec.eval (completed rest)
        (HackSpec.eval (instructionInput f.v_instruction e.v_inM) (architectural s)).2
    rw [ih _ hp.2.2.1 hr, hp.1]

/-- Every finite physical execution has exactly the architectural trace after hiding fetch edges. -/
theorem trace_correct (cycles : List Inputs) (s : State) (phase : s.v_execute = 0)
    (normal : ∀ i ∈ cycles, i.v_reset = 1) :
    retiredTrace cycles s = YosysLean.trace HackSpec.eval (completed cycles) (architectural s) := by
  induction cycles using pairs_induction generalizing s with
  | empty => rfl
  | single f =>
    simp [retiredTrace, (fetch_correct f s (normal f (by simp)) phase).2.1,
      completed, YosysLean.trace]
  | pair f e rest ih =>
    have hf := fetch_correct f s (normal f (by simp)) phase
    have hp := pair_correct f e s (normal f (by simp)) (normal e (by simp)) phase
    have hr : ∀ i ∈ rest, i.v_reset = 1 := fun i hi ↦ normal i (by simp [hi])
    have strip : retiredTrace (f :: e :: rest) s =
        observe (v_HackTwoCycle.eval e (v_HackTwoCycle.eval f s).2).1 ::
          retiredTrace rest (v_HackTwoCycle.eval e (v_HackTwoCycle.eval f s).2).2 := by
      simp [retiredTrace, hf.2.1, hp.2.2.2]
    rw [strip, ih _ hp.2.2.1 hr, hp.2.1, hp.1]
    rfl

private theorem completed_length (cycles : List Inputs) :
    (completed cycles).length = cycles.length / 2 := by
  induction cycles using pairs_induction with
  | empty => rfl
  | single => simp [completed]
  | pair f e rest ih =>
    simp only [completed, List.length_cons, ih]
    omega

private theorem trace_length (eval : I → S → O × S) (inputs : List I) (s : S) :
    (YosysLean.trace eval inputs s).length = inputs.length := by
  induction inputs generalizing s with
  | nil => rfl
  | cons i rest ih => simp [YosysLean.trace, ih]

/-- Progress is explicit: reset-free execution retires exactly one instruction per two edges. -/
theorem retirement_count (cycles : List Inputs) (s : State) (phase : s.v_execute = 0)
    (normal : ∀ i ∈ cycles, i.v_reset = 1) :
    (retiredTrace cycles s).length = cycles.length / 2 := by
  rw [trace_correct cycles s phase normal, trace_length, completed_length]

/-- A closed ROM/RAM environment using exactly the same program as the single-cycle example. -/
def closedStep (_ : Unit) (s : State × HackProofs.RAM) : Unit × (State × HackProofs.RAM) :=
  let (cpu, ram) := s
  let i : Inputs :=
    { v_reset := 1, v_instruction := HackProofs.rom (cpu.v_PC.setWidth 15),
      v_inM := ram (cpu.v_areg.setWidth 15) }
  let (o, next) := v_HackTwoCycle.eval i cpu
  let ram := if o.v_writeM == 1 then
    fun addr ↦ if addr == o.v_addressM then o.v_outM else ram addr
    else ram
  ((), (next, ram))

def programResult (cycles : Nat) : BitVec 16 :=
  let initial : State × HackProofs.RAM :=
    ({ v_areg := 0, v_dreg := 0, v_PC := 0, v_ir := 0, v_execute := 0 }, fun _ ↦ 0)
  (YosysLean.run closedStep (List.replicate cycles ()) initial).2 0

/-- The six-instruction program needs twelve edges; its final fetch does not write early. -/
theorem program_stores_five : programResult 11 = 0 ∧ programResult 12 = 5 := by decide

#check_claim initial_iff, fetch_correct, fetch_stutters, execute_correct, reset_correct,
  pair_correct, pair_matches_single, pair_outputs_match_single, run_correct, trace_correct,
  retirement_count, program_stores_five

end TwoCycleProofs
