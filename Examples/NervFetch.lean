import Examples.NervArithmetic
import Examples.Generated.NervFetchView
import Examples.Generated.NervFetchBridge

/-! Actual fetch requests and synchronous instruction-memory composition for unchanged NERV. -/
namespace NervFetch
open v_NervFetch
set_option maxRecDepth 4096
set_option maxHeartbeats 800000
set_option exponentiation.threshold 2048

/-- Fetch follows the next physical PC, including stalls, from a coherent held address. -/
theorem request_next_pc (i : Inputs) (s : State)
    (ready : NervArchitecture.running (NervFetchBridge.state s))
    (reset : i.v_reset = 0) (held : s.v_cpu_imem_addr_q = s.v_cpu_pc) :
    (eval i s).1.v_imem_addr = (eval i s).2.v_cpu_pc := by
  rcases ready with ⟨hq, ht, hm⟩
  change s.v_cpu_reset_q = 0 at hq
  change s.v_cpu_trap = 0 at ht
  change s.v_cpu_mem_rd_enable_q = 0 at hm
  have gate : Named.Signals.v_n478 i s =
      v_NervAdd.Named.Signals.v_n478 (NervFetchBridge.inputs i) (NervFetchBridge.state s) :=
    by rfl
  rw [NervSafety.execution_gate] at gate
  by_cases stall : i.v_stall = (1#1)
  · have hg : Named.Signals.v_n478 i s = 0 := by simpa [NervFetchBridge.inputs, stall] using gate
    change (Named.eval i s).1.v_imem_addr = (Named.eval i s).2.v_cpu_pc
    dsimp only [Named.eval]
    unfold_nodes v_NervFetch.Named except
      [v_NervFetch.Named.Signals.v_n478, v_NervFetch.Named.Signals.v_n933]
    simp [reset, hq, ht, hm, hg, stall, held]
  · have stall0 : i.v_stall = (0#1) := by
      have cases : ∀ b : BitVec 1, b = 0 ∨ b = 1 := by decide
      exact (cases i.v_stall).resolve_right stall
    have hg : Named.Signals.v_n478 i s = 1 := by
      simpa [NervFetchBridge.inputs, NervFetchBridge.state, reset, hq, ht, stall0] using gate
    change (Named.eval i s).1.v_imem_addr = (Named.eval i s).2.v_cpu_pc
    dsimp only [Named.eval]
    unfold_nodes v_NervFetch.Named except
      [v_NervFetch.Named.Signals.v_n478, v_NervFetch.Named.Signals.v_n933]
    simp [reset, hq, ht, hm, hg, stall0]

/-- The port's held-address register captures the actual request on every edge. -/
theorem held_request (i : Inputs) (s : State) :
    (eval i s).2.v_cpu_imem_addr_q = (eval i s).1.v_imem_addr := by rfl

private theorem one_or (b : BitVec 1) : (1#1) ||| b = 1 := by revert b; decide
private theorem or_one (b : BitVec 1) : b ||| (1#1) = 1 := by revert b; decide

theorem reset_control (i : Inputs) (s : State) (reset : i.v_reset = 1) :
    (eval i s).2.v_cpu_reset_q = 1 ∧ (eval i s).2.v_cpu_trap = 0 ∧
    (eval i s).2.v_cpu_mem_rd_enable_q = 0 := by
  change (Named.eval i s).2.v_cpu_reset_q = 1 ∧ (Named.eval i s).2.v_cpu_trap = 0 ∧
    (Named.eval i s).2.v_cpu_mem_rd_enable_q = 0
  dsimp only [Named.eval]
  repeat' apply And.intro
  all_goals unfold_nodes v_NervFetch.Named except
    [v_NervFetch.Named.Signals.v_n478, v_NervFetch.Named.Signals.v_n880,
     v_NervFetch.Named.Signals.v_cpu_mem_rd_enable]
  all_goals simp [reset, one_or]

/-- Recovery requests the reset vector when memory is enabled and no old trap/load is pending. -/
theorem reset_request (i : Inputs) (s : State) (hq : s.v_cpu_reset_q = 1)
    (ht : s.v_cpu_trap = 0) (hm : s.v_cpu_mem_rd_enable_q = 0) (stall : i.v_stall = 0) :
    (eval i s).1.v_imem_addr = 0 := by
  change (Named.eval i s).1.v_imem_addr = 0
  dsimp only [Named.eval]
  unfold_nodes v_NervFetch.Named except [v_NervFetch.Named.Signals.v_n932]
  simp [hq, ht, hm, stall, or_one]

#check_claim NervFetchBridge.agrees, request_next_pc, held_request, reset_control, reset_request
end NervFetch
