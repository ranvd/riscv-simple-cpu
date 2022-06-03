/*
 * PC register and move to next instr(add word)
*/

module pc_reg (
    input wire clk_i,
    input wire rst_i,
    output reg[`InstAddrBus] pc_o,
    output reg ce_o       //the output used to control the fetch instuction or not.
);
    
    always @(posedge clk_i) begin
        if (rst_i == `RstEnable) begin
            ce_o <= `ChipDisable;
        end else begin
            ce_o <= `ChipEnable;
        end
    end

    always @(posedge clk_i) begin
        if (ce_o == `ChipDisable) begin
            pc_o <= `CpuResetAddr;
        end else begin
            pc_o <= pc_o + 1'b1;
        end
    end

endmodule