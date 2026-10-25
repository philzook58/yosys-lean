import YosysLean.BitVec
import YosysLean.Check
import YosysLean.Formal
import Examples.Generated.NervAddi
import Examples.Generated.NervAdd

/-! A checked execution of unchanged NERV RTL, including upstream RVFI assertions.
This finite witness is not an unbounded ISA-refinement theorem. -/
namespace NervProofs
open YosysLean.Bits
set_option maxRecDepth 4096
set_option maxHeartbeats 800000
set_option synthInstance.maxSize 4096
set_option exponentiation.threshold 2048


namespace Addi
open v_NervAddi

def input (insn : BitVec 32) (reset : BitVec 1 := 0) (stall : BitVec 1 := 0) : Inputs :=
  { (default : Inputs) with v_imem_data := insn, v_reset := reset, v_stall := stall }

-- Two reset-recovery edges, then x1=5, x2=x1-6=-1, x3=x1+x2=4, x0 write discarded.
-- A stalled edge supplies irrelevant instruction data; the report is not retired then.
def program : List Inputs :=
  [input 0 1, input 0, input 0x00500093, input 0xffa08113,
   input 0xdeadbeef 0 1, input 0x002081b3, input 0x00700013, input 0x00000013]

theorem execution :
    initial default ∧
    YosysLean.Along eval assumptions program default ∧
    YosysLean.Along eval assertions program default := by
  simp only [program, YosysLean.along_cons]
  simp only [YosysLean.Along, YosysLean.trace, List.not_mem_nil,
    false_implies, implies_true, and_true, initial, assumptions, assertions]
  decide

theorem result :
    (YosysLean.run eval program default).v_cpu_regfile_1_ = 5 ∧
    (YosysLean.run eval program default).v_cpu_regfile_2_ = 0xffffffff ∧
    (YosysLean.run eval program default).v_cpu_regfile_3_ = 4 := by decide

theorem reached : ∃ o ∈ YosysLean.trace eval program default,
    covers o ∧ o.v_rvfi_valid = 1 ∧ o.v_rvfi_rd_addr = 2 ∧ o.v_rvfi_rd_wdata = 0xffffffff := by
  refine ⟨(YosysLean.trace eval program default)[5], ?_, ?_⟩
  · exact List.getElem_mem (by decide : 5 < (YosysLean.trace eval program default).length)
  · simp only [covers]; decide
end Addi

namespace Add
open v_NervAdd

def input (insn : BitVec 32) (reset : BitVec 1 := 0) (other : Inputs := default) : Inputs :=
  { other with v_imem_data := insn, v_reset := reset, v_stall := 0 }

def start (a b : BitVec 32) : State :=
  { (default : State) with v_cpu_regfile_1_ := a, v_cpu_regfile_2_ := b }

/-- An actual ADD retirement for arbitrary 32-bit register operands, after reset recovery.
All imported instruction-checker assertions hold at the observed edge. -/
theorem retirement (a b : BitVec 32) (i0 i1 i2 i3 : Inputs) :
    let s := YosysLean.run eval [input 0 1 i0, input 0 0 i1, input 0x002081b3 0 i2] (start a b)
    let o := (eval (input 0x00000013 0 i3) s).1
    initial (start a b) ∧ assertions o ∧ assumptions o ∧ covers o ∧
      o.v_rvfi_valid = 1 ∧ o.v_rvfi_rd_addr = 3 ∧ o.v_rvfi_rd_wdata = a + b := by
  dsimp only [YosysLean.run, input, start, eval]
  simp (disch := decide) [initial, assertions, assumptions, covers,
    -BitVec.append_eq, slice_low, slice_high, default, instInhabitedState.default]
  simp
  simp (disch := decide) [HAppend.hAppend, -BitVec.append_eq, slice_low]
end Add

#check_claim Addi.execution, Addi.result, Addi.reached, Add.retirement
end NervProofs
