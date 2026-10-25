module crc8 (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       data_in,
    input  logic       valid_in,
    output logic [7:0] crc
);
    logic feedback;
    assign feedback = crc[7] ^ data_in;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            crc <= 8'hFF;
        else if (valid_in) begin
            crc[7] <= crc[6];
            crc[6] <= crc[5];
            crc[5] <= crc[4];
            crc[4] <= crc[3];
            crc[3] <= crc[2];
            crc[2] <= crc[1] ^ feedback;
            crc[1] <= crc[0] ^ feedback;
            crc[0] <= feedback;
        end
    end
endmodule
