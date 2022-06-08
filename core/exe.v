module exe (
    input wire rst_i,

    //from id_exe
    input wire[`RegBus] op1_i,
    input wire[`RegBus] op2_i,
    input wire reg_we_i,
    input wire[`RegAddrBus] reg_waddr_i,
    input wire[`AluOpBus] aluOp_i,
    
    //to exe_mem
    output wire[`RegAddrBus] reg_waddr_o,
    output wire reg_we_o,
    output wire[`RegBus] reg_wdata_o
);  
    alu alu0(
        .op1_i(op1_i),
        .op2_i(op2_i),
        .reg_we_i(reg_we_i),
        .reg_waddr_i(reg_waddr_i),
        .aluOp_i(aluOp_i),
        .reg_waddr_o(reg_waddr_o),
        .reg_we_o(reg_we_o),
        .reg_wdata_o(reg_wdata_o)
    );
    
endmodule