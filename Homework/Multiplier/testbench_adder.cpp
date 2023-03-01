#include <iostream>
#include <memory>

#include "Vadder.h"
#include "verilated_vcd_c.h"

vluint64_t main_time = 0;

double sc_time_stamp(int len) { return (main_time) % len; }

int main(int argc, char* argv[]) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    VerilatedVcdC* tfp = new VerilatedVcdC();

    std::unique_ptr<Vadder> top(new Vadder);
    top->trace(tfp, 0);
    tfp->open("wave.vcd");

    while (sc_time_stamp(20) < 19 && !Verilated::gotFinish()) {
        // std:: cout << main_time << std::endl;
        top->a_i = rand() % 0x16;
        top->b_i = rand() % 0x16 << 1;
        top->c_i = rand() % 0x16 << 2;
        top->eval();
        tfp->dump(main_time);
        main_time++;
    }
    top->final();
    tfp->close();
    return 0;
}