"""Check enabled properties, first-state assumptions, and edge sampling in actual Lean."""


def check_properties(args, run, yosys, quote, env):
    for mode in ("", "-named "):
        _check_properties(args, run, yosys, quote, env, mode)


def _check_properties(args, run, yosys, quote, env, mode):
    source = args.work / "Properties.v"
    source.write_text("""module Properties(input clk, en, p, output reg q);
      initial assume(p);
      always @* if(en) begin assert(p); assume(p); cover(p); end
      always @(posedge clk) begin q <= p; assert(q == p); end
    endmodule
    """)
    model = args.work / "Properties.lean"
    yosys(f"read_verilog -formal {quote(source)}; hierarchy -top Properties; "
          + f"lean_prepare; write_lean {mode}{quote(model)}")
    text = model.read_text()
    assert text.count("  -- $assert ") == 2
    assert text.count("  -- $assume ") == 2
    assert text.count("  -- $cover ") == 1
    assert "Properties.v:" in text
    assert "$auto$lean.cc:" not in text
    run([args.lake, "env", "lean", "-o", args.work / "Properties.olean", model], env=env)
    proof = args.work / "PropertyChecks.lean"
    proof.write_text("""import Properties
open v_Properties
example : ∀ (en p q first : BitVec 1),
    assertions (eval ⟨en, p⟩ { v_q := q, v__initstate := first }).1 ↔
      (en = 1 → p = 1) ∧ q = p := by unfold assertions; decide
example : ∀ (en p q first : BitVec 1),
    assumptions (eval ⟨en, p⟩ { v_q := q, v__initstate := first }).1 ↔
      (en = 1 → p = 1) ∧ (first = 1 → p = 1) := by unfold assumptions; decide
example : ∀ (en p q first : BitVec 1),
    covers (eval ⟨en, p⟩ { v_q := q, v__initstate := first }).1 ↔
      en = 1 ∧ p = 1 := by unfold covers; decide
example : ∀ (en p q first : BitVec 1),
    (eval ⟨en, p⟩ { v_q := q, v__initstate := first }).2.v_q = p ∧
    (eval ⟨en, p⟩ { v_q := q, v__initstate := first }).2.v__initstate = 0 := by decide
example : ∀ (q first : BitVec 1),
    initial { v_q := q, v__initstate := first } ↔ first = 1 := by unfold initial; decide
""")
    run([args.lake, "env", "lean", proof], env=env)
    print(f"PASS ({mode.strip() or 'compact'}): enabled assertions/assumptions, nonvacuous covers, initial-only assumptions, "
          "and pre-edge property sampling", flush=True)
