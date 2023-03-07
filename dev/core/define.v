`ifndef GENERAL_DEFINE
`define GENERAL_DEFINE

/* 
 * This system space have 48 bits and the memory space is 32 bit.
 * In other words, the maximum memory size in 4GB.
 */
`define SYS_ADDR_SPACE 48
`define MEM_ADDR_SPACE 32
`define MEM_SIZE {{(`SYS_ADDR_SPACE-`MEM_ADDR_SPACE){1'b0}}, `MEM_ADDR_SPACE'h200000} // 200 KB


`define START_ADDR `SYS_ADDR_SPACE'b0
`define MEM_BASE `START_ADDR


`endif