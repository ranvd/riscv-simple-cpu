`define SYS_ADDR_SPACE 32
`define On 1'b1
`define Off 1'b0

module bus #(
    parameter Num_master = 2,
    parameter Num_device = 14,
    parameter AddrWidth = 32,
    parameter DataWidth = 32,
    parameter addr_mask = 32'hfff_ffff,
    parameter device_mask = 4'b1110
) (
    input wire clk_i,
    input wire rst_i,

    input wire master_req                      [Num_master],
    input wire [AddrWidth-1:0] master_req_addr [Num_master],
    input wire master_read_write               [Num_master],
    input wire [DataWidth-1:0] master_wdata    [Num_master],
    output reg [DataWidth-1:0] master_rdata    [Num_master],
    output wire master_gnt                      [Num_master],
    // output wire master_err                      [Num_master],

    output reg [AddrWidth-1:0] device_addr     [Num_device],
    output reg device_re                       [Num_device],
    output reg device_we                       [Num_device],
    output reg [DataWidth-1:0] device_rdata    [Num_device],
    input wire [DataWidth-1:0] device_wdata    [Num_device],
    input wire device_gnt                      [Num_device]
    // input wire device_err                      [Num_device]
);
    /* 
     * Address map:
     * 0x0000_0000 is for master
     * 0x1000_0000 is for master
     * others' reserved for device.
     */

    reg [`SYS_ADDR_SPACE-1:0] sel_master;
    reg signed [`SYS_ADDR_SPACE-1:0] sel_device;
    reg [`SYS_ADDR_SPACE-1:0] sel_device_addr;


    /* 
     * select master: the priority is higher if the address is lower
     */
    always_latch @(*) begin
        integer i;
        for (i = Num_master; i >= 0; i = i - 1) begin
            if (master_req[i] == `On) begin
                sel_master = i;
            end
        end
    end

    /* parse requested device position and address for access */
    always @(*) begin
        if (master_req[sel_master] == `On) begin
            sel_device = (master_req_addr[sel_master] & ~addr_mask >> 28) - 2;
            sel_device_addr = master_req_addr[sel_master] & addr_mask;
        end else begin
            sel_device = `SYS_ADDR_SPACE'b0;
            sel_device_addr = `SYS_ADDR_SPACE'b0;
        end
    end

    assign device_addr[sel_master] = sel_device_addr;

    always @(*) begin
        if (sel_device >= 0) begin
            if (master_read_write[sel_master] == `On) begin
                device_we[sel_device[3:0]] = `Off;
                device_re[sel_device[3:0]] = `On;
            end else begin
                device_we[sel_device[3:0]] = `On;
                device_re[sel_device[3:0]] = `Off;
            end
        end else begin
            device_we[sel_device[3:0]] = `Off;
            device_re[sel_device[3:0]] = `Off;
        end
    end

    always @(*) begin
        if (device_we[sel_device[3:0]] == `On)begin
            device_rdata[sel_device] = master_wdata[sel_master];
        end else begin
            device_rdata[sel_device] = 'b0;
        end

        if (device_re[sel_device[3:0]] == `On) begin
            master_rdata[sel_master] = device_wdata[sel_device];
        end else begin
            master_rdata[sel_master] = 'b0;
        end
    end

    always @(posedge clk_i) begin
        if (device_gnt[sel_device[3:0]] == `On) begin
            master_gnt[sel_master] <= `On;
        end else begin
            master_gnt[sel_master] <= `Off;
        end
    end

endmodule