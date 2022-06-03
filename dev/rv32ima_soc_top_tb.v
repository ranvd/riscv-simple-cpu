module rv32ima_soc_tb();
    reg CLOCK_50;
    reg rst;

    initial begin
        CLOCK_50 = 1'b0;
        forever #10 CLOCK_50 = ~CLOCK_50;
    end

    initial begin
        $readmemh("rom.data", rv32ima_top0.rom0.inst_mem);
    end

    initial begin
        $dumpfile("rv32ima_soc_tb.vcd");
        $dumpvars(0, rv32ima_soc_tb);

        rst = `RstEnable;
        #195 rst = `RstDisable;
        #1000 $stop;
    end

    rv32ima_soc_top rv32ima_top0(
        .clk(CLOCK_50),
        .rst(rst)
    );

endmodule