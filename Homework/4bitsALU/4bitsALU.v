/* verilator lint_off UNOPTFLAT */
`include "1bitsALU.v"

module ALU_4bits (
    input wire [3:0] a_i,
    input wire [3:0] b_i,
    input wire c_i,
    input wire [1:0] op,

    output wire [3:0] r_o,
    output wire c_o
);
    wire ALU_c [3:0];
    wire ALU_r [3:0];

    ALU_1bits ALU1(a_i[0], b_i[0], c_i, op, ALU_r[0], ALU_c[0]);
    ALU_1bits ALU2(a_i[1], b_i[1], ALU_c[0], op, ALU_r[1], ALU_c[1]);
    ALU_1bits ALU3(a_i[2], b_i[2], ALU_c[1], op, ALU_r[2], ALU_c[2]);
    ALU_1bits ALU4(a_i[3], b_i[3], ALU_c[2], op, ALU_r[3], ALU_c[3]);

    assign r_o = {ALU_r[3], ALU_r[2], ALU_r[1], ALU_r[0]};
    assign c_o = ALU_c[3];
    

endmodule 