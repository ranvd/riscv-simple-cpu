FILE = $(wildcard *.v)
OUTFILE = $(patsubst %.v, V%.h, ${FILE})


all: ${OUTFILE}
	@echo "all file are: "${FILE}
	@echo "all outfile are: "${OUTFILE}

V%.h: %.v testbench_%.cpp
	@verilator $< --exe --build $(word 2, $^) -cc --trace --timescale 1s/1s

gtk:
	gtkwave wave.vcd

.PHONY: clean
clean:
	rm -rf obj_dir *.vcd

.PHONY : vars
vars:
	@echo "FILE= " $(FILE)
	@echo "OUTFILE= " $(OUTFILE)