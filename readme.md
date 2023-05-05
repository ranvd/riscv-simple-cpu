# RISC-V simple CPU
This is a single-core 5-stage CPU write in Verilog. Thanks to Verilator, I can compile verilog code into executable file, and execute RISC-V instruction on any platform. For me, I think it can be regarded as kind of virtual machine, isn't it?

## Dependence
```
verilator == 5.007
gtkwave == v3.3.104
```
* [Verilator](https://github.com/verilator/verilator) is the tool for simulate the signal. Verilator can compile your verilog code into binary executable file and dump out the `.vcd` file for gtkwave.
* [gtkwave](https://gtkwave.sourceforge.net/) is the tool for inspect the signal value. By using this, you can easiy observe the signal and check if there are some unexpect signals.

## Accepted Instruction
I support rv32im instruction, expect the `FENCE` in standard instruction. The standard testing code is in `testbench/`. The testing code is accessed from [riscv github](https://github.com/riscv-software-src/riscv-tests).

## Usage

### step 1.
Compile the code.
```
make verilate
```

### step 2.
If you want to test standard testing code, go to `testbench/` folder and execute `testbench.sh`.
```
./testbench.sh
```
you can change the `bench=` variable in `testbench.sh` in `testbench/` to test different standard testing code.


If you want to test your own binary code. You need to compile your code first and extract the binary code in the executable file.

if you don't know how to do it, you can simply put your assembly code in `testbench/self_test` folder and execute `make custom_file`. Your code will be convert to pure binary file with `*.bin` suffix.

After all work be done, use the following instruction to test your code.
```
make custom_test testFile={your_file_path}
```

### step 3.
In `sim/conf_core.h`, you can activate some functions by uncomment the define.
```
conf_core.h
// #define TRACE_REGs 1
// #define END_REGs 1
// #define BIG_ENDIAN_HOST
```
`TRACE_REGs` will print out the register value every cycle.

`END_REGs` will print out the register value only at the final cycle.

`BIG_ENDIAN_HOST`, if your host machine are big-endian you should uncomment it, or your code may work unexpectively. But I don't guaranty this wil work fine, since my host is little-endian.

## Architecture
For abbrivation.
* 5-stage CPU
* control unit give out different signal of every instruction.
* hazard detection unit detect all hazard.
* forwarding unit forward all signal required to be forward.
* branch unit at second stage, deciding if branch are needed.
* static branch prediction. Predict not branch.
* 4-cycle to complete multiplication
* 2-cycle to complete division and remainder.