module IF_ID (
    input wire clk_i,
    
    // from IF
    input wire [`INST_WIDTH-1:0] stall_i,
    input wire [`INST_WIDTH-1:0] flush_i,
    input wire [`INST_WIDTH-1:0] instr_i,
    input wire [1:0] sel_i,

    input wire [`SYS_ADDR_SPACE-1:0] pc_i,
    
    // to ID
    output reg [`INST_WIDTH-1:0] instr_o,
    output reg [`SYS_ADDR_SPACE-1:0] pc_o
);
    wire [`INST_WIDTH-1:0] instr;
    
    mux3 mux(
        .a_i(stall_i),
        .b_i(flush_i),
        .c_i(instr_i),
        .sel_i(sel_i),
        .out(instr)
    );

    always @(posedge clk_i) begin
        instr_o <= instr;
        pc_o <= pc_i;
    end
    
endmodule