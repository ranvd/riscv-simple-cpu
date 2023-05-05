/* verilator lint_off LATCH */
module M_extend (
    input wire clk_i,
    input wire ce_i,
    input wire [`INST_ID_LEN-1:0] instr_id_i,
    input wire signed [`GPR_WIDTH-1:0] rs1_val_i,
    input wire signed [`GPR_WIDTH-1:0] rs2_val_i,

    output reg ready_o,
    output reg [`GPR_WIDTH-1:0] result_o
);
    
    reg [`GPR_WIDTH-1:0] rs1_val;
    reg rs1_comp;
    reg [`GPR_WIDTH-1:0] rs2_val;
    reg rs2_comp;
    reg [`GPR_WIDTH*2-1:0] mul_result;
    reg [`GPR_WIDTH*2-1:0] mul_result_buffer;
    reg [`GPR_WIDTH-1:0] div_result;
    reg [`GPR_WIDTH-1:0] rem_result;
    reg [1:0] status;
    reg [1:0] Mstatus;
    reg [1:0] Dstatus;
    reg [1:0] Rstatus;
    reg Mready;
    reg Dready;
    reg Rready;
    reg Mce;
    reg Dce;
    reg Rce;

    always @(*) begin
        case (instr_id_i)
        `MUL_ID, `MULH_ID, `MULHU_ID, `MULHSU_ID: begin
            status = Mstatus;
            ready_o = Mready;
            Mce = ce_i;
            Dce = `Off;
            Rce = `Off;
        end
        `DIV_ID, `DIVU_ID: begin
            status = Dstatus;
            ready_o = Dready;
            Mce = `Off;
            Dce = ce_i;
            Rce = `Off;
        end
        `REM_ID, `REMU_ID: begin
            status = Rstatus;
            ready_o = Rready;
            Mce = `Off;
            Dce = `Off;
            Rce = ce_i;
        end
        default : begin
            status = Mstatus;
            ready_o = Mready;
            Mce = `Off;
            Dce = `Off;
            Rce = `Off;
        end
        endcase
    end

    always @(*) begin
        if (status == 2'b11) begin
            case (instr_id_i)
            `MUL_ID, `MULH_ID, `DIV_ID, `REM_ID: begin
                if (rs1_val_i < 0)begin
                    rs1_val = ~rs1_val_i + 1;
                    rs1_comp = `On;
                end else begin
                    rs1_val = rs1_val_i;
                    rs2_comp = `Off;
                end

                if (rs2_val_i < 0)begin
                    rs2_val = ~rs2_val_i + 1;
                    rs2_comp = `On;
                end else begin
                    rs2_val = rs2_val_i;
                    rs2_comp = `Off;
                end
            end
            `MULHSU_ID: begin
                if (rs1_val_i < 0)begin
                    rs1_val = ~rs1_val_i + 1;
                    rs1_comp = `On;
                end else begin
                    rs1_val = rs1_val_i;
                    rs2_comp = `Off;
                end
                rs2_val = rs2_val_i;
                rs2_comp = `Off;
            end
            default: begin
                rs2_val = rs2_val_i;
                rs1_val = rs1_val_i;
                rs1_comp = `Off;
                rs2_comp = `Off;
            end
            endcase
        end
    end

    mul_32 mul_32_1(
        .ce_i(Mce),
        .clk_i(clk_i),
        .rs1_i(rs1_val),
        .rs2_i(rs2_val),
        .result_o(mul_result),
        .ready_o(Mready),
        .status_o(Mstatus)
    );

    div_32 div_32_1(
        .ce_i(Dce),
        .clk_i(clk_i),
        .rs1_i(rs1_val),
        .rs2_i(rs2_val),
        .result_o(div_result),
        .ready_o(Dready),
        .status_o(Dstatus)
    );

    rem_32 rem_32_1(
        .ce_i(Rce),
        .clk_i(clk_i),
        .rs1_i(rs1_val),
        .rs2_i(rs2_val),
        .result_o(rem_result),
        .ready_o(Rready),
        .status_o(Rstatus)
    );

    always @(*) begin
        case (instr_id_i)
            `MUL_ID : begin
                if (rs1_comp ^ rs2_comp) begin
                    result_o = (~mul_result[`GPR_WIDTH-1:0] + 1);
                end else begin
                    result_o = mul_result[`GPR_WIDTH-1:0];
                end
            end
            `MULH_ID : begin
                if (rs1_comp ^ rs2_comp) begin
                    mul_result_buffer = ~mul_result + 1;
                    result_o = mul_result_buffer[`GPR_WIDTH*2-1:`GPR_WIDTH];
                end else begin
                    result_o = mul_result[`GPR_WIDTH*2-1:`GPR_WIDTH];
                end
            end
            `MULHSU_ID : begin
                if (rs1_comp) begin
                    mul_result_buffer = ~mul_result + 1;
                    result_o = mul_result_buffer[`GPR_WIDTH*2-1:`GPR_WIDTH];
                end else begin
                    result_o = mul_result[`GPR_WIDTH*2-1:`GPR_WIDTH];
                end
            end
            `MULHU_ID : begin
                result_o = mul_result[`GPR_WIDTH*2-1:`GPR_WIDTH];
            end
            `DIV_ID : begin
                if (rs2_val == `GPR_WIDTH'b0)begin
                    result_o = div_result;
                end else if (rs1_comp ^ rs2_comp) begin
                    result_o = ~div_result + 1;
                end else begin
                    result_o = div_result;
                end
            end
            `DIVU_ID : begin
                result_o = div_result;
            end
            `REM_ID : begin
                if (rs1_comp) begin
                    result_o = (~rem_result[`GPR_WIDTH-1:0] + 1);
                end else begin
                    result_o = rem_result[`GPR_WIDTH-1:0];
                end
            end
            `REMU_ID : begin
                result_o = rem_result;
            end
            default: begin
                result_o = 32'b0;
            end
        endcase
    end
endmodule