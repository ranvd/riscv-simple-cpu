/* verilator lint_off CASEOVERLAP */
/* verilator lint_off LATCH */

module LOAD_IDFR (
    input wire ce,
    input wire [`funct3_width-1:0] funct3,
    output reg [`INST_ID_LEN-1:0] instr_id
);
    always @(*) begin
        if (ce == `On) begin
            case (funct3)
                `LB_FUN3 : begin
                    instr_id = `LB_ID;
                end
                `LH_FUN3 : begin
                    instr_id = `LH_ID;
                end
                `LW_FUN3 : begin
                    instr_id = `LW_ID;
                end
                `LBU_FUN3 : begin
                    instr_id = `LBU_ID;
                end
                `LHU_FUN3 : begin
                    instr_id = `LHU_ID;
                end
                default : begin
                    instr_id = `NONE_ID;
                end
            endcase
        end
    end
endmodule