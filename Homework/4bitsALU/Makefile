
FILE = $(wildcard *.v)
OUTFILE = $(patsubst %.v, V%.h, ${FILE})
TESTBENCH = $(patsubst %.v, testbench_%.cpp, %{FILE})
RUN = ""

all: ${OUTFILE}
	@echo "all file are: "${FILE}
	@echo "all outfile are: "${OUTFILE}

V%.h: %.v testbench_%.cpp
	verilator $< --exe --build $(word 2, $^) -cc $<

.PHONY: trace
trace: ${OUTFILE}
	@echo "all file are: "${FILE}
	@echo "all outfile are: "${OUTFILE}

V%.h: %.v testbench_%.cpp
	verilator $< --exe --build $(word 2, $^) -cc --trace

.PHONY: run
run:
	./obj_dir/${RUN}

.PHONY: gtk
gtk:
	gtkwave wave.vcd


.PHONY: test
# usage: make test FILE="testing_file_name"
test:
	iverilog ${FILE}

.PHONY: clean
clean:
	rm -rf obj_dir *.vcd