module mux3 (
    input wire [`INST_WIDTH-1:0] a_i,
    input wire [`INST_WIDTH-1:0] b_i,
    input wire [`INST_WIDTH-1:0] c_i,
    input wire [1:0] sel_i,
    output reg [`INST_WIDTH-1:0] out
);
    always @(*) begin
        case (sel_i)
            2'b00 : out = a_i;
            2'b01 : out = b_i;
            2'b10 : out = c_i;
            default: out = `INST_WIDTH'b0;
        endcase
    end
    
endmodule