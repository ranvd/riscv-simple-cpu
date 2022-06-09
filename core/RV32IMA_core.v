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
    wire[`InstAddrBus] id_inst_addr_o;
    wire[`AluOpBus] id_aluOp_o;
    wire[`RegBus] id_op1_o;
    wire[`RegBus] id_op2_o;
    wire id_reg_we_o;
    wire[`RegAddrBus] id_reg_waddr_o;
    wire[`RegBus] id_imm_o;

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
    wire[`InstAddrBus] exe_inst_addr_i;
    wire[`RegBus] exe_op1_i;
    wire[`RegBus] exe_op2_i;
    wire exe_reg_we_i;
    wire[`RegAddrBus] exe_reg_waddr_i;
    wire[`AluOpBus] exe_aluOp_i;
    wire[`RegBus] exe_imm_i;
    wire exe_mem_we_i;

    //exe to exe_mem wire
    wire[`InstAddrBus] exe_inst_addr_o;
    wire exe_reg_we_o;
    wire[`RegAddrBus] exe_reg_waddr_o;
    wire[`RegBus] exe_reg_wdata_o;
    wire[`StoreAddrBus] exe_mem_waddr_o;
    wire exe_mem_we_o;

    //exe to ctrl
    wire jumpe_i;
    wire[`AluOpBus] aluOp_i;

    //exe_mem to mem wire
    wire mem_reg_we_i;
    wire[`RegAddrBus] mem_reg_waddr_i;
    wire[`RegBus] mem_reg_wdata_i;
    wire[`StoreAddrBus] mem_mem_waddr_i;
    wire mem_mem_we_i;

    //exe_mem to pc wire
    wire[`InstAddrBus] exe_pc_jump_addr_i;

    //mem to mem_wb wire
    wire mem_reg_we_o;
    wire[`RegAddrBus] mem_reg_waddr_o;
    wire[`RegBus] mem_reg_wdata_o;

    //ctrl to pc
    wire jumpe_o;
    //ctrl to if_id
    wire if_id_flush;
    //ctrl to id_exe
    wire id_exe_flush;
    //ctrl to exe_mem
    wire exe_mem_flush;
    // ctrl to mem
    wire[`AluOpBus] mem_ctrl;


    //pc
    pc_reg pc_reg0(
        .clk_i(clk_i), .rst_i(rst_i),
        //from ctrl
        .jumpe_i(jumpe_o),
        //from exe_mem
        .jump_addr_i(exe_pc_jump_addr_i),
        //to if_id
        .pc_o(pc), .ce_o(rom_ce_o)
    );
    assign rom_addr_o = pc;

    //IF/ID
    if_id if_id0(
        .clk_i(clk_i), .rst_i(rst_i),
        //from ctrl unit
        .if_id_flush(if_id_flush),
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
        .inst_addr_o(id_inst_addr_o),
        .aluOp_o(id_aluOp_o), .op1_o(id_op1_o),
        .op2_o(id_op2_o), .reg_we_o(id_reg_we_o),
        .reg_waddr_o(id_reg_waddr_o),
        .imm(id_imm_o)
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
        //from ctrl unit
        .id_exe_flush(id_exe_flush),
        //from id
        .inst_addr_i(id_inst_addr_o),
        .aluOp_i(id_aluOp_o), .op1_i(id_op1_o),
        .op2_i(id_op2_o), .reg_we_i(id_reg_we_o),
        .reg_waddr_i(id_reg_waddr_o),
        .imm_i(id_imm_o),
        
        //to exe
        .inst_addr_o(exe_inst_addr_i),
        .op1_o(exe_op1_i), .op2_o(exe_op2_i),
        .reg_we_o(exe_reg_we_i), .reg_waddr_o(exe_reg_waddr_i),
        .aluOp_o(exe_aluOp_i),
        .imm_o(exe_imm_i)
    );

    //EXE
    exe exe0(
        .rst_i(rst_i),
        
        //from id_exe
        .inst_addr_i(exe_inst_addr_i),
        .op1_i(exe_op1_i), .op2_i(exe_op2_i),
        .reg_we_i(exe_reg_we_i), .reg_waddr_i(exe_reg_waddr_i),
        .aluOp_i(exe_aluOp_i),
        .imm_i(exe_imm_i),
        //to exe_mem
        .jump_addr_o(exe_inst_addr_o),
        .reg_waddr_o(exe_reg_waddr_o), .reg_we_o(exe_reg_we_o), 
        .reg_wdata_o(exe_reg_wdata_o),
        .mem_addr_o(exe_mem_waddr_o),

        //to ctrl unit
        .jumpe_o(jumpe_i),
        .aluOp_o(aluOp_i)
    );

    //exe_mem
    exe_mem exe_mem0(
        .rst_i(rst_i), .clk_i(clk_i),
        //from ctrl unit
        .exe_mem_flush(exe_mem_flush),
        //from exe
        .jump_addr_i(exe_inst_addr_o),
        .reg_waddr_i(exe_reg_waddr_o), .reg_we_i(exe_reg_we_o), 
        .reg_wdata_i(exe_reg_wdata_o),
        .mem_addr_i(exe_mem_waddr_o),
        
        //to mem
        .reg_waddr_o(mem_reg_waddr_i), .reg_we_o(mem_reg_we_i), 
        .reg_wdata_o(mem_reg_wdata_i),
        .mem_addr_o(mem_mem_waddr_i),
        
        //to PC
        .jump_addr_o(exe_pc_jump_addr_i)
    );

    //mem
    mem mem0(
        .rst_i(rst_i),
        //from ctrl unit
        .mem_ctrl_i(mem_ctrl),
        //from exe_mem
        .reg_waddr_i(mem_reg_waddr_i), .reg_we_i(mem_reg_we_i), 
        .reg_wdata_i(mem_reg_wdata_i),
        .mem_addr_i(mem_mem_waddr_i),
        .mem_we_i(mem_mem_we_i),
        
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

    ctrl ctrl0(
        .clk_i(clk_i),
        .rst_i(rst_i),

        //from exe
        .jumpe_i(jumpe_i),
        .aluOp_i(aluOp_i),
        
        //to if_id
        .if_id_flush(if_id_flush),
        //to id_exe
        .id_exe_flush(id_exe_flush),
        //to mem_exe
        .exe_mem_flush(exe_mem_flush),
        //to pc
        .jumpe_o(jumpe_o),
        //to mem
        .mem_ctrl_o(mem_ctrl)
    );
endmodule