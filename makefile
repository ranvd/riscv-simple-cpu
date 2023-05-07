
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
MODULE_PATH3 = core/M_extend
MODULE_PATH4 = bus/
MODULE_PATH5 = perip/

FILE = sim_pcb.cpp \
			sim_mem.cpp \
			Vpcb.v \
			conf_general_define.v \
			conf_riscv_spec.v \

SIM_DIR = sim/obj_dir
CONF = config.vlt

# VPATH = sim/
# VPATH = core/

CUSTOM_PATH = testbench/self_test
CC_FILE = $(wildcard $(CUSTOM_PATH)/*.S)
CC_OUT_FILE = $(patsubst %.S, %.bin, $(CC_FILE))

.DEFAULT_GOAL: verilate
.PHONY : verilate
verilate :
	verilator -y ${MODULE_PATH1} -y ${MODULE_PATH2} -y ${MODULE_PATH3} \
	-y ${MODULE_PATH4} -y ${MODULE_PATH5} \
	-Mdir ${SIM_DIR} -cc --exe --build ${FILE} ${CONF} --trace

.PHONY := custom_file
custom_file : $(CC_OUT_FILE)

%.bin : %.elf
	${OBJCOPY} -O binary $^ $@

.PRECIOUS: %.elf
%.elf : %.S
	${CC} ${CFLAGS} $^ -o $@

testFile = ./$(CUSTOM_PATH)/test_1.bin
.PHONY : custom_test
custom_test :
	./$(SIM_DIR)/VCore $(testFile)

.PHONY : disassemble
disassemble :
	@${OBJDUMP} -S $(testFile)

.PHONY : hex
hex :
	@hexdump -e '"%08_ax " 1/4 "%08x" "\n"' $(testFile)


.PHONY : analyze
analyze : all
	${READELF} -a ./$(CUSTOM_PATH)/$(testFile) > ./$(CUSTOM_PATH)/section_info
	${OBJDUMP} -D ./$(CUSTOM_PATH)/$(testFile) > ./$(CUSTOM_PATH)/disassemble_info


.PHONY : clean
clean : 
	rm -rf sim/obj_dir wave.vcd $(CUSTOM_PATH)/*.elf $(CUSTOM_PATH)/*.bin