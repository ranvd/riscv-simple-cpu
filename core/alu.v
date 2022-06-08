module alu (
    input wire rst_i,

    //from id_exe
    input wire[`RegBus] op1_i,
    input wire[`RegBus] op2_i,
    input wire reg_we_i,
    input wire[`RegAddrBus] reg_waddr_i,
    input wire[`AluOpBus] aluOp_i,
    
    //to exe_mem
    output reg[`RegAddrBus] reg_waddr_o,
    output reg reg_we_o,
    output reg[`RegBus] reg_wdata_o
);
    wire op1_ge_op2_signed, op1_ge_op2_unsigned;
    assign op1_ge_op2_signed = $signed(op1_i) >= $signed(op2_i);
    assign op1_ge_op2_unsigned = op1_i >= op2_i;
    
    always @(*) begin
        if (rst_i == `RstEnable) begin
            reg_waddr_o <= `ZeroReg;
            reg_wdata_o <= `ZeroWord;
            reg_we_o <= `WriteDisable;
        end else begin
            case (aluOp_i)
                `ORI, `OR: begin
                    reg_waddr_o <= reg_waddr_i;
                    reg_wdata_o <= op1_i | op2_i;
                    reg_we_o <= reg_we_i;
                end
                `ADDI, `ADD: begin
                    reg_waddr_o <= reg_waddr_i;
                    reg_wdata_o <= op1_i + op2_i; //TODO: 要檢查 overflow 使用 $signed() 內建函式式沒用的
                    reg_we_o <= reg_we_i;
                end
                `ANDI, `AND: begin
                    reg_waddr_o <= reg_waddr_i;
                    reg_wdata_o <= op1_i & op2_i;
                    reg_we_o <= reg_we_i;
                end
                `XORI, `XOR: begin
                    reg_waddr_o <= reg_waddr_i;
                    reg_wdata_o <= op1_i ^ op2_i;
                    reg_we_o <= reg_we_i;
                end
                `SLTI, `SLT: begin
                    reg_waddr_o <= reg_waddr_i;
                    reg_wdata_o <= {32{~op1_ge_op2_signed}} & 32'h1;
                    reg_we_o <= reg_we_i;
                end
                `SLTIU, `SLTU: begin
                    reg_waddr_o <= reg_waddr_i;
                    reg_wdata_o <= {32{~op1_ge_op2_unsigned}} & 32'h1;
                    reg_we_o <= reg_we_i;
                end
                `SLLI, `SLL: begin
                    reg_waddr_o <= reg_waddr_i;
                    reg_wdata_o <= op1_i << op2_i[4:0];
                    reg_we_o <= reg_we_i;
                end
                `SRLI, `SRL: begin
                    reg_waddr_o <= reg_waddr_i;
                    reg_wdata_o <= op1_i >> op2_i[4:0];
                    reg_we_o <= reg_we_i;
                end
                `SRAI, `SRA: begin
                    reg_waddr_o <= reg_waddr_i;
                    reg_wdata_o <= op1_i >>> op2_i[4:0];
                    reg_we_o <= reg_we_i;
                end
                `SUB: begin
                    reg_waddr_o <= reg_waddr_i;
                    reg_wdata_o <= op1_i - op2_i;
                    reg_we_o <= reg_we_i;
                end
                default: begin
                    reg_waddr_o <= `ZeroReg;
                    reg_wdata_o <= `ZeroWord;
                    reg_we_o <= `WriteDisable;
                end
            endcase
        end
    end
endmodule