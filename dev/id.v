`include "defines.v"

module id(
    input wire rst_i,
    
    //from if_id
    input wire[`InstAddrBus] inst_addr_i,
    input wire[`InstBus] inst_i,
    
    //from regfile *還沒 implement 我也不知道為什麼需要
    input wire[`RegBus] reg1_rdata_i,
    input wire[`RegBus] reg2_rdata_i,
       
    // to regfile
    output reg[`RegAddrBus] reg1_raddr_o,
    output reg[`RegAddrBus] reg2_raddr_o,
    output reg reg1_re_o,
    output reg reg2_re_o,
    
    //to id_exe
    output reg[`AluOpBus] aluOp_o,
    output reg[`RegBus] op1_o,
    output reg[`RegBus] op2_o,
    output reg reg_we_o,
    output reg[`RegAddrBus] reg_waddr_o
    );
    
    wire[6:0] opcode = inst_i[6:0];
    wire[2:0] funct3 = inst_i[14:12];
    wire[6:0] funct7 = inst_i[31:25];
    wire[4:0] rd = inst_i[11:7];
    wire[4:0] rs1 = inst_i[19:15];
    wire[4:0] rs2 = inst_i[24:20];
    
    always @(*) begin
        if (rst_i == `RstEnable) begin
            aluOp_o <= `NOP;
            reg1_raddr_o <= `ZeroReg;
            reg2_raddr_o <= `ZeroReg;
            reg1_re_o <= `ReadDisable;
            reg2_re_o <= `ReadDisable;
            reg_we_o <= `WriteDisable;
            reg_waddr_o <= `ZeroReg;
            op1_o <= `ZeroWord;
            op2_o <= `ZeroWord;
        end else begin
            case (opcode)
                `INST_TYPE_I:begin
                    case (funct3)
                        `INST_ORI: begin
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                            reg1_raddr_o <= rs1;
                            reg2_raddr_o <= `ZeroReg;
                            reg1_re_o <= `ReadEnable;
                            reg2_re_o <= `ReadDisable;
                            op1_o <= reg1_rdata_i;
                            op2_o <= {{20{inst_i[31]}}, inst_i[31:20]}; // immi value, sign extention
                            aluOp_o <= `ORI;         
                        end//INST_ORI
                        default: begin
                            reg_we_o = `WriteDisable;
                            reg_waddr_o <= `ZeroReg;
                            reg1_raddr_o <= `ZeroReg;
                            reg1_re_o <= `ReadDisable;
                            reg2_raddr_o <= `ZeroReg;
                            reg2_re_o <= `ReadDisable;
                            op1_o <= `ZeroWord;
                            op2_o <= `ZeroWord;
                            aluOp_o <= `NOP;
                        end//default
                    endcase
		        end
                default:begin
                        reg_we_o = `WriteDisable;
                        reg_waddr_o <= `ZeroReg;
                        reg1_raddr_o <= `ZeroReg;
                        reg1_re_o <= `ReadDisable;
                        reg2_raddr_o <= `ZeroReg;
                        reg2_re_o <= `ReadDisable;                                 
                        op1_o <= `ZeroWord;
                        op2_o <= `ZeroWord;
                        aluOp_o <= `NOP;
                end//default
            endcase
        end//if
    end//always
endmodule