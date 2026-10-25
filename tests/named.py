"""General named-expression output: symbolic semantics and ordinary local Lean proofs."""
import re
from smt import read_model


def check_named(args, run, yosys, quote, symbolic, env, fixtures):
    for top, source, formal in fixtures:
        compact = args.work / (top + ".lean")
        named_top = top + "Named"
        named = args.work / (named_top + ".lean")
        script = f"read_verilog {'-formal ' if formal else ''}{quote(source)}; "
        script += f"hierarchy -check -top {top}; rename {top} {named_top}; "
        yosys(script + f"lean_prepare; write_lean -named {quote(named)}")
        before = named.read_bytes()
        # Printing must not modify the design or the names on a subsequent print.
        again = args.work / "NamedAgain.lean"
        compact_again = args.work / (top + "RoundTrip.lean")
        yosys(script + f"lean_prepare; write_lean -named {quote(again)}; "
              + f"write_lean -named {quote(named)}; write_lean {quote(compact_again)}")
        assert "namespace Signals" not in compact_again.read_text()
        assert read_model(compact_again.read_text()) == read_model(compact.read_text())
        assert named.read_bytes() == again.read_bytes() == before
        oracle = args.work / (named_top + ".smt2")
        yosys(script + "proc; flatten; opt_clean; dffunmap; "
              + f"write_smt2 -stdt -wires {quote(oracle)}")
        symbolic(named_top, named, oracle)
        run([args.lake, "env", "lean", "-o", args.work / (named_top + ".olean"), named], env=env)
        fields, _, _, _ = read_model(compact.read_text())
        maps = []
        for kind in ("Inputs", "State", "Outputs"):
            values = ", ".join(f"{field} := value.{field}" for field, _ in fields[kind])
            maps.append(f"def map{kind} (value : v_{top}.{kind}) : v_{named_top}.{kind} :=\n"
                        + f"  {{ {values} }}\n")
        proof = args.work / (top + "NamedProof.lean")
        proof.write_text(f"import {top}\nimport {named_top}\n" + "\n".join(maps)
            + f"example (i : v_{top}.Inputs) (s : v_{top}.State) :\n"
            + f"    v_{named_top}.eval (mapInputs i) (mapState s) =\n"
            + f"      (mapOutputs (v_{top}.eval i s).1, mapState (v_{top}.eval i s).2) := by rfl\n"
            + f"example (s : v_{top}.State) :\n"
            + f"    v_{named_top}.initial (mapState s) ↔ v_{top}.initial s := by rfl\n")
        with proof.open("a") as output:
            for field, _ in fields["State"]:
                output.write(f"example (i : v_{named_top}.Inputs) (s : v_{named_top}.State) :\n"
                    + f"    (v_{named_top}.eval i s).2.{field} = v_{named_top}.Next.{field} i s :=\n"
                    + f"  v_{named_top}.eval_next_{field} i s\n")
        run([args.lake, "env", "lean", proof], env=env)
    print("PASS: named expressions agree with compact Lean and write_smt2; deterministic printing", flush=True)

    # Hierarchical wire names provide directly addressable, ordinary proof boundaries.
    source = args.work / "ProofInterface.v"
    source.write_text("""module Stage(input [7:0] data, output [7:0] result);
      wire [7:0] bumped = data + 8'd1;
      assign result = bumped ^ data;
    endmodule
    module ProofInterface(input clk,reset,enable,input [7:0] data,output reg [7:0] q);
      wire [7:0] intermediate;
      Stage stage(data, intermediate);
      always @(posedge clk) if(reset) q<=0; else if(enable) q<=intermediate;
    endmodule
    """)
    model = args.work / "ProofInterface.lean"
    yosys(f"read_verilog {quote(source)}; hierarchy -check -top ProofInterface; "
          + f"lean_prepare; write_lean -named {quote(model)}")
    text = model.read_text()
    assert "def v_stage_bumped " in text and "; src:" in text
    run([args.lake, "env", "lean", "-o", args.work / "ProofInterface.olean", model], env=env)
    proof = args.work / "LocalSignalProof.lean"
    signal_body = text.split("namespace Signals\n", 1)[1].split("end Signals", 1)[0]
    definitions = re.findall(r"^def (v_\w+) \(inputs", signal_body, re.M)
    unfold = ", ".join("Signals." + name for name in definitions if name != "v_stage_bumped")
    proof.write_text("import ProofInterface\nopen v_ProofInterface\n"
        + "theorem local_arithmetic (i : Inputs) (s : State) :\n"
        + "    Signals.v_stage_bumped i s = i.v_data + 1 := by rfl\n"
        + "example (i : Inputs) (s : State) (r : i.v_reset = 0) (e : i.v_enable = 1) :\n"
        + "    (eval i s).2.v_q = (i.v_data + 1) ^^^ i.v_data := by\n"
        + "  rw [eval_next_v_q]\n"
        + "  have datapath := congrArg (fun x ↦ x ^^^ i.v_data) (local_arithmetic i s)\n"
        + f"  simpa [Next.v_q, {unfold}, r, e] using datapath\n"
        + "#print axioms eval_next_v_q\n")
    # The local arithmetic theorem above intentionally refers only to the retained
    # RTL signal name. The state update proof uses the generated mux definitions.
    run([args.lake, "env", "lean", proof], env=env)
    print("PASS: hierarchical intermediate signal lemma and register update proof", flush=True)
