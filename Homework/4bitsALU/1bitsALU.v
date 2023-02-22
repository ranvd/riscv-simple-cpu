`include "mux.v"

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

module ALU_1bits (
    input wire a_i,
    input wire b_i,
    input wire c_i,
    input wire [1:0] op,

    output wire r_o,
    output wire c_o
);
    wire and_o, or_o, add_o, zero;
    assign and_o = a_i & b_i;
    assign or_o = a_i | b_i;
    assign zero = 1'b0;
    fulladder adder(a_i, b_i, c_i, add_o, c_o);
    mux_4x1 mux(and_o, or_o, add_o, zero, op, r_o);

endmodule