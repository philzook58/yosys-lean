// SPDX-License-Identifier: ISC
// Same 0x07 polynomial, MSB-first, 0xff initial remainder as crc8_sync.
module CrcByte(input clk, rst_n, valid_in, input [7:0] data_in, output reg [7:0] crc);
  function [7:0] update;
    input [7:0] state, data;
    reg [7:0] r;
    integer i;
    begin
      r = state;
      for (i=7; i>=0; i=i-1)
        r = (r << 1) ^ ((r[7] ^ data[i]) ? 8'h07 : 8'h00);
      update = r;
    end
  endfunction
  always @(posedge clk)
    if (!rst_n) crc <= 8'hff;
    else if (valid_in) crc <= update(crc, data_in);
endmodule
