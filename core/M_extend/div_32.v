/* verilator lint_off LATCH */
module div_32(
    input wire ce_i,
    input wire clk_i,
    input wire [`GPR_WIDTH-1:0] rs1_i,
    input wire [`GPR_WIDTH-1:0] rs2_i,

    output reg [`GPR_WIDTH-1:0] result_o,
    output reg ready_o,
    output reg [1:0] status_o
);
    reg ready;
    reg [1:0] status;
    reg [`GPR_WIDTH-1:0] rs1;
    reg [`GPR_WIDTH-1:0] rs2;

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
            status = 2'b10;
        end else begin
            status = 2'b11;
        end

        if (rs2 == 32'b0) begin
            result_o = -1;
        end else begin
            result_o = rs1 / rs2;
        end
    end
endmodule