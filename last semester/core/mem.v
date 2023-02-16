/*
 * RAM
*/

module mem (
    input wire rst_i,

    //from ctrl unit
    input wire[`AluOpBus] mem_ctrl_i,

    //from exe_mem
    input wire[`RegAddrBus] reg_waddr_i,
    input wire reg_we_i,
    input wire[`RegBus] reg_wdata_i,
    input wire[`StoreAddrBus] mem_addr_i,
    input wire mem_we_i,
    input wire mem_re_i,

    //to mem_wb
    output reg[`RegAddrBus] reg_waddr_o,
    output reg reg_we_o,
    output reg[`RegBus] reg_wdata_o
);
    reg[`StoreMemAlign] ram[0:`StoreMemNum-1];

    always @(*) begin
        if (rst_i == `RstEnable) begin
            reg_waddr_o <= `ZeroReg;
            reg_we_o <= `WriteDisable;
            reg_wdata_o <= `ZeroWord;
        end else begin
            case (mem_ctrl_i)
                `SB, `SH, `SW: begin
                    reg_waddr_o <= reg_waddr_i;
                    reg_we_o <= reg_we_i;
                    case (mem_ctrl_i)
                        `SB: begin
                            ram[mem_addr_i] <= reg_wdata_i[7:0];
                        end
                        `SH: begin
                            ram[mem_addr_i] <= reg_wdata_i[7:0];
                            ram[mem_addr_i + 1] <= reg_wdata_i[15:8];
                        end
                        `SW: begin
                            ram[mem_addr_i] <= reg_wdata_i[7:0];
                            ram[mem_addr_i + 1] <= reg_wdata_i[15:8];
                            ram[mem_addr_i + 2] <= reg_wdata_i[23:16];
                            ram[mem_addr_i + 3] <= reg_wdata_i[31:24];
                        end 
                    endcase
                end
                `LB, `LH, `LW, `LBU, `LHU: begin
                    reg_waddr_o <= reg_waddr_i;
                    reg_we_o <= reg_we_i;
                    case (mem_ctrl_i)
                        `LB: reg_wdata_o <= {{25{ram[mem_addr_i][7]}}, ram[mem_addr_i][6:0]};
                        `LH: reg_wdata_o <= {{17{ram[mem_addr_i+1][7]}}, ram[mem_addr_i+1][6:0], ram[mem_addr_i]};
                        `LW: reg_wdata_o <= {ram[mem_addr_i+3], ram[mem_addr_i+2], ram[mem_addr_i+1], ram[mem_addr_i]};
                        `LBU: reg_wdata_o <= {24'b0, ram[mem_addr_i]};
                        `LHU: reg_wdata_o <= {16'b0, ram[mem_addr_i+1], ram[mem_addr_i]};
                    endcase
                end
                default: begin
                    reg_waddr_o <= reg_waddr_i;
                    reg_we_o <= reg_we_i;
                    reg_wdata_o <= reg_wdata_i;
                end
            endcase
        end 
    end

endmodule