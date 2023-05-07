module Vpcb #(
    parameter AddrWidth = 32,
    parameter DataWidth = 32
) (
    input wire clk_i,
    input wire rst_i,

    output wire anomaly_o
);

    parameter Num_master = 2;
    parameter Num_device = 14;

    reg master_req                      [Num_master];
    reg [AddrWidth-1:0] master_req_addr [Num_master];
    reg master_read_write               [Num_master];
    reg [DataWidth-1:0] master_wdata    [Num_master];
    reg [DataWidth-1:0] master_rdata    [Num_master];
    reg master_gnt                      [Num_master];

    reg [AddrWidth-1:0] device_addr     [Num_device];
    reg device_re                       [Num_device];
    reg device_we                       [Num_device];
    reg [DataWidth-1:0] device_rdata    [Num_device];
    reg [DataWidth-1:0] device_wdata    [Num_device];
    reg device_gnt                      [Num_device];

    initial begin
        integer i;
        for (i = 0; i < Num_master; i = i + 1) begin
            master_req_addr[i] = 0;
            master_read_write[i] = 0;
            master_wdata[i] = 0;
            master_rdata[i] = 0;
            master_gnt[i] = 0;
        end
        for (i = 0; i < Num_device; i = i + 1) begin
            device_addr[i] = 0;
            device_re[i] = 0;
            device_we[i] = 0;
            device_rdata[i] = 0;
            device_wdata[i] = 0;
            device_gnt[i] = 0;
        end
    end

    bus bus1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .master_req(master_req),
        .master_req_addr(master_req_addr),
        .master_read_write(master_read_write),
        .master_wdata(master_wdata),
        .master_rdata(master_rdata),
        .master_gnt(master_gnt),
        .device_addr(device_addr),
        .device_re(device_re),
        .device_we(device_we),
        .device_rdata(device_rdata),
        .device_wdata(device_wdata),
        .device_gnt(device_gnt)
    );

    // 0x0000_0000
    Core Core1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .anomaly_o(anomaly_o),
        .req_o(master_req[0]),
        .req_addr(master_req_addr[0]),
        .read_write(master_read_write[0]),
        .wdata(master_wdata[0]),
        .rdata(master_rdata[0]),
        .gnt(master_gnt[0])
    );
    // 0x3000_0000
    ram ram1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .re_i(device_re[0]),
        .we_i(device_we[0]),
        .raddr_i(device_addr[0]),
        .waddr_i(device_addr[0]),
        .wdata_i(device_rdata[0]),
        .rdata_o(device_wdata[0]),
        .gnt(device_gnt[0])
    );
endmodule