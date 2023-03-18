module hazard_detect_unit (
    
    // from ID
    input wire [`GPR_ADDR_SPACE-1:0] id_rs1_addr,
    input wire id_rs1_re,
    input wire [`GPR_ADDR_SPACE-1:0] id_rs2_addr,
    input wire id_rs2_re,
    
    // from ID_EXE
    input wire [`INST_ID_LEN-1:0] id_exe_instr_id,
    input wire [`GPR_ADDR_SPACE-1:0] id_exe_rd_addr,
    input wire id_exe_rd_we, // This may not be use for now
    input wire id_exe_mem_re, // This may not be use for now

    // to IF_ID
    output reg [1:0] if_id_mode,
    
    // to ID_EXE
    output reg [1:0] id_exe_mode,

    // to IF
    output reg if_stall
);
    reg rs1_load_harzard;
    reg rs2_load_harzard;

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

    always @(*) begin
        if (rs1_load_harzard || rs2_load_harzard) begin
            if_id_mode = `Stall;
            id_exe_mode = `Flush;
            if_stall = `On;
        end else begin
            if_id_mode = `Normal;
            id_exe_mode = `Normal;
            if_stall = `Off;
        end
    end
endmodule