`include "conf_riscv_spec.v"
`include "conf_general_define.v"

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

    // This wire value may be change in the future, Control by hazard detection
    assign if_id_flush_i = `INST_WIDTH'b0;
    assign if_id_sel_i = 2'b10; // sel = selection, used in mux.

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

    // some wire for ID stage
    wire [`GPR_ADDR_SPACE-1:0] regfile_rs1_addr_i;
    wire [`GPR_ADDR_SPACE-1:0] regfile_rs2_addr_i;
    wire [`funct7_width-1:0] control_funct7_i;
    wire [`funct3_width-1:0] control_funct3_i;
    wire [`opcode_width-1:0] control_opcode_i;
    wire id_rd_we_i;
    wire id_mem_re_i;
    wire id_mem_we_i;
    wire [`INST_ID_LEN-1:0] id_instr_id_i;
    wire [`GPR_WIDTH-1:0]id_rs1_val_i;
    wire [`GPR_WIDTH-1:0]id_rs2_val_i;

    // from WB (used for rd)
    wire [`GPR_ADDR_SPACE-1:0] regfile_rd_addr_i;
    wire [`GPR_WIDTH-1:0] regfile_rd_val_i;
    wire regfile_rd_we_i;

    // from ID to ID_EXE
    wire [`GPR_ADDR_SPACE-1:0] id_exe_rd_addr_i;
    wire id_exe_rd_we_i;
    wire id_exe_mem_re_i;
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
        .mem_re_i       (id_mem_re_i),
        .mem_we_i       (id_mem_we_i),
        .instr_id_i     (id_instr_id_i),

        // from regfile
        .rs1_val_i      (id_rs1_val_i),
        .rs2_val_i      (id_rs2_val_i),
        
        // to ID_EXE
        .rd_addr_o      (id_exe_rd_addr_i),
        .rd_we_o        (id_exe_rd_we_i),
        .mem_re_o       (id_exe_mem_re_i),
        .mem_we_o       (id_exe_mem_we_i),
        .instr_id_o     (id_exe_instr_id_i),
        .rs1_val_o      (id_exe_rs1_val_i),
        .rs2_val_o      (id_exe_rs2_val_i),
        .imm_o          (id_exe_imm_i)
    );

    regfile regfile1(
        // from ID
        .rs1_addr_i     (regfile_rs1_addr_i),
        .rs2_addr_i     (regfile_rs2_addr_i),

        // from WB
        .rd_addr_i      (regfile_rd_addr_i),
        .rd_val_i       (regfile_rd_val_i),
        .rd_we_i        (regfile_rd_we_i),

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
        .mem_re         (id_mem_re_i),
        .mem_we         (id_mem_we_i),
        .instr_id       (id_instr_id_i)
    );

    
    // from ID_EXE to EXE
    wire [`GPR_ADDR_SPACE-1:0] exe_rd_addr_i;
    wire exe_rd_we_i;
    wire exe_mem_re_i;
    wire exe_mem_we_i;
    wire [`INST_ID_LEN-1:0] exe_instr_id_i;
    wire [`GPR_WIDTH-1:0] exe_rs1_val_i;
    wire [`GPR_WIDTH-1:0] exe_rs2_val_i;
    wire [`IMM_WIDTH-1:0] exe_imm_i;

    ID_EXE ID_EXE1(
        .clk_i(clk_i),

        // from ID
        .rd_addr_i     (id_exe_rd_addr_i),
        .rd_we_i       (id_exe_rd_we_i),
        .mem_re_i      (id_exe_mem_re_i),
        .mem_we_i      (id_exe_mem_we_i),
        .instr_id_i    (id_exe_instr_id_i),
        .rs1_val_i     (id_exe_rs1_val_i),
        .rs2_val_i     (id_exe_rs2_val_i),
        .imm_i         (id_exe_imm_i),

        // to EXE
        .rd_addr_o     (exe_rd_addr_i),
        .rd_we_o       (exe_rd_we_i),
        .mem_re_o      (exe_mem_re_i),
        .mem_we_o      (exe_mem_we_i),
        .instr_id_o    (exe_instr_id_i),
        .rs1_val_o     (exe_rs1_val_i),
        .rs2_val_o     (exe_rs2_val_i),
        .imm_o         (exe_imm_i)
    );

    // from EXE to EXE_WB
    wire [`GPR_WIDTH-1:0] exe_wb_alu_val_i;
    wire [`GPR_ADDR_SPACE-1:0] exe_wb_rd_addr_i;
    wire exe_wb_rd_we_i;
    wire [`GPR_WIDTH-1:0] exe_wb_rs2_val_i;
    wire exe_wb_mem_re_i;
    wire exe_wb_mem_we_i;

    EXE EXE1(
        // from ID_EXE
        .rd_addr_i     (exe_rd_addr_i),
        .rd_we_i       (exe_rd_we_i),
        .mem_re_i      (exe_mem_re_i),
        .mem_we_i      (exe_mem_we_i),
        .instr_id_i    (exe_instr_id_i),
        .rs1_val_i     (exe_rs1_val_i),
        .rs2_val_i     (exe_rs2_val_i),
        .imm_i         (exe_imm_i),

        // to EXE_WB
        .alu_val_o     (exe_wb_alu_val_i),
        .rd_addr_o     (exe_wb_rd_addr_i),
        .rd_we_o       (exe_wb_rd_we_i),
        .rs2_val_o     (exe_wb_rs2_val_i),
        .mem_re_o      (exe_wb_mem_re_i),
        .mem_we_o      (exe_wb_mem_we_i)
    );

    // form EXE_MEM to MEM
    wire [`GPR_WIDTH-1:0] mem_alu_val_i;
    wire [`GPR_ADDR_SPACE-1:0] mem_rd_addr_i;
    wire mem_rd_we_i;
    wire [`GPR_WIDTH-1:0] mem_rs2_val_i;
    wire mem_mem_re_i;
    wire mem_mem_we_i;

    EXE_MEM EXE_MEM1(
        .clk_i         (clk_i),
        // from EXE
        .alu_val_i     (exe_wb_alu_val_i),
        .rd_addr_i     (exe_wb_rd_addr_i),
        .rd_we_i       (exe_wb_rd_we_i),
        .rs2_val_i     (exe_wb_rs2_val_i),
        .mem_re_i      (exe_wb_mem_re_i),
        .mem_we_i      (exe_wb_mem_we_i),

        // to MEM
        .alu_val_o     (mem_alu_val_i),
        .rd_addr_o     (mem_rd_addr_i),
        .rd_we_o       (mem_rd_we_i),
        .rs2_val_o     (mem_rs2_val_i),
        .mem_re_o      (mem_mem_re_i),
        .mem_we_o      (mem_mem_we_i)
    );

    // from MEM to MEM_WB
    wire [`GPR_WIDTH-1:0] mem_wb_rd_val_i;
    wire [`GPR_ADDR_SPACE-1:0] mem_wb_rd_addr_i;
    wire mem_wb_rd_we_i;

    MEM MEM1(
        // from EXE_MEM
        .alu_val_i     (mem_alu_val_i),
        .rd_addr_i     (mem_rd_addr_i),
        .rd_we_i       (mem_rd_we_i),
        .rs2_val_i     (mem_rs2_val_i),
        .mem_re_i      (mem_mem_re_i),
        .mem_we_i      (mem_mem_we_i),

        // to MEM_WB
        .rd_val_o      (mem_wb_rd_val_i),
        .rd_addr_o     (mem_wb_rd_addr_i),
        .rd_we_o       (mem_wb_rd_we_i)
    );

    wire [`GPR_WIDTH-1:0] wb_rd_val_i;
    wire [`GPR_ADDR_SPACE-1:0] wb_rd_addr_i;
    wire wb_rd_we_i;

    MEM_WB MEM_WB1(
        .clk_i(clk_i),

        // from MEM
        .rd_val_i      (mem_wb_rd_val_i),
        .rd_addr_i     (mem_wb_rd_addr_i),
        .rd_we_i       (mem_wb_rd_we_i),

        // to WB
        .rd_val_o      (wb_rd_val_i),
        .rd_addr_o     (wb_rd_addr_i),
        .rd_we_o       (wb_rd_we_i)
    );


    WB WB1(
        // from MEM_WB
        .rd_val_i      (wb_rd_val_i),
        .rd_addr_i     (wb_rd_addr_i),
        .rd_we_i       (wb_rd_we_i),
        
        // to regfile
        .rd_val_o      (regfile_rd_val_i),
        .rd_addr_o     (regfile_rd_addr_i),
        .rd_we_o       (regfile_rd_we_i)
    );


endmodule