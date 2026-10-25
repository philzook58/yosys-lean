// SPDX-License-Identifier: ISC
// One-entry elastic stage: computes 5*x+1 modulo 2^16 on accepted input.
module Elastic(input clk, reset, in_valid, out_ready, input [15:0] in_data,
               output in_ready, out_valid, output [15:0] out_data);
  reg full;
  reg [15:0] data;
  initial full = 0;
  assign in_ready = !reset && (!full || out_ready);
  assign out_valid = !reset && full;
  assign out_data = data;
  always @(posedge clk) begin
    if (reset) full <= 0;
    else if (in_ready) begin
      full <= in_valid;
      if (in_valid) data <= (in_data << 2) + in_data + 16'd1;
    end
  end
endmodule
