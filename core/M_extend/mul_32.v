/*
 * Duing the mul_32 execution, chip enable signal(ce_i) should 
 * always at On state. Read signal(ready_o) should only at Off during
 * execution.
*/
/* verilator lint_off LATCH */
module mul_32 (
    input wire ce_i,
    input wire clk_i,
    input wire [`GPR_WIDTH-1:0] rs1_i,
    input wire [`GPR_WIDTH-1:0] rs2_i,

    output wire [`GPR_WIDTH*2-1:0] result_o,
    output wire ready_o,
    output wire [1:0] status_o
);
    reg ready;
    reg [1:0] status;
    reg [`GPR_WIDTH-1:0] rs1;
    reg [`GPR_WIDTH-1:0] rs2;
    reg [`GPR_WIDTH*2-1:0] sig [18:0];
    reg [`GPR_WIDTH*2-1:0] c [2:0];
    reg [`GPR_WIDTH*2-1:0] s [2:0];

    assign result_o = c[0] + s[0];
    assign ready_o = ready;
    assign status_o = status;

    always @(*)begin
        if (ready == `On || ce_i == `Off) begin
            rs1 = 32'b0;
            rs2 = 32'b0;
        end else begin
            if (rs1 == `GPR_WIDTH'b0) begin
                rs1 = rs1_i;
            end
            if (rs2 == `GPR_WIDTH'b0) begin
                rs2 = rs2_i;
            end
        end
    end
    
    always @(*) begin
        if ((ce_i == `On && status == 2'b10) || ce_i == `Off) begin
            ready = `On;
        end else  begin
            ready = `Off;
        end
    end

    always @(posedge clk_i)begin
        integer i = 0;
        
        if (ce_i == `On && ready == `On) begin
            status = 2'b11;
        end else if (ce_i == `On) begin
            status = status + 1;
        end else begin
            status = 2'b11;
        end

        // if (ce_i == `On) begin
        //     status = status + 1;
        // end else begin
        //     status = 2'b11;
        // end

        case (status)
            0: begin
                for (i = 0; i < 19; i = i+1) begin
                    sig[i] = ({32'b0, {32{rs1[i]}} & rs2}) << i;
                end
            end 
            1: begin
                sig[0] = c[0];
                sig[1] = c[1];
                sig[2] = c[2];
                sig[3] = s[0];
                sig[4] = s[1];
                sig[5] = s[2];
                for (i = 0; i < 13; i = i+1) begin
                    sig[i+6] = ({32'b0, {32{rs1[i+19]}} & rs2}) << i+19;
                end
            end
            2: begin
                sig[0] = c[0];
                sig[1] = c[1];
                sig[2] = c[2];
                sig[3] = s[0];
                sig[4] = s[1];
                sig[5] = s[2];
                for (i = 0; i < 13; i = i+1) begin
                    sig[i+6] = 64'b0;
                end
            end
            default: begin
                for (i = 0; i < 19; i = i+1) begin
                    sig[i] = 64'b0;
                end
            end
        endcase
    end
    
    reg [`GPR_WIDTH*2-1:0] inner_c [9:0];
    reg [`GPR_WIDTH*2-1:0] inner_s [9:0];

    pseudoadder pseudoadder_0(
        .a0(sig[0]),
        .a1(sig[1]),
        .a2(sig[2]),
        .s(inner_s[0]),
        .c(inner_c[0])
    );
    pseudoadder pseudoadder_1(
        .a0(sig[3]),
        .a1(sig[4]),
        .a2(sig[5]),
        .s(inner_s[1]),
        .c(inner_c[1])
    );
    pseudoadder pseudoadder_2(
        .a0(sig[6]),
        .a1(sig[7]),
        .a2(sig[8]),
        .s(inner_s[2]),
        .c(inner_c[2])
    );
    pseudoadder pseudoadder_3(
        .a0(sig[9]),
        .a1(sig[10]),
        .a2(sig[11]),
        .s(inner_s[3]),
        .c(inner_c[3])
    );
    pseudoadder pseudoadder_4(
        .a0(sig[12]),
        .a1(sig[13]),
        .a2(sig[14]),
        .s(inner_s[4]),
        .c(inner_c[4])
    );
    pseudoadder pseudoadder_5(
        .a0(sig[15]),
        .a1(sig[16]),
        .a2(sig[17]),
        .s(inner_s[5]),
        .c(inner_c[5])
    );
    pseudoadder pseudoadder_6(
        .a0(inner_c[0]),
        .a1(inner_s[1]),
        .a2(inner_c[1]),
        .s(inner_s[6]),
        .c(inner_c[6])
    );
    pseudoadder pseudoadder_7(
        .a0(inner_s[2]),
        .a1(inner_c[2]),
        .a2(inner_s[3]),
        .s(inner_s[7]),
        .c(inner_c[7])
    );
    pseudoadder pseudoadder_8(
        .a0(inner_c[3]),
        .a1(inner_s[4]),
        .a2(inner_c[4]),
        .s(inner_s[8]),
        .c(inner_c[8])
    );
    pseudoadder pseudoadder_9(
        .a0(inner_s[5]),
        .a1(inner_c[5]),
        .a2(sig[18]),
        .s(inner_s[9]),
        .c(inner_c[9])
    );
    pseudoadder pseudoadder_10(
        .a0(inner_s[0]),
        .a1(inner_s[6]),
        .a2(inner_c[6]),
        .s(s[0]),
        .c(c[0])
    );
    pseudoadder pseudoadder_11(
        .a0(inner_s[7]),
        .a1(inner_c[7]),
        .a2(inner_s[8]),
        .s(s[1]),
        .c(c[1])
    );
    pseudoadder pseudoadder_12(
        .a0(inner_c[8]),
        .a1(inner_s[9]),
        .a2(inner_c[9]),
        .s(s[2]),
        .c(c[2])
    );
    
endmodule