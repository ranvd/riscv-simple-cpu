module exe_mem (
    input wire rst_i,
    input wire clk_i,

    //from ctrl unit
    input wire exe_mem_flush,

    //from exe
    input wire[`InstAddrBus] jump_addr_i,
    input wire[`RegAddrBus] reg_waddr_i,
    input wire reg_we_i,
    input wire[`RegBus] reg_wdata_i,
    input wire[`StoreAddrBus] mem_addr_i,
    input wire mem_re_i,
    input wire mem_we_i,
    input wire mem_ls_bits_i,

    //to mem
    output reg[`RegAddrBus] reg_waddr_o,
    output reg reg_we_o,
    output reg[`RegBus] reg_wdata_o,
    output reg[`StoreAddrBus] mem_addr_o,

    //to pc
    output reg[`InstAddrBus] jump_addr_o
);
    always @(posedge clk_i) begin
        if (rst_i == `RstEnable || exe_mem_flush == `FlushEnable) begin
            reg_waddr_o <= `ZeroReg;
            reg_we_o <= `WriteDisable;
            reg_wdata_o <= `ZeroWord;
            jump_addr_o <= `ZeroWord;
            mem_addr_o <= `ZeroWord;
        end else begin
            reg_waddr_o <= reg_waddr_i;
            reg_we_o <= reg_we_i;
            reg_wdata_o <= reg_wdata_i;
            jump_addr_o <= jump_addr_i;
            mem_addr_o <= mem_addr_i;
        end
    end
endmodule