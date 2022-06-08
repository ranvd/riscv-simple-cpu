/*
 * the buffer between IF and ID
 * This buffer will stop the signal from IF to ID in one clock
*/

module if_id (
    input wire clk_i,
    input wire rst_i,
    // from ctrl unit
    input wire if_id_flush,

    //from if
    input wire[`InstAddrBus] inst_addr_i,
    input wire[`InstBus] inst_i,
    //to id
    output reg[`InstAddrBus] inst_addr_o,
    output reg[`InstBus] inst_o
);
    always @(posedge clk_i) begin
        if (rst_i == `RstEnable || if_id_flush == `FlushEnable) begin
            inst_addr_o <= `CpuResetAddr;
            inst_o = `NOP;
        end else begin
            inst_addr_o <= inst_addr_i;
            inst_o <= inst_i;
        end
    end
    
endmodule