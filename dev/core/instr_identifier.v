
module instr_identifier (
    input wire [`funct7_width-1:0] funct7_i,
    input wire [`funct3_width-1:0] funct3_i,
    input wire [`opcode_width-1:0] opcode_i,

    output reg [`INST_ID_LEN-1:0] instr_id_o
);
    reg OP_IMM_ce; // OP_IMM chip enable

    always @(*) begin
        case (opcode_i)
            `OP_IMM : begin
                OP_IMM_ce = `On;
            end
            default: begin
                OP_IMM_ce = `Off;
            end
        endcase
    end

    OP_IMM_IDFR op_imm_idfr(
        .ce(OP_IMM_ce),
        .funct7(funct7_i),
        .funct3(funct3_i),
        .instr_id(instr_id_o)
    );
    
endmodule