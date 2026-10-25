import Init.Data.BitVec.Lemmas

/-! Explicit slice rewrites for lowered circuits. No global simp rules. -/
namespace YosysLean.Bits

/-- A slice contained in the low concatenated word ignores the high word. -/
theorem slice_low (a : BitVec m) (b : BitVec n) (start len : Nat)
    (h : start + len ≤ n) :
    (BitVec.append a b).extractLsb' start len = b.extractLsb' start len :=
  BitVec.extractLsb'_append_eq_of_add_le h

/-- A slice above the low word can be taken directly from the high word. -/
theorem slice_high (a : BitVec m) (b : BitVec n) (start len : Nat)
    (h : n ≤ start) :
    (BitVec.append a b).extractLsb' start len = a.extractLsb' (start-n) len :=
  BitVec.extractLsb'_append_eq_of_le h

end YosysLean.Bits
