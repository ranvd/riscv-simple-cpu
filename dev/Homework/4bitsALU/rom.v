module rom #(
    parameter XLEN = 32,
    parameter MEM_SIZE = 32
) (
    input wire ce_i, // chip enable
    input wire [XLEN-1:0] addr_i,
    output reg [XLEN-1:0] inst_o
);
    localparam MADDR_WIDTH = MEM_SIZE>1? $clog2(MEM_SIZE):1;
    reg [7:0] mem[MEM_SIZE-1:0]; //total size = MEM_SIZE bytes

    //read memory data
    initial begin
        $readmemh("rom.data", mem);
    end

    wire [MADDR_WIDTH-1:0] addr4;
    assign addr4 = {addr_i[MADDR_WIDTH-1:2], 2'b0};

    always @(*) begin
        if (ce_i == 1'b0) begin
            inst_o = 32'h0;
        end else begin
            inst_o = {mem[addr4], mem[addr4+1], mem[addr4+2], mem[addr4+3]};
        end
    end

endmodule

/*
老師的 code 中有定義一個 clog2 function 如下，但實際上不需要定義，已有內建 math function 可以呼叫
function integer clog2 (input integer n); begin
    n = n - 1;
    for (clog2 = 0; n > 0; clog2 = clog2 + 1)
      n = n >> 1;
    end
endfunction 
*/