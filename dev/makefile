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

.DEFAULT_GOAL := all
all :
	@${CC} ${CFLAGS} test.S -o test.elf
	@${OBJCOPY} -O binary test.elf test.bin

.PHONY : verilate
verilate : testbench.cpp IF.v
	verilator -cc --exe --build testbench.cpp sim_mem.cpp IF.v config.vlt --trace



.PHONY : code
code : all
	@${OBJDUMP} -S test.elf | less

.PHONY : hex
hex : all
	@hexdump -C test.bin

.PHONY : clean
clean : 
	rm -rf *.o *.bin *.elf obj_dir