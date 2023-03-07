`include "define.v"
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
    wire re_wire; // assume from control unit
    assign re_wire = 1'b1;
    
    pc pc1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .pc_o(pc_wire)
    );
    
    assign pc_o = pc_wire;

    rom rom1(
        .clk_i(clk_i),
        .re_i(re_wire),
        .addr_i(pc_wire),
        .inst_o(inst_o)
    );
    
endmodule