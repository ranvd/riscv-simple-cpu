PREFIX = "Vcounter"
FILE = "counter.v"

all:
	verilator ${FILE} --exe --build testbench.cpp -cc

trace:
	verilator ${FILE} --exe --build testbench.cpp -cc --trace

run:
	./obj_dir/${PREFIX}

gtk:
	gtkwave wave.vcd

clean:
	rm -r obj_dir wave.vcd