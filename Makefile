# command
RISC_COMPILE = riscv-none-elf-
CC = $(RISC_COMPILE)gcc
LD = $(RISC_COMPILE)ld
OBJCOPY = $(RISC_COMPILE)objcopy

# .v file path
CORE = core/
PERIPS = perips/
SOC = soc/
SIM = sim/

# output file
TB = sim/out.vvp   # cpu Testbench
ROM = sim/rom.data  # risc-v instruction in hex

all: $(TB) $(ROM) clean

$(TB): $(CORE)*.v $(PERIPS)*.v $(SOC)*.v
	iverilog -o $(TB) $(CORE)*.v $(PERIPS)*.v $(SOC)*.v -I $(CORE)

$(ROM): sim/rom.bin
	hexdump -e '/2 "%04x \n"' $< > $@

sim/rom.bin: sim/rom.o
	$(OBJCOPY) -O binary $< $@
	
sim/rom.o: sim/rom.S
	$(CC) -c $(SIM)rom.S -o $(SIM)rom.o

clean:
	rm sim/rom.bin sim/rom.o