/* verilator lint_off LATCH */

module instr_identifier (
    input wire [`funct7_width-1:0] funct7_i,
    input wire [`funct3_width-1:0] funct3_i,
    input wire [`opcode_width-1:0] opcode_i,

    output reg [`INST_ID_LEN-1:0] instr_id_o
);
    reg OP_IMM_ce; // OP_IMM chip enable
    reg OP_ce;
    reg LUI_ce;
    reg AUIPC_ce;
    reg LOAD_ce;
    reg STORE_ce;

    always @(*) begin
        case (opcode_i)
            `OP_IMM : begin
                OP_IMM_ce = `On;
                OP_ce = `Off;
                LUI_ce = `Off;
                AUIPC_ce = `Off;
                LOAD_ce = `Off;
                STORE_ce = `Off;
            end
            `OP : begin
                OP_IMM_ce = `Off;
                OP_ce = `On;
                LUI_ce = `Off;
                AUIPC_ce = `Off;
                LOAD_ce = `Off;
                STORE_ce = `Off;
            end
            `LUI : begin
                OP_IMM_ce = `Off;
                OP_ce = `Off;
                LUI_ce = `On;
                AUIPC_ce = `Off;
                LOAD_ce = `Off;
                STORE_ce = `Off;
            end
            `AUIPC : begin
                OP_IMM_ce = `Off;
                OP_ce = `Off;
                LUI_ce = `Off;
                AUIPC_ce = `On;
                LOAD_ce = `Off;
                STORE_ce = `Off;
            end
            `LOAD : begin
                OP_IMM_ce = `Off;
                OP_ce = `Off;
                LUI_ce = `Off;
                AUIPC_ce = `Off;
                LOAD_ce = `On;
                STORE_ce = `Off;
            end
            `STORE : begin
                OP_IMM_ce = `Off;
                OP_ce = `Off;
                LUI_ce = `Off;
                AUIPC_ce = `Off;
                LOAD_ce = `Off;
                STORE_ce = `On;
            end
            default: begin
                OP_IMM_ce = `Off;
                OP_ce = `Off;
                LUI_ce = `Off;
                AUIPC_ce = `Off;
                LOAD_ce = `Off;
                STORE_ce = `Off;
                instr_id_o = `NONE_ID;
            end
        endcase
    end

    OP_IMM_IDFR op_imm_idfr(
        .ce(OP_IMM_ce),
        .funct7(funct7_i),
        .funct3(funct3_i),
        .instr_id(instr_id_o)
    );

    OP_IDFR op_idfr(
        .ce(OP_ce),
        .funct7(funct7_i),
        .funct3(funct3_i),
        .instr_id(instr_id_o)
    );

    LUI_IDFR lui_idfr(
        .ce(LUI_ce),
        .instr_id(instr_id_o)
    );

    AUIPC_IDFR auipc_idfr(
        .ce(AUIPC_ce),
        .instr_id(instr_id_o)
    );

    LOAD_IDFR load_idfr(
        .ce(LOAD_ce),
        .funct3(funct3_i),
        .instr_id(instr_id_o)
    );

    STORE_IDFR store_idfr(
        .ce(STORE_ce),
        .funct3(funct3_i),
        .instr_id(instr_id_o)
    );

    
endmodule