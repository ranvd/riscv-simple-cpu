// 這邊只解決指令間隔 1~2 個的 data hazard 
// 間隔 3 個的 data hazard 在 regfile 裡面解決(我認為這樣不好，但之後有空再來改)

module id(
    input wire rst_i,
    
    //from if_id
    input wire[`InstAddrBus] inst_addr_i,
    input wire[`InstBus] inst_i,
    
    //from regfile
    input wire[`RegBus] reg1_rdata_i,
    input wire[`RegBus] reg2_rdata_i,

    //新增 from exe 解決 data hazard
    input wire[`RegAddrBus] exe_reg_waddr_i,
    input wire exe_reg_we_i,
    input wire[`RegBus] exe_reg_wdata_i,

    //新增 from meme 解決 data hazard
    input wire[`RegAddrBus] mem_reg_waddr_i,
    input wire mem_reg_we_i,
    input wire[`RegBus] mem_reg_wdata_i,
       
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

    // 因為 immediate value 的位元並不固定，因此先宣告，等到確定後再做 signed extension
    reg[`RegBus] imm;
    
    always @(*) begin
        // 原本的 op1_o 和 op2_o 要在這一段裡面做
        // 但這樣會有 data hazard 因此改移到最後在決定。
        if (rst_i == `RstEnable) begin
            aluOp_o <= `NOP;
            reg1_raddr_o <= `ZeroReg;
            reg2_raddr_o <= `ZeroReg;
            reg1_re_o <= `ReadDisable;
            reg2_re_o <= `ReadDisable;
            reg_we_o <= `WriteDisable;
            reg_waddr_o <= `ZeroReg;
            //op1_o <= `ZeroWord;
            //op2_o <= `ZeroWord;
        end else begin
            case (opcode)
                `INST_TYPE_I: begin
                    case (funct3)
                        `INST_ORI, `INST_ADDI, `INST_XORI, `INST_ANDI, `INST_SLTI, `INST_SLTIU: begin
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                            reg1_raddr_o <= rs1;
                            reg2_raddr_o <= `ZeroReg;
                            reg1_re_o <= `ReadEnable;
                            reg2_re_o <= `ReadDisable;
                            imm <= {{20{inst_i[31]}}, inst_i[31:20]};
                            //op1_o <= reg1_rdata_i; //這兩行註解掉是因為這樣會有 data harzard
                            //op2_o <= {{20{inst_i[31]}}, inst_i[31:20]};
                            aluOp_o <= {funct3, opcode};    
                        end//INST_ORI
                        `INST_SLLI, `INST_SRLI, `INST_SRAI: begin
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                            reg1_raddr_o <= rs1;
                            reg2_raddr_o <= `ZeroReg;
                            reg1_re_o <= `ReadEnable;
                            reg2_re_o <= `ReadDisable;
                            imm <= {{27{1'b0}}, rs2[4:0]};
                            aluOp_o <= {funct3, funct7};
                        end
                        default: begin
                            reg_we_o = `WriteDisable;
                            reg_waddr_o <= `ZeroReg;
                            reg1_raddr_o <= `ZeroReg;
                            reg1_re_o <= `ReadDisable;
                            reg2_raddr_o <= `ZeroReg;
                            reg2_re_o <= `ReadDisable;
                            //op1_o <= `ZeroWord;
                            //op2_o <= `ZeroWord;
                            //aluOp_o <= `NOP;
                        end//default

                        // 將 aluOp_o 移到這邊在做
                    endcase
		        end
                `INST_TYPE_R: begin
                    case (funct3)
                        `INST_ADD, `INST_SUB, `INST_SLL, `INST_SLT, `INST_SLTU, 
                        `INST_XOR, `INST_SRL, `INST_SRA, `INST_OR, `INST_AND: begin
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                            reg1_raddr_o <= rs1;
                            reg2_raddr_o <= rs2;
                            reg1_re_o <= `ReadEnable;
                            reg2_re_o <= `ReadEnable;
                            aluOp_o <= {funct3, funct7};
                        end
                    endcase
                end
                default:begin
                        reg_we_o = `WriteDisable;
                        reg_waddr_o <= `ZeroReg;
                        reg1_raddr_o <= `ZeroReg;
                        reg1_re_o <= `ReadDisable;
                        reg2_raddr_o <= `ZeroReg;
                        reg2_re_o <= `ReadDisable;                                 
                        //op1_o <= `ZeroWord;
                        //op2_o <= `ZeroWord;
                        aluOp_o <= `NOP;
                end//default
            endcase
        end//if
    end//always

    always @(*) begin
        if (rst_i == `RstEnable) begin
            op1_o <= `ZeroWord;
        end else if (reg1_re_o == `ReadEnable && exe_reg_we_i == `WriteEnable && exe_reg_waddr_i == reg1_raddr_o) begin
            // 解決 exe 階段的 data hazard
            op1_o <= exe_reg_wdata_i;
        end else if (reg1_re_o == `ReadEnable && mem_reg_we_i == `WriteEnable && mem_reg_waddr_i == reg1_raddr_o) begin
            // 解決 mem 階段的 data hazard
            op1_o <= mem_reg_wdata_i;
        end else if (reg1_re_o == `ReadEnable) begin
            op1_o <= reg1_rdata_i;
        end else if (reg1_re_o == `ReadDisable) begin
            op1_o <= imm; //這行應該是不會用到拉
        end else begin
            op1_o <= `ZeroWord; //這行應該也是不會用到，但為了程式的安全，還是加一下
        end
    end//always

    always @(*) begin
        if (rst_i == `RstEnable) begin
            op2_o <= `ZeroWord;
        end else if (reg2_re_o == `ReadEnable && exe_reg_we_i == `WriteEnable && exe_reg_waddr_i == reg2_raddr_o) begin
            // 解決 exe 階段的 data hazard
            op2_o <= exe_reg_wdata_i;
        end else if (reg2_re_o == `ReadEnable && mem_reg_we_i == `WriteEnable && mem_reg_waddr_i == reg2_raddr_o) begin
            // 解決 mem 階段的 data hazard
            op2_o <= mem_reg_wdata_i;
        end else if (reg2_re_o == `ReadEnable) begin
            op2_o <= reg2_rdata_i;
        end else if (reg2_re_o == `ReadDisable) begin
            op2_o <= imm;
        end else begin
            op2_o <= `ZeroWord; //這行應該也是不會用到，但為了程式的安全，還是加一下
        end
    end//always
endmodule