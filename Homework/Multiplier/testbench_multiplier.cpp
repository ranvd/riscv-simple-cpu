#include <iostream>
#include <memory>

#include "Vmultiplier.h"
#include "verilated_vcd_c.h"

vluint64_t main_time = 0;

double sc_time_stamp(int len) { return (main_time) % len; }

int main(int argc, char* argv[]) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    VerilatedVcdC* tfp = new VerilatedVcdC();

    std::unique_ptr<Vmultiplier> top(new Vmultiplier);
    top->trace(tfp, 0);
    tfp->open("wave.vcd");

    while (sc_time_stamp(20) < 5 && !Verilated::gotFinish()) {
        // std:: cout << main_time << std::endl;
        top->in_data = -16;
        top->eval();
        tfp->dump(main_time);
        main_time++;

        printf("in_data: %08X\n", top->in_data);
        printf("out_data: %08X\n", top->out_data);
    }
    top->final();
    tfp->close();
    return 0;
}