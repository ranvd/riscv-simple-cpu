/* verilator lint_off CASEOVERLAP */
/* verilator lint_off LATCH */

module LUI_IDFR (
    input wire ce,
    output reg [`INST_ID_LEN-1:0] instr_id
);
    always @(*) begin
        if (ce == `On) begin
            instr_id = `LUI_ID;
        end
    end
endmodule