import YosysLean.Check
import Examples.HackSpec
import Examples.Generated.Hack
import Examples.Generated.Original
import Std.Tactic

namespace HackProofs

def abstractState (s : v_Hack.State) : HackSpec.State :=
  { a := s.v_areg, d := s.v_dreg, pc := s.v_PC.setWidth 15 }

def abstractInput (i : v_Hack.Inputs) : HackSpec.Inputs :=
  { instruction := i.v_instruction, memory := i.v_inM, resetN := i.v_reset == 1 }

def observe (o : v_Hack.Outputs) : HackSpec.Outputs :=
  { value := o.v_outM, write := o.v_writeM == 1, address := o.v_addressM,
    pc := o.v_PC.setWidth 15 }

def reference (i : v_Hack.Inputs) (s : HackSpec.State) :=
  HackSpec.eval (abstractInput i) s

set_option maxRecDepth 8192
set_option maxHeartbeats 100000
set_option pp.deepTerms false

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

/-- Every repaired circuit edge agrees with an architectural instruction, including reset. -/
theorem next_correct (i : v_Hack.Inputs) (s : v_Hack.State) :
    abstractState (v_Hack.eval i s).2 = (reference i (abstractState s)).2 := by
  cases i
  cases s
  simp only [abstractState, abstractInput, reference, v_Hack.eval, HackSpec.eval, HackSpec.alu]
  congr 1 <;>
    (try simp only [extract_if, extract_append, width_if]) <;>
    (try simp [bit_one, BitVec.setWidth_eq_extractLsb']) <;> grind

/-- The memory interface and current PC are also covered, not just internal registers. -/
theorem outputs_correct (i : v_Hack.Inputs) (s : v_Hack.State) :
    observe (v_Hack.eval i s).1 = (reference i (abstractState s)).1 := by
  cases i
  cases s
  simp only [abstractState, abstractInput, observe, reference, v_Hack.eval,
    HackSpec.eval, HackSpec.alu]
  congr 1 <;>
    (try simp only [extract_if, extract_append, bit_one_bool]) <;>
    (try simp [Bool.and_comm]) <;> grind

/-- The RTL supplies no initial values; this proof does not assume zeroed registers. -/
theorem initial_unconstrained (s : v_Hack.State) : v_Hack.initial s := by
  simp [v_Hack.initial]

/-- Architectural agreement for every finite number of instructions and every input sequence. -/
theorem run_correct (inputs : List v_Hack.Inputs) (s : v_Hack.State) :
    abstractState (YosysLean.run v_Hack.eval inputs s) =
      YosysLean.run reference inputs (abstractState s) := by
  induction inputs generalizing s with
  | nil => rfl
  | cons i rest ih =>
    change abstractState (YosysLean.run v_Hack.eval rest (v_Hack.eval i s).2) =
      YosysLean.run reference rest (reference i (abstractState s)).2
    rw [ih, next_correct]

/-- The whole observable trace agrees at arbitrary execution lengths. -/
theorem trace_correct (inputs : List v_Hack.Inputs) (s : v_Hack.State) :
    (YosysLean.trace v_Hack.eval inputs s).map observe =
      YosysLean.trace reference inputs (abstractState s) := by
  induction inputs generalizing s with
  | nil => rfl
  | cons i rest ih =>
    simp only [YosysLean.trace, List.map_cons, outputs_correct, ih, next_correct]

/-- The original circuit fails @1 with zero A/D: the subsequent memory address stays zero. -/
theorem original_counterexample :
    (v_CPU.eval { v_instruction := 1, v_inM := 0, v_reset := 1 }
      { v_areg := 0, v_dreg := 0, v_PC := 0 }).2.v_areg = 0 ∧
    (HackSpec.eval { instruction := 1, memory := 0, resetN := true }
      { a := 0, d := 0, pc := 0 }).2.a = 1 := by
  decide

/-- A minimal ROM: @2; D=A; @3; D=D+A; @0; M=D. -/
def rom (pc : BitVec 15) : BitVec 16 :=
  match pc.toNat with
  | 0 => 2
  | 1 => 0xec10
  | 2 => 3
  | 3 => 0xe090
  | 4 => 0
  | 5 => 0xe308
  | _ => 0

abbrev RAM := BitVec 15 → BitVec 16

/-- ROM and RAM are supplied by the harness, rather than expanded into circuit gates. -/
def closedStep (_ : Unit) (s : v_Hack.State × RAM) : Unit × (v_Hack.State × RAM) :=
  let (cpu, ram) := s
  let inputs : v_Hack.Inputs :=
    { v_reset := 1, v_instruction := rom (cpu.v_PC.setWidth 15),
      v_inM := ram (cpu.v_areg.setWidth 15) }
  let (o, next) := v_Hack.eval inputs cpu
  let ram := if o.v_writeM == 1 then
    fun addr ↦ if addr == o.v_addressM then o.v_outM else ram addr
    else ram
  ((), (next, ram))

def programResult : BitVec 16 :=
  let initial : v_Hack.State × RAM :=
    ({ v_areg := 0, v_dreg := 0, v_PC := 0 }, fun _ ↦ 0)
  (YosysLean.run closedStep (List.replicate 6 ()) initial).2 0

/-- Kernel-checked execution of the generated circuit with a complete memory environment. -/
theorem program_stores_five : programResult = 5 := by decide

#check_claim next_correct, outputs_correct, initial_unconstrained, run_correct, trace_correct,
  original_counterexample, program_stores_five, YosysLean.run_simulation,
  YosysLean.run_invariant, YosysLean.reachable_invariant

end HackProofs
