all:
	verilator --exe -cc --build testbench.cpp adder4.v  --trace --public

.PHONY : verilator
verilator : testbench.cpp adder4.v
	verilator --exe -cc --build testbench.cpp adder4.v  --trace

run:
	./obj_dir/Vadder

gtk:
	gtkwave wave.vcd

clean:
	rm -rf obj_dir wave.vcd