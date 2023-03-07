module control_unit (
    // from ID
    input wire [`funct7_width-1:0] funct7,
    input wire [`funct3_width-1:0] funct3,
    input wire [`opcode_width-1:0] opcode,

    // to ID
    output reg rd_we,
    output reg mem_we,
    output reg [`INST_ID_LEN-1:0] instr_id // 也許會出問題
);
    instr_identifier instr_idfr(
        .funct7_i(funct7),
        .funct3_i(funct3),
        .opcode_i(opcode),
        .instr_id_o(instr_id)
    );

    always @(*) begin
        case (instr_id)
            `ORI_ID : begin
                rd_we = 1;
                mem_we = 0;
            end
            default: begin
                rd_we = 0;
                mem_we = 0;
            end
        endcase
    end

endmodule