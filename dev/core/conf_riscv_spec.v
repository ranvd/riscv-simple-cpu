`ifndef RV32_SPEC
`define RV32_SPEC

/*
 * This is RISC-V, which instruction are 32 bits width.
 */
`define INST_WIDTH 32

/* 
 * register file
 */
`define GPR_NUM 32
`define GPR_WIDTH 32
`define GPR_ADDR_SPACE $clog2(`GPR_NUM)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                        risc-v instruction format                                          //
//                                                                                                           //
//   ___________________________________________________________________________________________________     //
//  |          |31                 25|24       20|19       15|14      12|11                 7|6        0|    //
//  |  R-type  |       funct7        |    rs2    |    rs1    |  funct3  |         rd         |  opcode  |    //
//  |__________|_____________________|___________|___________|__________|____________________|__________|    //
//  |          |31                             20|19       15|14      12|11                 7|6        0|    //
//  |  I-type  |            imm[11:0]            |    rs1    |  funct3  |         rd         |  opcode  |    //
//  |__________|_________________________________|___________|__________|____________________|__________|    //
//  |          |31                 25|24       20|19       15|14      12|11                 7|6        0|    //
//  |  S-type  |      imm[11:5]      |    rs2    |    rs1    |  funct3  |      imm[4:0]      |  opcode  |    //
//  |__________|_____________________|___________|___________|__________|____________________|__________|    //
//  |          |31       |         25|24       20|19       15|14      12|11                 7|6        0|    //
//  |  B-type  | imm[12] | imm[10:5] |    rs2    |    rs1    |  funct3  |  imm[4:1]|imm[11]  |  opcode  |    //
//  |__________|_________|___________|___________|___________|__________|____________________|__________|    //
//  |          |31                                                    12|11                 7|6        0|    //
//  |  U-type  |                       imm[31:12]                       |         rd         |  opcode  |    //
//  |__________|________________________________________________________|____________________|__________|    //
//  |          |31         |               |           |              12|11                 7|6        0|    //
//  |  J-type  |  imm[20]  |   imm[10:1]   |  imm[11]  |   imm[19:12]   |         rd         |  opcode  |    //
//  |__________|___________|_______________|___________|________________|____________________|__________|    //
//                                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
`define funct7 31:25
`define funct7_width 7
`define rs2 24:20
`define rs1 19:15
`define funct3 14:12
`define funct3_width 3
`define rd 11:7
`define opcode 6:0
`define opcode_width 7

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                         risc-v immediate format                                                //
//                                                                                                                //
//   ________________________________________________________________________________________________________     //
//  |          |31                                                  11|10          5|4           1|0         |    //
//  |  I-type  |                       inst[31]                       | inst[30:25] | inst[24:21] | inst[20] |    //
//  |__________|______________________________________________________|_____________|_____________|__________|    //
//  |          |31                                                  11|10          5|4           1|0         |    //
//  |  S-type  |                       inst[31]                       | inst[30:25] | inst[11:8]  | inst[7]  |    //
//  |__________|______________________________________________________|_____________|_____________|__________|    //
//  |          |31                                        12|       11|10          5|4           1|0         |    //
//  |  B-type  |             inst[31]                       | inst[7] | inst[30:25] | inst[11:8]  |    0     |    //
//  |__________|____________________________________________|_________|_____________|_____________|__________|    //
//  |          |31          |30           20|19           12|11                                             0|    //
//  |  U-type  |  inst[31]  |  inst[30:20]  |  inst[19:12]  |                        0                       |    //
//  |__________|____________|_______________|_______________|________________________________________________|    //
//  |          |31                        20|19           12|       11|10          5|4           1|0         |    //
//  |  J-type  |         inst[31]           |  inst[19:12]  | inst[20]| inst[30:25] | inst[24:21] |    0     |    //
//  |__________|____________________________|_______________|_________|_____________|_____________|__________|    //
//                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* These macro are used for transform the immediate value of 
 * different instruction type in convenience. 
 */
`define IMM_WIDTH 32
`define I_TYPE_IMM(instr) {{21{instr[31]}}, instr[30:25], instr[24:21], instr[20]}
`define S_TYPE_IMM(instr) {{21{instr[31]}}, instr[30:25], instr[11:8], instr[7]}
`define B_TYPE_IMM(instr) {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}
`define U_TYPE_IMM(instr) {instr[31], instr[30:20], instr[19:12], 12'b0}
`define J_TYPE_IMM(instr) {{12{instr[31]}}, instr[19:12], instr[20], instr[30:25], instr[24:21], 1'b0}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                      risc-v instruction identifier                                             //
//                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* ---------------- opcode ----------------
 * Due to the Ch.24 in risc-v unprivileged spec.
 * the opcode are seperated like this.
 * This is why I write it in 2-3-2 format.
 */
`define OP_IMM    7'b00_100_11
`define OP        7'b01_100_11
`define LUI       7'b01_101_11
`define AUIPC     7'b00_101_11
`define LOAD      7'b00_000_11
`define STORE     7'b01_000_11
`define JAL       7'b11_011_11 
`define JALR      7'b11_001_11

`define FUN3_NONE 3'b000
`define FUN7_NONE 7'b0000000


/* ------------ func3 and func7 ----------- */
/* ---------------- I-type ---------------- */
`define ADDI             3'b000
`define SLTI             3'b010
`define SLTIU            3'b011
`define XORI             3'b100
`define ORI              3'b110
`define ANDI             3'b111
`define SLLI             3'b001
`define SLLI_FUNCT7      7'b0000000
`define SRLI             3'b101
`define SRLI_FUNCT7      7'b0000000
`define SRAI             3'b101
`define SRAI_FUNCT7      7'b0100000
`define LB_FUN3          3'b000
`define LH_FUN3          3'b001
`define LW_FUN3          3'b010
`define LBU_FUN3         3'b100
`define LHU_FUN3         3'b101
`define JALR_FUN3        3'b000
/* ---------------- S-type ---------------- */
`define SB_FUN3          3'b000
`define SH_FUN3          3'b001
`define SW_FUN3          3'b010
/* ---------------- R-type ---------------- */
`define ADD              3'b000
`define ADD_FUNCT7       7'b0000000
`define SUB              3'b000
`define SUB_FUNCT7       7'b0100000
`define SLL              3'b001
`define SLL_FUNCT7       7'b0000000
`define SLT              3'b010
`define SLT_FUNCT7       7'b0000000
`define SLTU             3'b011
`define SLTU_FUNCT7      7'b0000000
`define XOR              3'b100
`define XOR_FUNCT7       7'b0000000
`define SRL              3'b101
`define SRL_FUNCT7       7'b0000000
`define SRA              3'b101
`define SRA_FUNCT7       7'b0100000
`define OR               3'b110
`define OR_FUNCT7        7'b0000000
`define AND              3'b111
`define AND_FUNCT7       7'b0000000



// Pesudo
// `define NOP              `ADDI


/* ---------------- Instr. ID ---------------- */
`define INST_ID_LEN 17 // {funct7, funct3, opcode}
`define NONE_ID          17'b0
/* ---------------- I-type ID ---------------- */
`define ADDI_ID          {`FUN7_NONE, `ADDI, `OP_IMM}
`define SLTI_ID          {`FUN7_NONE, `SLTI, `OP_IMM}
`define SLTIU_ID         {`FUN7_NONE, `SLTIU, `OP_IMM}
`define XORI_ID          {`FUN7_NONE, `XORI, `OP_IMM}
`define ORI_ID           {`FUN7_NONE, `ORI, `OP_IMM}
`define ANDI_ID          {`FUN7_NONE, `ANDI, `OP_IMM}
`define SLLI_ID          {`SLLI_FUNCT7, `SLLI, `OP_IMM}
`define SRLI_ID          {`SRLI_FUNCT7, `SRLI, `OP_IMM}
`define SRAI_ID          {`SRAI_FUNCT7, `SRAI, `OP_IMM}
`define LB_ID            {`FUN7_NONE, `LB_FUN3, `LOAD}
`define LH_ID            {`FUN7_NONE, `LH_FUN3, `LOAD}
`define LW_ID            {`FUN7_NONE, `LW_FUN3, `LOAD}
`define LBU_ID           {`FUN7_NONE, `LBU_FUN3, `LOAD}
`define LHU_ID           {`FUN7_NONE, `LHU_FUN3, `LOAD}
`define JALR_ID          {`FUN7_NONE, `JALR_FUN3, `JALR}
/* ---------------- S-type ID ---------------- */
`define SB_ID           {`FUN7_NONE, `SB_FUN3, `STORE}
`define SH_ID           {`FUN7_NONE, `SH_FUN3, `STORE}
`define SW_ID           {`FUN7_NONE, `SW_FUN3, `STORE}
/* ---------------- R-type ID ---------------- */
`define ADD_ID          {`ADD_FUNCT7, `ADD, `OP}
`define SUB_ID          {`SUB_FUNCT7, `SUB, `OP}
`define SLL_ID          {`SLL_FUNCT7, `SLL, `OP}
`define SLT_ID          {`SLT_FUNCT7, `SLT, `OP}
`define SLTU_ID         {`SLTU_FUNCT7, `SLTU, `OP}
`define XOR_ID          {`XOR_FUNCT7, `XOR, `OP}
`define SRL_ID          {`SRL_FUNCT7, `SRL, `OP}
`define SRA_ID          {`SRA_FUNCT7, `SRA, `OP}
`define OR_ID           {`OR_FUNCT7, `OR, `OP}
`define AND_ID          {`AND_FUNCT7, `AND, `OP}
/* ---------------- U-type ID ---------------- */
`define LUI_ID          {`FUN7_NONE, `FUN3_NONE, `LUI}
`define AUIPC_ID        {`FUN7_NONE, `FUN3_NONE, `AUIPC}
/* ---------------- J-type ID ---------------- */
`define JAL_ID          {`FUN7_NONE, `FUN3_NONE, `JAL}

`endif