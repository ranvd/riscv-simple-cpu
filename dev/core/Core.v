`include "conf_riscv_spec.v"
`include "conf_general_define.v"

module Core (
    input wire clk_i,
    input wire rst_i
);
    wire [`INST_WIDTH-1:0] if_id_instr_i;
    wire [`SYS_ADDR_SPACE-1:0] if_id_pc_i;
    wire if_stall_i;  // from hazard detect unit
    wire [`SYS_ADDR_SPACE-1:0] if_pc_val_i; // from branch unit
    wire if_pc_we_i;  // from branch unit

    IF IF1(
        .clk_i        (clk_i),
        .rst_i        (rst_i),
        
        // from hazard detect unit
        .stall_i      (if_stall_i),
        // from branch unit
        .pc_i         (if_pc_val_i),
        .pc_we        (if_pc_we_i),
        // to IF_ID
        .inst_o       (if_id_instr_i),
        .pc_o         (if_id_pc_i)
    );

    wire [1:0] if_id_mode_i;  // used for hazard detection unit
    wire [`SYS_ADDR_SPACE-1:0] id_pc_i;
    wire [`INST_WIDTH-1:0] id_instr_i;

    IF_ID IF_ID1(
        .clk_i         (clk_i),
        // from hazard detection
        .mode_i        (if_id_mode_i),
        
        // from IF
        .instr_i       (if_id_instr_i),
        .pc_i          (if_id_pc_i),
        .instr_o       (id_instr_i),
        .pc_o          (id_pc_i)
    );

    // some wire for ID stage
    wire [`GPR_ADDR_SPACE-1:0] regfile_rs1_addr_i;
    wire [`GPR_ADDR_SPACE-1:0] regfile_rs2_addr_i;
    wire [`funct7_width-1:0] control_funct7_i;
    wire [`funct3_width-1:0] control_funct3_i;
    wire [`opcode_width-1:0] control_opcode_i;
    wire id_rs1_re;
    wire id_rs2_re;
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
    wire [`SYS_ADDR_SPACE-1:0] id_exe_pc_i;
    wire id_exe_rs1_re_i;
    wire id_exe_rs2_re_i;
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

        // to regfile and forwarding unit
        .rs1_addr_o     (regfile_rs1_addr_i),
        .rs2_addr_o     (regfile_rs2_addr_i),
        
        // to control unit
        .funct7_o       (control_funct7_i),
        .funct3_o       (control_funct3_i),
        .opcode_o       (control_opcode_i),

        // from control unit and forwarding unit
        .rs1_re_i       (id_rs1_re),
        .rs2_re_i       (id_rs2_re),
        .rd_we_i        (id_rd_we_i),
        .mem_re_i       (id_mem_re_i),
        .mem_we_i       (id_mem_we_i),
        .instr_id_i     (id_instr_id_i),

        // from regfile
        .rs1_val_i      (id_rs1_val_i),
        .rs2_val_i      (id_rs2_val_i),
        
        // to ID_EXE and hazard detect unit
        .pc_o           (id_exe_pc_i),
        .rs1_re_o       (id_exe_rs1_re_i),
        .rs2_re_o       (id_exe_rs2_re_i),
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
        .rs1_re         (id_rs1_re),
        .rs2_re         (id_rs2_re),
        .rd_we          (id_rd_we_i),
        .mem_re         (id_mem_re_i),
        .mem_we         (id_mem_we_i),
        .instr_id       (id_instr_id_i)
    );

    
    // from ID_EXE to EXE
    wire [`SYS_ADDR_SPACE-1:0] exe_pc_i;
    wire [`GPR_ADDR_SPACE-1:0] exe_rd_addr_i;
    wire exe_rd_we_i;
    wire exe_mem_re_i;
    wire exe_mem_we_i;
    wire [`INST_ID_LEN-1:0] exe_instr_id_i;
    wire [`GPR_WIDTH-1:0] exe_rs1_val_i;
    wire [`GPR_WIDTH-1:0] exe_rs2_val_i;
    wire [`IMM_WIDTH-1:0] exe_imm_i;

    // from forwarding unit to EXE
    reg [`GPR_WIDTH-1:0] fexe_rs1_val_i;
    reg [`GPR_WIDTH-1:0] fexe_rs2_val_i;
    reg fexe_rs1_we_i;
    reg fexe_rs2_we_i;

    // from ID_EXE to forwarding unit
    wire [`GPR_ADDR_SPACE-1:0] forward_rs1_addr_i;
    wire forward_rs1_re_i;
    wire [`GPR_ADDR_SPACE-1:0] forward_rs2_addr_i;
    wire forward_rs2_re_i;

    // from hazard detect unit to ID_EXE
    wire [1:0] id_exe_mode_i; 

    ID_EXE ID_EXE1(
        .clk_i         (clk_i),

        .mode_i        (id_exe_mode_i),
        // from ID
        .pc_i          (id_exe_pc_i),
        .rs1_val_i     (id_exe_rs1_val_i),
        .rs1_addr_i    (regfile_rs1_addr_i),
        .rs1_re_i      (id_exe_rs1_re_i),
        .rs2_val_i     (id_exe_rs2_val_i),
        .rs2_addr_i    (regfile_rs2_addr_i),
        .rs2_re_i      (id_exe_rs2_re_i),
        .rd_addr_i     (id_exe_rd_addr_i),
        .rd_we_i       (id_exe_rd_we_i),
        .mem_re_i      (id_exe_mem_re_i),
        .mem_we_i      (id_exe_mem_we_i),
        .instr_id_i    (id_exe_instr_id_i),
        .imm_i         (id_exe_imm_i),

        // to EXE and hazard detect unit
        .pc_o          (exe_pc_i),
        .rs1_val_o     (exe_rs1_val_i),
        .rs2_val_o     (exe_rs2_val_i),
        .rd_addr_o     (exe_rd_addr_i),
        .rd_we_o       (exe_rd_we_i),
        .mem_re_o      (exe_mem_re_i),
        .mem_we_o      (exe_mem_we_i),
        .instr_id_o    (exe_instr_id_i),
        .imm_o         (exe_imm_i),

        // to forwarding unit and hazard detection unit
        .rs1_addr_o    (forward_rs1_addr_i),
        .rs1_re_o      (forward_rs1_re_i),
        .rs2_addr_o    (forward_rs2_addr_i),
        .rs2_re_o      (forward_rs2_re_i)
    );

    // from EXE to EXE_WB
    wire [`GPR_WIDTH-1:0] exe_mem_alu_val_i;
    wire [`GPR_ADDR_SPACE-1:0] exe_mem_rd_addr_i;
    wire exe_mem_rd_we_i;
    wire [`GPR_WIDTH-1:0] exe_mem_rs2_val_i;
    wire exe_mem_mem_re_i;
    wire exe_mem_mem_we_i;
    wire [`funct3_width-1:0] exe_mem_mem_mode_i;

    EXE EXE1(
        // from ID_EXE
        .pc_i                (exe_pc_i),
        .rd_addr_i           (exe_rd_addr_i),
        .rd_we_i             (exe_rd_we_i),
        .mem_re_i            (exe_mem_re_i),
        .mem_we_i            (exe_mem_we_i),
        .instr_id_i          (exe_instr_id_i),
        .rs1_val_i           (exe_rs1_val_i),
        .rs2_val_i           (exe_rs2_val_i),
        .imm_i               (exe_imm_i),

        // from forwarding unit
        .forward_rs1_val_i   (fexe_rs1_val_i),
        .forward_rs2_val_i   (fexe_rs2_val_i),
        .forward_rs1_we_i    (fexe_rs1_we_i),
        .forward_rs2_we_i    (fexe_rs2_we_i),

        // to EXE_WB
        .alu_val_o           (exe_mem_alu_val_i),
        .rd_addr_o           (exe_mem_rd_addr_i),
        .rd_we_o             (exe_mem_rd_we_i),
        .rs2_val_o           (exe_mem_rs2_val_i),
        .mem_re_o            (exe_mem_mem_re_i),
        .mem_we_o            (exe_mem_mem_we_i),
        .mem_mode_o          (exe_mem_mem_mode_i)
    );

    // form EXE_MEM to MEM
    wire [`GPR_WIDTH-1:0] mem_alu_val_i;
    wire [`GPR_ADDR_SPACE-1:0] mem_rd_addr_i;
    wire mem_rd_we_i;
    wire [`GPR_WIDTH-1:0] mem_rs2_val_i;
    wire mem_mem_re_i;
    wire mem_mem_we_i;
    wire [`funct3_width-1:0] mem_mem_mode_i;

    EXE_MEM EXE_MEM1(
        .clk_i         (clk_i),

        // from EXE
        .alu_val_i     (exe_mem_alu_val_i),
        .rd_addr_i     (exe_mem_rd_addr_i),
        .rd_we_i       (exe_mem_rd_we_i),
        .rs2_val_i     (exe_mem_rs2_val_i),
        .mem_re_i      (exe_mem_mem_re_i),
        .mem_we_i      (exe_mem_mem_we_i),
        .mem_mode_i    (exe_mem_mem_mode_i),

        // to MEM, forwarding unit, hazard detect unit.
        // (alu value and rd information are also send to forwarding unit)
        // some value are send to hazard detect unit too.
        .alu_val_o     (mem_alu_val_i),
        .rd_addr_o     (mem_rd_addr_i),
        .rd_we_o       (mem_rd_we_i),
        .rs2_val_o     (mem_rs2_val_i),
        .mem_re_o      (mem_mem_re_i),
        .mem_we_o      (mem_mem_we_i),
        .mem_mode_o    (mem_mem_mode_i)
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
        .mem_mode_i    (mem_mem_mode_i),

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

    reg [`GPR_WIDTH-1:0] fbranch_rs1_val_i;
    reg [`GPR_WIDTH-1:0] fbranch_rs2_val_i;
    reg branchd_rs1_we_i;
    reg branchd_rs2_we_i;
    
    forwarding_unit forwarding_unit1(
        // from ID
        .id_rs1_addr        (regfile_rs1_addr_i),
        .id_rs2_addr        (regfile_rs2_addr_i),
        // from control unit
        .id_rs1_re          (id_rs1_re),
        .id_rs2_re          (id_rs2_re),

        // from ID_EXE
        .id_exe_rs1_addr    (forward_rs1_addr_i),
        .id_exe_rs1_re      (forward_rs1_re_i),
        .id_exe_rs2_addr    (forward_rs2_addr_i),
        .id_exe_rs2_re      (forward_rs2_re_i),

        // from EXE_MEM
        .exe_mem_alu_val    (mem_alu_val_i),
        .exe_mem_rd_addr    (mem_rd_addr_i),
        .exe_mem_rd_we      (mem_rd_we_i),
        .exe_mem_mem_re     (mem_mem_re_i),
        

        // from MEM_WB
        .mem_wb_rd_val      (wb_rd_val_i),
        .mem_wb_rd_addr     (wb_rd_addr_i),
        .mem_wb_rd_we       (wb_rd_we_i),

        // to EXE
        .forward_rs1_val_to_exe    (fexe_rs1_val_i),
        .forward_rs2_val_to_exe    (fexe_rs2_val_i),
        .forward_rs1_we_to_exe     (fexe_rs1_we_i),
        .forward_rs2_we_to_exe     (fexe_rs2_we_i),

        // to branch unit
        .forward_rs1_val_to_branch (fbranch_rs1_val_i),
        .forward_rs2_val_to_branch (fbranch_rs2_val_i),
        .forward_rs1_we_to_branch  (branchd_rs1_we_i),
        .forward_rs2_we_to_branch  (branchd_rs2_we_i)
    );

    // assign if_id_mode_i = `Normal;
    // assign id_exe_mode_i = `Normal;
    // assign exe_mem_mode_i = `Normal;

    reg [`Hazard_Signal_Width-1:0] signal_cycle_a; // this variable isn't be used for now.
    hazard_detect_unit hazard_detect_unit1(
        // from ID
        .id_instr_id      (id_exe_instr_id_i),
        .id_rs1_addr      (regfile_rs1_addr_i),
        .id_rs1_re        (id_exe_rs1_re_i),
        .id_rs2_addr      (regfile_rs2_addr_i),
        .id_rs2_re        (id_exe_rs2_re_i),

        // from ID_EXE
        .id_exe_instr_id  (exe_instr_id_i),
        .id_exe_rd_addr   (exe_rd_addr_i),
        .id_exe_rd_we     (exe_rd_we_i),
        .id_exe_mem_re    (exe_mem_re_i),

        // from EXE_MEM
        .exe_mem_mem_re   (mem_mem_re_i),
        .exe_mem_rd_addr  (mem_rd_addr_i),
        .exe_mem_rd_we    (mem_rd_we_i),

        // to IF_ID
        .if_id_mode       (if_id_mode_i),
        // to ID_EXE
        .id_exe_mode      (id_exe_mode_i),
        // to IF
        .if_stall         (if_stall_i),
        // to all unit who acquire hazard
        .signal_cycle     (signal_cycle_a)
    );

    branch_unit branch_unit1(
        // from forwarding unit
        .forward_rs1_val     (fbranch_rs1_val_i),
        .forward_rs2_val     (fbranch_rs2_val_i),
        .forward_rs1_we      (branchd_rs1_we_i),
        .forward_rs2_we      (branchd_rs2_we_i),

        // from regfile
        .reg_rs1_val         (id_rs1_val_i),
        .reg_rs2_val         (id_rs2_val_i),

        // from control unit
        .instr_id            (id_instr_id_i),
        .rs1_re              (id_rs1_re),
        .rs2_re              (id_rs2_re),

        // from ID
        .pc_i                (id_exe_pc_i),
        .imm_i               (id_exe_imm_i),

        // to IF
        .pc_o                (if_pc_val_i),
        .pc_we               (if_pc_we_i)
    );
endmodule
