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
                  "x0     %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[0], rv32ima_top0.rv32IMAcore0.mem0.ram[3], rv32ima_top0.rv32IMAcore0.mem0.ram[2], rv32ima_top0.rv32IMAcore0.mem0.ram[1], rv32ima_top0.rv32IMAcore0.mem0.ram[0],
                  "x1     %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[1], rv32ima_top0.rv32IMAcore0.mem0.ram[7], rv32ima_top0.rv32IMAcore0.mem0.ram[6], rv32ima_top0.rv32IMAcore0.mem0.ram[5], rv32ima_top0.rv32IMAcore0.mem0.ram[4],
                  "x2     %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[2], rv32ima_top0.rv32IMAcore0.mem0.ram[11], rv32ima_top0.rv32IMAcore0.mem0.ram[10], rv32ima_top0.rv32IMAcore0.mem0.ram[9], rv32ima_top0.rv32IMAcore0.mem0.ram[8],
                  "x3     %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[3], rv32ima_top0.rv32IMAcore0.mem0.ram[15], rv32ima_top0.rv32IMAcore0.mem0.ram[14], rv32ima_top0.rv32IMAcore0.mem0.ram[13], rv32ima_top0.rv32IMAcore0.mem0.ram[12],
                  "x4     %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[4], rv32ima_top0.rv32IMAcore0.mem0.ram[19], rv32ima_top0.rv32IMAcore0.mem0.ram[18], rv32ima_top0.rv32IMAcore0.mem0.ram[17], rv32ima_top0.rv32IMAcore0.mem0.ram[16],
                  "x5     %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[5], rv32ima_top0.rv32IMAcore0.mem0.ram[23], rv32ima_top0.rv32IMAcore0.mem0.ram[22], rv32ima_top0.rv32IMAcore0.mem0.ram[21], rv32ima_top0.rv32IMAcore0.mem0.ram[20],
                  "x6     %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[6], rv32ima_top0.rv32IMAcore0.mem0.ram[27], rv32ima_top0.rv32IMAcore0.mem0.ram[26], rv32ima_top0.rv32IMAcore0.mem0.ram[25], rv32ima_top0.rv32IMAcore0.mem0.ram[24],
                  "x7     %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[7], rv32ima_top0.rv32IMAcore0.mem0.ram[31], rv32ima_top0.rv32IMAcore0.mem0.ram[30], rv32ima_top0.rv32IMAcore0.mem0.ram[29], rv32ima_top0.rv32IMAcore0.mem0.ram[28],
                  "x8     %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[8], rv32ima_top0.rv32IMAcore0.mem0.ram[35], rv32ima_top0.rv32IMAcore0.mem0.ram[34], rv32ima_top0.rv32IMAcore0.mem0.ram[33], rv32ima_top0.rv32IMAcore0.mem0.ram[32],
                  "x9     %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[9], rv32ima_top0.rv32IMAcore0.mem0.ram[39], rv32ima_top0.rv32IMAcore0.mem0.ram[38], rv32ima_top0.rv32IMAcore0.mem0.ram[37], rv32ima_top0.rv32IMAcore0.mem0.ram[36],
                  "x10    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[10], rv32ima_top0.rv32IMAcore0.mem0.ram[43], rv32ima_top0.rv32IMAcore0.mem0.ram[42], rv32ima_top0.rv32IMAcore0.mem0.ram[41], rv32ima_top0.rv32IMAcore0.mem0.ram[40],
                  "x11    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[11], rv32ima_top0.rv32IMAcore0.mem0.ram[47], rv32ima_top0.rv32IMAcore0.mem0.ram[46], rv32ima_top0.rv32IMAcore0.mem0.ram[45], rv32ima_top0.rv32IMAcore0.mem0.ram[44],
                  "x12    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[12], rv32ima_top0.rv32IMAcore0.mem0.ram[51], rv32ima_top0.rv32IMAcore0.mem0.ram[50], rv32ima_top0.rv32IMAcore0.mem0.ram[49], rv32ima_top0.rv32IMAcore0.mem0.ram[48],
                  "x13    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[13], rv32ima_top0.rv32IMAcore0.mem0.ram[55], rv32ima_top0.rv32IMAcore0.mem0.ram[54], rv32ima_top0.rv32IMAcore0.mem0.ram[53], rv32ima_top0.rv32IMAcore0.mem0.ram[52],
                  "x14    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[14], rv32ima_top0.rv32IMAcore0.mem0.ram[59], rv32ima_top0.rv32IMAcore0.mem0.ram[58], rv32ima_top0.rv32IMAcore0.mem0.ram[57], rv32ima_top0.rv32IMAcore0.mem0.ram[56],
                  "x15    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[15], rv32ima_top0.rv32IMAcore0.mem0.ram[63], rv32ima_top0.rv32IMAcore0.mem0.ram[62], rv32ima_top0.rv32IMAcore0.mem0.ram[61], rv32ima_top0.rv32IMAcore0.mem0.ram[60],
                  "x16    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[16], rv32ima_top0.rv32IMAcore0.mem0.ram[67], rv32ima_top0.rv32IMAcore0.mem0.ram[66], rv32ima_top0.rv32IMAcore0.mem0.ram[65], rv32ima_top0.rv32IMAcore0.mem0.ram[64],
                  "x17    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[17], rv32ima_top0.rv32IMAcore0.mem0.ram[71], rv32ima_top0.rv32IMAcore0.mem0.ram[70], rv32ima_top0.rv32IMAcore0.mem0.ram[69], rv32ima_top0.rv32IMAcore0.mem0.ram[68],
                  "x18    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[18], rv32ima_top0.rv32IMAcore0.mem0.ram[75], rv32ima_top0.rv32IMAcore0.mem0.ram[74], rv32ima_top0.rv32IMAcore0.mem0.ram[73], rv32ima_top0.rv32IMAcore0.mem0.ram[72],
                  "x19    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[19], rv32ima_top0.rv32IMAcore0.mem0.ram[79], rv32ima_top0.rv32IMAcore0.mem0.ram[78], rv32ima_top0.rv32IMAcore0.mem0.ram[77], rv32ima_top0.rv32IMAcore0.mem0.ram[76],
                  "x20    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[20], rv32ima_top0.rv32IMAcore0.mem0.ram[83], rv32ima_top0.rv32IMAcore0.mem0.ram[82], rv32ima_top0.rv32IMAcore0.mem0.ram[81], rv32ima_top0.rv32IMAcore0.mem0.ram[80],
                  "x21    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[21], rv32ima_top0.rv32IMAcore0.mem0.ram[87], rv32ima_top0.rv32IMAcore0.mem0.ram[86], rv32ima_top0.rv32IMAcore0.mem0.ram[85], rv32ima_top0.rv32IMAcore0.mem0.ram[84],
                  "x22    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[22], rv32ima_top0.rv32IMAcore0.mem0.ram[91], rv32ima_top0.rv32IMAcore0.mem0.ram[90], rv32ima_top0.rv32IMAcore0.mem0.ram[89], rv32ima_top0.rv32IMAcore0.mem0.ram[88],
                  "x23    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[23], rv32ima_top0.rv32IMAcore0.mem0.ram[95], rv32ima_top0.rv32IMAcore0.mem0.ram[94], rv32ima_top0.rv32IMAcore0.mem0.ram[93], rv32ima_top0.rv32IMAcore0.mem0.ram[92],
                  "x24    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[24], rv32ima_top0.rv32IMAcore0.mem0.ram[99], rv32ima_top0.rv32IMAcore0.mem0.ram[98], rv32ima_top0.rv32IMAcore0.mem0.ram[97], rv32ima_top0.rv32IMAcore0.mem0.ram[96],
                  "x25    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[25], rv32ima_top0.rv32IMAcore0.mem0.ram[103], rv32ima_top0.rv32IMAcore0.mem0.ram[102], rv32ima_top0.rv32IMAcore0.mem0.ram[101], rv32ima_top0.rv32IMAcore0.mem0.ram[100],
                  "x26    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[26], rv32ima_top0.rv32IMAcore0.mem0.ram[107], rv32ima_top0.rv32IMAcore0.mem0.ram[106], rv32ima_top0.rv32IMAcore0.mem0.ram[105], rv32ima_top0.rv32IMAcore0.mem0.ram[104],
                  "x27    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[27], rv32ima_top0.rv32IMAcore0.mem0.ram[111], rv32ima_top0.rv32IMAcore0.mem0.ram[110], rv32ima_top0.rv32IMAcore0.mem0.ram[109], rv32ima_top0.rv32IMAcore0.mem0.ram[108],
                  "x28    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[28], rv32ima_top0.rv32IMAcore0.mem0.ram[115], rv32ima_top0.rv32IMAcore0.mem0.ram[114], rv32ima_top0.rv32IMAcore0.mem0.ram[113], rv32ima_top0.rv32IMAcore0.mem0.ram[112],
                  "x29    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[29], rv32ima_top0.rv32IMAcore0.mem0.ram[119], rv32ima_top0.rv32IMAcore0.mem0.ram[118], rv32ima_top0.rv32IMAcore0.mem0.ram[117], rv32ima_top0.rv32IMAcore0.mem0.ram[116],
                  "x30    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[30], rv32ima_top0.rv32IMAcore0.mem0.ram[123], rv32ima_top0.rv32IMAcore0.mem0.ram[122], rv32ima_top0.rv32IMAcore0.mem0.ram[121], rv32ima_top0.rv32IMAcore0.mem0.ram[120],
                  "x31    %h         mem       %h%h%h%h\n", rv32ima_top0.rv32IMAcore0.regfile0.regs[31], rv32ima_top0.rv32IMAcore0.mem0.ram[127], rv32ima_top0.rv32IMAcore0.mem0.ram[126], rv32ima_top0.rv32IMAcore0.mem0.ram[125], rv32ima_top0.rv32IMAcore0.mem0.ram[124],
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