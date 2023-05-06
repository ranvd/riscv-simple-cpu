/* verilator lint_off LATCH */
`include "conf_general_define.v"

module cache #(
    parameter word_offset = 2,
    parameter index_width = 12,
    parameter tag_width = 18
)
(
    input wire re_i, // read enable
    input wire we_i, // write enable
    input wire [`SYS_ADDR_SPACE-1:0] r_addr_i,
    input wire [`SYS_ADDR_SPACE-1:0] w_addr_i,
    input wire [`DATA_WIDTH-1:0] w_data_i,
    input wire [`funct3_width-1:0] mem_mode_i,

    output reg[`DATA_WIDTH-1:0] data_o
    // output reg[`DATA_WIDTH-1:0] wdata_o
);
    parameter integer cache_width = 2 + tag_width + (2**word_offset) * 8; //52
    parameter integer cache_number = 2**index_width;

    reg err_siganl;
    reg [cache_width-1:0] cache [cache_number];

    reg [`SYS_ADDR_SPACE-1:0] mask;
    reg [index_width-1:0] read_idx;
    reg [tag_width-1:0]   read_tag;
    reg [`SYS_ADDR_SPACE-1:0] read_idx_32;
    reg [`SYS_ADDR_SPACE-1:0] read_tag_32;
    reg [index_width-1:0] write_idx;
    reg [tag_width-1:0]   write_tag;
    reg [`SYS_ADDR_SPACE-1:0] write_idx_32;
    reg [`SYS_ADDR_SPACE-1:0] write_tag_32;
    reg [`DATA_WIDTH-1:0] write_data;

    assign write_data = w_data_i;
    assign mask = {{tag_width{1'b1}}, 14'b0};
    assign read_idx_32 = (r_addr_i & ~mask) >> 2;
    assign read_tag_32 = (r_addr_i & mask) >> (index_width + 2);
    assign read_idx = read_idx_32[index_width-1:0];
    assign read_tag = read_tag_32[tag_width-1:0];

    assign write_idx_32 = (w_addr_i & ~mask) >> 2;
    assign write_tag_32 = (w_addr_i & mask) >> (index_width + 2);
    assign write_idx = write_idx_32[index_width-1:0];
    assign write_tag = write_tag_32[tag_width-1:0];


    reg [tag_width-1:0] tag;
    
    /* read */
    always @(*) begin
        if (re_i == `Off) begin
            data_o = 32'h0;
        end else begin
            case (r_addr_i[1:0])
                2'b00: begin
                    if (cache[read_idx][0] == `On & 
                        (cache[read_idx][2+tag_width-1:2] === read_tag))begin

                        data_o = cache[read_idx][cache_width-1:2+tag_width];
                    end else begin
                        data_o = 32'h0;
                    end
                end
                2'b01: begin
                    if (cache[read_idx][0] == `On & cache[read_idx+1][0] == `On & 
                        (cache[read_idx][2+tag_width-1:2] === read_tag) & (cache[read_idx+1][2+tag_width-1:2] === read_tag))begin

                        data_o = {cache[read_idx+1][2+tag_width+7:2+tag_width],cache[read_idx][cache_width-1 : 2+tag_width+8]};
                    end else begin
                        data_o = 32'h0;
                    end
                end
                2'b10: begin
                    if (cache[read_idx][0] == `On & cache[read_idx+1][0] == `On & 
                        (cache[read_idx][2+tag_width-1:2] === read_tag) & (cache[read_idx+1][2+tag_width-1:2] === read_tag))begin

                        data_o = {cache[read_idx+1][2+tag_width+15:2+tag_width],cache[read_idx][cache_width-1 : 2+tag_width+16]};
                    end else begin
                        data_o = 32'h0;
                    end
                end
                2'b11: begin
                    if (cache[read_idx][0] == `On & cache[read_idx+1][0] == `On & 
                        (cache[read_idx][2+tag_width-1:2] === read_tag) & (cache[read_idx+1][2+tag_width-1:2] === read_tag))begin

                        data_o = {cache[read_idx+1][2+tag_width+23:2+tag_width],cache[read_idx][cache_width-1 : 2+tag_width+24]};
                    end else begin
                        data_o = 32'h0;
                    end
                end 
                default: begin
                    data_o = 32'h0;
                end
            endcase
        end
    end

    /* write */
    /* 先不管 dirty 問題和需要先 read 在 write 的問題(忘記專有名詞) */
    always @(*) begin
        if (we_i == `On) begin
            case (w_addr_i[1:0])
                2'b00: begin
                    case (mem_mode_i)
                        `SB_FUN3: begin
                            cache[write_idx][7+tag_width+2:0] = {write_data[7:0], write_tag, 1'b1, 1'b1};
                        end
                        `SH_FUN3: begin
                            cache[write_idx][15+tag_width+2:0] = {write_data[15:0], write_tag, 1'b1, 1'b1};
                        end
                        `SW_FUN3: begin
                            cache[write_idx] = {write_data, write_tag, 1'b1, 1'b1};
                        end
                        default: begin
                            err_siganl = `On;
                        end
                    endcase
                end
                2'b01: begin
                    case (mem_mode_i)
                        `SB_FUN3: begin
                            cache[write_idx][15+tag_width+2:8+tag_width+2] = write_data[7:0];
                            cache[write_idx][tag_width+1:0] = {write_tag, 1'b1, 1'b1};
                        end
                        `SH_FUN3: begin
                            cache[write_idx][23+tag_width+2:8+tag_width+2] = write_data[15:0];
                            cache[write_idx][tag_width+1:0] = {write_tag, 1'b1, 1'b1};
                        end
                        `SW_FUN3: begin
                            cache[write_idx][cache_width-1:8+tag_width+2] = write_data[23:0];
                            cache[write_idx+1][7+tag_width+2:tag_width+2] = write_data[31:24];
                            cache[write_idx][tag_width+1:0] = {write_tag, 1'b1, 1'b1};
                            cache[write_idx+1][tag_width+1:0] = {write_tag, 1'b1, 1'b1};
                        end
                        default: begin
                            err_siganl = `On;
                        end
                    endcase
                    
                end
                2'b10: begin
                    case (mem_mode_i)
                        `SB_FUN3: begin
                            cache[write_idx][23+tag_width+2:16+tag_width+2] = write_data[7:0];
                            cache[write_idx][tag_width+1:0] = {write_tag, 1'b1, 1'b1};
                        end
                        `SH_FUN3: begin
                            cache[write_idx][31+tag_width+2:16+tag_width+2] = write_data[15:0];
                            cache[write_idx][tag_width+1:0] = {write_tag, 1'b1, 1'b1};
                        end
                        `SW_FUN3: begin
                            cache[write_idx][cache_width-1 : 16+tag_width+2] = write_data[15:0];
                            cache[write_idx+1][15+tag_width+2:tag_width+2] = write_data[31:16];
                            cache[write_idx][tag_width+1:0] = {write_tag, 1'b1, 1'b1};
                            cache[write_idx+1][tag_width+1:0] = {write_tag, 1'b1, 1'b1};
                        end
                        default: begin
                            err_siganl = `On;
                        end
                    endcase
                end
                2'b11: begin
                    case (mem_mode_i)
                        `SB_FUN3: begin
                            cache[write_idx][31+tag_width+2:24+tag_width+2] = write_data[7:0];
                            cache[write_idx][tag_width+1:0] = {write_tag, 1'b1, 1'b1};
                        end
                        `SH_FUN3: begin
                            cache[write_idx][31+tag_width+2:24+tag_width+2] = write_data[7:0];
                            cache[write_idx+1][7+tag_width+2:tag_width+2] = write_data[15:8];
                            cache[write_idx][tag_width+1:0] = {write_tag, 1'b1, 1'b1};
                            cache[write_idx][tag_width+1:0] = {write_tag, 1'b1, 1'b1};
                        end
                        `SW_FUN3: begin
                            cache[write_idx][cache_width-1:24+tag_width+2] = write_data[7:0];
                            cache[write_idx+1][23+tag_width+2:tag_width+2] = write_data[31:8];
                            cache[write_idx][tag_width+1:0] = {write_tag, 1'b1, 1'b1};
                            cache[write_idx+1][tag_width+1:0] = {write_tag, 1'b1, 1'b1};
                        end
                        default: begin
                            err_siganl = `On;
                        end
                    endcase
                end 
                default: begin
                    err_siganl = `On;
                end
            endcase
        end
    end
    task writeByte;
        /* verilator public */
        input reg unsigned [`SYS_ADDR_SPACE-1:0] byte_addr;
        input reg unsigned [7:0] val;
        begin
            reg [`SYS_ADDR_SPACE-1:0] t_idx;
            reg [`SYS_ADDR_SPACE-1:0] t_tag;
            assign t_idx = (byte_addr & ~mask) >> 2;
            assign t_tag = (byte_addr & mask) >> (index_width + 2);
            case (byte_addr[1:0])
                2'b00: begin
                    cache[t_idx][7+tag_width+2:0] = {val, t_tag[tag_width-1:0], 1'b1, 1'b1};
                end
                2'b01: begin
                    cache[t_idx][15+tag_width+2:8+tag_width+2] = val;
                    cache[t_idx][tag_width+2-1:0] = {t_tag[tag_width-1:0], 1'b1, 1'b1};
                end
                2'b10: begin
                    cache[t_idx][23+tag_width+2:16+tag_width+2] = val;
                    cache[t_idx][tag_width+2-1:0] = {t_tag[tag_width-1:0], 1'b1, 1'b1};
                end
                2'b11: begin
                    cache[t_idx][31+tag_width+2:24+tag_width+2] = val;
                    cache[t_idx][tag_width+2-1:0] = {t_tag[tag_width-1:0], 1'b1, 1'b1};
                end 
                default: begin
                    val = 0;
                end
            endcase
        end
    endtask

    task readByte;
        /* verilator public */
        input reg unsigned [`SYS_ADDR_SPACE-1:0] byte_addr;
        output reg unsigned [7:0] val;
        begin
            reg [`SYS_ADDR_SPACE-1:0] t_idx;
            assign t_idx = (byte_addr & ~mask) >> 2;
            case (byte_addr[1:0])
                2'b00: begin
                    val = cache[t_idx][7:0];
                end
                2'b01: begin
                    val = cache[t_idx][15:8];
                end
                2'b10: begin
                    val = cache[t_idx][23:16];
                end
                2'b11: begin
                    val = cache[t_idx][31:24];
                end 
                default: begin
                    val = 0;
                end
            endcase
        end
    endtask
    
    // ******************************* //
    // reg [7:0] mem [`MEM_SIZE-1:0];
    // reg err_siganl;
    // wire[`SYS_ADDR_SPACE-1:0] r_addr;
    // wire[`SYS_ADDR_SPACE-1:0] w_addr;

    // assign r_addr = r_addr_i;
    // assign w_addr = w_addr_i;

    // always @(*)begin // read
    //     if (re_i == `Off) begin
    //         data_o = 32'h0;
    //     end else begin
    //         data_o = {mem[r_addr+3], mem[r_addr+2], mem[r_addr+1], mem[r_addr]};
    //     end
    // end

    // always @(*)begin // write
    //     if (we_i == `On) begin
    //         case (mem_mode_i)
    //             `SB_FUN3: begin
    //                 mem[w_addr] = w_data_i[7:0];
    //             end
    //             `SH_FUN3: begin
    //                 mem[w_addr] = w_data_i[7:0];
    //                 mem[w_addr+1] = w_data_i[15:8];
    //             end
    //             `SW_FUN3: begin
    //                 mem[w_addr] = w_data_i[7:0];
    //                 mem[w_addr+1] = w_data_i[15:8];
    //                 mem[w_addr+2] = w_data_i[23:16];
    //                 mem[w_addr+3] = w_data_i[31:24];
    //             end
    //             default: begin
    //                 err_siganl = `On;
    //             end
    //         endcase
    //     end
    // end

    // task writeByte;
    //     /* verilator public */
    //     input reg unsigned [`SYS_ADDR_SPACE-1:0] byte_addr;
    //     input reg unsigned [7:0] val;
    //     begin
    //         reg [`SYS_ADDR_SPACE-1:0] t_addr;
    //         if (byte_addr >= `MEM_BASE && byte_addr <= `MEM_BASE + `MEM_SIZE) begin
    //             t_addr = byte_addr - `MEM_BASE;
    //             mem[t_addr[`SYS_ADDR_SPACE-1:0]] = val;
    //         end else begin
    //             $display("Write disable");
    //         end
    //     end
    // endtask

    // task readByte;
    //     /* verilator public */
    //     input reg unsigned [`SYS_ADDR_SPACE-1:0] byte_addr;
    //     output reg unsigned [7:0] val;
    //     begin
    //         val = mem[byte_addr];
    //     end
    // endtask

endmodule