module MEM (
    // from EXE_MEM
    input wire [`GPR_WIDTH-1:0] alu_val_i,
    input wire [`GPR_ADDR_SPACE-1:0] rd_addr_i,
    input wire rd_we_i,
    input wire [`GPR_WIDTH-1:0] rs2_val_i,
    input wire mem_re_i,
    input wire mem_we_i,

    // to MEM_WB
    output reg [`GPR_WIDTH-1:0] rd_val_o,
    output reg [`GPR_ADDR_SPACE-1:0] rd_addr_o,
    output reg rd_we_o
);
    reg[`CACHE_DATA_WIDTH-1:0] data_cache_o;

    cache data_cache1(
        .re_i(mem_re_i),
        .we_i(mem_we_i),
        .r_addr_i(alu_val_i),
        .w_addr_i(alu_val_i),
        .w_data_i(rs2_val_i),
        .data_o(data_cache_o)
    );
    
    always @(*) begin
        if(mem_re_i) begin
            rd_val_o = data_cache_o;
            rd_addr_o = rd_addr_i;
            rd_we_o = rd_we_i;
        end else begin
            rd_val_o = alu_val_i;
            rd_addr_o = rd_addr_i;
            rd_we_o = rd_we_i;
        end

    end

endmodule