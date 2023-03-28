/* verilator lint_off LATCH */
`include "conf_general_define.v"

module cache #(
    parameter word_offset = `CACHE_WORD_OFFSET,
    parameter block_offset = `CACHE_BLOCK_OFFSET,
    parameter index = `CACHE_INDEX,
    parameter tag = `CACHE_TAG
)
(
    input wire re_i, // read enable
    input wire we_i, // write enable
    input wire [`SYS_ADDR_SPACE-1:0] r_addr_i,
    input wire [`SYS_ADDR_SPACE-1:0] w_addr_i,
    input wire[`CACHE_DATA_WIDTH-1:0] w_data_i,
    input wire [`funct3_width-1:0] mem_mode_i,

    output reg[`CACHE_DATA_WIDTH-1:0] data_o
);
    // parameter integer cache_width = tag+(2**word_offset)*8*(2**block_offset);
    // parameter integer cache_number = 2**index;
    // reg [cache_width:0] cache[cache_number:0];

    
    reg [7:0] mem [`MEM_SIZE-1:0];
    reg err_siganl;
    wire[`MEM_ADDR_SPACE-1:0] r_addr;
    wire[`MEM_ADDR_SPACE-1:0] w_addr;

    assign r_addr = r_addr_i;
    assign w_addr = w_addr_i;

    always @(*)begin // read
        if (re_i == 1'b0) begin
            data_o = 32'h0;
        end else begin
            data_o = {mem[r_addr+3], mem[r_addr+2], mem[r_addr+1], mem[r_addr]};
        end
    end

    always @(*)begin // write
        if (we_i == `On) begin
            case (mem_mode_i)
                `SB_FUN3: begin
                    mem[w_addr] = w_data_i[7:0];
                end
                `SH_FUN3: begin
                    mem[w_addr] = w_data_i[7:0];
                    mem[w_addr+1] = w_data_i[15:8];
                end
                `SW_FUN3: begin
                    mem[w_addr] = w_data_i[7:0];
                    mem[w_addr+1] = w_data_i[15:8];
                    mem[w_addr+2] = w_data_i[23:16];
                    mem[w_addr+3] = w_data_i[31:24];
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
            reg [`SYS_ADDR_SPACE-1:0] t_addr;
            if (byte_addr >= `MEM_BASE && byte_addr <= `MEM_BASE + `MEM_SIZE) begin
                t_addr = byte_addr - `MEM_BASE;
                mem[t_addr[`MEM_ADDR_SPACE-1:0]] = val;
            end else begin
                $display("Write disable");
            end
        end
    endtask

    task readByte;
        /* verilator public */
        input reg unsigned [`SYS_ADDR_SPACE-1:0] byte_addr;
        output reg unsigned [7:0] val;
        begin
            val = mem[byte_addr];
        end
    endtask

endmodule