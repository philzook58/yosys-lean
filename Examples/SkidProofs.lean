import YosysLean.Check
import Examples.Generated.ZipSkid

/-! Ordered stream conservation for the unchanged 32-bit, unregistered-output ZipCPU skid buffer. -/
namespace SkidProofs
open v_ZipSkid

private theorem bit_cases (b : BitVec 1) : b = 0 ∨ b = 1 := by revert b; decide

/-- Words buffered in the physical register; invalid data is ignored. -/
def pending (s : State) : List (BitVec 32) :=
  if s.v_LOGIC_r_valid == 1 then [s.v_LOGIC_r_data] else []

/-- Input handshakes, counted outside reset. -/
def take (i : Inputs) (s : State) : List (BitVec 32) :=
  if i.v_i_reset == 0 && i.v_i_valid == 1 && (eval i s).1.v_o_ready == 1 then
    [i.v_i_data] else []

/-- Output handshakes, counted outside reset. -/
def give (i : Inputs) (s : State) : List (BitVec 32) :=
  if i.v_i_reset == 0 && i.v_i_ready == 1 && (eval i s).1.v_o_valid == 1 then
    [(eval i s).1.v_o_data] else []

/-- Includes combinational bypass and capture on the first downstream stall. -/
theorem step_balance (i : Inputs) (s : State) (reset : i.v_i_reset = 0) :
    pending s ++ take i s = give i s ++ pending (eval i s).2 := by
  rcases i with ⟨r, v, d, ready⟩
  rcases s with ⟨saved, full⟩
  change r = 0 at reset
  subst r
  rcases bit_cases v with rfl | rfl <;>
    rcases bit_cases ready with rfl | rfl <;>
    rcases bit_cases full with rfl | rfl <;>
    simp [pending, take, give, eval]

/-- Accepted data over a finite execution. -/
def accepted : List Inputs → State → List (BitVec 32)
  | [], _ => []
  | i :: rest, s => take i s ++ accepted rest (eval i s).2

/-- Delivered data over a finite execution. -/
def emitted : List Inputs → State → List (BitVec 32)
  | [], _ => []
  | i :: rest, s => give i s ++ emitted rest (eval i s).2

/-- No loss, duplication, or reordering for arbitrary words and reset-free stall patterns.
Undelivered words remain in `pending`; permanently stalled receivers need not make progress. -/
theorem trace_balance (inputs : List Inputs) (s : State)
    (reset : ∀ i ∈ inputs, i.v_i_reset = 0) :
    pending s ++ accepted inputs s = emitted inputs s ++ pending (YosysLean.run eval inputs s) := by
  induction inputs generalizing s with
  | nil => simp [accepted, emitted, YosysLean.run]
  | cons i rest ih =>
      have first := step_balance i s (reset i (by simp))
      have tail := ih (eval i s).2 (fun j hj ↦ reset j (by simp [hj]))
      simp only [accepted, emitted, YosysLean.run]
      calc
        _ = (pending s ++ take i s) ++ accepted rest (eval i s).2 := by
          simp [List.append_assoc]
        _ = give i s ++ (pending (eval i s).2 ++ accepted rest (eval i s).2) := by
          rw [first]; simp [List.append_assoc]
        _ = _ := by rw [tail]; simp [List.append_assoc]

/-- Reset clears buffered work and suppresses delivery. -/
theorem reset_flush (i : Inputs) (s : State) (reset : i.v_i_reset = 1) :
    pending (eval i s).2 = [] ∧ give i s = [] := by
  simp [pending, give, eval, reset]

#check_claim step_balance, trace_balance, reset_flush
end SkidProofs
