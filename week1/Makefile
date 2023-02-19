all:
	verilator adder.v --exe --build testbench.cpp -cc --trace

run:
	./obj_dir/Vadder

gtk:
	gtkwave wave.vcd

clean:
	rm -r obj_dir wave.vcd