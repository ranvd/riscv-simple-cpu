/* 
 * We can't use wire as the datatype in "always" block.(sequentail circuit)
 * 
 */

module mux_4x1 (
    input wire a_i,
    input wire b_i,
    input wire c_i,
    input wire d_i,
    input wire [1:0]sel_i,
    output reg out
);
    always @(a_i or b_i or c_i or d_i or sel_i) begin
        case (sel_i)
            2'b00:  out = a_i;
            2'b01:  out = b_i;
            2'b10:  out = c_i;
            2'b11:  out = d_i;
            default:    out = a_i;
        endcase
    end
    
endmodule