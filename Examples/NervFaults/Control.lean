import YosysLean.Check
import YosysLean.Trace
import YosysLean.Formal
import Examples.Generated.NervFaultControl

/-! Shared definitions for the finite, unmodified-RTL repair controls. -/
namespace NervFaultControls
open v_NervFaultControl
set_option maxRecDepth 4096
set_option synthInstance.maxSize 16384

def input (scenario : BitVec 3) : Inputs := { (default : Inputs) with v_scenario := scenario }
def program (scenario : BitVec 3) : List Inputs := List.replicate 13 (input scenario)

def passes (scenario : BitVec 3) : Prop := initial default ∧
  YosysLean.Along eval assumptions (program scenario) default ∧
  YosysLean.Along eval assertions (program scenario) default

instance : DecidablePred assumptions := by unfold assumptions; infer_instance
instance : DecidablePred assertions := by unfold assertions; infer_instance
instance : DecidablePred covers := by unfold covers; infer_instance

end NervFaultControls
