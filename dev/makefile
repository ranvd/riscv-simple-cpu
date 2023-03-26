
CROSS_COMPILE = riscv64-unknown-elf-
CFLAGS = -nostdlib -fno-builtin -march=rv32ima -mabi=ilp32 -g -Wall
# -nostdlib: do not link to the standard library.
# -fno-buildin: do not use the buildin function. Without using this option many cause some warning message.
# And this message many not have and affect. Just a little bit annoying.
# -march: use the instruction set which is RISC-V 32 bit IMA.
# -mabi: generate sepcified data model. ilp32 means, "int, long int, pointer are 32 bit".
# Another example of mabi is lp64 which means "int are 32 bits and long int, pointer are 64 bits"

CC = ${CROSS_COMPILE}gcc
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = ${CROSS_COMPILE}objdump
READELF = ${CROSS_COMPILE}readelf

V_MODULE_PATH1 = core
V_MODULE_PATH2 = core/inst_idfr

FILE = testbench.cpp \
			sim_mem.cpp \
			Core.v \

SIM_DIR = sim/obj_dir
CONF = config.vlt

# VPATH = sim/
# VPATH = core/

.DEFAULT_GOAL := all
No = 1
all :
	${CC} ${CFLAGS} sim/test_${No}.S -o sim/test.elf
	${OBJCOPY} -O binary sim/test.elf sim/test.bin

.PHONY : verilate
verilate :
	verilator -y ${V_MODULE_PATH1} -y ${V_MODULE_PATH2} -Mdir ${SIM_DIR} -cc --exe --build ${FILE} ${CONF} --trace

.PHONY : sim
sim :
	./sim/obj_dir/VCore ./sim/test.bin

.PHONY : disassemble
disassemble :
	@${OBJDUMP} -S ./sim/test.elf

.PHONY : hex
hex :
	@hexdump -e '"%08_ax " 1/4 "%08x" "\n"' ./sim/test.bin


.PHONY : analyze
analyze : all
	${READELF} -a ./sim/test.elf > ./sim/section_info
	${OBJDUMP} -D ./sim/test.elf > ./sim/disassemble_info

.PHONY : clean
clean : 
	rm -rf sim/obj_dir wave.vcd sim/*.elf sim/*.bin