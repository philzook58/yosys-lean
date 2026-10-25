import Lean.Elab.Tactic.Simp

/-! Explicit unfolding of generated definitions, with chosen proof boundaries. -/
open Lean Elab Tactic

/-- Unfold definitions in a namespace while keeping the listed signal definitions opaque. -/
elab "unfold_nodes " ns:ident " except " "[" cuts:ident,* "]" : tactic => do
  let rootName := ns.getId
  let skip := cuts.getElems.map (·.getId)
  let mut ids : Array (TSyntax `ident) := #[]
  for (name, info) in (← getEnv).constants.toList do
    if rootName.isPrefixOf name && !skip.contains name then
      if info matches .defnInfo _ then ids := ids.push (mkIdent name)
  if ids.isEmpty then throwError "No definitions under {rootName}"
  evalTactic (← `(tactic| dsimp only [$[$ids:ident],*]))
