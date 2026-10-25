import YosysLean.Formal
import Lean.Elab.Tactic.Basic
import Lean.Meta.Reduce
import Lean.Meta.Tactic.AuxLemma

/-! Kernel-checked finite traces with concrete state checkpoints. No native-evaluation axiom. -/
namespace YosysLean

private theorem along_nil (eval : I → S → O × S) (p : O → Prop) (s : S) :
    Along eval p [] s := by simp [Along, trace]

private theorem along_step (eval : I → S → O × S) (p : O → Prop) (i : I)
    (rest : List I) (s next : S) (edge : (eval i s).2 = next)
    (head : p (eval i s).1) (tail : Along eval p rest next) : Along eval p (i :: rest) s := by
  rw [along_cons, edge]
  exact ⟨head, tail⟩

private theorem not_along_head (eval : I → S → O × S) (p : O → Prop) (i : I)
    (rest : List I) (s : S) (head : ¬p (eval i s).1) : ¬Along eval p (i :: rest) s := by
  intro h
  exact head ((along_cons ..).mp h).1

private theorem not_along_tail (eval : I → S → O × S) (p : O → Prop) (i : I)
    (rest : List I) (s next : S) (edge : (eval i s).2 = next)
    (tail : ¬Along eval p rest next) : ¬Along eval p (i :: rest) s := by
  intro h
  have later := ((along_cons ..).mp h).2
  rw [edge] at later
  exact tail later

/-- A failed universal absence check supplies a nonvacuous finite cover witness. -/
theorem exists_of_not_along_not (eval : I → S → O × S) (p : O → Prop)
    (inputs : List I) (s : S) (h : ¬Along eval (fun o ↦ ¬p o) inputs s) :
    ∃ o ∈ trace eval inputs s, p o := by
  classical
  simpa [Along] using h

open Lean Meta Elab Tactic

initialize registerTraceClass `YosysLean.checkTrace

-- Rebuild bitvectors as literals, dropping large computational proofs inside their Fin fields.
private def concreteState (value : Expr) : MetaM Expr := do
  let value ← reduce value (explicitOnly := false)
  let mut fields := #[]
  for field in value.getAppArgs do
    let type ← whnf (← inferType field)
    unless type.isAppOfArity ``BitVec 1 do throwError "Expected a generated bitvector state"
    let numeral ← reduce (← mkAppM ``BitVec.toNat #[field])
    let some n := numeral.rawNatLit? | throwError "State field is not closed"
    fields := fields.push (mkApp2 (mkConst ``BitVec.ofNat) type.appArg! (mkNatLit n))
  return mkAppN value.getAppFn fields

private def checked (type proof : Expr) : MetaM Expr := do
  return mkConst (← mkAuxLemma [] type proof)

-- Every edge and property proof is checked before the recursion moves to the next state.
private partial def certify (eval p inputs state : Expr) : MetaM (Bool × Expr) := do
  let list ← whnf inputs
  if list.isAppOfArity ``List.nil 1 then
    return (true, ← mkAppM ``along_nil #[eval, p, state])
  unless list.isAppOfArity ``List.cons 3 do throwError "Expected a closed finite input list"
  let remaining ← reduce (← mkAppM ``List.length #[inputs])
  trace[YosysLean.checkTrace] "checking {remaining} remaining edges"
  let i := list.getArg! 1
  let rest := list.getArg! 2
  let result := mkApp2 eval i state
  let property := mkApp p (mkProj ``Prod 0 result)
  let decision ← whnf (← mkDecide property)
  if decision.isConstOf ``Bool.false then
    let failed := mkNot property
    let proof ← checked failed (← mkDecideProof failed)
    return (false, ← mkAppM ``not_along_head #[eval, p, i, rest, state, proof])
  unless decision.isConstOf ``Bool.true do throwError "Property is not closed and decidable"
  let head ← checked property (← mkDecideProof property)
  trace[YosysLean.checkTrace] "property checked"
  let oldNext := mkProj ``Prod 1 result
  let next ← concreteState oldNext
  let edge ← checked (← mkEq oldNext next) (← mkEqRefl oldNext)
  trace[YosysLean.checkTrace] "transition checked"
  resetCache
  let (passed, tail) ← certify eval p rest next
  let lemma := if passed then ``along_step else ``not_along_tail
  let args := #[eval, p, i, rest, state, next, edge]
  let proof ← mkAppM lemma (if passed then args ++ #[head, tail] else args.push tail)
  return (passed, proof)

/-- Certify `Along` or its negation for a closed input list and generated bitvector state.
Intermediate states and step proofs are kernel-checked checkpoints, not extra assumptions. -/
elab "check_trace" : tactic => withMainContext do
  let goal ← getMainGoal
  let target ← instantiateMVars (← goal.getType)
  let negated := target.isAppOfArity ``Not 1
  let claim := if negated then target.appArg! else target
  unless claim.isAppOfArity ``Along 7 do throwError "Expected Along eval property inputs state"
  let args := claim.getAppArgs
  let (passed, proof) ← certify args[3]! args[4]! args[5]! args[6]!
  if passed == negated then throwError "Trace has the opposite outcome to the requested claim"
  goal.assign proof
  replaceMainGoal []

end YosysLean
