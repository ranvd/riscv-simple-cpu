#include <iostream>
#include <memory>

#include "Vmux.h"
#include "verilated_vcd_c.h"

vluint64_t main_time = 0;

double sc_time_stamp(int len) { return (main_time++) % len; }

int main(int argc, char* argv[]) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    VerilatedVcdC* tfp = new VerilatedVcdC();

    std::unique_ptr<Vmux> top(new Vmux);
    top->trace(tfp, 0);
    tfp->open("wave.vcd");

    top->a_i = 0;
    top->b_i = 1;
    top->c_i = 0;
    top->d_i = 1;

    while (sc_time_stamp(20) < 19 && !Verilated::gotFinish()) {
        top->sel_i = rand() % 0x3;
        top->eval();
        printf("Time=%ld, a = %d, b = %d, c=%d, d=%d, sel_i=%d, q_o=%d\n",
               main_time, top->a_i, top->b_i, top->c_i, top->d_i, top->sel_i,
               top->out);
        tfp->dump(main_time);
    }
    top->final();
    tfp->close();
    return 0;
}