import Lean.Elab.Command
import Lean.Util.CollectAxioms

/-! Explicit theorem audits. Successful file compilation alone is not an audit. -/
open Lean Elab Command

/-- Check named theorems for nonstandard axioms and report their actual statements. -/
elab "#check_claim " claims:ident,+ : command => do
  for claim in claims.getElems do
    let name ← liftCoreM <| realizeGlobalConstNoOverloadWithInfo claim
    let info ← getConstInfo name
    unless info matches .thmInfo _ do
      throwErrorAt claim "{name} is not a theorem"
    let axioms ← collectAxioms name
    for axiomName in axioms do
      unless #[``propext, ``Classical.choice, ``Quot.sound].contains axiomName do
        throwErrorAt claim "{name} depends on nonstandard axiom {axiomName}"
    logInfoAt claim m!"CLAIM {name} : {info.type}\naxioms: {axioms}"
