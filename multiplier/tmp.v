module test();
    reg[3:0] value = 4'b0001;
    reg[3:0] out;
    initial begin
        out = value - 4'b1111;
        $display("out: %b", out);
    end
endmodule