/*
 * The code in instruction fetch here is different from teacher's concept.
 * rst_i represent reset signal. In my design, if this signal is rise,
 * PC will jump to the start position instand of disable fetching instruction from rom.
 */
module IF (
    input wire clk_i,
    input wire rst_i,
    
    output reg[`INST_WIDTH-1:0] inst_o,
    output reg[`SYS_ADDR_SPACE-1:0] pc_o
);
    wire [`SYS_ADDR_SPACE-1:0] pc_wire;
    wire [`CACHE_DATA_WIDTH-1:0] w_data_zero;
    wire re_wire; // assume from control unit
    wire we_wire;

    assign w_data_zero = `CACHE_DATA_WIDTH'h0;
    assign re_wire = !rst_i;
    assign we_wire = 1'b0;
    
    pc pc1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .pc_o(pc_wire)
    );
    
    assign pc_o = pc_wire;

    cache instr_cache1(
        .re_i(re_wire),
        .we_i(we_wire),
        .r_addr_i(pc_wire),
        .w_addr_i(pc_wire),
        .w_data_i(w_data_zero),
        .data_o(inst_o)
    );
    
endmodule