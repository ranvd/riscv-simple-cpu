module EXE (
    // from ID_EXE
    input wire [`GPR_ADDR_SPACE-1:0] rd_addr_i,
    input wire rd_we_i,
    input wire mem_re_i,
    input wire mem_we_i,
    input wire [`INST_ID_LEN-1:0] instr_id_i,
    input wire signed [`GPR_WIDTH-1:0] rs1_val_i,
    input wire signed [`GPR_WIDTH-1:0] rs2_val_i,
    input wire [`IMM_WIDTH-1:0] imm_i,

    // to EXE_WB
    output reg [`GPR_WIDTH-1:0] alu_val_o,
    output reg [`GPR_ADDR_SPACE-1:0] rd_addr_o,
    output reg rd_we_o,
    output reg [`GPR_WIDTH-1:0] rs2_val_o,
    output reg mem_re_o,
    output reg mem_we_o
);
    assign rd_addr_o = rd_addr_i;
    assign rd_we_o = rd_we_i;
    assign mem_re_o = mem_re_i;
    assign mem_we_o = mem_we_i;
    assign rs2_val_o = rs2_val_i;

    always @(*) begin
        case (instr_id_i)
            `ADDI_ID : begin
                alu_val_o = rs1_val_i + imm_i;
            end
            `SLTI_ID : begin
                if (rs1_val_i < imm_i) begin
                    alu_val_o = `GPR_WIDTH'h1;
                end else begin
                    alu_val_o = `GPR_WIDTH'h0;
                end
            end
            `SLTIU_ID : begin
                if ($unsigned(rs1_val_i) < $unsigned(imm_i)) begin
                    alu_val_o = `GPR_WIDTH'h1;
                end else begin
                    alu_val_o = `GPR_WIDTH'h0;
                end
            end
            `XORI_ID : begin
                alu_val_o = rs1_val_i ^ imm_i;
            end
            `ORI_ID : begin
                alu_val_o = rs1_val_i | imm_i;
            end
            `ANDI_ID : begin
                alu_val_o = rs1_val_i & imm_i;
            end
            `SLLI_ID : begin
                alu_val_o = rs1_val_i << imm_i[4:0];
            end
            `SRLI_ID : begin
                alu_val_o = rs1_val_i >> imm_i[4:0];
            end
            `SRAI_ID : begin
                alu_val_o = rs1_val_i >>> imm_i[4:0];
            end
            default: begin
                alu_val_o = 32'b0;
            end
        endcase
    end
    
endmodule