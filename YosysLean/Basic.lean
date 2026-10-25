import Init.Data.BitVec

/-! Small helpers for generated word-level circuits and handwritten inductive proofs. -/
namespace YosysLean

/-- SMT-LIB division, including the all-ones result on a zero divisor. -/
def udiv {w : Nat} (a b : BitVec w) : BitVec w :=
  if b == 0 then ~~~(0 : BitVec w) else a / b

/-- Exclusive-or reduction, expressed through bits so `bv_decide` can unfold it. -/
def parity {w : Nat} (a : BitVec w) : Bool :=
  (List.range w).foldl (fun p i ↦ p ^^ a.getLsbD i) false

/-- State after a finite list of input samples. Outputs are sampled before each edge. -/
def run (eval : I → S → O × S) : List I → S → S
  | [], s => s
  | i :: rest, s => run eval rest (eval i s).2

/-- Output observations of a finite execution. -/
def trace (eval : I → S → O × S) : List I → S → List O
  | [], _ => []
  | i :: rest, s => (eval i s).1 :: trace eval rest (eval i s).2

/-- A one-step simulation lifts to arbitrarily long finite executions. -/
theorem run_simulation (impl : I → S → O × S) (spec : I → T → P × T)
    (rel : S → T → Prop)
    (step : ∀ i s t, rel s t → rel (impl i s).2 (spec i t).2)
    (inputs : List I) (s : S) (t : T) (h : rel s t) :
    rel (run impl inputs s) (run spec inputs t) := by
  induction inputs generalizing s t with
  | nil => exact h
  | cons i rest ih => exact ih _ _ (step i s t h)

/-- Every step is allowed at the state reached by the reference execution. -/
def Admissible (eval : I → S → O × S) (allowed : I → S → Prop) : List I → S → Prop
  | [], _ => True
  | i :: rest, s => allowed i s ∧ Admissible eval allowed rest (eval i s).2

/-- A reference invariant establishes the per-step assumptions for a finite input stream. -/
theorem admissible_of_invariant (eval : I → S → O × S) (allowed : I → S → Prop)
    (inv : S → Prop) (inputs : List I)
    (step : ∀ i ∈ inputs, ∀ s, inv s → allowed i s ∧ inv (eval i s).2)
    (s : S) (h : inv s) : Admissible eval allowed inputs s := by
  induction inputs generalizing s with
  | nil => trivial
  | cons i rest ih =>
      have ⟨allowed, next⟩ := step i (by simp) s h
      exact ⟨allowed, ih (fun j hj ↦ step j (by simp [hj])) _ next⟩

/-- Lift a projected step refinement with explicit reference-path assumptions and an invariant. -/
theorem run_refinement (impl : I → S → O × S) (spec : I → T → P × T)
    (inv : S → Prop) (project : S → T) (allowed : I → T → Prop)
    (step : ∀ i s, inv s → allowed i (project s) →
      inv (impl i s).2 ∧ project (impl i s).2 = (spec i (project s)).2)
    (inputs : List I) (s : S) (h : inv s)
    (permit : Admissible spec allowed inputs (project s)) :
    inv (run impl inputs s) ∧ project (run impl inputs s) = run spec inputs (project s) := by
  induction inputs generalizing s with
  | nil => exact ⟨h, rfl⟩
  | cons i rest ih =>
      have ⟨nextInv, next⟩ := step i s h permit.1
      have ⟨finalInv, final⟩ := ih _ nextInv (by simpa only [next] using permit.2)
      exact ⟨finalInv, by simpa only [run, next] using final⟩

/-- A preserved invariant holds after every finite execution. -/
theorem run_invariant (eval : I → S → O × S) (inv : S → Prop)
    (preserve : ∀ i s, inv s → inv (eval i s).2)
    (inputs : List I) (s : S) (h : inv s) : inv (run eval inputs s) :=
  run_simulation eval eval (fun s _ ↦ inv s) (fun i s _ h ↦ preserve i s h)
    inputs s s h

/-- Reachability includes all states satisfying the initial predicate. -/
inductive Reachable (eval : I → S → O × S) (initial : S → Prop) : S → Prop
  | init {s} : initial s → Reachable eval initial s
  | step {s} (i : I) : Reachable eval initial s → Reachable eval initial (eval i s).2

/-- Induction over reachable states turns an invariant into an unbounded safety theorem. -/
theorem reachable_invariant (eval : I → S → O × S) (initial inv : S → Prop)
    (base : ∀ s, initial s → inv s)
    (preserve : ∀ i s, inv s → inv (eval i s).2)
    (s : S) (h : Reachable eval initial s) : inv s := by
  induction h with
  | init h => exact base _ h
  | step i _ ih => exact preserve i _ ih

end YosysLean
