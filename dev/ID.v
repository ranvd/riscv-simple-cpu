module ID (
    // from ID_IF
    input wire [`INST_WIDTH-1:0] instr_i,
    input wire [`SYS_ADDR_SPACE-1:0] pc_i,

    // to regfile
    output wire [`GPR_ADDR_SPACE-1:0] rs1_addr_o,
    output wire [`GPR_ADDR_SPACE-1:0] rs2_addr_o,
    
    // to control unit
    output wire [`funct7_width-1:0] funct7_o,
    output wire [`funct3_width-1:0] funct3_o,
    output wire [`opcode_width-1:0] opcode_o,

    // from control unit
    input wire rd_we_i,
    input wire mem_we_i,
    input wire [`INST_ID_LEN-1:0] instr_id_i,

    // from regfile
    input wire [`GPR_WIDTH-1:0] rs1_val_i,
    input wire [`GPR_WIDTH-1:0] rs2_val_i,

    // to ID_EXE
    output wire [`GPR_ADDR_SPACE-1:0] rd_addr_o,
    output wire rd_we_o,
    output wire mem_we_o,
    output wire [`INST_ID_LEN-1:0] instr_id_o,
    output wire [`GPR_WIDTH-1:0] rs1_val_o,
    output wire [`GPR_WIDTH-1:0] rs2_val_o,
    output reg [`IMM_WIDTH-1:0]imm_o
);
    // instruction decode
    assign rs1_addr_o = instr_i[`rs1];
    assign rs2_addr_o = instr_i[`rs2];
    assign funct7_o = instr_i[`funct7];
    assign funct3_o = instr_i[`funct3];
    assign opcode_o = instr_i[`opcode];
    
    assign rd_addr_o = instr_i[`rd];
    assign rd_we_o = rd_we_i;
    assign mem_we_o = mem_we_i;
    assign instr_id_o = instr_id_i;
    assign rs1_val_o = rs1_val_i;
    assign rs2_val_o = rs2_val_i;


    always @(*) begin
        case (opcode_o)
            `OP_IMM : begin
                imm_o = `I_TYPE_IMM(instr_i);
            end
            default:
                imm_o = 32'b0;
        endcase
    end
    
endmodule