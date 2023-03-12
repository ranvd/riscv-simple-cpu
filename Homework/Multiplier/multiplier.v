// 

module multipiler (
    input wire signed [31:0] in_data,

    output reg signed [31:0] out_data
);
    reg signed [31:0] tmp;

    always @(*) begin
        tmp = in_data >>> 4;
    end
    assign out_data = tmp;

    
endmodule