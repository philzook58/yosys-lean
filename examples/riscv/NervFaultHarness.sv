// Finite fault-detection workloads. The unmodified CPU is the repair control.
// Instruction memory has one rising-edge latency. Data memory returns the word 9.
`include "rvfi_macros.vh"
module NervFaultHarness (
  input clock,
  input [2:0] scenario,
  output reg [4:0] phase = 0,
  output reg [2:0] retired = 0,
  output [31:0] imem_addr,
  output operands_ok, result_ok, sequence_ok, fetch_ok, progress_ok, contract_ok,
  `RVFI_OUTPUTS
);
  reg [2:0] selected = 0;
  wire reset = phase == 0;
  wire stall = selected == 2 && phase == 4;
  wire [2:0] count = selected == 0 || selected == 3 ? 3 : 4;
  reg [31:0] imem_data = 0;
  reg [31:0] dmem_rdata = 0;

  // 0: bad source read; 1: rd=rs1 alias; 2: resume after stall;
  // 3: consume a load immediately; 4: jump over a wrong-path instruction.
  function [31:0] rom(input [2:0] which, input [31:0] addr);
    begin
      rom = 32'h00000013; // NOP outside the workload
      if (which == 3) begin
        case (addr)
          0: rom = 32'h00200093; // ADDI x1,x0,2
          4: rom = 32'h00002083; // LW x1,0(x0)
          8: rom = 32'h001081b3; // ADD x3,x1,x1 (18)
        endcase
      end else if (which == 4) begin
        case (addr)
           0: rom = 32'h00200093; // ADDI x1,x0,2
           4: rom = 32'h0080006f; // JAL x0,+8
           8: rom = 32'h06300113; // wrong path: ADDI x2,x0,99
          12: rom = 32'h00700113; // ADDI x2,x0,7
          16: rom = 32'h002081b3; // ADD x3,x1,x2 (9)
        endcase
      end else begin
        case (addr)
           0: rom = 32'h00200093; // ADDI x1,x0,2
           4: rom = 32'h00300113; // ADDI x2,x0,3
           8: rom = which == 0 ? 32'h002081b3 : 32'h002080b3;
          12: rom = which == 0 ? 32'h00000013 : 32'h002081b3; // alias/stall: 8
        endcase
      end
    end
  endfunction

  always @(posedge clock) begin
    if (phase < 15) phase <= phase + 1;
    if (reset) selected <= scenario;
    imem_data <= rom(selected, imem_addr);
    dmem_rdata <= 9;
    if (phase >= 3 && phase < 12 && retired < count && rvfi_valid)
      retired <= retired + 1;
  end

  wire dmem_valid;
  wire [31:0] dmem_addr, dmem_wdata;
  wire [3:0] dmem_wstrb;
  nerv cpu (.clock(clock), .reset(reset), .stall(stall),
    .imem_addr(imem_addr), .imem_data(imem_data),
    .dmem_valid(dmem_valid), .dmem_addr(dmem_addr), .dmem_wstrb(dmem_wstrb),
    .dmem_wdata(dmem_wdata), .dmem_rdata(dmem_rdata), `RVFI_CONN);

  wire checking = phase >= 3 && phase < 12 && retired < count && rvfi_valid;
  wire [31:0] expected_pc = {27'b0, retired, 2'b00}
    + (selected == 4 && retired >= 2 ? 4 : 0);
  wire [31:0] expected_insn = rom(selected, expected_pc);
  wire expected_add = expected_insn[6:0] == 7'h33;
  wire [31:0] expected_a = selected == 3 ? 9
    : (selected == 1 || selected == 2) && retired == 3 ? 5 : 2;
  wire [31:0] expected_b = selected == 3 ? 9 : selected == 4 ? 7 : 3;
  reg [31:0] expected_result;
  always_comb begin
    if (selected == 3)
      case (retired)
        0: expected_result = 2;
        1: expected_result = 9;
        default: expected_result = 18;
      endcase
    else if (selected == 4)
      case (retired)
        0: expected_result = 2;
        1: expected_result = 0; // JAL to x0
        2: expected_result = 7;
        default: expected_result = 9;
      endcase
    else
      case (retired)
        0: expected_result = 2;
        1: expected_result = 3;
        2: expected_result = 5;
        default: expected_result = 8;
      endcase
  end
  assign operands_ok = !checking || !expected_add
    || (rvfi_rs1_rdata == expected_a && rvfi_rs2_rdata == expected_b);
  assign result_ok = !checking
    || (rvfi_rd_addr == expected_insn[11:7] && rvfi_rd_wdata == expected_result);
  assign sequence_ok = !checking
    || (rvfi_pc_rdata == expected_pc && rvfi_insn == expected_insn);
  assign fetch_ok = !checking || rvfi_insn == rom(selected, rvfi_pc_rdata);
  assign progress_ok = phase != 12 || retired == count;
  assign contract_ok = operands_ok && result_ok && sequence_ok && fetch_ok && progress_ok;

`ifdef FORMAL
  wire add_report = rvfi_insn[6:0] == 7'h33 && rvfi_insn[14:12] == 0
    && rvfi_insn[31:25] == 0;
  rvfi_insn_check check_insn (.clock(clock), .reset(reset),
    .check(rvfi_valid && add_report), `RVFI_CONN);
  always @* begin
    if (reset) assume(scenario < 5);
    assert(operands_ok);
    assert(result_ok);
    assert(sequence_ok);
    assert(fetch_ok);
    assert(progress_ok);
    cover(phase == 12 && retired == count);
  end
`endif
endmodule
