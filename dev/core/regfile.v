/* verilator lint_off WIDTHEXPAND */
module regfile(
    
    // from ID
    input wire [`GPR_ADDR_SPACE-1:0] rs1_addr_i,
    input wire [`GPR_ADDR_SPACE-1:0] rs2_addr_i,

    // from WB
    input wire [`GPR_ADDR_SPACE-1:0] rd_addr_i,
    input wire [`GPR_WIDTH-1:0] rd_val_i,
    input wire rd_we_i,

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

    always @(*) begin
        if(rd_we_i) begin
            GPR[rd_addr_i] = rd_val_i;
        end else begin
            GPR[0] = `GPR_WIDTH'h0;
        end
    end

    task writeReg;
        input reg unsigned [`GPR_ADDR_SPACE-1:0] reg_addr;
        input reg unsigned [`GPR_WIDTH-1:0] val;

        begin
            if (reg_addr < `GPR_NUM) begin
                GPR[reg_addr] = val;
            end
        end
    endtask

    task readReg;
        input reg unsigned [`GPR_ADDR_SPACE-1:0] reg_addr;
        output reg unsigned [`GPR_WIDTH-1:0] val;

        begin
            if (reg_addr < `GPR_NUM) begin
                val = GPR[reg_addr];
            end
        end
    endtask

    task readRegs;
        output reg unsigned [`GPR_WIDTH-1:0] vals [`GPR_NUM];

        begin
            integer i = 0;
            for (i = 0; i < `GPR_NUM; i = i +1) begin
                readReg(i[`GPR_ADDR_SPACE-1:0], vals[i]);
            end
        end
    endtask
endmodule