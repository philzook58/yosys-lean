import YosysLean.Check
import YosysLean.Formal
import Examples.Generated.BugCounter
import Examples.Generated.FixedCounter
import Examples.Generated.BugStall
import Examples.Generated.FixedStall
import Examples.Generated.BugShift
import Examples.Generated.FixedShift

/-! Real implementation defects: finite witnesses violate imported RTL assertions while
obeying every imported assumption. The same witnesses satisfy the repaired assertions. -/
namespace BugCounterexamples
set_option maxRecDepth 4096
set_option maxHeartbeats 200000

namespace Counter
open v_BugCounter

def inputs : List Inputs := ⟨1, 0⟩ :: (List.replicate 10 ⟨0, 1⟩ ++ [⟨0, 0⟩])

/-- Reset, ten enabled edges, and a final sample expose count=10. -/
theorem counterexample :
    YosysLean.Counterexample eval initial assumptions assertions inputs default := by
  simp [YosysLean.Counterexample, YosysLean.Along, YosysLean.trace,
    inputs, List.replicate_succ, initial, assumptions, assertions, eval] <;> decide

theorem earlier_samples_pass : YosysLean.Along eval assertions inputs.dropLast default := by
  simp [YosysLean.Along, YosysLean.trace, inputs, List.replicate_succ, assertions, eval] <;> decide

theorem not_safe : ¬YosysLean.Safety eval initial assumptions assertions := counterexample.not_safe

def repaired_inputs : List v_FixedCounter.Inputs := inputs.map (fun i ↦ ⟨i.v_reset, i.v_enable⟩)

theorem repaired_trace_passes :
    v_FixedCounter.initial default ∧
    YosysLean.Along v_FixedCounter.eval v_FixedCounter.assumptions repaired_inputs default ∧
    YosysLean.Along v_FixedCounter.eval v_FixedCounter.assertions repaired_inputs default := by
  simp [YosysLean.Along, YosysLean.trace, repaired_inputs, inputs, List.replicate_succ,
    v_FixedCounter.initial, v_FixedCounter.assumptions,
    v_FixedCounter.assertions, v_FixedCounter.eval] <;> decide
end Counter

namespace Stall
open v_BugStall

def inputs : List Inputs := [⟨1, 0, 0, 0⟩, ⟨0, 1, 0, 42⟩, ⟨0, 1, 0, 99⟩, ⟨0, 0, 0, 0⟩]

/-- A blocked replacement changes an outstanding valid word from 42 to 99. -/
theorem counterexample :
    YosysLean.Counterexample eval initial assumptions assertions inputs default := by
  simp [YosysLean.Counterexample, YosysLean.Along, YosysLean.trace,
    inputs, initial, assumptions, assertions, eval] <;> decide

theorem earlier_samples_pass : YosysLean.Along eval assertions inputs.dropLast default := by
  simp [YosysLean.Along, YosysLean.trace, inputs, assertions, eval] <;> decide

theorem not_safe : ¬YosysLean.Safety eval initial assumptions assertions := counterexample.not_safe

def repaired_inputs : List v_FixedStall.Inputs :=
  inputs.map (fun i ↦ ⟨i.v_reset, i.v_in_valid, i.v_out_ready, i.v_in_data⟩)

theorem repaired_trace_passes :
    v_FixedStall.initial default ∧
    YosysLean.Along v_FixedStall.eval v_FixedStall.assumptions repaired_inputs default ∧
    YosysLean.Along v_FixedStall.eval v_FixedStall.assertions repaired_inputs default := by
  simp [YosysLean.Along, YosysLean.trace, repaired_inputs, inputs,
    v_FixedStall.initial, v_FixedStall.assumptions,
    v_FixedStall.assertions, v_FixedStall.eval] <;> decide
end Stall

namespace Shift
open v_BugShift

def inputs : List Inputs := [⟨0xe0000000, 0x1fffffe2⟩]

/-- RV32 specifies a shift by two; the buggy six-bit amount instead shifts by 34. -/
theorem counterexample :
    YosysLean.Counterexample eval initial (fun _ ↦ True) assertions inputs default := by
  simp [YosysLean.Counterexample, YosysLean.Along, YosysLean.trace,
    inputs, initial, assertions, eval] <;> decide

theorem not_safe : ¬YosysLean.Safety eval initial (fun _ ↦ True) assertions :=
  counterexample.not_safe

def repaired_inputs : List v_FixedShift.Inputs := inputs.map (fun i ↦ ⟨i.v_value, i.v_amount⟩)

theorem repaired_trace_passes :
    v_FixedShift.initial default ∧
    YosysLean.Along v_FixedShift.eval v_FixedShift.assertions repaired_inputs default := by
  simp [YosysLean.Along, YosysLean.trace, repaired_inputs, inputs,
    v_FixedShift.initial, v_FixedShift.assertions, v_FixedShift.eval] <;> decide
end Shift

#check_claim Counter.counterexample, Counter.not_safe, Counter.earlier_samples_pass,
  Counter.repaired_trace_passes, Stall.counterexample, Stall.not_safe,
  Stall.earlier_samples_pass, Stall.repaired_trace_passes, Shift.counterexample, Shift.not_safe,
  Shift.repaired_trace_passes
end BugCounterexamples
