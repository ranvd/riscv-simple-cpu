module EXE_MEM (
    input wire clk_i,

    // from EXE
    input wire [`GPR_WIDTH-1:0] alu_val_i,
    input wire [`GPR_ADDR_SPACE-1:0] rd_addr_i,
    input wire rd_we_i,
    input wire [`GPR_WIDTH-1:0] rs2_val_i,
    input wire mem_re_i,
    input wire mem_we_i,
    input wire [`funct3_width-1:0] mem_mode_i,

    // to MEM
    output reg [`GPR_WIDTH-1:0] alu_val_o,
    output reg [`GPR_ADDR_SPACE-1:0] rd_addr_o,
    output reg rd_we_o,
    output reg [`GPR_WIDTH-1:0] rs2_val_o,
    output reg mem_re_o,
    output reg mem_we_o,
    output reg [`funct3_width-1:0] mem_mode_o
);
    always @(posedge clk_i) begin
        alu_val_o <= alu_val_i;
        rd_addr_o <= rd_addr_i;
        rd_we_o <= rd_we_i;
        rs2_val_o <= rs2_val_i;
        mem_re_o <= mem_re_i;
        mem_we_o <= mem_we_i;
        mem_mode_o <= mem_mode_i;
    end
    
endmodule