module ID_EXE (
    // from ID
    output wire [`GPR_ADDR_SPACE-1:0] rd_addr_o,
    output wire rd_we_o,
    output wire mem_we_o,
    output wire [`INST_ID_LEN-1:0] instr_id_o,
    output wire [`GPR_WIDTH-1:0] rs1_val_o,
    output wire [`GPR_WIDTH-1:0] rs2_val_o,
    output wire [`IMM_WIDTH-1:0]imm_o
);
    
endmodule