`ifndef GENERAL_DEFINE
`define GENERAL_DEFINE

`include "conf_riscv_spec.v"

`define WORD 4

//////////////////////////////////////////////////////////////////
//                        Hardward define                       //
//                                                              //
//////////////////////////////////////////////////////////////////
/* 
 * This system space have 48 bits and the memory space is 32 bit.
 * In other words, the maximum memory size in 4GB.
 */
`define SYS_ADDR_SPACE 32
`define MEM_ADDR_SPACE 32
`define MEM_SIZE `MEM_ADDR_SPACE'h200000
// `define MEM_SIZE {{(`SYS_ADDR_SPACE-`MEM_ADDR_SPACE){1'b0}}, `MEM_ADDR_SPACE'h200000} // 200 KB


`define START_ADDR `SYS_ADDR_SPACE'b0
`define MEM_BASE `START_ADDR

// address in cache can be seperate as tag, index, block offset, word offset.
// In this seting, the cache size will be 64KB( 2^12 * 4 * 4 )
`define CACHE_DATA_WIDTH `INST_WIDTH
`define CACHE_WORD_OFFSET $clog2(`WORD)
`define CACHE_BLOCK_OFFSET 2
`define CACHE_INDEX 12
`define CACHE_TAG `SYS_ADDR_SPACE - `CACHE_WORD_OFFSET - `CACHE_BLOCK_OFFSET - `CACHE_INDEX

//////////////////////////////////////////////////////////////////
//                         Singal define                        //
//                                                              //
//////////////////////////////////////////////////////////////////
`define On 1'b1
`define Off 1'b0

// Used in Forwarding unit
`define Forward_Rs1 2'b01
`define Forward_Rs2 2'b10
`define Forward_Both 2'b11

// Used in Hazard detection unit
`define Normal 2'b00
`define Flush 2'b01
`define Stall 2'b10
`define MAX_Stall {32{1'b1}}
`define Hazard_Signal_Width $clog2(`MAX_Stall)

//////////////////////////////////////////////////////////////////
//                         Singal define                        //
//                                                              //
//////////////////////////////////////////////////////////////////
// `define Mux_DATA_WIDTH `INST_WIDTH
`endif