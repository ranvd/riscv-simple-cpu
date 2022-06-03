module id_exe (
    input wire rst_i,
    input wire clk_i,

    //from id
    input wire[`RegBus] op1_i,
    input wire[`RegBus] op2_i,
    input wire reg_we_i,
    input wire[`RegAddrBus] reg_waddr_i,
    input wire[`AluOpBus] aluOp_i,

    //to exe
    output reg[`RegBus] op1_o,
    output reg[`RegBus] op2_o,
    output reg reg_we_o,
    output reg[`RegAddrBus] reg_waddr_o,
    output reg[`AluOpBus] aluOp_o
);
    always @(posedge clk_i) begin
        if (rst_i == `RstEnable) begin
            aluOp_o <= `NOP;
            op1_o <= `ZeroWord;
            op2_o <= `ZeroWord;
            reg_we_o <= `WriteDisable;
            reg_waddr_o <= `ZeroReg;
        end else begin
            aluOp_o <= aluOp_i;
            op1_o <= op1_i;
            op2_o <= op2_i;
            reg_we_o <= reg_we_i;
            reg_waddr_o <= reg_waddr_i;
        end
    end
endmodule