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
        /**/
        $monitor("time#%d\n", $time,
                  "x0     %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[0],
                  "x1     %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[1],
                  "x2     %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[2],
                  "x3     %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[3],
                  "x4     %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[4],
                  "x5     %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[5],
                  "x6     %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[6],
                  "x7     %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[7],
                  "x8     %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[8],
                  "x9     %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[9],
                  "x10    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[10],
                  "x11    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[11],
                  "x12    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[12],
                  "x13    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[13],
                  "x14    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[14],
                  "x15    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[15],
                  "x16    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[16],
                  "x17    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[17],
                  "x18    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[18],
                  "x19    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[19],
                  "x20    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[20],
                  "x21    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[21],
                  "x22    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[22],
                  "x23    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[23],
                  "x24    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[24],
                  "x25    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[25],
                  "x26    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[26],
                  "x27    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[27],
                  "x28    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[28],
                  "x29    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[29],
                  "x30    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[30],
                  "x31    %h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[31],
                  "-------------------------\n");
        /**/
        rst = `RstEnable;
        #15 rst = `RstDisable;
        #1000 $finish;
    end

    rv32ima_soc_top rv32ima_top0(
        .clk(CLOCK_50),
        .rst(rst)
    );

endmodule