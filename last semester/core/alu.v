module alu (
    input wire rst_i,

    //from id_exe
    input wire[`InstAddrBus] inst_addr_i,
    input wire[`RegBus] op1_i,
    input wire[`RegBus] op2_i,
    input wire[`RegAddrBus] reg_waddr_i,
    input wire[`AluOpBus] aluOp_i,
    input wire[`RegBus] imm_i,
    
    //to exe_mem
    output reg[`InstAddrBus] jump_addr_o,
    output reg[`RegAddrBus] reg_waddr_o,
    output reg[`RegBus] reg_wdata_o,
    output reg[`StoreAddrBus] mem_addr_o,

    //to ctrl unit
    output reg jumpe_o
);
    wire op1_ge_op2_signed, op1_ge_op2_unsigned;
    assign op1_ge_op2_signed = $signed(op1_i) >= $signed(op2_i);
    assign op1_ge_op2_unsigned = op1_i >= op2_i;
    
    always @(*) begin
        if (rst_i == `RstEnable) begin
            reg_waddr_o <= `ZeroReg;
            reg_wdata_o <= `ZeroWord;
        end else begin
            reg_waddr_o <= reg_waddr_i;
            
            case (aluOp_i)
                `ORI, `OR: begin
                    reg_wdata_o <= op1_i | op2_i;
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                end
                `ADDI, `ADD: begin
                    reg_wdata_o <= op1_i + op2_i; //TODO: 要檢查 overflow 使用 $signed() 內建函式式沒用的
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                end
                `ANDI, `AND: begin
                    reg_wdata_o <= op1_i & op2_i;
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                end
                `XORI, `XOR: begin
                    reg_wdata_o <= op1_i ^ op2_i;
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                end
                `SLTI, `SLT: begin
                    reg_wdata_o <= {32{~op1_ge_op2_signed}} & 32'h1;
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                end
                `SLTIU, `SLTU: begin
                    reg_wdata_o <= {32{~op1_ge_op2_unsigned}} & 32'h1;
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                end
                `SLLI, `SLL: begin
                    reg_wdata_o <= op1_i << op2_i[4:0];
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                end
                `SRLI, `SRL: begin
                    reg_wdata_o <= op1_i >> op2_i[4:0];
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                end
                `SRAI, `SRA: begin
                    reg_wdata_o <= op1_i >>> op2_i[4:0];
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                end
                `SUB: begin
                    reg_wdata_o <= op1_i - op2_i;
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                end
                `JAL: begin
                    reg_wdata_o <= inst_addr_i + 3'b100; // 這個指令的下一個指令。
                    jump_addr_o <= inst_addr_i + op1_i;
                    jumpe_o <= `JumpEnable;
                end
                `JALR: begin
                    reg_wdata_o <= inst_addr_i + 3'b100; // 這個指令的下一個指令。
                    jump_addr_o <= op1_i + op2_i;
                    jumpe_o <= `JumpEnable;
                end
                `LUI: begin
                    reg_wdata_o <= op1_i;
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                end
                `AUIPC: begin
                    reg_wdata_o <= op1_i + {inst_addr_i[31:12], 12'b0};
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                end
                `BEQ: begin
                    reg_wdata_o <= `ZeroWord;
                    jump_addr_o <= inst_addr_i + imm_i;
                    jumpe_o <= `JumpEnable && (op1_i == op2_i);
                end
                `BNE: begin
                    reg_wdata_o <= `ZeroWord;
                    jump_addr_o <= inst_addr_i + imm_i;
                    jumpe_o <= `JumpEnable && (op1_i != op2_i);
                end
                `BLT: begin
                    reg_wdata_o <= `ZeroWord;
                    jump_addr_o <= inst_addr_i + imm_i;
                    jumpe_o <= `JumpEnable && (op1_i < op2_i);
                end
                `BGE: begin
                    reg_wdata_o <= `ZeroWord;
                    jump_addr_o <= inst_addr_i + imm_i;
                    jumpe_o <= `JumpEnable && (op1_i > op2_i);
                end
                `BLTU: begin
                    reg_wdata_o <= `ZeroWord;
                    jump_addr_o <= inst_addr_i + imm_i;
                    jumpe_o <= `JumpEnable && ($signed(op1_i) < $signed(op2_i));
                end
                `BGEU: begin
                    reg_wdata_o <= `ZeroWord;
                    jump_addr_o <= inst_addr_i + imm_i;
                    jumpe_o <= `JumpEnable && ($signed(op1_i) > $signed(op2_i));
                end
                `SB: begin
                    reg_wdata_o <= {24'b0, op2_i[7:0]};
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                    mem_addr_o <= op1_i + imm_i;
                end
                `SH: begin
                    reg_wdata_o <= {16'b0, op2_i[15:0]};
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                    mem_addr_o <= op1_i + imm_i;
                end
                `SW: begin
                    reg_wdata_o <= op2_i;
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                    mem_addr_o <= op1_i + imm_i;
                end
                `LB, `LH, `LW, `LBU, `LHU: begin
                    reg_wdata_o <= `ZeroWord;
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                    mem_addr_o <= op1_i + imm_i;
                end

                default: begin
                    reg_waddr_o <= `ZeroReg;
                    reg_wdata_o <= `ZeroWord;
                    jump_addr_o <= `ZeroWord;
                    jumpe_o <= `JumpDisable;
                end
            endcase
        end
    end
endmodule