/* verilator lint_off CASEOVERLAP */
/* verilator lint_off LATCH */

module OP_IDFR (
    input wire ce,
    input wire [`funct7_width-1:0] funct7,
    input wire [`funct3_width-1:0] funct3,

    output reg [`INST_ID_LEN-1:0] instr_id
);
    always @(*) begin
        if (ce == `On) begin
            case (funct3)
                `ADD, `SUB : begin
                    if (funct7 == `ADD_FUNCT7) begin
                        instr_id = `ADD_ID;
                    end else if (funct7 == `SUB_FUNCT7) begin
                        instr_id = `SUB_ID;
                    end else begin
                        instr_id = `NONE_ID;
                    end
                end
                `SLL : begin
                    instr_id = `SLL_ID;
                end
                `SLT : begin
                    instr_id = `SLT_ID;
                end
                `SLTU : begin
                    instr_id = `SLTU_ID;
                end
                `XOR : begin
                    instr_id = `XOR_ID;
                end
                `SRL, `SRA : begin
                    if (funct7 == `SRL_FUNCT7) begin
                        instr_id = `SRL_ID;
                    end else if (funct7 == `SRA_FUNCT7) begin
                        instr_id = `SRA_ID;
                    end else begin
                        instr_id = `NONE_ID;
                    end
                end
                `OR : begin
                    instr_id = `OR_ID;
                end
                `AND: begin
                    instr_id = `AND_ID;
                end
                default: begin
                    instr_id = `NONE_ID;
                end
            endcase
        end
    end
endmodule