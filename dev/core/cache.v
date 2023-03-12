/* verilator lint_off LATCH */
`include "conf_general_define.v"

module cache (
    input wire re_i, // read enable
    input wire we_i, // write enable
    input wire [`SYS_ADDR_SPACE-1:0] r_addr_i,
    input wire [`SYS_ADDR_SPACE-1:0] w_addr_i,
    input wire[`CACHE_DATA_WIDTH-1:0] w_data_i,

    output reg[`CACHE_DATA_WIDTH-1:0] data_o
);
    reg [7:0] mem [`MEM_SIZE-1:0];
    reg empty_siganl;
    wire[`MEM_ADDR_SPACE-1:0] r_addr;
    wire[`MEM_ADDR_SPACE-1:0] w_addr;

    assign r_addr = {r_addr_i[`MEM_ADDR_SPACE-1:2], 2'b0};
    assign w_addr = {w_addr_i[`MEM_ADDR_SPACE-1:2], 2'b0};

    always @(*)begin
        if (re_i == 1'b0) begin
            data_o = 32'h0;
        end else begin
            data_o = {mem[r_addr], mem[r_addr+1], mem[r_addr+2], mem[r_addr+3]};
        end
    end

    always @(*)begin
        if (we_i == 1'b0) begin
            empty_siganl = 1'b0;
        end else begin
            mem[w_addr] = w_data_i[7:0];
            mem[w_addr+1] = w_data_i[15:8];
            mem[w_addr+2] = w_data_i[23:16];
            mem[w_addr+3] = w_data_i[31:24];
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
            end
        end
    endtask


    
endmodule