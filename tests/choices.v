// Independent choices at each edge; each driver retains its own identity.
module Choices(input clk, input en, output [7:0] choice, other, output reg [7:0] last);
  assign choice = $anyseq;
  assign other = $anyseq;
  always @(posedge clk) if (en) last <= choice;
endmodule
