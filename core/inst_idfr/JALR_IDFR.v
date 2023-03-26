/* verilator lint_off CASEOVERLAP */
/* verilator lint_off LATCH */

module JALR_IDFR (
    input wire ce,
    input wire [`funct3_width-1:0] funct3,
    output reg [`INST_ID_LEN-1:0] instr_id
);
    always @(*) begin
        if (ce == `On) begin
            case (funct3)
                `JALR_FUN3 : begin
                    instr_id = `JALR_ID;
                end
                default : begin
                    instr_id = `NONE_ID;
                end
            endcase
        end
    end
endmodule