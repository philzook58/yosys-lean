// SPDX-License-Identifier: ISC
// Intended: count modulo ten. The buggy terminal comparison permits count=10.
module Counter(input clk, reset, enable, output reg [3:0] count);
  always @(posedge clk) begin
    if (reset) count <= 0;
    else if (enable) begin
`ifdef REPAIRED
      if (count == 9) count <= 0;
`else
      if (count == 10) count <= 0;
`endif
      else count <= count + 1;
    end
  end
`ifdef FORMAL
  reg past_valid = 0;
  always @(posedge clk) begin
    if (!past_valid) assume(reset);
    past_valid <= 1;
    if (!reset) count_in_range: assert(count < 10);
  end
`endif
endmodule
