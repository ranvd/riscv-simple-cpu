/*
 * PC register and move to next instr(add word)
 * pc_reg沒有照著老師寫，如果到時候出問題要記得會去看老師的
 * 不會有讀不到第一個指令的問題。因為上下都是 posedge clk 驅動，
 * 因此
*/

module pc_reg (
    input wire clk_i,
    input wire rst_i,
    // from ctrl
    input wire jumpe_i,

    // from exe_mem
    input wire[`InstAddrBus] jump_addr_i,

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
        end else if(ce_o == `ChipEnable && jumpe_i == `JumpEnable) begin
            pc_o <= jump_addr_i;
        end else begin
            pc_o <= pc_o + 3'b100;
        end
    end
endmodule