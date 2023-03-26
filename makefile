
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

MODULE_PATH1 = core
MODULE_PATH2 = core/inst_idfr

FILE = testbench.cpp \
			sim_mem.cpp \
			Core.v \

SIM_DIR = sim/obj_dir
CONF = config.vlt

# VPATH = sim/
# VPATH = core/

FILE_PATH = testbench/self_test
CC_FILE = $(wildcard $(FILE_PATH)/*.S)
CC_OUT_FILE = $(patsubst %.S, %.bin, $(CC_FILE))

.DEFAULT_GOAL := all
all : $(CC_OUT_FILE)

%.bin : %.elf
	${OBJCOPY} -O binary $^ $@

.PRECIOUS: %.elf
%.elf : %.S
	${CC} ${CFLAGS} $^ -o $@


.PHONY : verilate
verilate :
	verilator -y ${MODULE_PATH1} -y ${MODULE_PATH2} -Mdir ${SIM_DIR} -cc --exe --build ${FILE} ${CONF} --trace


No = 1
.PHONY : sim
sim :
	./$(SIM_DIR)/VCore ./$(FILE_PATH)/test_$(No).bin

.PHONY : disassemble
disassemble :
	@${OBJDUMP} -S ./$(FILE_PATH)/test_$(No).elf

.PHONY : hex
hex :
	@hexdump -e '"%08_ax " 1/4 "%08x" "\n"' ./$(FILE_PATH)/test_$(No).bin

.PHONY : analyze
analyze : all
	${READELF} -a ./$(FILE_PATH)/test_$(No).elf > ./$(FILE_PATH)/section_info
	${OBJDUMP} -D ./$(FILE_PATH)/test_$(No).elf > ./$(FILE_PATH)/disassemble_info


.PHONY : clean
clean : 
	rm -rf sim/obj_dir wave.vcd $(FILE_PATH)/*.elf $(FILE_PATH)/*.bin