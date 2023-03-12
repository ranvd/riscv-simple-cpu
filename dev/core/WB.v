module WB (
    // from MEM_WB
    input wire [`GPR_WIDTH-1:0]rd_val_i,
    input wire [`GPR_ADDR_SPACE-1:0]rd_addr_i,
    input wire rd_we_i,

    // to regfile
    output reg [`GPR_WIDTH-1:0]rd_val_o,
    output reg [`GPR_ADDR_SPACE-1:0]rd_addr_o,
    output wire rd_we_o
);
    assign rd_val_o = rd_val_i;
    assign rd_addr_o = rd_addr_i;
    assign rd_we_o = rd_we_i;
    
endmodule