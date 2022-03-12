/*
This file is for PC module
    - variable end up with 'i' is for input and 'o' is for output.
    - clk_i represent clock
    - rst_i represent reset
    - pc_o represent PC register(Program counter)
        the PC here is 6bit width
    - ce_o is 
*/

module pc_reg (
    input wire clk_i,
    input wire rst_i,
    output reg[5:0] pc_o,
    output reg ce_o
);
    always @(posedge clk_i) begin
        if (rst_i) begin
            ce_o <= 1'b0;
        end else begin
            ce_o <= 1'b1; // if we don't reset,, ce_o value will be 1 at most of the time
        end
    end

    always @(posedge clk_i) begin
        if (ce_o) begin
            pc_o <= pc_o + 1'b1;
        end else begin
            pc_o <= 6'b000000;
        end
    end
    
endmodule