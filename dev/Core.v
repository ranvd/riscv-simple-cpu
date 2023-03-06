`include "riscv_spec.v"
`include "define.v"

module Core (
    input wire clk_i,
    input wire rst_i
);
    wire [`INST_WIDTH-1:0] if_id_instr_i;
    wire [`SYS_ADDR_SPACE-1:0] if_id_pc_i;

    IF IF1(
        .clk_i        (clk_i),
        .rst_i        (rst_i),
        .inst_o       (if_id_instr_i),
        .pc_o         (if_id_pc_i)
    );

    wire [`INST_WIDTH-1:0] if_id_flush_i;
    wire [1:0] if_id_sel_i;
    wire [`SYS_ADDR_SPACE-1:0] id_pc_i;
    wire [`INST_WIDTH-1:0] id_instr_i;

    assign if_id_flush_i = `INST_WIDTH'b0;
    assign if_id_sel_i = 2'b10;

    IF_ID IF_ID1(
        .clk_i(clk_i),
        .stall_i      (id_instr_i),
        .flush_i      (if_id_flush_i),
        .instr_i      (if_id_instr_i),
        .sel_i        (if_id_sel_i),
        .pc_i         (if_id_pc_i),
        .instr_o       (id_instr_i),
        .pc_o         (id_pc_i)
    );

    wire [`GPR_ADDR_SPACE-1:0] regfile_rs1_addr_i;
    wire [`GPR_ADDR_SPACE-1:0] regfile_rs2_addr_i;
    wire [`funct7_width-1:0] control_funct7_i;
    wire [`funct3_width-1:0] control_funct3_i;
    wire [`opcode_width-1:0] control_opcode_i;
    wire id_rd_we_i;
    wire id_mem_we_i;
    wire [`INST_ID_LEN-1:0] id_instr_id_i;
    wire [`GPR_WIDTH-1:0]id_rs1_val_i;
    wire [`GPR_WIDTH-1:0]id_rs2_val_i;

    wire [`GPR_ADDR_SPACE-1:0] id_exe_rd_addr_i;
    wire id_exe_rd_we_i;
    wire id_exe_mem_we_i;
    wire [`INST_ID_LEN-1:0] id_exe_instr_id_i;
    wire [`GPR_WIDTH-1:0] id_exe_rs1_val_i;
    wire [`GPR_WIDTH-1:0] id_exe_rs2_val_i;
    wire [`IMM_WIDTH-1:0]id_exe_imm_i;


    ID ID1(
        // from ID_IF
        .instr_i        (id_instr_i),
        .pc_i           (id_pc_i),

        // to regfile
        .rs1_addr_o     (regfile_rs1_addr_i),
        .rs2_addr_o     (regfile_rs2_addr_i),
        
        // to control unit
        .funct7_o       (control_funct7_i),
        .funct3_o       (control_funct3_i),
        .opcode_o       (control_opcode_i),

        // from control unit
        .rd_we_i        (id_rd_we_i),
        .mem_we_i       (id_mem_we_i),
        .instr_id_i     (id_instr_id_i),

        // from regfile
        .rs1_val_i      (id_rs1_val_i),
        .rs2_val_i      (id_rs2_val_i),
        
        // to ID_EXE
        .rd_addr_o      (id_exe_rd_addr_i),
        .rd_we_o        (id_exe_rd_we_i),
        .mem_we_o       (id_exe_mem_we_i),
        .instr_id_o     (id_exe_instr_id_i),
        .rs1_val_o      (id_exe_rs1_val_i),
        .rs2_val_o      (id_exe_rs2_val_i),
        .imm_o          (id_exe_imm_i)
    );

    regfile refile1(
        // from ID
        .rs1_addr_i     (regfile_rs1_addr_i),
        .rs2_addr_i     (regfile_rs2_addr_i),

        // to ID
        .rs1_val_o      (id_rs1_val_i),
        .rs2_val_o      (id_rs2_val_i)
    );

    control_unit control_unit1(
        // from ID
        .funct7         (control_funct7_i),
        .funct3         (control_funct3_i),
        .opcode         (control_opcode_i),

        // to ID
        .rd_we          (id_rd_we_i),
        .mem_we         (id_mem_we_i),
        .instr_id       (id_instr_id_i)
    );

    
endmodule