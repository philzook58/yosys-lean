import Examples.BugCounterexamples

/-! Print the exact Lean-certified counterexample traces and their repaired counterparts. -/
namespace ReplayCounterexamples

instance counterAssumptions (o : v_BugCounter.Outputs) :
    Decidable (v_BugCounter.assumptions o) := by
  unfold v_BugCounter.assumptions; infer_instance
instance counterAssertions (o : v_BugCounter.Outputs) :
    Decidable (v_BugCounter.assertions o) := by
  unfold v_BugCounter.assertions; infer_instance
instance fixedCounterAssumptions (o : v_FixedCounter.Outputs) :
    Decidable (v_FixedCounter.assumptions o) := by
  unfold v_FixedCounter.assumptions; infer_instance
instance fixedCounterAssertions (o : v_FixedCounter.Outputs) :
    Decidable (v_FixedCounter.assertions o) := by
  unfold v_FixedCounter.assertions; infer_instance
instance stallAssumptions (o : v_BugStall.Outputs) :
    Decidable (v_BugStall.assumptions o) := by
  unfold v_BugStall.assumptions; infer_instance
instance stallAssertions (o : v_BugStall.Outputs) :
    Decidable (v_BugStall.assertions o) := by
  unfold v_BugStall.assertions; infer_instance
instance fixedStallAssumptions (o : v_FixedStall.Outputs) :
    Decidable (v_FixedStall.assumptions o) := by
  unfold v_FixedStall.assumptions; infer_instance
instance fixedStallAssertions (o : v_FixedStall.Outputs) :
    Decidable (v_FixedStall.assertions o) := by
  unfold v_FixedStall.assertions; infer_instance
instance shiftAssertions (o : v_BugShift.Outputs) :
    Decidable (v_BugShift.assertions o) := by
  unfold v_BugShift.assertions; infer_instance
instance fixedShiftAssertions (o : v_FixedShift.Outputs) :
    Decidable (v_FixedShift.assertions o) := by
  unfold v_FixedShift.assertions; infer_instance

private def replay (name header : String) (eval : I → S → O × S)
    (assumptions assertions : O → Prop) [DecidablePred assumptions] [DecidablePred assertions]
    (inputs : List I) (initial : S) (describe : I → S → O → String) : IO Unit := do
  IO.println s!"CASE {name}"
  IO.println s!"sample,{header},assumptions,assertions"
  let mut state := initial
  let mut sample := 0
  for i in inputs do
    let (o, next) := eval i state
    let a := if assumptions o then 1 else 0
    let p := if assertions o then 1 else 0
    IO.println s!"{sample},{describe i state o},{a},{p}"
    state := next
    sample := sample + 1

end ReplayCounterexamples

open ReplayCounterexamples

def main : IO Unit := do
  replay "BugCounter" "reset,enable,count" v_BugCounter.eval
    v_BugCounter.assumptions v_BugCounter.assertions BugCounterexamples.Counter.inputs default
    (fun i _ o ↦ s!"{i.v_reset.toNat},{i.v_enable.toNat},{o.v_count.toNat}")
  replay "FixedCounter" "reset,enable,count" v_FixedCounter.eval
    v_FixedCounter.assumptions v_FixedCounter.assertions
    BugCounterexamples.Counter.repaired_inputs default
    (fun i _ o ↦ s!"{i.v_reset.toNat},{i.v_enable.toNat},{o.v_count.toNat}")
  replay "BugStall" "reset,in_valid,out_ready,in_data,in_ready,out_valid,out_data" v_BugStall.eval
    v_BugStall.assumptions v_BugStall.assertions BugCounterexamples.Stall.inputs default
    (fun i _ o ↦ s!"{i.v_reset.toNat},{i.v_in_valid.toNat},{i.v_out_ready.toNat},"
      ++ s!"{i.v_in_data.toNat},"
      ++ s!"{o.v_in_ready.toNat},{o.v_out_valid.toNat},{o.v_out_data.toNat}")
  replay "FixedStall" "reset,in_valid,out_ready,in_data,in_ready,out_valid,out_data"
    v_FixedStall.eval
    v_FixedStall.assumptions v_FixedStall.assertions
    BugCounterexamples.Stall.repaired_inputs default
    (fun i _ o ↦ s!"{i.v_reset.toNat},{i.v_in_valid.toNat},{i.v_out_ready.toNat},"
      ++ s!"{i.v_in_data.toNat},"
      ++ s!"{o.v_in_ready.toNat},{o.v_out_valid.toNat},{o.v_out_data.toNat}")
  replay "BugShift" "value,amount,result" v_BugShift.eval
    (fun _ ↦ True) v_BugShift.assertions BugCounterexamples.Shift.inputs default
    (fun i _ o ↦ s!"{i.v_value.toNat},{i.v_amount.toNat},{o.v_result.toNat}")
  replay "FixedShift" "value,amount,result" v_FixedShift.eval
    (fun _ ↦ True) v_FixedShift.assertions BugCounterexamples.Shift.repaired_inputs default
    (fun i _ o ↦ s!"{i.v_value.toNat},{i.v_amount.toNat},{o.v_result.toNat}")
