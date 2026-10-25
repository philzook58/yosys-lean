import YosysLean.Check
import YosysLean.Formal
import Examples.Generated.SMTIncrement
import Examples.Generated.SBYCounter
import Examples.Generated.EQYFSM
import Examples.Generated.EQYFSMBad
import Lean.Elab.Tactic.Omega

/-! The conclusions are the assertions imported from upstream RTL and a Verilog miter.
Local invariants strengthen those properties; they do not replace their statements. -/
namespace FormalTutorialProofs
set_option maxRecDepth 4096
set_option maxHeartbeats 200000

namespace SMTIncrement
open v_SMTIncrement

def invariant (s : State) : Prop := s.v__initstate = 1 ∨ s.v_cnt.toNat ≤ 11

theorem base (s : State) (h : initial s) : invariant s := by
  rcases s with ⟨first, count⟩
  revert first count
  unfold initial invariant
  decide

theorem step (i : Inputs) (s : State) (h : invariant s)
    (a : assumptions (eval i s).1) : invariant (eval i s).2 := by
  rcases i with ⟨addtwo⟩
  rcases s with ⟨first, count⟩
  revert addtwo first count
  unfold invariant assumptions eval
  decide

theorem sound (i : Inputs) (s : State) (h : invariant s)
    (a : assumptions (eval i s).1) : assertions (eval i s).1 := by
  rcases i with ⟨addtwo⟩
  rcases s with ⟨first, count⟩
  revert addtwo first count
  unfold invariant assumptions assertions eval
  decide

/-- Upstream `assert property (cnt != 15)` for every execution allowed by its initial assume. -/
theorem safe : YosysLean.Safety eval initial assumptions assertions :=
  YosysLean.safety_of_invariant eval initial invariant assumptions assertions base step sound
end SMTIncrement

namespace SBYCounter
open v_SBYCounter

def invariant (s : State) : Prop := s.v_counter.toNat ≤ 15

theorem base (s : State) (h : initial s) : invariant s := by
  rcases s with ⟨count⟩
  revert count
  unfold initial invariant
  decide

theorem step (i : Inputs) (s : State) (h : invariant s) (_ : True) :
    invariant (eval i s).2 := by
  rcases i with ⟨⟩
  rcases s with ⟨count⟩
  revert count
  unfold invariant eval
  decide

theorem sound (i : Inputs) (s : State) (h : invariant s) (_ : True) :
    assertions (eval i s).1 := by
  rcases i with ⟨⟩
  rcases s with ⟨count⟩
  revert count
  unfold invariant assertions eval
  decide

/-- The original clocked `assert(counter < 32)` holds for arbitrary finite executions. -/
theorem safe : YosysLean.Safety eval initial (fun _ ↦ True) assertions :=
  YosysLean.safety_of_invariant eval initial invariant (fun _ ↦ True) assertions base step sound
end SBYCounter

namespace EQYFSM
open v_EQYFSM

def encoding (s : State) : Prop :=
  (s.v_gold_currentstate = 1 ∧ s.v_gate_currentstate = 0) ∨
  (s.v_gold_currentstate = 2 ∧ s.v_gate_currentstate = 1) ∨
  (s.v_gold_currentstate = 4 ∧ s.v_gate_currentstate = 2) ∨
  (s.v_gold_currentstate = 8 ∧ s.v_gate_currentstate = 3)

def invariant (s : State) : Prop :=
  encoding s ∧ (s.v_started = 1 → s.v_gold_o = s.v_gate_o)

theorem base (s : State) (h : initial s) : invariant s := by
  simp [initial] at h
  rcases h with ⟨gold, gate, started⟩
  have g : s.v_gold_currentstate = 1 := (BitVec.and_allOnes).symm.trans gold
  have t : s.v_gate_currentstate = 0 := (BitVec.and_allOnes).symm.trans gate
  have off : s.v_started = 0 := (BitVec.and_allOnes).symm.trans started
  simp [invariant, encoding, g, t, off]

theorem step (i : Inputs) (s : State) (h : invariant s) (_ : True) :
    invariant (eval i s).2 := by
  rcases h.1 with ⟨gold, gate⟩ | ⟨gold, gate⟩ | ⟨gold, gate⟩ | ⟨gold, gate⟩ <;>
    simp [invariant, encoding, eval, gold, gate]

theorem sound (i : Inputs) (s : State) (h : invariant s) (_ : True) :
    assertions (eval i s).1 := by
  have bits : ∀ x : BitVec 1, x = 0 ∨ x = 1 := by decide
  rcases bits s.v_started with off | on
  · simp [assertions, eval, off]
  · have equal := h.2 on
    simp [assertions, eval, on, equal]

/-- Imported miter assertion: the upstream one-hot and binary FSM outputs agree after one edge. -/
theorem safe : YosysLean.Safety eval initial (fun _ ↦ True) assertions :=
  YosysLean.safety_of_invariant eval initial invariant (fun _ ↦ True) assertions base step sound
end EQYFSM

/-- Negative control changes the Verilog assertion; Lean certifies an actual failing sampled output. -/
theorem bad_miter :
    let s : v_EQYFSMBad.State :=
      { v_gold_currentstate := 1, v_gate_currentstate := 0,
        v_gold_o := 0, v_gate_o := 0, v_started := 0 }
    v_EQYFSMBad.initial s ∧
      ¬v_EQYFSMBad.assertions (v_EQYFSMBad.eval {} (v_EQYFSMBad.eval {} s).2).1 := by
  unfold v_EQYFSMBad.initial v_EQYFSMBad.assertions
  decide

/-- Without the imported initial assumption, the original SMTBMC assertion can fail immediately. -/
theorem assumption_is_needed :
    let s : v_SMTIncrement.State := { v__initstate := 1, v_cnt := 15 }
    v_SMTIncrement.initial s ∧
      ¬v_SMTIncrement.assumptions (v_SMTIncrement.eval ⟨0⟩ s).1 ∧
      ¬v_SMTIncrement.assertions (v_SMTIncrement.eval ⟨0⟩ s).1 := by
  unfold v_SMTIncrement.initial v_SMTIncrement.assumptions v_SMTIncrement.assertions
  decide

#check_claim SMTIncrement.safe, SBYCounter.safe, EQYFSM.safe, bad_miter, assumption_is_needed
end FormalTutorialProofs
