module hazard_detect_unit (
    // from branch unit
    input wire pc_we,

    // from cache, cache miss
    input wire icache_miss,
    input wire dcache_miss,

    // from ID
    input wire [`INST_ID_LEN-1:0] id_instr_id,
    input wire [`GPR_ADDR_SPACE-1:0] id_rs1_addr,
    input wire id_rs1_re,
    input wire [`GPR_ADDR_SPACE-1:0] id_rs2_addr,
    input wire id_rs2_re,
    
    // from ID_EXE
    input wire [`INST_ID_LEN-1:0] id_exe_instr_id,
    input wire [`GPR_ADDR_SPACE-1:0] id_exe_rd_addr,
    input wire id_exe_rd_we, // This may not be use for now
    input wire id_exe_mem_re, // This may not be use for now

    // from EXE stage
    input wire exe_ready,

    // from EXE_MEM
    input wire exe_mem_mem_re,
    input wire [`GPR_ADDR_SPACE-1:0] exe_mem_rd_addr,
    input wire exe_mem_rd_we,

    // to IF_ID
    output reg [1:0] if_id_mode,
    
    // to ID_EXE
    output reg [1:0] id_exe_mode,

    // to EXE_MEM
    output reg [1:0] exe_mem_mode,

    // to IF
    output reg if_stall,

    // to all unit who acquire hazard signal
    output reg [`Hazard_Signal_Width-1:0] signal_cycle
);
    reg rs1_load_harzard;
    reg rs2_load_harzard;
    reg branch_hazard;
    reg exe_to_id_hazard;
    reg mem_to_id_hazard;

    /* For detecting load hazard */
    always @(*) begin
        case (id_exe_instr_id)
            `LB_ID, `LH_ID, `LW_ID, `LBU_ID, `LHU_ID : begin
                if (id_rs1_re && id_rs1_addr == id_exe_rd_addr) begin
                    rs1_load_harzard = `On;
                end else begin
                    rs1_load_harzard = `Off;
                end
                if (id_rs2_re && id_rs2_addr == id_exe_rd_addr) begin
                    rs2_load_harzard = `On;
                end else begin
                    rs2_load_harzard = `Off;
                end
            end
            default: begin
                rs1_load_harzard = `Off;
                rs2_load_harzard = `Off;
            end
        endcase
    end

    /* For detecting hazard about branch instruction */
    always @(*) begin
        case(id_instr_id)
            `JAL_ID : begin
                branch_hazard = `On;
            end
            `JALR_ID : begin
                branch_hazard = `On;
                if (id_rs1_addr == id_exe_rd_addr && id_exe_rd_we) begin
                    exe_to_id_hazard = `On;
                end else begin
                    exe_to_id_hazard = `Off;
                end
                if (id_rs1_addr == exe_mem_rd_addr && exe_mem_rd_we && exe_mem_mem_re) begin
                    mem_to_id_hazard = `On;
                end else begin
                    mem_to_id_hazard = `Off;
                end
            end
            `BEQ_ID, `BNE_ID, `BLT_ID, `BGE_ID, `BLTU_ID, `BGEU_ID : begin
                if (pc_we) begin
                    branch_hazard = `On;
                end else begin
                    branch_hazard = `Off;
                end
                if ((id_rs1_addr == id_exe_rd_addr || id_rs2_addr == id_exe_rd_addr ) && id_exe_rd_we) begin
                    exe_to_id_hazard = `On;
                end else begin
                    exe_to_id_hazard = `Off;
                end
                if ((id_rs1_addr == exe_mem_rd_addr || id_rs2_addr == exe_mem_rd_addr) && exe_mem_rd_we && exe_mem_mem_re) begin
                    mem_to_id_hazard = `On;
                end else begin
                    mem_to_id_hazard = `Off;
                end
            end

            default : begin
                branch_hazard = `Off;
            end
        endcase
    end

    reg [1:0] if_id_mode_1;
    reg [1:0] id_exe_mode_1;
    reg if_stall_1;
    reg [`Hazard_Signal_Width-1:0] signal_cycle_1;

    reg [1:0] if_id_mode_2;
    reg [1:0] id_exe_mode_2;
    reg if_stall_2;
    reg [`Hazard_Signal_Width-1:0] signal_cycle_2;

    reg [1:0] if_id_mode_3;
    reg [1:0] id_exe_mode_3;
    reg if_stall_3;
    reg [`Hazard_Signal_Width-1:0] signal_cycle_3;

    reg [1:0] if_id_mode_4;
    reg [1:0] id_exe_mode_4;
    reg if_stall_4;
    reg [`Hazard_Signal_Width-1:0] signal_cycle_4;

    reg [1:0] if_id_mode_5;
    reg [1:0] id_exe_mode_5;
    reg if_stall_5;
    reg [`Hazard_Signal_Width-1:0] signal_cycle_5;

    reg [1:0] if_id_mode_6;
    reg [1:0] id_exe_mode_6;
    reg if_stall_6;
    reg [`Hazard_Signal_Width-1:0] signal_cycle_6;
    // reg exe_mem_mode;

    always @(*) begin
        if (rs1_load_harzard || rs2_load_harzard) begin
            if_id_mode_1 = `Stall;
            id_exe_mode_1 = `Flush;
            if_stall_1 = `On;
            signal_cycle_1 = 1;
        end else begin
            if_id_mode_1 = `Normal;
            id_exe_mode_1 = `Normal;
            if_stall_1 = `Off;
            signal_cycle_1 = 0;
        end

        if (branch_hazard) begin
            if_id_mode_2 = `Flush;
            id_exe_mode_2 = `Normal;
            if_stall_2 = `Off;
            signal_cycle_2 = 1;
        end else begin
            if_id_mode_2 = `Normal;
            id_exe_mode_2 = `Normal;
            if_stall_2 = `Off;
            signal_cycle_2 = 0;
        end

        if (exe_to_id_hazard || mem_to_id_hazard) begin
            if_id_mode_3 = `Stall;
            id_exe_mode_3 = `Flush;
            if_stall_3 = `On;
            signal_cycle_3 = 1;
        end else begin
            if_id_mode_3 = `Normal;
            id_exe_mode_3 = `Normal;
            if_stall_3 = `Off;
            signal_cycle_3 = 0;
        end

        if (exe_ready) begin
            if_id_mode_4 = `Normal;
            id_exe_mode_4 = `Normal;
            if_stall_4 = `Off;
            signal_cycle_4 = 0;
        end else begin
            if_id_mode_4 = `Stall;
            id_exe_mode_4 = `Stall;
            if_stall_4 = `On;
            signal_cycle_4 = 1;
        end

        if (icache_miss) begin
            if_id_mode_5 = `Normal;
            id_exe_mode_5 = `Normal;
            if_stall_5 = `On;
            signal_cycle_5 = 1;
        end else begin
            if_id_mode_5 = `Normal;
            id_exe_mode_5 = `Normal;
            if_stall_5 = `Off;
            signal_cycle_5 = 0;
        end

        if (dcache_miss) begin
            if_id_mode_6 = `Stall;
            id_exe_mode_6 = `Stall;
            exe_mem_mode = `Stall;
            if_stall_6 = `On;
            signal_cycle_6 = 1;
        end else begin
            if_id_mode_6 = `Normal;
            id_exe_mode_6 = `Normal;
            exe_mem_mode = `Normal;
            if_stall_6 = `Off;
            signal_cycle_6 = 0;
        end
    end


    assign if_id_mode = if_id_mode_1 | if_id_mode_2 | if_id_mode_3 | if_id_mode_4;
    assign id_exe_mode = id_exe_mode_1 | id_exe_mode_2 | id_exe_mode_3 | id_exe_mode_4;
    assign if_stall = if_stall_1 | if_stall_2 | if_stall_3 | if_stall_4;
    assign signal_cycle = signal_cycle_1 | signal_cycle_2 | signal_cycle_3 | signal_cycle_4;

endmodule