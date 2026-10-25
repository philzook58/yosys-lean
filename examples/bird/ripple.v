// SPDX-License-Identifier: ISC
module Ripple32(input [31:0] a, b, input cin, output [31:0] sum, output cout);
  genvar i;
  generate for (i=0; i<32; i=i+1) begin: column
    wire carry_in, carry_out;
    if (i==0) assign carry_in = cin;
    else assign carry_in = column[i-1].carry_out;
    assign sum[i] = a[i] ^ b[i] ^ carry_in;
    assign carry_out = (a[i] & b[i]) | ((a[i] ^ b[i]) & carry_in);
  end endgenerate
  assign cout = column[31].carry_out;
endmodule
