module control_unit (
    // from ID
    input wire [`funct7_width-1:0] funct7,
    input wire [`funct3_width-1:0] funct3,
    input wire [`opcode_width-1:0] opcode,

    // to ID
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