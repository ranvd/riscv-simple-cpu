`include "defines.v"

module pc_reg(
    input wire clk_i,
    input wire rst_i,
    
    output reg[`InstAddrBus] pc_o,
    output reg ce_o
    );

    reg[`InstAddrBus] pc_next;

    always @(posedge clk_i) begin
        if (rst_i == `RstEnable) begin
            ce_o <= `ChipDisable;
        end else begin
            ce_o <= `ChipEnable;
        end//if
    end//always
    
    always @(posedge ce_o) begin
        pc_o <= `CpuResetAddr; 
    end

    always @(posedge clk_i) begin
        if (ce_o == `ChipDisable) begin
            pc_next <= `CpuResetAddr;
        end else begin
            pc_o <= pc_next;
            pc_next <= pc_next + 4'h4;
        end//if
    end//always
endmodule