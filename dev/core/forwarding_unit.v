/* verilator lint_off LATCH */
module forwarding_unit (
    // from ID_EXE
    input wire [`GPR_ADDR_SPACE-1:0] id_exe_rs1_addr,
    input wire id_exe_rs1_re,
    input wire [`GPR_ADDR_SPACE-1:0] id_exe_rs2_addr,
    input wire id_exe_rs2_re,

    // from EXE_MEM
    input wire [`GPR_ADDR_SPACE-1:0] exe_mem_rd_addr,
    input [`GPR_WIDTH-1:0] exe_mem_alu_val,
    input exe_mem_rd_we,

    // from MEM_WB
    input wire [`GPR_ADDR_SPACE-1:0] mem_wb_rd_addr,
    input [`GPR_WIDTH-1:0] mem_wb_rd_val,
    input mem_wb_rd_we,

    // to EXE
    output reg [`GPR_WIDTH-1:0] forward_rs1_val,
    output reg [`GPR_WIDTH-1:0] forward_rs2_val,
    output reg forward_rs1_we,
    output reg forward_rs2_we
);

    always @(*)begin
        // check rs1
        if (id_exe_rs1_addr == exe_mem_rd_addr && (id_exe_rs1_re & exe_mem_rd_we)) begin
            forward_rs1_we = `On;
            forward_rs1_val = exe_mem_alu_val;
        end else if (id_exe_rs1_addr == mem_wb_rd_addr && (id_exe_rs1_re & mem_wb_rd_we)) begin
            forward_rs1_we = `On;
            forward_rs1_val = mem_wb_rd_val;
        end else begin
            forward_rs1_we = `Off;
        end
    end

    always @(*) begin // check rs2
        if (id_exe_rs2_addr == exe_mem_rd_addr && (id_exe_rs2_re & exe_mem_rd_we)) begin
            forward_rs2_we = `On;
            forward_rs2_val = exe_mem_alu_val;
        end else if (id_exe_rs2_addr == mem_wb_rd_addr && (id_exe_rs2_re & mem_wb_rd_we)) begin
            forward_rs2_we = `On;
            forward_rs2_val = mem_wb_rd_val;
        end else begin
            forward_rs2_we = `Off;
        end
    end
endmodule