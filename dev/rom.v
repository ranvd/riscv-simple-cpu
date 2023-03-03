`include "define.v"

module rom (
    input wire clk_i,
    input wire re_i, //read enable
    input wire [`SYS_ADDR_SPACE-1:0] addr_i,

    output reg[`INST_WIDTH-1:0] inst_o
);
    reg [7:0] mem[`MEM_SIZE-1:0];
    wire[`MEM_ADDR_SPACE-1:0] addr;
    assign addr = {addr_i[`MEM_ADDR_SPACE-1:2], 2'b0};

    always @(posedge clk_i)begin
        if (re_i == 1'b0) begin
            inst_o <= 32'h0;
        end else begin
            inst_o <= {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]};
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