module exe (
    input wire rst_i,

    //from id_exe
    input wire[`RegBus] op1_i,
    input wire[`RegBus] op2_i,
    input wire reg_we_i,
    input wire[`RegAddrBus] reg_waddr_i,
    input wire[`AluOpBus] aluOp_i,
    
    //to exe_mem
    output reg[`RegAddrBus] reg_waddr_o,
    output reg reg_we_o,
    output reg[`RegBus] reg_wdata_o
);
    always @(*) begin
        if (rst_i == `RstEnable) begin
            reg_waddr_o <= `ZeroReg;
            reg_wdata_o <= `ZeroWord;
            reg_we_o <= `WriteDisable;
        end else begin
            case (aluOp_i)
                `ORI: begin
                    reg_waddr_o <= reg_waddr_i;
                    reg_wdata_o <= op1_i | op2_i;
                    reg_we_o <= `WriteEnable;
                end
                default: begin
                    reg_waddr_o <= `ZeroReg;
                    reg_wdata_o <= `ZeroWord;
                    reg_we_o <= `WriteDisable;
                end
            endcase
        end
    end
    
endmodule