module branch_unit (
    // from forwarding unit
    input wire [`GPR_WIDTH-1:0] forward_rs1_val,
    input wire [`GPR_WIDTH-1:0] forward_rs2_val,
    input wire forward_rs1_we,
    input wire forward_rs2_we,

    // from regfile
    input wire signed [`GPR_WIDTH-1:0] reg_rs1_val,
    input wire signed [`GPR_WIDTH-1:0] reg_rs2_val,

    // from control unit
    input wire [`INST_ID_LEN-1:0] instr_id,
    input wire rs1_re,
    input wire rs2_re,
    
    // from ID
    input wire [`SYS_ADDR_SPACE-1:0] pc_i,
    input wire [`IMM_WIDTH-1:0] imm_i,

    // to IF
    output reg [`SYS_ADDR_SPACE-1:0] pc_o,
    output reg pc_we    
);
    wire [1:0] forward_signal;
    reg signed [`GPR_WIDTH-1:0] rs1_val;
    reg signed [`GPR_WIDTH-1:0] rs2_val;

    assign forward_signal = {forward_rs2_we, forward_rs1_we};

    always @(*) begin
        case (forward_signal)
            `Forward_Rs1 : begin
                rs1_val = forward_rs1_val;
                rs2_val = reg_rs2_val;
            end
            `Forward_Rs2 : begin
                rs1_val = reg_rs1_val;
                rs2_val = forward_rs2_val;
            end
            `Forward_Both : begin
                rs1_val = forward_rs1_val;
                rs2_val = forward_rs2_val;
            end
            default: begin
                rs1_val = reg_rs1_val;
                rs2_val = reg_rs2_val;
            end
        endcase
    end

    always @(*) begin
        case(instr_id)
            `JAL_ID : begin
                pc_o = pc_i + imm_i;
                pc_we = `On;
            end
            `JALR_ID : begin
                pc_o = rs1_val + imm_i;
                pc_we = `On;
            end
            `BEQ_ID : begin
                pc_o = pc_i + imm_i;
                if (rs1_val == rs2_val) begin
                    pc_we = `On;
                end else begin
                    pc_we = `Off;
                end
            end
            `BNE_ID : begin
                pc_o = pc_i + imm_i;
                if (rs1_val != rs2_val) begin
                    pc_we = `On;
                end else begin
                    pc_we = `Off;
                end
            end
            `BLT_ID : begin
                pc_o = pc_i + imm_i;
                if (rs1_val < rs2_val) begin
                    pc_we = `On;
                end else begin
                    pc_we = `Off;
                end
            end
            `BGE_ID : begin
                pc_o = pc_i + imm_i;
                if (rs1_val >= rs2_val) begin
                    pc_we = `On;
                end else begin
                    pc_we = `Off;
                end
            end
            `BLTU_ID : begin
                pc_o = pc_i + imm_i;
                if ($unsigned(rs1_val) < $unsigned(rs2_val)) begin
                    pc_we = `On;
                end else begin
                    pc_we = `Off;
                end
            end
            `BGEU_ID : begin
                pc_o = pc_i + imm_i;
                if ($unsigned(rs1_val) >= $unsigned(rs2_val)) begin
                    pc_we = `On;
                end else begin
                    pc_we = `Off;
                end
            end
            default : begin
                pc_o = 0;
                pc_we = `Off;
            end
        endcase
    end

endmodule