module control_unit (
    // from ID
    input wire [`funct7_width-1:0] funct7,
    input wire [`funct3_width-1:0] funct3,
    input wire [`opcode_width-1:0] opcode,

    // to ID and branch unit
    output reg rs1_re, // new
    output reg rs2_re, // new
    output reg rd_we,
    output reg mem_re,
    output reg mem_we,
    output reg [`INST_ID_LEN-1:0] instr_id // 也許會出問題
);
    instr_identifier instr_idfr(
        .funct7_i(funct7),
        .funct3_i(funct3),
        .opcode_i(opcode),
        .instr_id_o(instr_id)
    );

    always @(*) begin
        case (instr_id)
            `ADDI_ID, `SLTI_ID, `SLTIU_ID, `XORI_ID, 
            `ORI_ID, `ANDI_ID, `SLLI_ID, `SRLI_ID, `SRAI_ID : begin
                rs1_re = `On;
                rs2_re = `Off;
                rd_we = `On;
                mem_re = `Off;
                mem_we = `Off;
            end
            `ADD_ID, `SUB_ID, `SLL_ID, `SLT_ID, `SLTU_ID,
            `XOR_ID, `SRL_ID, `SRA_ID, `OR_ID, `AND_ID, 
            `MUL_ID, `MULH_ID, `MULHSU_ID, `MULHU_ID, 
            `DIV_ID, `DIVU_ID, `REM_ID, `REMU_ID: begin
                rs1_re = `On;
                rs2_re = `On;
                rd_we = `On;
                mem_re = `Off;
                mem_we = `Off;
            end
            `LUI_ID, `AUIPC_ID : begin
                rs1_re = `Off;
                rs2_re = `Off;
                rd_we = `On;
                mem_re = `Off;
                mem_we = `Off;
            end
            `LB_ID, `LH_ID, `LW_ID, `LBU_ID, `LHU_ID: begin
                rs1_re = `On;
                rs2_re = `Off;
                rd_we = `On;
                mem_re = `On;
                mem_we = `Off;
            end
            `SB_ID, `SH_ID, `SW_ID : begin
                rs1_re = `On;
                rs2_re = `On;
                rd_we = `Off;
                mem_re = `Off;
                mem_we = `On;
            end
            `JAL_ID : begin // this can be merge to U-type (LUI, AUIPC)
                rs1_re = `Off;
                rs2_re = `Off;
                rd_we = `On;
                mem_re = `Off;
                mem_we = `Off;
            end
            `JALR_ID : begin // this can be merge to I-type (ADDI, ...)
                rs1_re = `On;
                rs2_re = `Off;
                rd_we = `On;
                mem_re = `Off;
                mem_we = `Off;
            end
            `BEQ_ID, `BNE_ID, `BLT_ID, `BGE_ID, `BLTU_ID, `BGEU_ID : begin
                rs1_re = `On;
                rs2_re = `On;
                rd_we = `Off;
                mem_re = `Off;
                mem_we = `Off;
            end
            default: begin
                rs1_re = `Off;
                rs2_re = `Off;
                rd_we = `Off;
                mem_re = `Off;
                mem_we = `Off;
            end
        endcase
    end

endmodule

