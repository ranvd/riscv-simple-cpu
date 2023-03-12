module MEM_WB (
    input wire clk_i,

    // from MEM
    input wire [`GPR_WIDTH-1:0] rd_val_i,
    input wire [`GPR_ADDR_SPACE-1:0] rd_addr_i,
    input wire rd_we_i,

    // to WB
    output reg [`GPR_WIDTH-1:0] rd_val_o,
    output reg [`GPR_ADDR_SPACE-1:0] rd_addr_o,
    output reg rd_we_o
);
    always @(posedge clk_i) begin
        rd_val_o <= rd_val_i;
        rd_addr_o <= rd_addr_i;
        rd_we_o <= rd_we_i; 
    end
    
endmodule