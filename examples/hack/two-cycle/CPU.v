// SPDX-License-Identifier: ISC
// One fetch edge latches the instruction; the next edge executes it.
// Data memory is sampled on execute. Reset aborts a pending instruction.
module HackTwoCycle(
    input clk,
    input reset,                   // active-low synchronous reset
    input [15:0] instruction,
    input [15:0] inM,
    output [15:0] outM,
    output writeM,
    output [14:0] addressM,
    output reg [15:0] PC,
    output retire
);
    reg execute = 1'b0;
    reg [15:0] ir;
    reg [15:0] areg;
    reg [15:0] dreg;

    wire zr, ng;
    wire [15:0] y = ir[12] ? inM : areg;
    alu myalu(.x(dreg), .y(y), .out(outM),
        .zx(ir[11]), .nx(ir[10]), .zy(ir[9]), .ny(ir[8]),
        .f(ir[7]), .no(ir[6]), .zr(zr), .ng(ng));

    wire jump = ir[15] & ((ir[2] & ng) | (ir[1] & zr) | (ir[0] & !ng & !zr));
    assign addressM = areg[14:0];
    assign retire = reset & execute;
    assign writeM = retire & ir[15] & ir[3];

    always @(posedge clk) begin
        if (!reset) begin
            PC <= 16'b0;
            execute <= 1'b0;
        end else if (!execute) begin
            ir <= instruction;
            execute <= 1'b1;
        end else begin
            execute <= 1'b0;
            if (!ir[15]) areg <= ir;
            else if (ir[5]) areg <= outM;
            if (ir[15] & ir[4]) dreg <= outM;
            PC <= jump ? areg : PC + 16'd1;
        end
    end
endmodule
