PREFIX = "Vcounter"
FILE = "counter.v"

all:
	verilator ${FILE} --exe --build testbench.cpp -cc

.PHONY:trace
trace:
	verilator ${FILE} --exe --build testbench.cpp -cc --trace

.PHONY:run
run:
	./obj_dir/${PREFIX}

.PHONY:gtk
gtk:
	gtkwave wave.vcd

.PHONY:clean
clean:
	rm -r obj_dir wave.vcd