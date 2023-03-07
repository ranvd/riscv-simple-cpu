
module regfile(
    
    // from ID
    input wire [`GPR_ADDR_SPACE-1:0] rs1_addr_i,
    input wire [`GPR_ADDR_SPACE-1:0] rs2_addr_i,

    // from WB
    // input wire [`GPR_ADDR_SPACE-1:0] rd_addr_i,
    // input wire [`GPR_ADDR_SPACE-1:0] rd_val_i,

    // Control signal from pipe line register
    // input wire rd_we_i, // rd write enable

    // to ID
    output reg [`GPR_WIDTH-1:0] rs1_val_o,
    output reg [`GPR_WIDTH-1:0] rs2_val_o
    
);
    reg [`GPR_WIDTH-1:0] GPR [`GPR_NUM-1:0];
    
    always @(*) begin
        rs1_val_o = GPR[rs1_addr_i];
        rs2_val_o = GPR[rs2_addr_i];
    end

    // always @(*) begin
        
    // end

    initial begin
        integer i = 0;
        for (i = 0; i < `GPR_NUM; i=i+1) begin
            GPR[i] = i;
        end
    end


endmodule