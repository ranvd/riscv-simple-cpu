module regfile (
    input wire clk_i,
    input wire rst_i,

    //from WB
    input wire we_i,
    input wire [`RegAddrBus] waddr_i,
    input wire [`RegBus] wdata_i,

    //from id read
    input wire re1_i,
    input wire[`RegAddrBus] raddr1_i,
    input wire re2_i,
    input wire[`RegAddrBus] raddr2_i,

    //to id
    output reg[`RegBus] rdata1_o,
    output reg[`RegBus] rdata2_o
);
    reg[`RegBus] regs[`RegNum-1:0];
    integer i;
    initial begin
        for(i=0; i < `RegNum; i = i+1)
            regs[i] = 0;
    end

    //write
    always @(posedge clk_i) begin
        if(rst_i == `RstDisable) begin
            //write first, read second
            if((we_i == `WriteEnable) && (waddr_i != `ZeroReg)) begin
                regs[waddr_i] <= wdata_i;
            end
        end
    end

    //read1  rs1
    always @(*) begin   //這裡使用 * 的原因是因為它不需要跟 clk 相關，而且在此設計中，regfile 與 id 會互相影響。
        if (raddr1_i == `ZeroReg) begin
            rdata1_o <= `ZeroWord;
        end else if (raddr1_i == waddr_i && we_i == `WriteEnable && re1_i == `ReadEnable) begin  //我認為這行應該不用，這行原本是用來解決相隔三個指令的 data hazard
            rdata1_o <= wdata_i;
        end else if (re1_i == `ReadEnable) begin
            rdata1_o <= regs[raddr1_i];
        end else begin
            rdata1_o <= `ZeroWord;
        end
    end

    //read2  rs2
    always @(*) begin   //不太懂為什麼要用 *，不用clk
        if (raddr2_i == `ZeroReg) begin
            rdata2_o <= `ZeroWord;
        end else if (raddr2_i == waddr_i && we_i == `WriteEnable && re2_i == `ReadEnable) begin
            rdata2_o <= wdata_i;
        end else if (re2_i == `ReadEnable) begin
            rdata2_o <= regs[raddr2_i];
        end else begin
            rdata2_o <= `ZeroWord;
        end
    end
    
endmodule