module rom (
    input wire ce_i,
    input wire [`InstAddrBus] addr_i,
    output reg[`InstBus] inst_o
);
    reg[`InstBus] inst_mem[0:`InstMemNum-1];   // 不懂老師為什麼這邊要將 0 設為 MSB // 懂了

    always @(*) begin
        if (ce_i == 1'b0) begin
            inst_o <= `ZeroWord;
        end else begin
            inst_o <= inst_mem[addr_i];
        end
    end
endmodule