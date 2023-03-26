/* verilator lint_off CASEOVERLAP */
/* verilator lint_off LATCH */

module OP_IMM_IDFR (
    input wire ce,
    input wire [`funct7_width-1:0] funct7,
    input wire [`funct3_width-1:0] funct3,

    output reg [`INST_ID_LEN-1:0] instr_id
);
    always @(*) begin
        if (ce == `On) begin
            case (funct3)
                `ADDI : begin
                    instr_id = `ADDI_ID;
                end
                `SLTI : begin
                    instr_id = `SLTI_ID;
                end
                `SLTIU : begin
                    instr_id = `SLTIU_ID;
                end
                `XORI : begin
                    instr_id = `XORI_ID;
                end
                `ORI : begin
                    instr_id = `ORI_ID;
                end
                `ANDI : begin
                    instr_id = `ANDI_ID;
                end
                `SLLI : begin
                    if (funct7 == `SLLI_FUNCT7) begin
                        instr_id = `SLLI_ID;
                    end else begin
                        instr_id = `NONE_ID;
                    end
                end
                `SRLI, `SRAI: begin
                    if (funct7 == `SRLI_FUNCT7) begin
                        instr_id = `SRLI_ID;
                    end else if(funct7 == `SRAI_FUNCT7) begin
                        instr_id = `SRAI_ID;
                    end else begin
                        instr_id = `NONE_ID;
                    end
                end
                default: begin
                    instr_id = `NONE_ID;
                end
            endcase
        end
    end
endmodule