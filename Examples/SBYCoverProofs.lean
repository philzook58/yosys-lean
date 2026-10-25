import YosysLean.Check
import Examples.Generated.SBYCover

/-! Concrete reachability witnesses for both unchanged upstream Verilog cover statements.
SMTBMC found the bytes; Lean checks the resulting exported executions. -/
namespace SBYCoverProofs
open v_SBYCover

-- One input per edge; the final eval samples the cover before its next update.
def decimal_inputs : List Inputs := [⟨9⟩, ⟨112⟩, ⟨62⟩, ⟨71⟩, ⟨46⟩]
def hexadecimal_inputs : List Inputs := [⟨9⟩, ⟨42⟩, ⟨87⟩, ⟨60⟩, ⟨120⟩, ⟨136⟩]

/-- Five edges reach the RTL's decimal cover target, from the imported initial state. -/
theorem decimal_cover :
    let o := (eval ⟨0⟩ (YosysLean.run eval decimal_inputs ⟨0⟩)).1
    initial ⟨0⟩ ∧ o.v__examples_formal_upstream_sby_cover_sv_13_cover_6 = 1 := by
  unfold initial
  decide

/-- Six edges reach the separate hexadecimal cover target. -/
theorem hexadecimal_cover :
    let o := (eval ⟨0⟩ (YosysLean.run eval hexadecimal_inputs ⟨0⟩)).1
    initial ⟨0⟩ ∧ o.v__examples_formal_upstream_sby_cover_sv_14_cover_8 = 1 := by
  unfold initial
  decide

#check_claim decimal_cover, hexadecimal_cover
end SBYCoverProofs
