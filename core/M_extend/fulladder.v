module fulladder (
    input wire a0,
    input wire a1,
    input wire cin,
    output wire s,
    output wire cout
);
    wire h0_s, h0_c;
    assign h0_s = a0 ^ a1;
    assign h0_c = a0 & a1;

    assign s = cin ^ h0_s;
    assign cout = (h0_s & cin) | h0_c;

endmodule