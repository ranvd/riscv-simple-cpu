module ID_EXE (
    input wire clk_i,
    // from ID
    input wire [`GPR_ADDR_SPACE-1:0] rs1_addr_i,
    input wire rs1_re_i,
    input wire [`GPR_ADDR_SPACE-1:0] rs2_addr_i,
    input wire rs2_re_i,
    input wire [`GPR_ADDR_SPACE-1:0] rd_addr_i,
    input wire rd_we_i,
    input wire mem_re_i,
    input wire mem_we_i,
    input wire [`INST_ID_LEN-1:0] instr_id_i,
    input wire [`GPR_WIDTH-1:0] rs1_val_i,
    input wire [`GPR_WIDTH-1:0] rs2_val_i,
    input wire [`IMM_WIDTH-1:0] imm_i,

    // to EXE
    output reg [`GPR_ADDR_SPACE-1:0] rs1_addr_o,
    output reg rs1_re_o,
    output reg [`GPR_ADDR_SPACE-1:0] rs2_addr_o,
    output reg rs2_re_o,
    output reg [`GPR_ADDR_SPACE-1:0] rd_addr_o,
    output reg rd_we_o,
    output reg mem_re_o,
    output reg mem_we_o,
    output reg [`INST_ID_LEN-1:0] instr_id_o,
    output reg [`GPR_WIDTH-1:0] rs1_val_o,
    output reg [`GPR_WIDTH-1:0] rs2_val_o,
    output reg [`IMM_WIDTH-1:0] imm_o
);
    always @(posedge clk_i) begin
        rs1_addr_o <= rs1_addr_i;
        rs1_re_o <= rs1_re_i;
        rs2_addr_o <= rs2_addr_i;
        rs2_re_o <= rs2_re_i;
        rd_addr_o <= rd_addr_i;
        rd_we_o <= rd_we_i;
        mem_re_o <= mem_re_i;
        mem_we_o <= mem_we_i;
        instr_id_o <= instr_id_i;
        rs1_val_o <= rs1_val_i;
        rs2_val_o <= rs2_val_i;
        imm_o <= imm_i;
    end
    
endmodule