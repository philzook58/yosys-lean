import YosysLean

/-! An instruction-level Hack specification, independent of the generated circuit. -/
namespace HackSpec

structure Inputs where
  instruction : BitVec 16
  memory : BitVec 16
  /-- The historical RTL uses an active-low synchronous PC reset. -/
  resetN : Bool
  deriving DecidableEq, Repr, Inhabited

structure State where
  a : BitVec 16
  d : BitVec 16
  pc : BitVec 15
  deriving DecidableEq, Repr, Inhabited

structure Outputs where
  value : BitVec 16
  write : Bool
  address : BitVec 15
  pc : BitVec 15
  deriving DecidableEq, Repr, Inhabited

/-- The six Hack ALU control bits, in their instruction positions. -/
def alu (instruction x y : BitVec 16) : BitVec 16 :=
  let x := if instruction.getLsbD 11 then 0 else x
  let x := if instruction.getLsbD 10 then ~~~x else x
  let y := if instruction.getLsbD 9 then 0 else y
  let y := if instruction.getLsbD 8 then ~~~y else y
  let value := if instruction.getLsbD 7 then x + y else x &&& y
  if instruction.getLsbD 6 then ~~~value else value

/-- All encodings with bit 15 set use C-instruction control fields, as in the RTL.
The unused C prefix bits do not restrict the theorem to assembler-produced programs. -/
def eval (i : Inputs) (s : State) : Outputs × State :=
  let insn := i.instruction
  let compute := insn.getLsbD 15
  let y := if insn.getLsbD 12 then i.memory else s.a
  let value := alu insn s.d y
  let negative := value.getLsbD 15
  let zero := value == 0
  let jump := (insn.getLsbD 2 && negative) || (insn.getLsbD 1 && zero) ||
    (insn.getLsbD 0 && !negative && !zero)
  ({ value, write := compute && insn.getLsbD 3,
     address := s.a.setWidth 15, pc := s.pc },
   { a := if !compute then insn else if insn.getLsbD 5 then value else s.a,
     d := if compute && insn.getLsbD 4 then value else s.d,
     pc := if !i.resetN then 0 else if compute && jump then s.a.setWidth 15 else s.pc + 1 })

end HackSpec
