// SPDX-License-Identifier: ISC
// Minimal reproduction of the EQY NERV tutorial's RV32 shift-amount width bug.
module ShiftWidth(input [31:0] value, amount, output [31:0] result);
`ifdef REPAIRED
  assign result = value << amount[4:0];
`else
  assign result = value << amount[5:0];
`endif
`ifdef FORMAL
  wire [31:0] expected = value << amount[4:0];
  always @* shift_matches_rv32: assert(result == expected);
`endif
endmodule
