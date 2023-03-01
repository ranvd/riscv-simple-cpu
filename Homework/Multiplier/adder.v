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


//Carry save adder

module CSR #(
    parameter LEN = 6
) (
    input wire [LEN-1:0] a_i,
    input wire [LEN-1:0] b_i,
    input wire [LEN-1:0] c_i,

    output wire [LEN-1:0] r_o,
    output wire [LEN-1:0] c_o
);
    // wire [LEN-1:0] a, b, c;
    // wire [LEN-1:0] r, c;
    // assign a = a_i;
    // assign b = b_i;
    // assign c = c_i

    genvar i;
    generate
        for (i=0; i<LEN; i=i+1)begin
            fulladder fa(a_i[i], b_i[i], c_i[i], r_o[i], c_o[i]);
        end
    endgenerate
    
endmodule