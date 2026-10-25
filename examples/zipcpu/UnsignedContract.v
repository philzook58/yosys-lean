// SPDX-License-Identifier: ISC
// One unsigned request from the divider's specified initial state, then quiet edges.
// This is a benchmark harness; the upstream divider is unchanged.
module DividerUnsignedContract #(
  parameter BW = 32, LGBW = 5
)(input clk, input [BW-1:0] numerator, denominator);
  reg [LGBW:0] cycle = 0;
  reg [BW-1:0] saved_a, saved_b;
  wire request = (cycle == 0);
  wire busy, valid, error;
  wire [BW-1:0] quotient;
  wire [3:0] flags;
  div #(.BW(BW), .LGBW(LGBW), .OPT_LOWPOWER(0)) uut (
    .i_clk(clk), .i_reset(1'b0), .i_wr(request), .i_signed(1'b0),
    .i_numerator(numerator), .i_denominator(denominator),
    .o_busy(busy), .o_valid(valid), .o_err(error),
    .o_quotient(quotient), .o_flags(flags)
  );
  always @(posedge clk) begin
    if (cycle < BW+2) cycle <= cycle + 1'b1;
    if (request) begin
      saved_a <= numerator;
      saved_b <= denominator;
    end
`ifdef FORMAL
    if (request) assume(denominator != 0);
    if (cycle > 0 && cycle <= BW)
      in_progress: assert(busy && !valid && !error);
    if (cycle == BW+1) begin
      completed: assert(!busy && valid && !error);
`ifdef BROKEN_PROPERTY
      arithmetic: assert(quotient == ((saved_a / saved_b) ^ 1'b1));
`else
      arithmetic: assert(quotient == saved_a / saved_b);
`endif
    end
    if (cycle == BW+2) pulse_cleared: assert(!valid && !busy && !error);
`endif
  end
endmodule
