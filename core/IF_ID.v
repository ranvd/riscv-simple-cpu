module IF_ID (
    input wire clk_i,
    
    // from hazard detection unit
    input wire [1:0] mode_i,
    
    // from IF
    input wire [`INST_WIDTH-1:0] instr_i,

    input wire [`SYS_ADDR_SPACE-1:0] pc_i,
    
    // to ID
    output reg [`INST_WIDTH-1:0] instr_o,
    output reg [`SYS_ADDR_SPACE-1:0] pc_o
);
    wire flush_e;
    wire stall_e;

    assign flush_e = mode_i[0];
    assign stall_e = mode_i[1];

    always @(posedge clk_i) begin
        if (stall_e) begin
            pc_o <= pc_o;
            instr_o <= instr_o;
        end else if (flush_e) begin
            pc_o <= `SYS_ADDR_SPACE'b0;
            instr_o <= `INST_WIDTH'b0;
        end else begin
            pc_o <= pc_i;
            instr_o <= instr_i;
        end
        // case (mode_i)
        //     `Flush : begin
        //         pc_o <= `SYS_ADDR_SPACE'b0;
        //         instr_o <= `INST_WIDTH;
        //     end
        //     `Stall : begin
        //         pc_o <= pc_o;
        //         instr_o <= instr_o;
        //     end 
        //     default: begin
        //         pc_o <= pc_i;
        //         instr_o <= instr_i;
        //     end
        // endcase
    end
    
endmodule