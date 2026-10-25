import YosysLean.Check
import Examples.Generated.CrcSerial
import Examples.Generated.CrcByte
import Lean.Elab.Tactic.Omega

namespace CrcProofs
set_option maxRecDepth 4096
set_option maxHeartbeats 200000

/-- Polynomial coefficients are bits, addition is XOR, and g = X^8 + X^2 + X + 1.
A degree-at-most-eight polynomial needs at most one long-division subtraction. -/
def remainder9 (p : BitVec 9) : BitVec 8 :=
  (if p.getLsbD 8 then p ^^^ 0x107 else p).setWidth 8

/-- Reduce r*X + b*X^8 modulo g. This is independent of the RTL feedback wiring. -/
def polyStep (r : BitVec 8) (b : BitVec 1) : BitVec 8 :=
  remainder9 ((r.setWidth 9 <<< 1) ^^^ (b.setWidth 9 <<< 8))

def bitsMSB (byte : BitVec 8) : List (BitVec 1) :=
  (List.range 8).map (fun i ↦ byte.extractLsb' (7 - i) 1)

def byteStep (r byte : BitVec 8) := (bitsMSB byte).foldl polyStep r

private def wireStep (r : BitVec 8) (b : BitVec 1) : BitVec 8 :=
  BitVec.append (r.extractLsb' 0 7) (0#1) ^^^
    (if (r.extractLsb' 7 1 ^^^ b) == 1 then 7 else 0)

private theorem bit_one (x : BitVec 1) : (x == 1) = x.getLsbD 0 := by
  revert x
  decide

private theorem get_ite (c : Prop) [Decidable c] (x y : BitVec w) (i : Nat) :
    (if c then x else y).getLsbD i = if c then x.getLsbD i else y.getLsbD i := by
  split <;> rfl

private theorem shift_bits (r : BitVec 8) (i : Nat) :
    (BitVec.append (r.extractLsb' 0 7) (0#1)).getLsbD i =
      if i < 1 then (0#1).getLsbD i else (r.extractLsb' 0 7).getLsbD (i-1) :=
  BitVec.getLsbD_append

private theorem wire_poly (r : BitVec 8) (b : BitVec 1) : wireStep r b = polyStep r b := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have cases_i : i=0 ∨ i=1 ∨ i=2 ∨ i=3 ∨ i=4 ∨ i=5 ∨ i=6 ∨ i=7 := by omega
  rcases cases_i with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
    simp only [wireStep, polyStep, remainder9, get_ite, bit_one,
        shift_bits, BitVec.getLsbD_xor, BitVec.getLsbD_shiftLeft,
        BitVec.getLsbD_setWidth, BitVec.getLsbD_extractLsb'] <;>
    cases hr : r.getLsbD 7 <;> cases hb : b.getLsbD 0 <;> simp_all

private theorem extract_shift (r : BitVec 8) :
    (BitVec.append (r.extractLsb' 0 7) (0#1)).extractLsb' 1 7 = r.extractLsb' 0 7 :=
  BitVec.extractLsb'_append_eq_left


private theorem append_bits (x : BitVec n) (y : BitVec m) (i : Nat) :
    (BitVec.append x y).getLsbD i =
      if i < m then y.getLsbD i else x.getLsbD (i-m) := BitVec.getLsbD_append

private theorem serial_wire (r : BitVec 8) (b : BitVec 1) :
    (v_CrcSerial.eval ⟨1, b, 1⟩ ⟨r⟩).2.v_crc = wireStep r b := by
  dsimp only [v_CrcSerial.eval]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have cases_i : i=0 ∨ i=1 ∨ i=2 ∨ i=3 ∨ i=4 ∨ i=5 ∨ i=6 ∨ i=7 := by omega
  rcases cases_i with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
    simp only [wireStep, get_ite, bit_one,
        append_bits,
        BitVec.getLsbD_xor, BitVec.getLsbD_extractLsb'] <;>
    cases hr : r.getLsbD 7 <;> cases hb : b.getLsbD 0 <;> simp_all

private theorem bit_cases (b : BitVec 1) : b=0 ∨ b=1 := by revert b; decide

/-- The synchronous adaptation computes polynomial remainder, including enable and reset. -/
theorem serial_step (r : BitVec 8) (b resetN valid : BitVec 1) :
    (v_CrcSerial.eval ⟨resetN, b, valid⟩ ⟨r⟩).2.v_crc =
      if resetN == 1 then (if valid == 1 then polyStep r b else r) else 0xff := by
  rcases bit_cases resetN with rfl | rfl <;> rcases bit_cases valid with rfl | rfl
  all_goals first
    | exact (serial_wire r b).trans (wire_poly r b)
    | (dsimp only [v_CrcSerial.eval]
       apply BitVec.eq_of_getLsbD_eq
       intro i hi
       have cases_i : i=0 ∨ i=1 ∨ i=2 ∨ i=3 ∨ i=4 ∨ i=5 ∨ i=6 ∨ i=7 := by omega
       rcases cases_i with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
         simp only [append_bits] <;> simp)


/-- The separately written byte-parallel RTL implements eight polynomial reductions. -/
theorem byte_step (r byte : BitVec 8) (resetN valid : BitVec 1) :
    (v_CrcByte.eval ⟨resetN, valid, byte⟩ ⟨r⟩).2.v_crc =
      if resetN == 1 then (if valid == 1 then byteStep r byte else r) else 0xff := by
  have functions : wireStep = polyStep := funext (fun r ↦ funext (wire_poly r))
  rw [byteStep, ← functions]
  dsimp [v_CrcByte.eval, bitsMSB, List.range, wireStep]
  simp only [extract_shift]
  rfl

def serialInput (b : BitVec 1) : v_CrcSerial.Inputs := ⟨1, b, 1⟩
def byteInput (b : BitVec 8) : v_CrcByte.Inputs := ⟨1, 1, b⟩

/-- Arbitrarily long bit messages refine the polynomial recurrence from any remainder. -/
theorem serial_run (bits : List (BitVec 1)) (r : BitVec 8) :
    (YosysLean.run v_CrcSerial.eval (bits.map serialInput) ⟨r⟩).v_crc =
      bits.foldl polyStep r := by
  induction bits generalizing r with
  | nil => rfl
  | cons b rest ih =>
      change (YosysLean.run v_CrcSerial.eval (rest.map serialInput)
        (v_CrcSerial.eval (serialInput b) ⟨r⟩).2).v_crc = _
      have stateEq : (v_CrcSerial.eval (serialInput b) ⟨r⟩).2 = ⟨polyStep r b⟩ :=
        congrArg v_CrcSerial.State.mk (serial_step r b 1 1)
      rw [stateEq]
      exact ih _

theorem byte_run (bytes : List (BitVec 8)) (r : BitVec 8) :
    (YosysLean.run v_CrcByte.eval (bytes.map byteInput) ⟨r⟩).v_crc =
      bytes.foldl byteStep r := by
  induction bytes generalizing r with
  | nil => rfl
  | cons b rest ih =>
      change (YosysLean.run v_CrcByte.eval (rest.map byteInput)
        (v_CrcByte.eval (byteInput b) ⟨r⟩).2).v_crc = _
      have stateEq : (v_CrcByte.eval (byteInput b) ⟨r⟩).2 = ⟨byteStep r b⟩ :=
        congrArg v_CrcByte.State.mk (byte_step r b 1 1)
      rw [stateEq]
      exact ih _

private theorem flatten_fold (bytes : List (BitVec 8)) (r : BitVec 8) :
    (bytes.flatMap bitsMSB).foldl polyStep r = bytes.foldl byteStep r := by
  induction bytes generalizing r with
  | nil => rfl
  | cons b rest ih => simpa [List.foldl_append, byteStep] using ih (byteStep r b)

/-- The generated byte circuit and eight-times-clocked serial circuit agree for every message. -/
theorem serial_byte_agree (bytes : List (BitVec 8)) (r : BitVec 8) :
    (YosysLean.run v_CrcSerial.eval
      ((bytes.flatMap bitsMSB).map serialInput) ⟨r⟩).v_crc =
    (YosysLean.run v_CrcByte.eval (bytes.map byteInput) ⟨r⟩).v_crc := by
  rw [serial_run, byte_run, flatten_fold]

/-- Reset polarity and enable holding are part of the same RTL correspondence. -/
theorem reset_and_hold (r : BitVec 8) (b : BitVec 1) :
    (v_CrcSerial.eval ⟨0, b, 1⟩ ⟨r⟩).2.v_crc = 0xff ∧
    (v_CrcSerial.eval ⟨1, b, 0⟩ ⟨r⟩).2.v_crc = r := by
  simp [serial_step]

#check_claim serial_step, byte_step, serial_run, byte_run, serial_byte_agree, reset_and_hold
end CrcProofs
