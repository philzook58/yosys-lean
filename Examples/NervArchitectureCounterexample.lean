import YosysLean.Check
import YosysLean.Formal
import Examples.Generated.NervWriteBad

/-! Instruction-local RVFI checks can pass while the CPU writes the wrong register. -/
namespace NervArchitectureCounterexample
open v_NervWriteBad
set_option maxRecDepth 4096
set_option synthInstance.maxSize 4096

def input (insn : BitVec 32) (reset : BitVec 1 := 0) : Inputs :=
  { (default : Inputs) with v_imem_data := insn, v_reset := reset }

def start : State :=
  { (default : State) with v_cpu_regfile_1_ := 2, v_cpu_regfile_2_ := 3 }

-- ADD x3,x1,x2 reports the correct value, but the mutant writes x2 instead of x3.
def program : List Inputs := [input 0 1, input 0, input 0x002081b3, input 0x00000013]

theorem checks_pass : initial start ∧
    YosysLean.Along eval assumptions program start ∧
    YosysLean.Along eval assertions program start := by
  simp only [program, YosysLean.along_cons]
  simp only [YosysLean.Along, YosysLean.trace, List.not_mem_nil,
    false_implies, implies_true, and_true, initial, assumptions, assertions]
  decide

theorem wrong_write :
    let s := YosysLean.run eval (program.take 3) start
    let o := (eval (input 0x00000013) s).1
    o.v_rvfi_valid = 1 ∧ o.v_rvfi_rd_addr = 3 ∧ o.v_rvfi_rd_wdata = 5 ∧
    s.v_cpu_regfile_3_ ≠ (2#32) + (3#32) ∧ s.v_cpu_regfile_2_ = 5 := by decide

#check_claim checks_pass, wrong_write
end NervArchitectureCounterexample
