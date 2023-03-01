
module IF (
    input wire clk_i,
    input wire rst_i,
    
    output reg[`INST_WIDTH-1:0] inst_o
);
    wire [`SYS_SPACE-1:0] pc_wire;
    wire re_wire; // assume from control unit
    assign re_wire = 1'b1;

    PC PC1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .pc_o(pc_wire)
    );
    rom rom1(
        .clk_i(clk_i),
        .re_i(re_wire),
        .addr_i(pc_wire)
        .inst_o(inst_o)
    );
    
endmodule