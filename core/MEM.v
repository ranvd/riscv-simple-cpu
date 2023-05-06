module MEM (
    // from EXE_MEM
    input wire [`GPR_WIDTH-1:0] alu_val_i,
    input wire [`GPR_ADDR_SPACE-1:0] rd_addr_i,
    input wire rd_we_i,
    input wire [`GPR_WIDTH-1:0] rs2_val_i,
    input wire mem_re_i,
    input wire mem_we_i,
    input wire [`funct3_width-1:0] mem_mode_i,

    // to MEM_WB
    output reg [`GPR_WIDTH-1:0] rd_val_o,
    output reg [`GPR_ADDR_SPACE-1:0] rd_addr_o,
    output reg rd_we_o
);
    reg [`DATA_WIDTH-1:0] data_cache_o;
    reg [`GPR_WIDTH-1:0] w_val;

    cache data_cache1(
        .re_i(mem_re_i),
        .we_i(mem_we_i),
        .r_addr_i(alu_val_i),
        .w_addr_i(alu_val_i),
        .w_data_i(rs2_val_i),
        .mem_mode_i(mem_mode_i),
        .data_o(data_cache_o)
    );

    assign rd_we_o = rd_we_i;
    assign rd_addr_o = rd_addr_i;

    
    always @(*) begin
        if(mem_re_i) begin
            case (mem_mode_i)
                `LB_FUN3 : begin
                    rd_val_o = {{24{data_cache_o[7]}}, data_cache_o[7:0]};
                end
                `LH_FUN3 : begin
                    rd_val_o = {{16{data_cache_o[15]}}, data_cache_o[15:0]};
                end
                `LW_FUN3 : begin
                    rd_val_o = data_cache_o;
                end
                `LBU_FUN3 : begin
                    rd_val_o = {{24{1'b0}}, data_cache_o[7:0]};
                end
                `LHU_FUN3 : begin
                    rd_val_o = {{16{1'b0}}, data_cache_o[15:0]};
                end
                default: begin
                    rd_val_o = data_cache_o;
                end
            endcase
        end else begin
            rd_val_o = alu_val_i;
        end
    end

    // always @(*) begin
    //     if (mem_we_i) begin
    //         case (mem_mode_i)
    //         `SB_FUN3: begin

    //         end
    //         `SH_FUN3: begin
    //         end
    //         `SW_FUN3: begin
    //         end
    //         default : begin
    //         end
    //         endcase
    //     end
    // end

endmodule