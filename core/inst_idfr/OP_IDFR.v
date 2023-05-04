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
            case (funct7)
                `SUB_FUNCT7, `SRA_FUNCT7: begin
                    case (funct3)
                        `SUB : begin
                            instr_id = `SUB_ID;
                        end 
                        `SRA : begin
                            instr_id = `SRA_ID;
                        end
                        default: begin
                            instr_id = `NONE_ID;
                        end
                    endcase
                end
                `ADD_FUNCT7, `SLL_FUNCT7, `SLT_FUNCT7, `SLTU_FUNCT7, 
                `XOR_FUNCT7, `SRL_FUNCT7, `OR_FUNCT7, `AND_FUNCT7: begin
                    case (funct3)
                        `ADD : begin
                            instr_id = `ADD_ID;
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
                        `SRL : begin
                            instr_id = `SRL_ID;
                        end
                        `OR : begin
                            instr_id = `OR_ID;
                        end
                        `AND : begin
                            instr_id = `AND_ID;
                        end
                        default: begin
                            instr_id = `NONE_ID;
                        end
                    endcase
                end
                `MULDIV_FUNCT7: begin
                    case (funct3)
                        `MUL : begin
                            instr_id = `MUL_ID;
                        end
                        `MULH : begin
                            instr_id = `MULH_ID;
                        end
                        `MULHSU : begin
                            instr_id = `MULHSU_ID;
                        end
                        `MULHU : begin
                            instr_id = `MULHU_ID;
                        end
                        `DIV : begin
                            instr_id = `DIV_ID;
                        end
                        `DIVU : begin
                            instr_id = `DIVU_ID;
                        end
                        `REM : begin
                            instr_id = `REM_ID;
                        end
                        `REMU : begin
                            instr_id = `REMU_ID;
                        end
                        default:begin
                            instr_id = `NONE_ID;
                        end 
                    endcase
                end
                default : begin
                    instr_id = `NONE_ID;
                end
            endcase
        end
    end
endmodule