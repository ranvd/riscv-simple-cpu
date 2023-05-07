module ram #(
    parameter ram_size = 'h40_0000, //4 MB
    parameter DataWidth = 32,
    parameter AddrWidth = 32
)(
    input wire clk_i,
    input wire rst_i,
    input wire re_i,
    input wire we_i,
    input wire [AddrWidth-1:0] raddr_i,
    input wire [AddrWidth-1:0] waddr_i,
    input wire [DataWidth-1:0] wdata_i,
    output reg [DataWidth-1:0] rdata_o,

    output reg gnt
);
    reg [7:0] ram [ram_size];
    always @(posedge clk_i) begin
        if (re_i == `On) begin
            rdata_o <= {ram[raddr_i], ram[raddr_i+1], ram[raddr_i+2], ram[raddr_i+3]};
            gnt <= `On;
        end else begin
            rdata_o <= 0;
            gnt <= `Off;
        end
    end

    always @(posedge clk_i) begin
        if (we_i == `On) begin
            if (waddr_i < ram_size) begin
                ram[waddr_i] <= wdata_i[7:0];
                ram[waddr_i+1] <= wdata_i[15:8];
                ram[waddr_i+2] <= wdata_i[23:16];
                ram[waddr_i+3] <= wdata_i[31:24];
                gnt <= `On;
            end else begin
                ram[0] <= ram[0];
                gnt <= `Off;
            end
        end
    end
endmodule