module EXE (
    input wire clk_i, // for M extension

    // from ID_EXE
    input wire [`SYS_ADDR_SPACE-1:0] pc_i,
    input wire [`GPR_ADDR_SPACE-1:0] rd_addr_i,
    input wire rd_we_i,
    input wire mem_re_i,
    input wire mem_we_i,
    input wire [`INST_ID_LEN-1:0] instr_id_i,
    input wire signed [`GPR_WIDTH-1:0] rs1_val_i,
    input wire signed [`GPR_WIDTH-1:0] rs2_val_i,
    input wire signed [`IMM_WIDTH-1:0] imm_i,

    // from forwarding unit
    input reg [`GPR_WIDTH-1:0] forward_rs1_val_i,
    input reg [`GPR_WIDTH-1:0] forward_rs2_val_i,
    input reg forward_rs1_we_i,
    input reg forward_rs2_we_i,

    // to EXE_WB
    output reg [`GPR_WIDTH-1:0] alu_val_o,
    output reg [`GPR_ADDR_SPACE-1:0] rd_addr_o,
    output reg rd_we_o,
    output reg [`GPR_WIDTH-1:0] rs2_val_o,
    output reg mem_re_o,
    output reg mem_we_o,
    output reg [`funct3_width-1:0] mem_mode_o,

    // to hazard unit
    output reg ready_o
);
    // inner module use
    reg signed [`GPR_WIDTH-1:0] rs1_val;
    reg signed [`GPR_WIDTH-1:0] rs2_val;
    wire [1:0] forward_signal;
    reg [`GPR_WIDTH-1:0] M_val;
    reg [`GPR_WIDTH-1:0] alu_val;
    reg M_ce;

    assign rd_addr_o = rd_addr_i;
    assign rd_we_o = rd_we_i;
    assign rs2_val_o = rs2_val;
    assign mem_re_o = mem_re_i;
    assign mem_we_o = mem_we_i;
    assign mem_mode_o = instr_id_i[9:7]; // this is func3
    assign forward_signal = {forward_rs2_we_i, forward_rs1_we_i};

    always @(*) begin
        case (forward_signal)
            `Forward_Rs1 : begin
                rs1_val = forward_rs1_val_i;
                rs2_val = rs2_val_i;
            end
            `Forward_Rs2 : begin
                rs1_val = rs1_val_i;
                rs2_val = forward_rs2_val_i;
            end
            `Forward_Both : begin
                rs1_val = forward_rs1_val_i;
                rs2_val = forward_rs2_val_i;
            end
            default: begin
                rs1_val = rs1_val_i;
                rs2_val = rs2_val_i;
            end
        endcase
    end

    always @(*) begin
        case (instr_id_i)
            `ADDI_ID, `LB_ID, `LH_ID, `LW_ID, `LBU_ID, `LHU_ID,
            `SB_ID, `SH_ID, `SW_ID : begin
                alu_val = rs1_val + imm_i;
                M_ce = `Off;
            end
            `SLTI_ID : begin
                if (rs1_val < imm_i) begin
                    alu_val = `GPR_WIDTH'h1;
                end else begin
                    alu_val = `GPR_WIDTH'h0;
                end
                M_ce = `Off;
            end
            `SLTIU_ID : begin
                if ($unsigned(rs1_val) < $unsigned(imm_i)) begin
                    alu_val = `GPR_WIDTH'h1;
                end else begin
                    alu_val = `GPR_WIDTH'h0;
                end
                M_ce = `Off;
            end
            `XORI_ID : begin
                alu_val = rs1_val ^ imm_i;
                M_ce = `Off;
            end
            `ORI_ID : begin
                alu_val = rs1_val | imm_i;
                M_ce = `Off;
            end
            `ANDI_ID : begin
                alu_val = rs1_val & imm_i;
                M_ce = `Off;
            end
            `SLLI_ID : begin
                alu_val = rs1_val << imm_i[4:0];
                M_ce = `Off;
            end
            `SRLI_ID : begin
                alu_val = rs1_val >> imm_i[4:0];
                M_ce = `Off;
            end
            `SRAI_ID : begin
                alu_val = rs1_val >>> imm_i[4:0];
                M_ce = `Off;
                // alu_val = rs1_val + imm_i;
            end
            `ADD_ID : begin
                alu_val = rs1_val + rs2_val;
                M_ce = `Off;
            end
            `SUB_ID : begin
                alu_val = rs1_val - rs2_val;
                M_ce = `Off;
            end
            `SLL_ID : begin
                alu_val = rs1_val << rs2_val[4:0];
                M_ce = `Off;
            end
            `SLT_ID : begin
                if (rs1_val < rs2_val) begin
                    alu_val = `GPR_WIDTH'h1;
                end else begin
                    alu_val = `GPR_WIDTH'h0;
                end
                M_ce = `Off;
            end
            `SLTU_ID : begin
                if ($unsigned(rs1_val) < $unsigned(rs2_val)) begin
                    alu_val = `GPR_WIDTH'h1;
                end else begin
                    alu_val = `GPR_WIDTH'h0;
                end
                M_ce = `Off;
            end
            `XOR_ID : begin
                alu_val = rs1_val ^ rs2_val;
                M_ce = `Off;
            end
            `SRL_ID : begin
                alu_val = rs1_val >> rs2_val[4:0];
                M_ce = `Off;
            end
            `SRA_ID : begin
                alu_val = rs1_val >>> rs2_val[4:0];
                M_ce = `Off;
            end
            `OR_ID : begin
                alu_val = rs1_val | rs2_val;
                M_ce = `Off;
            end
            `AND_ID : begin
                alu_val = rs1_val & rs2_val;
                M_ce = `Off;
            end
            `LUI_ID : begin
                alu_val = imm_i;
                M_ce = `Off;
            end
            `AUIPC_ID : begin
                alu_val = pc_i + imm_i;
                M_ce = `Off;
            end
            `JAL_ID, `JALR_ID : begin
                alu_val  = pc_i + 4;
                M_ce = `Off;
            end
            `MUL_ID, `MULH_ID, `MULHSU_ID, `MULHU_ID, `DIV_ID, 
            `DIVU_ID, `REM_ID, `REMU_ID: begin
                alu_val = 32'b0;
                M_ce = `On;
            end
            default: begin
                alu_val = 32'b0;
            end
        endcase
    end

    M_extend M_extend1(
        .clk_i(clk_i),
        .ce_i(M_ce),
        .instr_id_i(instr_id_i),
        .rs1_val_i(rs1_val),
        .rs2_val_i(rs2_val),
        .ready_o(ready_o),
        .result_o(M_val)
    );
    always @(*) begin
        if (M_ce == `On) begin
            alu_val_o = M_val;
        end else begin
            alu_val_o = alu_val;
        end

    end
    
endmodule