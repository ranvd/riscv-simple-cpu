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

// bus
`define InstBus 31:0
`define InstAddrBus 31:0
`define RegAddrBus 4:0
`define RegBus 31:0
`define AluOpBus 9:0  // func3 + opcode

// common regs
`define RegNum 32        // reg num
`define RegNumLog2 5

// number of rom
`define InstMemNum 64


// RV32I inst num //這裡我可能要先廢除了，原本是用來做 AluOp 的訊號用的，但我發現用 funct3 的訊號就可以決定了。
//`define LUI 8'h0
//`define AUIPC 8'h1
//`define JAL 8'h2
//`define JALR 8'h3
//`define BEQ 8'h4
//`define BNE 8'h5
//`define BLT 8'h6
//`define BGE 8'h7
//`define BLTU 8'h8
//`define BGEU 8'h9
//`define LB 8'ha
//`define LH 8'hb
//`define LW 8'hc
//`define LBU 8'hd
//`define LHU 8'he
//`define SB 8'hf
//`define SH 8'h10
//`define SW 8'h11
//`define ADDI 8'h12
//`define SLTI 8'h13
//`define SLTIU 8'h14
//`define XORI 8'h15
//`define ORI 8'h16
//`define ANDI 8'h17
//`define SLLI 8'h18 //先等等 這應該是 R-type 吧
//`define SRLI 8'h19 //這也是
//`define SRAI 8'h1a //這也是
//`define ADD 8'h1b
//`define SUB 8'h1c
//`define SLL 8'h1d
//`define SLT 8'h1e
//`define SLTU 8'h1f
//`define XOR 8'h20
//`define SRL 8'h21
//`define SRA 8'h22
//`define OR 8'h23
//`define AND 8'h24
//`define FENCE 8'h25
//`define ECALL 8'h26
//`define EBREAK 8'h27

// M  extension
//`define MUL 8'h28
//`define MULH 8'h29
//`define MULHSU 8'h2a
//`define MULHU 8'h2b
//`define DIV 8'h2c
//`define DIVU 8'h2d
//`define REM 8'h2e
//`define REMU 8'h2f

`define NOP 10'h0   //addi x0,x0,0



// I type inst
`define INST_TYPE_I 7'b0010011
`define INST_ADDI   3'b000
`define INST_SLTI   3'b010
`define INST_SLTIU  3'b011
`define INST_XORI   3'b100
`define INST_ORI    3'b110
`define INST_ANDI   3'b111

// -----------------------新的 aluOp 以 10 bit 定義。
//`define LUI 8'h0
//`define AUIPC 8'h1
//`define JAL 8'h2
//`define JALR 8'h3
//`define BEQ 8'h4
//`define BNE 8'h5
//`define BLT 8'h6
//`define BGE 8'h7
//`define BLTU 8'h8
//`define BGEU 8'h9
//`define LB 8'ha
//`define LH 8'hb
//`define LW 8'hc
//`define LBU 8'hd
//`define LHU 8'he
//`define SB 8'hf
//`define SH 8'h10
//`define SW 8'h11
`define ADDI  10'b000_0010011
`define SLTI  10'b010_0010011
`define SLTIU 10'b011_0010011
`define XORI  10'b100_0010011
`define ORI   10'b110_0010011
`define ANDI  10'b111_0010011
`define SLLI 8'h18 //先等等 這應該是 R-type 吧
`define SRLI 8'h19 //這也是
`define SRAI 8'h1a //這也是
//`define ADD 8'h1b
//`define SUB 8'h1c
//`define SLL 8'h1d
//`define SLT 8'h1e
//`define SLTU 8'h1f
//`define XOR 8'h20
//`define SRL 8'h21
//`define SRA 8'h22
//`define OR 8'h23
//`define AND 8'h24
//`define FENCE 8'h25
//`define ECALL 8'h26
//`define EBREAK 8'h27

// M  extension
//`define MUL 8'h28
//`define MULH 8'h29
//`define MULHSU 8'h2a
//`define MULHU 8'h2b
//`define DIV 8'h2c
//`define DIVU 8'h2d
//`define REM 8'h2e
//`define REMU 8'h2f