`define START_ADDR 32'b0

/* 
 * This system space have 48 bits and the memory space is 32 bit.
 * In other words, the maximum memory size in 4GB.
 */
`define SYS_SPACE 48
`define MEM_SPACE 32
`define MEM_SIZE 32'h200000 // 200 KB

/*
 * This is RISC-V, which instruction are 32 bits width.
 */
`define INST_WIDTH 32

