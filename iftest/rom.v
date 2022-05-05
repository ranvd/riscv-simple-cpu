module rom (
    input wire ce_i,
    input wire[31:0] addr_i,
    output reg[31:0] inst_o
);
    reg[31:0] rom[63:0];

    initial $readmemh("data/rom.data", rom);
    integer i;
    initial begin
    $display("data:");
        for(i=0;i<9;i=i+1)
            $display("%d:%h",i,rom[i]);   
    end
    
    always @(*) begin
        if(ce_i) begin
            inst_o = rom[addr_i];
        end else begin
            inst_o = 32'h0;
        end
    end
endmodule