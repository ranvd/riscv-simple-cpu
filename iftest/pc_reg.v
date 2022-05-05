/*
This file is for PC module
    - variable end up with 'i' is for input and 'o' is for output.
    - clk_i represent clock
    - rst_i represent reset
    - pc_o represent PC register(Program counter)
        the PC here is 6bit width
    - ce_o is 
*/
`include "defines.v"


module pc_reg (
    input wire clk_i,
    input wire rst_i,
    output reg[`InstAddrBus] pc_o,
    output reg ce_o
);
    always @(posedge clk_i) begin
        // if reset enable, then Chip disable
        if (rst_i == `RstEnable) begin
            ce_o <= `ChipDisable;
        end else begin
            ce_o <= `ChipEnable;
        end
    end

    always @(posedge clk_i) begin
        if (ce_o == `ChipEnable) begin
            pc_o <= pc_o + `Word;
        end else begin
            pc_o <= `CpuResetAddr;
        end
    end
    
endmodule
