module pseudoadder #(
    parameter DATA_WIDTH = 64
)(
    input wire [DATA_WIDTH-1:0] a0,
    input wire [DATA_WIDTH-1:0] a1,
    input wire [DATA_WIDTH-1:0] a2,
    output reg [DATA_WIDTH-1:0] s,
    output reg [DATA_WIDTH-1:0] c
);
    genvar i;
    for (i = 0; i < DATA_WIDTH-1; i = i+1) begin
        fulladder fd1 (a0[i], a1[i], a2[i], s[i], c[i+1]);
    end

    wire overflow;
    fulladder fd2 (a0[DATA_WIDTH-1], a1[DATA_WIDTH-1], a2[DATA_WIDTH-1], s[DATA_WIDTH-1], overflow);
    
endmodule