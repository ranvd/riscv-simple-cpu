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
    output reg anomaly_o,

    // from RAM
    input wire [`DATA_WIDTH-1:0] icache_data,
    input wire icache_we,
    // to hazard detect unit
    output reg req_stall_i
);
    wire [`SYS_ADDR_SPACE-1:0] pc_wire;
    // wire [`DATA_WIDTH-1:0] icache_data;
    wire re_wire; // assume from control unit
    wire we_wire;

    // assign icache_data = `DATA_WIDTH'h0;
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
        if (inst_o[1:0] != 2'b11 || inst_o == 32'b1110011) begin
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
    wire tmp;

    cache instr_cache1(
        .re_i(re_wire),
        .we_i(icache_we),
        .r_addr_i(pc_o),
        .w_addr_i(pc_o),
        .w_data_i(icache_data),
        .mem_mode_i(`SW_FUN3),
        .data_o(inst_o),
        .read_err_o(tmp)
    );
    
endmodule