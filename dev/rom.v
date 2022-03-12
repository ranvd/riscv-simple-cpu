/*
This file is for rom module, it's for storing instructions, 
where "instruction fetch(IF)" fetch the instruction.
In regular PC, IF is done on RAM but in here we assume it done on ROM 
as some embedding system always do. (not sure about that)
    - variable end up with 'i' is for input and 'o' is for output.
    - addr_i represent pc address
    - ce_i reprecet
    - inst_o represent the instruction
    - rom reprecent the rom, in here we have 64x32bit
*/


module rom (
    input wire ce_i,
    input wire[5:0] addr_i,
    output reg[31:0] inst_o
);
    reg[31:0] rom[63:0];
    
    always @(*) begin
        if(ce_i) begin
            inst_o = rom[addr_i];
        end else begin
            inst_o = 32'h0;
        end
    end
endmodule
