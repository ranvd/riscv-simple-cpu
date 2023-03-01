module fulladder (
    input wire a, b, c,
    output wire sum, c_out
);
    wire x1, a1, a2;
    xor xor1(x1, a, b); // xor(out, in, in);
    xor xor2(sum, x1, c);

    and and1(a1, a, b); // and(out, in, in);
    and and2(a2, x1, c);
    
    or or1(c_out, a1, a2); // or(out, in, in);

endmodule

// This is a ripple adder, which will cause numerous gate delays as the number of bits increases
module adder4 (
    input wire signed [3:0] a, // MSB:LSB, which mean this is in little endian form.
    input wire signed [3:0] b,
    input wire c_in,
    output wire signed [3:0] sum,
    output wire c_out
);
    wire c1, c2, c3;

    fulladder fa1(a[0], b[0], c_in, sum[0], c1); 
    fulladder fa2(a[1], b[1], c1, sum[1], c2);
    fulladder fa3(a[2], b[2], c2, sum[2], c3);
    fulladder fa4(a[3], b[3], c3, sum[3], c_out);
    
endmodule