import YosysLean.Check
import Examples.Generated.ZipAXIL

/-! Four-register semantics of the unchanged Easy AXI-Lite default configuration. -/
namespace AXILProofs
open v_ZipAXIL
set_option maxRecDepth 4096

private theorem bit_cases (b : BitVec 1) : b = 0 ∨ b = 1 := by revert b; decide

private theorem bit_and (a b : BitVec 1) :
    a &&& b = BitVec.ofBool (a == 1 && b == 1) := by revert a b; decide

/-- Address bits 3:2 choose one of four registers; low byte-address bits are ignored. -/
def readWord (s : State) (address : BitVec 4) : BitVec 32 :=
  let index := address.extractLsb' 2 2
  if index == 0 then s.v_r0 else if index == 1 then s.v_r1
  else if index == 2 then s.v_r2 else s.v_r3

/-- Each asserted byte strobe replaces just that byte. -/
def mergeBytes (old data : BitVec 32) (strobes : BitVec 4) : BitVec 32 :=
  let byte (k : Nat) :=
    if strobes.extractLsb' k 1 == 1 then data.extractLsb' (8*k) 8
    else old.extractLsb' (8*k) 8
  BitVec.append (byte 3) (BitVec.append (byte 2) (BitVec.append (byte 1) (byte 0)))

/-- A readable register/handshake model, independently expressed from the emitted netlist.
Reads sample the old registers, including when a read and write share an edge. -/
def step (i : Inputs) (s : State) : State :=
  let reset := i.v_S_AXI_ARESETN == 0
  let write := s.v_SIMPLE_WRITES_axil_awready == 1
  let read := i.v_S_AXI_ARVALID == 1 && s.v_S_AXI_RVALID == 0
  let update (index : BitVec 2) (old : BitVec 32) :=
    if reset then 0 else if write && i.v_S_AXI_AWADDR.extractLsb' 2 2 == index then
      mergeBytes old i.v_S_AXI_WDATA i.v_S_AXI_WSTRB else old
  { v_r0 := update 0 s.v_r0, v_r1 := update 1 s.v_r1,
    v_r2 := update 2 s.v_r2, v_r3 := update 3 s.v_r3,
    v_SIMPLE_WRITES_axil_awready := BitVec.ofBool (!reset && !write &&
      i.v_S_AXI_AWVALID == 1 && i.v_S_AXI_WVALID == 1 &&
      (s.v_S_AXI_BVALID == 0 || i.v_S_AXI_BREADY == 1)),
    v_S_AXI_BVALID := BitVec.ofBool (!reset &&
      (write || (s.v_S_AXI_BVALID == 1 && i.v_S_AXI_BREADY == 0))),
    v_S_AXI_RVALID := BitVec.ofBool (!reset &&
      (read || (s.v_S_AXI_RVALID == 1 && i.v_S_AXI_RREADY == 0))),
    v_S_AXI_RDATA := if s.v_S_AXI_RVALID == 0 || i.v_S_AXI_RREADY == 1 then
      readWord s i.v_S_AXI_ARADDR else s.v_S_AXI_RDATA }

private theorem read_mux (s : State) (a : BitVec 4) :
    (BitVec.append s.v_r3 (BitVec.append s.v_r2 (BitVec.append s.v_r1 s.v_r0)) >>>
      (BitVec.append (a.extractLsb' 2 2) (0#5)).toNat).extractLsb' 0 32 = readWord s a := by
  rw [← BitVec.setWidth_eq_extractLsb' (by decide : 32 ≤ 128),
    BitVec.setWidth_ushiftRight_eq_extractLsb]
  have cases : ∀ b : BitVec 2, b = 0 ∨ b = 1 ∨ b = 2 ∨ b = 3 := by decide
  rcases cases (a.extractLsb' 2 2) with h | h | h | h <;>
    simp [h, readWord]
  · exact (BitVec.extractLsb'_append_eq_of_add_le (by decide : 0 + 32 ≤ 96)).trans
      ((BitVec.extractLsb'_append_eq_of_add_le (by decide : 0 + 32 ≤ 64)).trans
        BitVec.extractLsb'_append_eq_right)
  · exact (BitVec.extractLsb'_append_eq_of_add_le (by decide : 32 + 32 ≤ 96)).trans
      ((BitVec.extractLsb'_append_eq_of_add_le (by decide : 32 + 32 ≤ 64)).trans
        BitVec.extractLsb'_append_eq_left)
  · exact (BitVec.extractLsb'_append_eq_of_add_le (by decide : 64 + 32 ≤ 96)).trans
      (BitVec.extractLsb'_append_eq_left (a := s.v_r2))
  · exact BitVec.extractLsb'_append_eq_left

/-- One edge of actual RTL agrees with the explicit model, for every input and state. -/
theorem next_correct (i : Inputs) (s : State) : (eval i s).2 = step i s := by
  have mux := read_mux s i.v_S_AXI_ARADDR
  simp only [BitVec.append_eq] at mux
  rcases bit_cases i.v_S_AXI_ARESETN with hr | hr <;>
    rcases bit_cases s.v_SIMPLE_WRITES_axil_awready with hw | hw <;>
    rcases bit_cases s.v_S_AXI_BVALID with hb | hb <;>
    rcases bit_cases s.v_S_AXI_RVALID with hv | hv <;>
    rcases bit_cases i.v_S_AXI_BREADY with hbr | hbr <;>
    rcases bit_cases i.v_S_AXI_RREADY with hrr | hrr <;>
    simp [eval, step, mergeBytes, bit_and, BitVec.ofBool, hr, hw, hb, hv, hbr, hrr, mux]
  all_goals
    by_cases hz : i.v_S_AXI_AWADDR.extractLsb' 2 2 = 0 <;>
      simp_all

/-- Actual ports expose the current response state; both response codes are OKAY. -/
theorem outputs_correct (i : Inputs) (s : State) : (eval i s).1 =
    { v_S_AXI_AWREADY := s.v_SIMPLE_WRITES_axil_awready,
      v_S_AXI_WREADY := s.v_SIMPLE_WRITES_axil_awready,
      v_S_AXI_BVALID := s.v_S_AXI_BVALID, v_S_AXI_BRESP := 0,
      v_S_AXI_ARREADY := ~~~s.v_S_AXI_RVALID,
      v_S_AXI_RVALID := s.v_S_AXI_RVALID, v_S_AXI_RDATA := s.v_S_AXI_RDATA,
      v_S_AXI_RRESP := 0 } := by rfl

/-- Once both request channels are offered to an idle slave, ready appears after one edge. -/
theorem request_ready (i : Inputs) (s : State) (reset : i.v_S_AXI_ARESETN = 1)
    (idle : s.v_SIMPLE_WRITES_axil_awready = 0) (free : s.v_S_AXI_BVALID = 0)
    (address : i.v_S_AXI_AWVALID = 1) (data : i.v_S_AXI_WVALID = 1) :
    (eval i s).2.v_SIMPLE_WRITES_axil_awready = 1 := by
  simp [next_correct, step, reset, idle, free, address, data]

/-- The model describes every finite RTL execution, including reset and arbitrary stalls. -/
theorem run_correct (inputs : List Inputs) (s : State) :
    YosysLean.run eval inputs s = inputs.foldl (fun s i ↦ step i s) s := by
  induction inputs generalizing s with
  | nil => rfl
  | cons i rest ih => simpa [YosysLean.run, next_correct] using ih (step i s)

/-- A stalled response retains both valid and data, even if address/data inputs change. -/
theorem stalled_read (i : Inputs) (s : State) (reset : i.v_S_AXI_ARESETN = 1)
    (valid : s.v_S_AXI_RVALID = 1) (ready : i.v_S_AXI_RREADY = 0) :
    (eval i s).2.v_S_AXI_RVALID = 1 ∧ (eval i s).2.v_S_AXI_RDATA = s.v_S_AXI_RDATA := by
  simp [next_correct, step, reset, valid, ready]

/-- An accepted read returns the selected old register with a valid response on the next edge. -/
theorem read_correct (i : Inputs) (s : State) (reset : i.v_S_AXI_ARESETN = 1)
    (valid : s.v_S_AXI_RVALID = 0) (request : i.v_S_AXI_ARVALID = 1) :
    (eval i s).2.v_S_AXI_RVALID = 1 ∧
      (eval i s).2.v_S_AXI_RDATA = readWord s i.v_S_AXI_ARADDR := by
  simp [next_correct, step, reset, valid, request]

/-- A write handshake updates the selected word's strobed bytes and produces a response. -/
theorem write_correct (i : Inputs) (s : State) (reset : i.v_S_AXI_ARESETN = 1)
    (ready : s.v_SIMPLE_WRITES_axil_awready = 1) :
    readWord (eval i s).2 i.v_S_AXI_AWADDR =
      mergeBytes (readWord s i.v_S_AXI_AWADDR) i.v_S_AXI_WDATA i.v_S_AXI_WSTRB ∧
      (eval i s).2.v_S_AXI_BVALID = 1 := by
  have cases : ∀ b : BitVec 2, b = 0 ∨ b = 1 ∨ b = 2 ∨ b = 3 := by decide
  rcases cases (i.v_S_AXI_AWADDR.extractLsb' 2 2) with h | h | h | h <;>
    simp [next_correct, step, readWord, reset, ready, h]

/-- A write response survives arbitrary downstream stalls until accepted or reset. -/
theorem stalled_write (i : Inputs) (s : State) (reset : i.v_S_AXI_ARESETN = 1)
    (valid : s.v_S_AXI_BVALID = 1) (ready : i.v_S_AXI_BREADY = 0) :
    (eval i s).2.v_S_AXI_BVALID = 1 := by
  simp [next_correct, step, reset, valid, ready]

#check_claim outputs_correct, request_ready, write_correct, stalled_write, next_correct, run_correct, stalled_read, read_correct
end AXILProofs
