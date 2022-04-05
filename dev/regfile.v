`include "defines.v"

module regfile(
    input wire clk_i,
    input wire rst_i,

    //from WB
    input wire we_i,
    input wire [`RegAddrBus] waddr_i,
    input wire [`RegBus] wdata_i,

    //from id read
    input wire re1_i, // read enable control
    input wire [`RegAddrBus] raddr1_i,
    input wire re2_i, // read enable control
    input wire [`RegAddrBus] raddr2_i,

    //to id
    output reg[`RegBus] rdata1_o,
    output reg[`RegBus] rdata2_o
);
    reg[`RegBus] regs[0:`RegNum-1];  // 32 bits

    // initial to zero 但是 initial 不是不能轉換成電路嗎？
    integer i;
    initial begin
        for (i = 0; i < `RegNum; i=i+1)
            regs[i] = 0;
    end

    //read 1
    always @(*) begin
       if (raddr1_i == `ZeroReg) begin
            rdata1_o <= `ZeroWord;
        // 如果 讀地址 = 寫地址且write enable，直接返回數據
        end else if (raddr1_i == waddr_i && we_i == `WriteEnable && re1_i == `ReadEnable) begin
            rdata1_o <= wdata_i;
        end else if (re1_i == `ReadEnable) begin
            rdata1_o <= regs[raddr1_i];
        end else begin
            rdata1_o <= `ZeroWord;
        end//if
    end//always
    
    //read 2
    always @(*) begin
        if (raddr2_i == `ZeroReg) begin
            rdata2_o <= `ZeroWord;
        // 如果 讀地址 = 寫地址且write enable，直接返回數據
        end else if (raddr2_i == waddr_i && we_i == `WriteEnable && re2_i == `ReadEnable) begin
            rdata2_o <= wdata_i;
        end else if (re2_i == `ReadEnable) begin
            rdata2_o <= regs[raddr2_i];
        end else begin
            rdata2_o <= `ZeroWord;
        end//if
    end//always
endmodule