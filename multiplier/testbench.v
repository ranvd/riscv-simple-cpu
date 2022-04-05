`timescale 1ns/1ps

module testbench();
    
    reg CLOCK;
    reg rst;
    reg[15:0] A = -16'b010;
    reg[15:0] B = 16'b1110;
    wire[31:0] out;
    
    initial begin
        CLOCK = 1'b0;
        forever #10 CLOCK = ~CLOCK;
    end

    initial begin
        $dumpfile("debug.vcd");
        $dumpvars(1);
        #0 rst = 1'b0;
        #200 rst = 1'b1;
        #900 $finish;
        #1000 $stop;
    end
    
    Multiplier M(
        .clk(CLOCK),
        .rst(rst),
        .A_i( A),
        .B_i(B),
        .C_o(out)
    );
    
endmodule