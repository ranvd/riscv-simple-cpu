module rv32ima_soc_top (
    input wire clk,
    input wire rst
);
    wire[`InstAddrBus] inst_addr;
    wire[`InstBus] inst;
    wire rom_ce;

    rv32IMACore rv32IMAcore0(
        .rst_i(rst),
        .clk_i(clk),
        .rom_data_i(inst),
        .rom_addr_o(inst_addr),
        .rom_ce_o(rom_ce)
    );

    rom rom0(
        .ce_i(rom_ce),
        .addr_i(inst_addr),
        .inst_o(inst)
    );
endmodule