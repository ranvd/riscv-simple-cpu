`include "define.v"

module rom (
    input wire clk_i,
    input wire re_i, //read enable
    input wire [`SYS_SPACE-1:0] addr_i,

    output reg[`INST_WIDTH-1:0] inst_o
);
    reg [7:0] mem[`MEM_SIZE-1:0];
    wire[`MEM_SPACE-1:0] addr;
    assign addr = {addr_i[`MEM_SPACE-1:2], 2'b0};

    always @(posedge clk_i)begin
        if (re_i == 1'b0) begin
            inst_o <= 32'h0;
        end else begin
            inst_o <= {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]};
        end
    end
    
    
endmodule