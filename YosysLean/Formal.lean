import YosysLean.Basic

/-! Safety of imported RTL assertions under imported assumptions. -/
namespace YosysLean

/-- Every sampled output of this finite execution satisfies the predicate. -/
def Along (eval : I → S → O × S) (property : O → Prop) (inputs : List I) (s : S) : Prop :=
  ∀ o ∈ trace eval inputs s, property o

theorem along_cons (eval : I → S → O × S) (property : O → Prop) (i : I)
    (inputs : List I) (s : S) :
    Along eval property (i :: inputs) s ↔
      property (eval i s).1 ∧ Along eval property inputs (eval i s).2 := by
  simp [Along, trace]

/-- All assertions hold on every finite execution satisfying the environment assumptions. -/
def Safety (eval : I → S → O × S) (initial : S → Prop)
    (assumptions assertions : O → Prop) : Prop :=
  ∀ inputs s, initial s → Along eval assumptions inputs s → Along eval assertions inputs s

/-- A strengthening invariant proves the imported assertions for executions of arbitrary length. -/
theorem safety_of_invariant (eval : I → S → O × S) (initial invariant : S → Prop)
    (assumptions assertions : O → Prop)
    (base : ∀ s, initial s → invariant s)
    (step : ∀ i s, invariant s → assumptions (eval i s).1 → invariant (eval i s).2)
    (sound : ∀ i s, invariant s → assumptions (eval i s).1 → assertions (eval i s).1) :
    Safety eval initial assumptions assertions := by
  have lift : ∀ inputs s, invariant s → Along eval assumptions inputs s →
      Along eval assertions inputs s := by
    intro inputs
    induction inputs with
    | nil => intro s _ _; simp [Along, trace]
    | cons i rest ih =>
        intro s inv assumed
        rcases (along_cons eval assumptions i rest s).1 assumed with ⟨first, tail⟩
        apply (along_cons eval assertions i rest s).2
        exact ⟨sound i s inv first, ih _ (step i s inv first) tail⟩
  intro inputs s init assumed
  exact lift inputs s (base s init) assumed

/-- A concrete initialized execution obeys all assumptions but violates an assertion. -/
def Counterexample (eval : I → S → O × S) (initial : S → Prop)
    (assumptions assertions : O → Prop) (inputs : List I) (s : S) : Prop :=
  initial s ∧ Along eval assumptions inputs s ∧ ¬Along eval assertions inputs s

theorem Counterexample.not_safe
    {eval : I → S → O × S} {initial : S → Prop} {assumptions assertions : O → Prop}
    {inputs : List I} {s : S}
    (h : Counterexample eval initial assumptions assertions inputs s) :
    ¬Safety eval initial assumptions assertions := by
  intro safe
  exact h.2.2 (safe inputs s h.1 h.2.1)

end YosysLean
