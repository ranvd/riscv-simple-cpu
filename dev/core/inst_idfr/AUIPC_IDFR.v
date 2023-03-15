/* verilator lint_off CASEOVERLAP */
/* verilator lint_off LATCH */

module AUIPC_IDFR (
    input wire ce,
    output reg [`INST_ID_LEN-1:0] instr_id
);
    always @(*) begin
        if (ce == `On) begin
            instr_id = `AUIPC_ID;
        end
    end
endmodule