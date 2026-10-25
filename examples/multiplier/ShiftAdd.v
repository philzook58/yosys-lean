// SPDX-License-Identifier: ISC
// Unsigned 32x32 -> 64; one multiplier bit per busy edge.
module ShiftAdd(input clk, reset, start, input [31:0] a, b,
                output reg busy, done, output reg [63:0] product);
  reg [63:0] lhs, rhs;
  reg [5:0] remaining;
  initial begin busy=0; done=0; end
  always @(posedge clk) begin
    done <= 0;
    if (reset) begin
      busy <= 0; product <= 0; lhs <= 0; rhs <= 0; remaining <= 0;
    end else if (busy) begin
      if (rhs[0]) product <= product + lhs;
      lhs <= lhs << 1;
      rhs <= rhs >> 1;
      remaining <= remaining - 1'b1;
      if (remaining == 1) begin busy <= 0; done <= 1; end
    end else if (start) begin
      lhs <= {32'b0,a}; rhs <= {32'b0,b}; product <= 0;
      remaining <= 32; busy <= 1;
    end
  end
endmodule
