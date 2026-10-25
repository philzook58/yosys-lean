// SPDX-License-Identifier: ISC
// A one-entry ready/valid buffer. Bug: overwrites data while its output is stalled.
module StallBuffer(input clk, reset, in_valid, out_ready, input [7:0] in_data,
                   output in_ready, out_valid, output [7:0] out_data);
  reg full;
  reg [7:0] data;
  assign in_ready = !reset && (!full || out_ready);
  assign out_valid = !reset && full;
  assign out_data = data;
  always @(posedge clk) begin
    if (reset) full <= 0;
    else begin
      if (in_ready) full <= in_valid;
`ifdef REPAIRED
      if (in_valid && in_ready) data <= in_data;
`else
      if (in_valid) data <= in_data;
`endif
    end
  end
`ifdef FORMAL
  reg past_valid = 0;
  always @(posedge clk) begin
    if (!past_valid) assume(reset);
    past_valid <= 1;
    if (past_valid && !reset && $past(!reset && out_valid && !out_ready))
      stable_while_stalled: assert(out_valid && out_data == $past(out_data));
  end
`endif
endmodule
