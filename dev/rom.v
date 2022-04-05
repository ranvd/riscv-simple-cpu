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

`include "defines.v"

module rom (
    input wire ce,
    input wire[`InstAddrBus] addr,
    output reg[`InstBus] inst
);

    reg[`InstBus] inst_mem[0:`InstMemNum-1];

    //.initial $readmemh("inst_rom.data", inst_mem);

    always @(*) begin
        if (ce == `ChipDisable) begin
            inst <= `ZeroWord;
        end else begin
            inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
        end// if
    end//always
endmodule
/* old
*/