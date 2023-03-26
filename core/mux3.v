
module mux3 #(
    parameter mux_data_width = `Mux_DATA_WIDTH
) (
    input wire [mux_data_width-1:0] a_i,
    input wire [mux_data_width-1:0] b_i,
    input wire [mux_data_width-1:0] c_i,
    input wire [1:0] sel_i,
    output reg [mux_data_width-1:0] out
);
    always @(*) begin
        case (sel_i)
            2'b00 : out = a_i;
            2'b01 : out = b_i;
            2'b10 : out = c_i;
            default: out = 0;
        endcase
    end
    
endmodule