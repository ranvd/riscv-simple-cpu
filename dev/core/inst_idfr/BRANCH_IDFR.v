/* verilator lint_off CASEOVERLAP */
/* verilator lint_off LATCH */

module BRANCH_IDFR (
    input wire ce,
    input wire [`funct3_width-1:0] funct3,
    output reg [`INST_ID_LEN-1:0] instr_id
);
    always @(*) begin
        if (ce == `On) begin
            case (funct3)
                `BEQ : begin
                    instr_id = `BEQ_ID;
                end
                `BNE : begin
                    instr_id = `BNE_ID;
                end
                `BLT : begin
                    instr_id = `BLT_ID;
                end
                `BGE : begin
                    instr_id = `BGE_ID;
                end
                `BLTU : begin
                    instr_id = `BLTU_ID;
                end
                `BGEU : begin
                    instr_id = `BGEU_ID;
                end
                default : begin
                    instr_id = `NONE_ID;
                end
            endcase
        end
    end
endmodule