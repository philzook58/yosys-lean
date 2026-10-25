import YosysLean.Check
import YosysLean.Formal
import Examples.Generated.ZipSkidFormal
import Examples.Generated.ZipAXILFormal
import Examples.Generated.ZipSkidBadFormal
import Examples.Generated.ZipAXILBadFormal

/-! Actual implementation mutations fail unchanged upstream assertions under their assumptions. -/
namespace BusCounterexamples
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

namespace Skid
open v_ZipSkidBadFormal

/-- Reset, capture 42 while stalled, then drain. The mutant incorrectly buffers zero. -/
def inputs : List Inputs :=
  [ { v_i_reset := 1, v_i_valid := 0, v_i_data := 0, v_i_ready := 0 },
    { v_i_reset := 0, v_i_valid := 1, v_i_data := 42, v_i_ready := 0 },
    { v_i_reset := 0, v_i_valid := 0, v_i_data := 0, v_i_ready := 1 } ]

theorem counterexample : YosysLean.Counterexample eval initial assumptions assertions inputs default :=
  by
    simp [YosysLean.Counterexample, YosysLean.Along, YosysLean.trace,
      inputs, initial, assumptions, assertions, eval] <;> decide
/-- The same requests, with the original circuit's input type. -/
def goodInputs : List v_ZipSkidFormal.Inputs :=
  inputs.map fun i ↦ ({
      v_i_reset := i.v_i_reset, v_i_valid := i.v_i_valid,
      v_i_data := i.v_i_data, v_i_ready := i.v_i_ready } : v_ZipSkidFormal.Inputs)

/-- The same requests satisfy the original's imported assumptions and assertions. -/
theorem original_trace :
    v_ZipSkidFormal.initial default ∧
    YosysLean.Along v_ZipSkidFormal.eval v_ZipSkidFormal.assumptions goodInputs default ∧
    YosysLean.Along v_ZipSkidFormal.eval v_ZipSkidFormal.assertions goodInputs default := by
  simp [YosysLean.Along, YosysLean.trace, inputs, goodInputs, v_ZipSkidFormal.initial,
    v_ZipSkidFormal.assumptions, v_ZipSkidFormal.assertions, v_ZipSkidFormal.eval] <;> decide
end Skid

namespace AXIL
set_option synthInstance.maxSize 4096
open v_ZipAXILBadFormal

/-- Reset recovery, a one-byte write, then idle. The mutant overwrites all four bytes. -/
def inputs : List Inputs :=
  let idle : Inputs := { (default : Inputs) with v_S_AXI_ARESETN := 1 }
  let write : Inputs := { idle with
    v_S_AXI_AWVALID := 1, v_S_AXI_WVALID := 1,
    v_S_AXI_WDATA := 0x11223344, v_S_AXI_WSTRB := 1 }
  [default, idle, write, write, idle]

/-- Respect the checkers' specified initial bits; all other bits may be zero. -/
def start : State := { (default : State) with
  v_fr0_SYNC_RESET_last_reset := 1, v__initstate := 1 }

theorem counterexample : YosysLean.Counterexample eval initial assumptions assertions inputs start := by
  simp only [YosysLean.Counterexample, inputs, YosysLean.along_cons]
  simp [YosysLean.Along, YosysLean.trace, start, initial, assumptions, assertions, eval] <;> decide
/-- The same requests, with the original circuit's input type. -/
def goodInputs : List v_ZipAXILFormal.Inputs :=
  inputs.map fun i ↦ ({
      v_S_AXI_ARESETN := i.v_S_AXI_ARESETN, v_S_AXI_AWVALID := i.v_S_AXI_AWVALID,
      v_S_AXI_AWADDR := i.v_S_AXI_AWADDR, v_S_AXI_AWPROT := i.v_S_AXI_AWPROT,
      v_S_AXI_WVALID := i.v_S_AXI_WVALID, v_S_AXI_WDATA := i.v_S_AXI_WDATA,
      v_S_AXI_WSTRB := i.v_S_AXI_WSTRB, v_S_AXI_BREADY := i.v_S_AXI_BREADY,
      v_S_AXI_ARVALID := i.v_S_AXI_ARVALID, v_S_AXI_ARADDR := i.v_S_AXI_ARADDR,
      v_S_AXI_ARPROT := i.v_S_AXI_ARPROT, v_S_AXI_RREADY := i.v_S_AXI_RREADY
    } : v_ZipAXILFormal.Inputs)

/-- The original checkers have the same required initial-one bits. -/
def goodStart : v_ZipAXILFormal.State := { (default : v_ZipAXILFormal.State) with
  v_fr0_SYNC_RESET_last_reset := 1, v__initstate := 1 }

/-- The original obeys its assumptions and assertions on the same one-byte-write trace. -/
theorem original_trace :
    v_ZipAXILFormal.initial goodStart ∧
    YosysLean.Along v_ZipAXILFormal.eval v_ZipAXILFormal.assumptions goodInputs goodStart ∧
    YosysLean.Along v_ZipAXILFormal.eval v_ZipAXILFormal.assertions goodInputs goodStart := by
  simp only [goodInputs, goodStart, inputs, List.map_cons, List.map_nil, YosysLean.along_cons]
  simp [YosysLean.Along, YosysLean.trace, v_ZipAXILFormal.initial,
    v_ZipAXILFormal.assumptions, v_ZipAXILFormal.assertions, v_ZipAXILFormal.eval] <;> decide
end AXIL

#check_claim Skid.counterexample, AXIL.counterexample, Skid.original_trace, AXIL.original_trace
end BusCounterexamples
