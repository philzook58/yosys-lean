// SPDX-License-Identifier: ISC
// Two multiplier bits per busy edge; a variable shift selects the partial product.
module BarrelMul(input clk, reset, start, input [31:0] a, b,
                 output reg busy, done, output reg [63:0] product);
  reg [63:0] multiplicand, rhs;
  reg [5:0] position, remaining;
  wire [63:0] shifted = multiplicand << position;
  wire [63:0] low = rhs[0] ? shifted : 64'd0;
  wire [63:0] high = rhs[1] ? (shifted << 1) : 64'd0;
  initial begin busy=0; done=0; end
  always @(posedge clk) begin
    done <= 0;
    if (reset) begin
      busy<=0; product<=0; multiplicand<=0; rhs<=0; position<=0; remaining<=0;
    end else if (busy) begin
      product <= product + low + high;
      rhs <= rhs >> 2;
      position <= position + 6'd2;
      remaining <= remaining - 1'b1;
      if (remaining == 1) begin busy<=0; done<=1; end
    end else if (start) begin
      multiplicand <= {32'b0,a}; rhs <= {32'b0,b}; product <= 0;
      position<=0; remaining<=16; busy<=1;
    end
  end
endmodule
