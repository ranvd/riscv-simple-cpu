//`include "rom.v"
//`include "pc_reg.v"

module inst_fetch (
    input wire rst_i,
    input wire clk_i,
    output wire[31:0] inst_o
);
    wire[5:0] pc_wire;
    wire ce_wire;

    pc_reg pc_reg0(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .pc_o(pc_wire),
        .ce_o(ce_wire)
    );

    rom rom0(
        .addr_i(pc_wire),
        .ce_i(ce_wire),
        .inst_o(inst_o)
    );
endmodule