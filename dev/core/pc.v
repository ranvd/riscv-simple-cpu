module pc (
    input wire clk_i,
    input wire rst_i,
    input wire stall_i,

    output reg[`SYS_ADDR_SPACE-1:0] pc_o
    // output reg ce_o
);
    always @(posedge clk_i) begin
        if (rst_i == 1'b1) begin
            pc_o <= `START_ADDR;
        end else if(stall_i) begin
            pc_o <= pc_o;
        end else begin
            pc_o <= pc_o + 4;
        end
    end
    
endmodule