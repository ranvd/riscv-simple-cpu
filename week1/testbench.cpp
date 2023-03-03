#include <iostream>
#include <memory>

#include "Vadder4.h"
#include "verilated_vcd_c.h"

vluint64_t main_time = 0;

double sc_time_stamp(int len) { return (main_time % len); }

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    // std::unique_ptr<VerilatedVcd> top = VerilatedVcd();
    VerilatedVcdC *tfp = new VerilatedVcdC;
    

    Vadder4 *top = new Vadder4("top");
    top->trace(tfp, 0);
    tfp->open("wave.vcd");

    
    while (sc_time_stamp(20) < 19 && !Verilated::gotFinish()) {
        int a = rand() & 0xF;
        int b = rand() & 0xF;
        top->a = a;
        top->b = b;
        top->c_in = 0;
        top->eval();
        std::cout << top->adder4->fa1->writeByte() <<std::endl;
        printf("time=%ld, a = %d, b = %d, sum = %d\n", main_time, a, b,
               top->sum);
        tfp->dump(main_time);
        main_time++;
    }
    top->final();
    tfp->close();
    delete top;
    return 0;
    // std::unique_ptr<Vadder> dut(new Vadder);
    // dut
}