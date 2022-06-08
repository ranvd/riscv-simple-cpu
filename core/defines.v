`define CpuResetAddr 32'h0

`define RstEnable 1'b0
`define RstDisable 1'b1
`define ZeroWord 32'h0
`define ZeroReg 5'h0
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define ChipEnable 1'b1
`define ChipDisable 1'b0
`define JumpEnable 1'b1
`define JumpDisable 1'b0
`define FlushEnable 1'b1
`define FlushDisable 1'b0

// bus
`define InstBus 31:0
`define InstAddrBus 31:0
`define RegAddrBus 4:0
`define RegBus 31:0
`define AluOpBus 9:0  // func3 + opcode

// common regs
`define RegNum 32        // reg num
`define RegNumLog2 5

// ROM
`define InstMemNum 256
`define InstMemAlign 7:0

// I type inst
`define INST_TYPE_I 7'b0010011
`define INST_ADDI   3'b000
`define INST_SLTI   3'b010
`define INST_SLTIU  3'b011
`define INST_XORI   3'b100
`define INST_ORI    3'b110
`define INST_ANDI   3'b111
`define INST_SLLI   3'b001
`define INST_SRLI   3'b101
`define INST_SRAI   3'b101
`define INST_JALR   3'b000  //這和 ADDI 重複了，但沒關係，opcode 不一樣


// R type inst
`define INST_TYPE_R 7'b0110011
`define INST_ADD    3'b000
`define INST_SUB    3'b000
`define INST_SLL    3'b001
`define INST_SLT    3'b010
`define INST_SLTU   3'b011
`define INST_XOR    3'b100
`define INST_SRL    3'b101
`define INST_SRA    3'b101
`define INST_OR     3'b110
`define INST_AND    3'b111

// S type inst

// B type inst
`define INST_TYPE_B 7'b1100011
`define INST_BEQ    3'b000
`define INST_BNE    3'b001
`define INST_BLT    3'b100
`define INST_BGE    3'b101
`define INST_BLTU   3'b110
`define INST_BGEU   3'b111

// U type inst 因為 U type opcode 都不一樣
`define INST_TYPE_U_LUI   7'b0110111
`define INST_TYPE_U_AUIPC 7'b0010111


// J type inst
`define INST_TYPE_J 7'b1101111
`define INST_JAL    3'b000 // J type 並沒有 funct3，這邊是我自己放上去的，只是方便看而已

// -----------------------新的 aluOp 以 10 bit 定義。
`define LUI   10'b000_0110111 //    000 + opcode
`define AUIPC 10'b000_0010111 //    000 + opcode
`define JAL   10'b000_1101111 //    000 + opcode
`define JALR  10'b000_1100111 //    000 + opcode
`define BEQ   10'b000_1100011 // funct3 + opcode
`define BNE   10'b001_1100011 // funct3 + opcode
`define BLT   10'b100_1100011 // funct3 + opcode
`define BGE   10'b101_1100011 // funct3 + opcode
`define BLTU  10'b110_1100011 // funct3 + opcode
`define BGEU  10'b111_1100011 // funct3 + opcode
//`define LB    10'b000_0000011 // funct3 + opcode
//`define LH    10'b001_0000011 // funct3 + opcode
//`define LW    10'b010_0000011 // funct3 + opcode
//`define LBU   10'b100_0000011 // funct3 + opcode
//`define LHU   10'b101_0000011 // funct3 + opcode
//`define SB    10'b000_0100011 // funct3 + opcode
//`define SH    10'b001_0100011 // funct3 + opcode
//`define SW    10'b010_0100011 // funct3 + opcode
`define ADDI  10'b000_0010011 // funct3 + opcode  I-type
`define SLTI  10'b010_0010011 // funct3 + opcode  I-type
`define SLTIU 10'b011_0010011 // funct3 + opcode  I-type
`define XORI  10'b100_0010011 // funct3 + opcode  I-type
`define ORI   10'b110_0010011 // funct3 + opcode  I-type
`define ANDI  10'b111_0010011 // funct3 + opcode  I-type
`define SLLI  10'b001_0000000 // funct3 + funct7  I-type
`define SRLI  10'b101_0000000 // funct3 + funct7  I-type
`define SRAI  10'b101_0100000 // funct3 + funct7  I-type
`define ADD   10'b000_0000000 // funct3 + funct7  R-type
`define SUB   10'b000_0100000 // funct3 + funct7  R-type
`define SLL   10'b001_0000000 // funct3 + funct7  R-type
`define SLT   10'b010_0000000 // funct3 + funct7  R-type
`define SLTU  10'b011_0000000 // funct3 + funct7  R-type
`define XOR   10'b100_0000000 // funct3 + funct7  R-type
`define SRL   10'b101_0000000 // funct3 + funct7  R-type
`define SRA   10'b101_0100000 // funct3 + funct7  R-type
`define OR    10'b110_0000000 // funct3 + funct7  R-type
`define AND   10'b111_0000000 // funct3 + funct7  R-type
//`define FENCE 10'b000_0001111
//`define ECALL 10'b000_0010011 //特別指令，之後再設計
//`define EBREAK 10'b000_0010011 //特別指令，之後再設計

// M  extension
//`define MUL    10'b000_0110011
//`define MULH   10'b001_0110011
//`define MULHSU 10'b010_0110011
//`define MULHU  10'b011_0110011
//`define DIV    10'b100_0110011
//`define DIVU   10'b101_0110011
//`define REM    10'b110_0110011
//`define REMU   10'b111_0110011

`define NOP 10'b000_0010011   //addi x0,x0,0