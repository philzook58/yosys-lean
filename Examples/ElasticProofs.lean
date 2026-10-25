import YosysLean.Check
import Examples.Generated.Elastic
import Lean.Elab.Tactic.Omega

namespace ElasticProofs
set_option maxRecDepth 4096
set_option maxHeartbeats 200000

/-- Arithmetic contract, modulo 2^16. -/
def transform (x : BitVec 16) := x * 5 + 1

private theorem datapath (x : BitVec 16) :
    BitVec.append (x.extractLsb' 0 14) (0#2) + x + 1 = transform x := by
  apply BitVec.eq_of_toNat_eq
  have bits := BitVec.toNat_append (x.extractLsb' 0 14) (0#2)
  simp [Nat.shiftLeft_eq] at bits
  have bound := x.isLt
  simp only [transform, BitVec.toNat_add, BitVec.toNat_mul]
  simp
  omega

private theorem bit_cases (b : BitVec 1) : b = 0 ∨ b = 1 := by revert b; decide

/-- The queue represented by physical registers; invalid data bits are ignored. -/
def pending (s : v_Elastic.State) : List (BitVec 16) :=
  if s.v_full == 1 then [s.v_data] else []

def take (i : v_Elastic.Inputs) (s : v_Elastic.State) : List (BitVec 16) :=
  if i.v_in_valid == 1 && (v_Elastic.eval i s).1.v_in_ready == 1 then [i.v_in_data] else []

def give (i : v_Elastic.Inputs) (s : v_Elastic.State) : List (BitVec 16) :=
  if i.v_out_ready == 1 && (v_Elastic.eval i s).1.v_out_valid == 1 then
    [(v_Elastic.eval i s).1.v_out_data] else []

/-- A local queue conservation equation, including simultaneous dequeue and replacement. -/
theorem step_balance (i : v_Elastic.Inputs) (s : v_Elastic.State) (h : i.v_reset = 0) :
    pending s ++ (take i s).map transform =
      give i s ++ pending (v_Elastic.eval i s).2 := by
  rcases i with ⟨reset, valid, ready, x⟩
  rcases s with ⟨full, data⟩
  change reset = 0 at h
  subst reset
  rcases bit_cases valid with rfl | rfl <;>
    rcases bit_cases ready with rfl | rfl <;>
    rcases bit_cases full with rfl | rfl <;>
    simp [pending, take, give, v_Elastic.eval]
  all_goals exact (datapath x).symm

/-- Accepted input words, measured using the actual RTL ready output. -/
def accepted : List v_Elastic.Inputs → v_Elastic.State → List (BitVec 16)
  | [], _ => []
  | i :: rest, s => take i s ++ accepted rest (v_Elastic.eval i s).2

/-- Emitted words, measured only on valid/ready handshakes. -/
def emitted : List v_Elastic.Inputs → v_Elastic.State → List (BitVec 16)
  | [], _ => []
  | i :: rest, s => give i s ++ emitted rest (v_Elastic.eval i s).2

/-- For any finite stall pattern, all accepted data is either emitted in order or still pending.
This theorem concerns a reset-free epoch. Reset deliberately discards pending work. -/
theorem trace_balance (inputs : List v_Elastic.Inputs) (s : v_Elastic.State)
    (h : ∀ i ∈ inputs, i.v_reset = 0) :
    pending s ++ (accepted inputs s).map transform =
      emitted inputs s ++ pending (YosysLean.run v_Elastic.eval inputs s) := by
  induction inputs generalizing s with
  | nil => simp [accepted, emitted, YosysLean.run]
  | cons i rest ih =>
      have first := step_balance i s (h i (by simp))
      have tail := ih (v_Elastic.eval i s).2 (fun j hj ↦ h j (by simp [hj]))
      simp only [accepted, emitted, YosysLean.run, List.map_append]
      calc
        _ = (pending s ++ (take i s).map transform) ++
            (accepted rest (v_Elastic.eval i s).2).map transform := by simp [List.append_assoc]
        _ = give i s ++ (pending (v_Elastic.eval i s).2 ++
            (accepted rest (v_Elastic.eval i s).2).map transform) := by
              rw [first]; simp [List.append_assoc]
        _ = _ := by rw [tail]; simp [List.append_assoc]

/-- From an empty stage, the observed stream is a prefix of transformed accepted input. -/
theorem no_loss_or_reordering (inputs : List v_Elastic.Inputs) (s : v_Elastic.State)
    (empty : pending s = []) (h : ∀ i ∈ inputs, i.v_reset = 0) :
    (accepted inputs s).map transform =
      emitted inputs s ++ pending (YosysLean.run v_Elastic.eval inputs s) := by
  simpa [empty] using trace_balance inputs s h

/-- The remaining suffix never contains more than one word. -/
theorem capacity (s : v_Elastic.State) : (pending s).length ≤ 1 := by
  unfold pending
  split <;> simp

/-- A stalled valid output retains both its data and its validity across the edge. -/
theorem stalled (i : v_Elastic.Inputs) (s : v_Elastic.State)
    (reset : i.v_reset = 0) (ready : i.v_out_ready = 0) (full : s.v_full = 1) :
    (v_Elastic.eval i s).2 = s := by
  cases i; cases s
  simp_all [v_Elastic.eval]

/-- Reset cancels the pending transaction and suppresses both handshakes. -/
theorem reset_flush (i : v_Elastic.Inputs) (s : v_Elastic.State) (h : i.v_reset = 1) :
    pending (v_Elastic.eval i s).2 = [] ∧ take i s = [] ∧ give i s = [] := by
  simp [pending, take, give, v_Elastic.eval, h]

#check_claim step_balance, trace_balance, no_loss_or_reordering, capacity, stalled, reset_flush,
  datapath
end ElasticProofs
