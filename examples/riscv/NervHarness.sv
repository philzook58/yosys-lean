// Unchanged NERV RTL; select which retirement reports the upstream checker checks.
`include "rvfi_macros.vh"
module NervHarness (
  input clock, reset, stall,
  input [31:0] imem_data, dmem_rdata,
  `RVFI_OUTPUTS
);
`ifdef CHECK_ADDI
  wire selected = rvfi_insn[6:0] == 7'b0010011 && rvfi_insn[14:12] == 0;
`else
  wire selected = rvfi_insn[6:0] == 7'b0110011 && rvfi_insn[14:12] == 0 && rvfi_insn[31:25] == 0;
`endif
  nerv cpu (.clock(clock), .reset(reset), .stall(stall),
    .imem_data(imem_data), .dmem_rdata(dmem_rdata), `RVFI_CONN);
  rvfi_insn_check check_insn (.clock(clock), .reset(reset),
    .check(rvfi_valid && selected), `RVFI_CONN);
  // Reset before observing the arbitrary power-on state.
  reg started = 0;
  always @(posedge clock) started <= 1;
  always @* if (!started) assume(reset);
endmodule
