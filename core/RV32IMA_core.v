`include "defines.v"

module rv32IMACore(
    input wire rst_i,
    input wire clk_i,
    
    //from instruction ROM
    input wire[`RegBus] rom_data_i,
    
    //to instruction ROM
    output wire[`RegBus] rom_addr_o,
    output wire  rom_ce_o
);

    // 連接 if_id 與 id 的線
    wire[`InstAddrBus] pc;
    wire[`InstAddrBus] id_inst_addr_i;
    wire[`InstBus] id_inst_i;

    // 連接 id 與 id_exe線
    wire[`AluOpBus] id_aluOp_o;
    wire[`RegBus] id_op1_o;
    wire[`RegBus] id_op2_o;
    wire id_reg_we_o;
    wire[`RegAddrBus] id_reg_waddr_o;

    //regfile 對外接線
    wire reg1_re;
    wire reg2_re;
    wire[`RegBus] reg1_data;
    wire[`RegBus] reg2_data;
    wire[`RegAddrBus] reg1_addr;
    wire[`RegAddrBus] reg2_addr;

    //mem_wb 到 regfile 的連線
    wire wb_reg_we;
    wire[`RegAddrBus] wb_reg_waddr;
    wire[`RegBus] wb_reg_wdata;

    //id_exe 與 exe 連線
    wire[`RegBus] exe_op1_i;
    wire[`RegBus] exe_op2_i;
    wire exe_reg_we_i;
    wire[`RegAddrBus] exe_reg_waddr_i;
    wire[`AluOpBus] exe_aluOp_i;

    //exe to exe_mem wire
    wire exe_reg_we_o;
    wire[`RegAddrBus] exe_reg_waddr_o;
    wire[`RegBus] exe_reg_wdata_o;

    //exe_mem to mem wire
    wire mem_reg_we_i;
    wire[`RegAddrBus] mem_reg_waddr_i;
    wire[`RegBus] mem_reg_wdata_i;

    //mem to mem_wb wire
    wire mem_reg_we_o;
    wire[`RegAddrBus] mem_reg_waddr_o;
    wire[`RegBus] mem_reg_wdata_o;

    //pc
    pc_reg pc_reg0(
        .clk_i(clk_i), .rst_i(rst_i),
        //to if_id
        .pc_o(pc), .ce_o(rom_ce_o)
    );
    assign rom_addr_o = pc;

    //IF/ID
    if_id if_id0(
        .clk_i(clk_i), .rst_i(rst_i),
        //from pc_reg
        .inst_addr_i(rom_addr_o), .inst_i(rom_data_i),
        //to id
        .inst_addr_o(id_inst_addr_i), .inst_o(id_inst_i)
    );

    //ID
    id id0(
        .rst_i(rst_i),

        //from exe 解決 data hazard 用
        .exe_reg_waddr_i(exe_reg_waddr_o), .exe_reg_wdata_i(exe_reg_wdata_o), .exe_reg_we_i(exe_reg_we_o),

        //from mem 解決 data hazard 用
        .mem_reg_waddr_i(mem_reg_waddr_o), .mem_reg_wdata_i(mem_reg_wdata_o), .mem_reg_we_i(mem_reg_we_o),

        //from if_id
        .inst_addr_i(id_inst_addr_i), .inst_i(id_inst_i),
        
        //from regfile
        .reg1_rdata_i(reg1_data), .reg2_rdata_i(reg2_data),

        //to regfile
        .reg1_raddr_o(reg1_addr), .reg2_raddr_o(reg2_addr),
        .reg1_re_o(reg1_re), .reg2_re_o(reg2_re),
        
        //to id_exe
        .aluOp_o(id_aluOp_o), .op1_o(id_op1_o),
        .op2_o(id_op2_o), .reg_we_o(id_reg_we_o),
        .reg_waddr_o(id_reg_waddr_o)
    );

    //regfile
    regfile regfile0(
        .rst_i(rst_i), .clk_i(clk_i),
        
        //from MEM_WB
        .we_i(wb_reg_we), .waddr_i(wb_reg_waddr), .wdata_i(wb_reg_wdata),
        
        //from id 
        .re1_i(reg1_re), .raddr1_i(reg1_addr), .re2_i(reg2_re), .raddr2_i(reg2_addr),
        
        //to id
        .rdata1_o(reg1_data), .rdata2_o(reg2_data)
    );


    //ID_EXE
    id_exe id_exe0(
        .rst_i(rst_i), .clk_i(clk_i),
        
        //from id
        .aluOp_i(id_aluOp_o), .op1_i(id_op1_o),
        .op2_i(id_op2_o), .reg_we_i(id_reg_we_o),
        .reg_waddr_i(id_reg_waddr_o),
        
        //to exe
        .op1_o(exe_op1_i), .op2_o(exe_op2_i),
        .reg_we_o(exe_reg_we_i), .reg_waddr_o(exe_reg_waddr_i),
        .aluOp_o(exe_aluOp_i)
    );

    //EXE
    exe exe0(
        .rst_i(rst_i),
        
        //from id_exe
        .op1_i(exe_op1_i), .op2_i(exe_op2_i),
        .reg_we_i(exe_reg_we_i), .reg_waddr_i(exe_reg_waddr_i),
        .aluOp_i(exe_aluOp_i),
        //to exe_mem
        .reg_waddr_o(exe_reg_waddr_o), .reg_we_o(exe_reg_we_o), 
        .reg_wdata_o(exe_reg_wdata_o)    
    );

    //exe_mem
    exe_mem exe_mem0(
        .rst_i(rst_i), .clk_i(clk_i),
        
        //from exe
        .reg_waddr_i(exe_reg_waddr_o), .reg_we_i(exe_reg_we_o), 
        .reg_wdata_i(exe_reg_wdata_o),
        
        //to mem
        .reg_waddr_o(mem_reg_waddr_i), .reg_we_o(mem_reg_we_i), 
        .reg_wdata_o(mem_reg_wdata_i)
        
        
    );

    //mem
    mem mem0(
        .rst_i(rst_i),
        
        //from exe_mem
        .reg_waddr_i(mem_reg_waddr_i), .reg_we_i(mem_reg_we_i), 
        .reg_wdata_i(mem_reg_wdata_i),
        
        //to mem_wb
        .reg_waddr_o(mem_reg_waddr_o), .reg_we_o(mem_reg_we_o), .reg_wdata_o(mem_reg_wdata_o)    
    );

    //mem_wb
    mem_wb mem_wb0(
        .rst_i(rst_i), .clk_i(clk_i),
        // from mem
        .reg_waddr_i(mem_reg_waddr_o), .reg_we_i(mem_reg_we_o), .reg_wdata_i(mem_reg_wdata_o),    
        
        //to regfile
        .reg_waddr_o(wb_reg_waddr), .reg_we_o(wb_reg_we), .reg_wdata_o(wb_reg_wdata)
    );
endmodule