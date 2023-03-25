/* verilator lint_off LATCH */
module forwarding_unit (
    // from ID
    input wire [`GPR_ADDR_SPACE-1:0] id_rs1_addr,
    input wire id_rs1_re,
    input wire [`GPR_ADDR_SPACE-1:0] id_rs2_addr,
    input wire id_rs2_re,

    // from ID_EXE
    input wire [`GPR_ADDR_SPACE-1:0] id_exe_rs1_addr,
    input wire id_exe_rs1_re,
    input wire [`GPR_ADDR_SPACE-1:0] id_exe_rs2_addr,
    input wire id_exe_rs2_re,

    // from EXE_MEM
    input wire [`GPR_ADDR_SPACE-1:0] exe_mem_rd_addr,
    input [`GPR_WIDTH-1:0] exe_mem_alu_val,
    input wire exe_mem_rd_we,
    input wire exe_mem_mem_re,

    // from MEM_WB
    input wire [`GPR_ADDR_SPACE-1:0] mem_wb_rd_addr,
    input [`GPR_WIDTH-1:0] mem_wb_rd_val,
    input mem_wb_rd_we,

    // to EXE
    output reg [`GPR_WIDTH-1:0] forward_rs1_val_to_exe,
    output reg [`GPR_WIDTH-1:0] forward_rs2_val_to_exe,
    output reg forward_rs1_we_to_exe,
    output reg forward_rs2_we_to_exe,

    // to branch unit
    output reg [`GPR_WIDTH-1:0] forward_rs1_val_to_branch,
    output reg [`GPR_WIDTH-1:0] forward_rs2_val_to_branch,
    output reg forward_rs1_we_to_branch,
    output reg forward_rs2_we_to_branch 
);

    always @(*)begin
        // check exe rs1
        if (id_exe_rs1_addr != 0 && id_exe_rs1_addr == exe_mem_rd_addr && (id_exe_rs1_re & exe_mem_rd_we) && !exe_mem_mem_re) begin
            forward_rs1_we_to_exe = `On;
            forward_rs1_val_to_exe = exe_mem_alu_val;
        end else if (id_exe_rs1_addr != 0 && id_exe_rs1_addr == mem_wb_rd_addr && (id_exe_rs1_re & mem_wb_rd_we)) begin
            forward_rs1_we_to_exe = `On;
            forward_rs1_val_to_exe = mem_wb_rd_val;
        end else begin
            forward_rs1_we_to_exe = `Off;
        end
    end

    always @(*) begin // check exe rs2
        if (id_exe_rs2_addr != 0 && id_exe_rs2_addr == exe_mem_rd_addr && (id_exe_rs2_re & exe_mem_rd_we) && !exe_mem_mem_re) begin
            forward_rs2_we_to_exe = `On;
            forward_rs2_val_to_exe = exe_mem_alu_val;
        end else if (id_exe_rs2_addr != 0 && id_exe_rs2_addr == mem_wb_rd_addr && (id_exe_rs2_re & mem_wb_rd_we)) begin
            forward_rs2_we_to_exe = `On;
            forward_rs2_val_to_exe = mem_wb_rd_val;
        end else begin
            forward_rs2_we_to_exe = `Off;
        end
    end

    always @(*)begin
        // check id rs1
        if (id_rs1_addr != 0 && id_rs1_addr == exe_mem_rd_addr && (id_rs1_re & exe_mem_rd_we) && !exe_mem_mem_re) begin
            forward_rs1_we_to_branch = `On;
            forward_rs1_val_to_branch = exe_mem_alu_val;
        end else begin
            forward_rs1_we_to_branch = `Off;
        end
    end

    always @(*) begin
        // check id rs2
        if (id_rs2_addr != 0 && id_rs2_addr == exe_mem_rd_addr && (id_rs2_re & exe_mem_rd_we) && !exe_mem_mem_re) begin
            forward_rs2_we_to_branch = `On;
            forward_rs2_val_to_branch = exe_mem_alu_val;
        end else begin
            forward_rs2_we_to_branch = `Off;
        end
    end
    
endmodule