//`include "inst_fetch.v"

module inst_fetch_tb;
    reg CLOCK;
    reg rst;
    wire[31:0] inst;

    initial begin
        CLOCK = 1'b0;
        forever #10 CLOCK = ~CLOCK;
    end

    initial begin
        $dumpfile("debug.vcd");
        $dumpvars(1);
        rst = 1'b1;

        #195 rst = 1'b0;
        #1000 $stop;
    end

    inst_fetch inst_fetch_tb(
        .clk_i(CLOCK),
        .rst_i(rst),
        .inst_o(inst)
    );
endmodule