// SPDX-License-Identifier: ISC
// The original FSM leaves output 'o' uninitialized. Compare once both have taken an edge.
module EqyFSMHarness(input clk);
  wire [1:0] gold_o, gate_o;
  EQYGold gold(clk, gold_o);
  EQYGate gate(clk, gate_o);
  reg started = 0;
  always @(posedge clk) started <= 1;
  always @* if (started) begin
`ifdef NEGATIVE_CONTROL
    outputs_equal: assert (gold_o == (gate_o ^ 2'b01));
`else
    outputs_equal: assert (gold_o == gate_o);
`endif
  end
endmodule
