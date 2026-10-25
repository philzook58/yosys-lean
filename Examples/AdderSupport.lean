import Init.Data.BitVec.Bitblast
import Lean.Elab.Tactic.Omega
import Lean.Elab.Tactic.Lets
import Lean.Elab.Tactic.ExposeNames
/-! Proof helpers for fixed exported netlists. Preserve SSA lets and stop unfolding
at proved carry boundaries, rather than expanding the entire circuit at once.
The tactics only construct ordinary kernel-checked proofs; they add no axioms. -/

namespace AdderProofs
set_option maxRecDepth 4096
set_option maxHeartbeats 500000
set_option pp.deepTerms false

/-- Widen before adding so the contract includes carry-out. -/
def sum33 (a b : BitVec 32) (cin : BitVec 1) : BitVec 33 :=
  a.setWidth 33 + b.setWidth 33 + cin.setWidth 33

theorem cin_bool (c : BitVec 1) : BitVec.ofBool (c.getLsbD 0) = c := by
  simpa using (BitVec.setWidth_one (x := c)).symm

theorem full_adder (a b c : Bool) :
    Bool.atLeastTwo a b c = ((a && b) || ((a ^^ b) && c)) := by
  cases a <;> cases b <;> cases c <;> rfl

theorem sum_bit (a b : BitVec 32) (c : BitVec 1) (i : Nat) (hi : i < 33) :
    (sum33 a b c).getLsbD i =
      ((a.setWidth 33).getLsbD i ^^ ((b.setWidth 33).getLsbD i ^^
        BitVec.carry i (a.setWidth 33) (b.setWidth 33) (c.getLsbD 0))) := by
  unfold sum33
  conv => lhs; rw [← cin_bool c]
  exact BitVec.getLsbD_add_add_bool hi _ _ _

theorem append_bits (x : BitVec n) (y : BitVec m) (i : Nat) :
    (BitVec.append x y).getLsbD i =
      if i < m then y.getLsbD i else x.getLsbD (i-m) := BitVec.getLsbD_append

-- Explicit unfolding keeps the named carry cut abstract.
elab "wire_simp" "[" skip:ident,* "]" : tactic => Lean.Elab.Tactic.withMainContext do
  let skip := skip.getElems.map (fun x => x.getId.eraseMacroScopes)
  let mut nodes : Array (Lean.TSyntax [`Lean.Parser.Tactic.simpStar, `Lean.Parser.Tactic.simpErase, `Lean.Parser.Tactic.simpLemma]) := #[]
  for d in ← Lean.getLCtx do
    if d.isLet && d.userName.eraseMacroScopes.toString.startsWith "v_" &&
        !skip.contains d.userName.eraseMacroScopes then
      let ident := Lean.mkIdent d.userName
      let node ← `(Lean.Parser.Tactic.simpLemma| $ident:term)
      nodes := nodes.push ⟨node.raw⟩
  Lean.Elab.Tactic.evalTactic (← `(tactic|
    simp (config := { zetaDelta := false }) only [$[$nodes],*, append_bits,
      BitVec.getLsbD_and, BitVec.getLsbD_or, BitVec.getLsbD_xor,
      BitVec.getLsbD_extractLsb', BitVec.getLsbD_setWidth, full_adder]))

-- Expand the arithmetic recurrence only to the selected previous carry.
elab "carry_step" k:num "from" boundary:num "at" wire:ident
    "using" previous:ident "cut" cut:ident "as" newName:ident : tactic => do
  let a := Lean.mkIdent `a
  let b := Lean.mkIdent `b
  let cin := Lean.mkIdent `cin
  let mut rules : Array (Lean.TSyntax `Lean.Parser.Tactic.rwRule) := #[]
  for j in (List.range (k.getNat - boundary.getNat)).reverse do
    let n := Lean.quote (boundary.getNat + j)
    rules := rules.push (← `(Lean.Parser.Tactic.rwRule| BitVec.carry_succ $n))
  rules := rules.push (← `(Lean.Parser.Tactic.rwRule| ← $previous:term))
  Lean.Elab.Tactic.evalTactic (← `(tactic|
    have $newName : ($wire).getLsbD 0 = BitVec.carry $k
        (($a).setWidth 33) (($b).setWidth 33) (($cin).getLsbD 0) := by
      rw [$[$rules],*]
      wire_simp [$cut]
      simp (config := { zetaDelta := false }) [Bool.and_or_distrib_left] <;> ac_rfl))

theorem equal_bits33 (x y : BitVec 33)
    (h0 : x.getLsbD 0 = y.getLsbD 0)
    (h1 : x.getLsbD 1 = y.getLsbD 1)
    (h2 : x.getLsbD 2 = y.getLsbD 2)
    (h3 : x.getLsbD 3 = y.getLsbD 3)
    (h4 : x.getLsbD 4 = y.getLsbD 4)
    (h5 : x.getLsbD 5 = y.getLsbD 5)
    (h6 : x.getLsbD 6 = y.getLsbD 6)
    (h7 : x.getLsbD 7 = y.getLsbD 7)
    (h8 : x.getLsbD 8 = y.getLsbD 8)
    (h9 : x.getLsbD 9 = y.getLsbD 9)
    (h10 : x.getLsbD 10 = y.getLsbD 10)
    (h11 : x.getLsbD 11 = y.getLsbD 11)
    (h12 : x.getLsbD 12 = y.getLsbD 12)
    (h13 : x.getLsbD 13 = y.getLsbD 13)
    (h14 : x.getLsbD 14 = y.getLsbD 14)
    (h15 : x.getLsbD 15 = y.getLsbD 15)
    (h16 : x.getLsbD 16 = y.getLsbD 16)
    (h17 : x.getLsbD 17 = y.getLsbD 17)
    (h18 : x.getLsbD 18 = y.getLsbD 18)
    (h19 : x.getLsbD 19 = y.getLsbD 19)
    (h20 : x.getLsbD 20 = y.getLsbD 20)
    (h21 : x.getLsbD 21 = y.getLsbD 21)
    (h22 : x.getLsbD 22 = y.getLsbD 22)
    (h23 : x.getLsbD 23 = y.getLsbD 23)
    (h24 : x.getLsbD 24 = y.getLsbD 24)
    (h25 : x.getLsbD 25 = y.getLsbD 25)
    (h26 : x.getLsbD 26 = y.getLsbD 26)
    (h27 : x.getLsbD 27 = y.getLsbD 27)
    (h28 : x.getLsbD 28 = y.getLsbD 28)
    (h29 : x.getLsbD 29 = y.getLsbD 29)
    (h30 : x.getLsbD 30 = y.getLsbD 30)
    (h31 : x.getLsbD 31 = y.getLsbD 31)
    (h32 : x.getLsbD 32 = y.getLsbD 32)
    : x = y := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have choices : i=0 ∨ i=1 ∨ i=2 ∨ i=3 ∨ i=4 ∨ i=5 ∨ i=6 ∨ i=7 ∨ i=8 ∨ i=9 ∨ i=10 ∨ i=11 ∨ i=12 ∨ i=13 ∨ i=14 ∨ i=15 ∨ i=16 ∨ i=17 ∨ i=18 ∨ i=19 ∨ i=20 ∨ i=21 ∨ i=22 ∨ i=23 ∨ i=24 ∨ i=25 ∨ i=26 ∨ i=27 ∨ i=28 ∨ i=29 ∨ i=30 ∨ i=31 ∨ i=32 := by omega
  rcases choices with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> first
    | exact h0
    | exact h1
    | exact h2
    | exact h3
    | exact h4
    | exact h5
    | exact h6
    | exact h7
    | exact h8
    | exact h9
    | exact h10
    | exact h11
    | exact h12
    | exact h13
    | exact h14
    | exact h15
    | exact h16
    | exact h17
    | exact h18
    | exact h19
    | exact h20
    | exact h21
    | exact h22
    | exact h23
    | exact h24
    | exact h25
    | exact h26
    | exact h27
    | exact h28
    | exact h29
    | exact h30
    | exact h31
    | exact h32

elab "finish_bit" k:num "as" newName:ident : tactic => Lean.Elab.Tactic.withMainContext do
  let a := Lean.mkIdent `a
  let b := Lean.mkIdent `b
  let cin := Lean.mkIdent `cin
  let cout := Lean.mkIdent `v_cout
  let sum := Lean.mkIdent `v_sum
  let mut cuts : Array (Lean.TSyntax `ident) := #[]
  let mut facts : Array (Lean.TSyntax [`Lean.Parser.Tactic.simpStar,
      `Lean.Parser.Tactic.simpErase, `Lean.Parser.Tactic.simpLemma]) := #[]
  for d in ← Lean.getLCtx do
    let name := d.userName.eraseMacroScopes.toString
    if name.startsWith "h" && (name.drop 1).toString.toNat?.isSome then
      let lhs := d.type.getAppArgs[1]!
      let word := lhs.getAppArgs[1]!
      if word.isFVar then
        cuts := cuts.push (Lean.mkIdent (← word.fvarId!.getDecl).userName)
        let ident := Lean.mkIdent d.userName
        let fact ← `(Lean.Parser.Tactic.simpLemma| $ident:term)
        facts := facts.push ⟨fact.raw⟩
  Lean.Elab.Tactic.evalTactic (← `(tactic|
    have $newName : (BitVec.append $cout $sum).getLsbD $k = (sum33 $a $b $cin).getLsbD $k := by
      rw [sum_bit $a $b $cin $k (by decide)]
      wire_simp [$[$cuts],*]
      simp (config := { zetaDelta := false }) only [$[$facts],*, BitVec.carry_zero]
      simp (config := { zetaDelta := false }) <;> ac_rfl))

end AdderProofs
