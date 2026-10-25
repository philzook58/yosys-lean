import Examples.NervControlProgram

/-! A stored countdown loop: initialize x1=5, decrement, branch back, then park. -/
namespace NervControlExample
open NervArchitecture NervProgram NervControlProgram NervControlDecode
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

/-- 0: addi x1,x0,5; 4: addi x1,x1,-1; 8: bne x1,x0,-4; 12: jal x0,0. -/
def rom : Program := fun pc ↦
  if pc = 0 then 0x00500093 else if pc = 4 then 0xfff08093
  else if pc = 8 then 0xfe009ee3 else 0x0000006f

private def invariant (a : Architecture) : Prop :=
  a.regs 0 = 0 ∧ (a.pc = 0 ∨ a.pc = 4 ∨ a.pc = 8 ∨ a.pc = 12)

private theorem loop_step (a : Architecture) (h : invariant a) :
    NervControl.valid (rom a.pc) a ∧ invariant (NervControl.execute (rom a.pc) a) := by
  rcases h with ⟨zero, pc | pc | pc | pc⟩
  all_goals
    simp only [rom, pc, ↓reduceIte, BitVec.reduceEq]
    simp [NervControl.valid, NervControl.supported, NervArithmetic.supported,
      NervImmediate.isAddi, NervSafety.isAdd, isJal, isJalr, isBranch, branchFunction,
      aligned, target, displacement, taken, NervControl.execute, NervArithmetic.commit,
      invariant, pc]
  all_goals split <;> simp_all

/-- Admission is proved for every run length and stall schedule, independently of CPU state. -/
theorem loop_admitted (controls : List Inputs) (low : ∀ i ∈ controls, i.v_reset = 0)
    (a : Architecture) (pc : a.pc = 0) (zero : a.regs 0 = 0) :
    admitted rom controls a := by
  apply YosysLean.admissible_of_invariant (NervControlProgram.reference rom) _ invariant controls ?_
    a ⟨zero, Or.inl pc⟩
  intro i hi a h
  have ⟨valid, next⟩ := loop_step a h
  refine ⟨⟨low i hi, Or.inr valid⟩, ?_⟩
  simp only [NervControlProgram.reference]
  split <;> assumption

/-- Unchanged Verilog executes this looping ROM correctly for arbitrarily long runs with stalls. -/
theorem loop_from_reset (controls : List Inputs)
    (low : ∀ k ∈ controls, k.v_reset = 0) (i j : Inputs) (s : Machine)
    (reset : i.v_reset = 1) (release : j.v_reset = 0) (stall : j.v_stall = 0) :
    let start := (eval rom j (eval rom i s).2).2
    (NervProgram.project start).pc = 0 ∧
      coherent rom (YosysLean.run (eval rom) controls start) ∧
      NervProgram.project (YosysLean.run (eval rom) controls start) =
        YosysLean.run (NervControlProgram.reference rom) controls (NervProgram.project start) :=
  from_reset rom controls (loop_admitted controls low) i j s reset release stall

private def observe (a : Architecture) : BitVec 32 × BitVec 32 := (a.pc, a.regs 1)

private def counter (p : BitVec 32 × BitVec 32) : BitVec 32 × BitVec 32 :=
  if p.1 = 0 then (4, 5) else if p.1 = 4 then (8, p.2 - 1)
  else if p.1 = 8 then (if p.2 = 0 then 12 else 4, p.2) else p

private theorem observe_step (a : Architecture) (h : invariant a) :
    observe (NervControl.execute (rom a.pc) a) = counter (observe a) := by
  rcases h with ⟨zero, pc | pc | pc | pc⟩
  all_goals
    have zeroBits : a.regs (0#5) = (0#32) := zero
    simp [observe, counter, rom, pc, NervControl.execute, NervArithmetic.commit,
      NervArithmetic.result, NervImmediate.immediate, target, displacement, taken,
      zeroBits]
  all_goals simp only [BitVec.sub_eq_add_neg]; rfl

private theorem observe_run (n : Nat) (a : Architecture) (h : invariant a) :
    observe (YosysLean.run (NervControlProgram.reference rom)
      (List.replicate n (default : Inputs)) a) =
    YosysLean.run (fun (_ : Unit) p ↦ ((), counter p)) (List.replicate n ()) (observe a) := by
  induction n generalizing a with
  | zero => rfl
  | succ n ih =>
      have next := (loop_step a h).2
      have step : (NervControlProgram.reference rom default a).2 =
          NervControl.execute (rom a.pc) a := rfl
      simp only [List.replicate_succ, YosysLean.run, step]
      rw [ih _ next, observe_step a h]

-- Project equalities on variables first, so elaboration need not unfold a large CPU run.
private theorem observed_fields (a : Architecture) (p : BitVec 32 × BitVec 32)
    (h : observe a = p) : a.pc = p.1 ∧ a.regs 1 = p.2 := by
  exact ⟨congrArg Prod.fst h, congrArg Prod.snd h⟩

private theorem transfer_fields (a b : Architecture) (h : a = b)
    (done : b.pc = 12 ∧ b.regs 1 = 0) : a.pc = 12 ∧ a.regs 1 = 0 := by
  subst a
  exact done

/-- Eleven unstalled instructions initialize, count down five times, and reach the parking loop. -/
theorem reference_completes (a : Architecture) (pc : a.pc = 0) (zero : a.regs 0 = 0) :
    let final := YosysLean.run (NervControlProgram.reference rom)
      (List.replicate 11 (default : Inputs)) a
    final.pc = 12 ∧ final.regs 1 = 0 := by
  have done : YosysLean.run (fun (_ : Unit) p ↦ ((), counter p))
      (List.replicate 11 ()) (observe a) = (12, 0) := by
    change YosysLean.run _ _ (a.pc, a.regs 1) = _
    simp [YosysLean.run, List.replicate_succ, counter, pc]
  have simulation := (observe_run 11 a ⟨zero, Or.inl pc⟩).trans done
  exact observed_fields _ _ simulation

/-- The actual CPU reaches PC=12 with x1=0 after eleven unstalled instructions from reset. -/
theorem cpu_completes (i j : Inputs) (s : Machine)
    (reset : i.v_reset = 1) (release : j.v_reset = 0) (stall : j.v_stall = 0) :
    let start := (eval rom j (eval rom i s).2).2
    let final := NervProgram.project
      (YosysLean.run (eval rom) (List.replicate 11 (default : Inputs)) start)
    final.pc = 12 ∧ final.regs 1 = 0 := by
  have low : ∀ k ∈ List.replicate 11 (default : Inputs), k.v_reset = 0 := by
    intro k hk
    have same : k = default := List.eq_of_mem_replicate hk
    subst k
    rfl
  have ⟨pc, _, agrees⟩ := loop_from_reset _ low i j s reset release stall
  exact transfer_fields _ _ agrees (reference_completes _ pc rfl)

#check_claim loop_admitted, loop_from_reset, reference_completes, cpu_completes
end NervControlExample
