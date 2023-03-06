module OP_IMM_IDFR (
    input wire ce,
    input wire [`funct7_width-1:0] funct7,
    input wire [`funct3_width-1:0] funct3,

    output reg [`INST_ID_LEN-1:0] instr_id
);
    always @(*) begin
        case (funct3)
            `ORI : begin
                instr_id = `ORI_ID;
            end
            default: begin
                instr_id = `NONE_ID;
            end
        endcase
    end
endmodule