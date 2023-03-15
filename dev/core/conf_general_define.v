`ifndef GENERAL_DEFINE
`define GENERAL_DEFINE

`include "conf_riscv_spec.v"

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

`define CACHE_DATA_WIDTH `INST_WIDTH

//////////////////////////////////////////////////////////////////
//                         Singal define                        //
//                                                              //
//////////////////////////////////////////////////////////////////
`define On 1'b1
`define Off 1'b0

`define Forward_Rs1 2'b01
`define Forward_Rs2 2'b10
`define Forward_Both 2'b11

`endif