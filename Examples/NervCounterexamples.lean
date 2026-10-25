import YosysLean.Check
import YosysLean.Formal
import Examples.Generated.NervAddiBad

/-! The actual NERV ADDI datapath is mutated to add one too much. -/
namespace NervCounterexamples
open v_NervAddiBad
set_option maxRecDepth 4096
set_option synthInstance.maxSize 4096

def input (insn : BitVec 32) (reset : BitVec 1 := 0) : Inputs :=
  { (default : Inputs) with v_imem_data := insn, v_reset := reset }

def program : List Inputs := [input 0 1, input 0, input 0x00500093, input 0x00000013]

theorem counterexample :
    YosysLean.Counterexample eval initial assumptions assertions program default := by
  simp only [YosysLean.Counterexample, program, YosysLean.along_cons]
  simp only [YosysLean.Along, YosysLean.trace, List.not_mem_nil,
    false_implies, implies_true, and_true, initial, assumptions, assertions]
  decide

#check_claim counterexample
end NervCounterexamples
