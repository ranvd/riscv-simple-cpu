`include "defines.v"

module rv32ima_soc_top(
    input wire clk,
    input wire rst
);
    //連機 ROM的線
    wire[`InstAddrBus] inst_addr;
    wire[`InstBus] inst;
    wire rom_ce;

    rv32IMACore rv32IMACore0(
        .rst_i(rst), .clk_i(clk),
        .rom_addr_o(inst_addr), 
        .rom_data_i(inst), 
        .rom_ce_o(rom_ce)
    );

    rom rom0(
        .ce(rom_ce), 
        .addr(inst_addr), 
        .inst(inst)
    );

endmodule