/*
 * The code in instruction fetch here is different from teacher's concept.
 * rst_i represent reset signal. In my design, if this signal is rise,
 * PC will jump to the start position instand of disable fetching instruction from rom.
 */
module IF (
    input wire clk_i,
    input wire rst_i,

    // from hazard detect unit
    input wire stall_i,

    // from branch unit
    input wire [`SYS_ADDR_SPACE-1:0] pc_i,
    input wire pc_we,

    // to IF_ID
    output reg[`INST_WIDTH-1:0] inst_o,
    output reg[`SYS_ADDR_SPACE-1:0] pc_o,
    output reg anomaly_o
);
    wire [`SYS_ADDR_SPACE-1:0] pc_wire;
    wire [`CACHE_DATA_WIDTH-1:0] w_data_zero;
    wire re_wire; // assume from control unit
    wire we_wire;

    assign w_data_zero = `CACHE_DATA_WIDTH'h0;
    assign re_wire = !rst_i; // reset enable = read disable
    assign we_wire = 1'b0;
    
    pc pc1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .stall_i(stall_i),
        .we_i(pc_we),
        .pc_i(pc_i),
        .pc_o(pc_wire)
    );
    
    assign pc_o = pc_wire;
    always @(*) begin
        if (inst_o[1:0] != 2'b11) begin
            anomaly_o = `On;
        end else begin
            anomaly_o = `Off;
        end
    end
    // always @(*) begin
    //     if(pc_we) begin
    //         pc_o = pc_i;
    //     end else begin
    //         pc_o = pc_wire;
    //     end
    // end

    cache instr_cache1(
        .re_i(re_wire),
        .we_i(`Off),
        .r_addr_i(pc_o),
        .w_addr_i(pc_o),
        .w_data_i(w_data_zero),
        .mem_mode_i(`LW_FUN3),
        .data_o(inst_o)
    );
    
endmodule