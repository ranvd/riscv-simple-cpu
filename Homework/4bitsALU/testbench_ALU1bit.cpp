#include <iostream>
#include <memory>

#include "VALU1bit.h"
#include "verilated_vcd_c.h"

vluint64_t main_time = 0;

double sc_time_stamp(int len) { return (main_time++) % len; }

int main(int argc, char* argv[]) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    VerilatedVcdC* tfp = new VerilatedVcdC();

    std::unique_ptr<VALU1bit> top(new VALU1bit);
    top->trace(tfp, 0);
    tfp->open("wave.vcd");

    while (sc_time_stamp(20) < 19 && !Verilated::gotFinish()) {
        top->a_i = rand() % 0x2;
        top->b_i = rand() % 0x2;
        top->c_i = rand() % 0x2;
        top->op = rand() % 0x4;
        top->eval();
        printf("Time=%ld, a = %d, b = %d, c=%d, op=%d\n", main_time, top->a_i,
               top->b_i, top->c_i, top->op);
        tfp->dump(main_time);
    }
    top->final();
    tfp->close();
    return 0;
}