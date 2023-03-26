#include <iostream>
#include <memory>

#include "Vcounter.h"
#include "verilated_vcd_c.h"

vluint64_t main_time = 0;

double sc_time_stamp(int len) {
    return (main_time++ % len);
}
int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    VerilatedVcdC *tfp = new VerilatedVcdC;

    Vcounter *top = new Vcounter();
    top->trace(tfp, 0);
    tfp->open("wave.vcd");

    int clk = 1;
    while (sc_time_stamp(20) < 10 && !Verilated::gotFinish()) {
        top->clk = clk;
        top->rst = 0;
        clk = !clk;
        top->eval();
        tfp->dump(main_time);
        std::cout << clk << " ";
    }
    std::cout << std::endl;

    top->final();
    tfp->close();
    delete top;
    delete tfp;
    return 0;
}