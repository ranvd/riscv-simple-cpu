module exe (
    input wire rst_i,

    //from id_exe
    input wire[`InstAddrBus] inst_addr_i,
    input wire[`RegBus] op1_i,
    input wire[`RegBus] op2_i,
    input wire reg_we_i,
    input wire[`RegAddrBus] reg_waddr_i,
    input wire[`AluOpBus] aluOp_i,
    input wire[`RegBus] imm_i,
    input wire mem_we_i,
    input wire mem_re_i,
    
    //to exe_mem
    output wire[`InstAddrBus] jump_addr_o,
    output wire[`RegAddrBus] reg_waddr_o,
    output reg reg_we_o,
    output wire[`RegBus] reg_wdata_o,
    output wire[`StoreAddrBus] mem_addr_o,

    //to ctrl unit
    output wire jumpe_o,  // jump enable 放到這到 alu 裡面是因為有些 Jump 要經過運算
    output reg[`AluOpBus] aluOp_o
);  
    always @(*) begin
        if(rst_i == `RstEnable) begin
            reg_we_o <= `WriteDisable;
        end else begin
            reg_we_o <= reg_we_i;
            aluOp_o <= aluOp_i;
        end

    end

    alu alu0(
        .inst_addr_i(inst_addr_i),
        .op1_i(op1_i),
        .op2_i(op2_i),
        .reg_waddr_i(reg_waddr_i),
        .aluOp_i(aluOp_i),
        .imm_i(imm_i),
        .jump_addr_o(jump_addr_o),
        .reg_waddr_o(reg_waddr_o),
        .reg_wdata_o(reg_wdata_o),
        .jumpe_o(jumpe_o),
        .mem_addr_o(mem_addr_o)
    );
    
endmodule