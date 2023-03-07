#include <assert.h>
#include <stdio.h>

#include <string>

#include "VCore.h"
#include "VCore__Syms.h"
#include "verilated_vcd_c.h"
#include "sim_mem.h"

#define MAX_SIM_CYCLE 20
#define TIME_SLICE 5
vluint64_t main_time = 0;

double sc_time_stamp() { return (main_time); }

int main(int argc,char **argv)
{
    Verilated::commandArgs(argc,argv);
    Verilated::traceEverOn(true); 

    if (argc < 2) {
        printf("Please provide riscv test elf file\n");
        return -1;
    }

    VerilatedVcdC* tfp = new VerilatedVcdC(); 

    VCore *top = new VCore("top");
    top->trace(tfp, 0);
    tfp->open("wave.vcd"); 

    sim_mem_load_bin(top->Core->IF1->rom1, std::string(argv[1]));

    top->rst_i = 1;
    for (int i = 0 ; i < 1 ; i ++){
        top->clk_i = 0;
        top->eval ();
        main_time += TIME_SLICE;
        tfp->dump(main_time);
        top->clk_i = 1;
        top->eval ();
        main_time += TIME_SLICE;
        tfp->dump(main_time);
    }

    top->rst_i = 0;    
    for( int i=0; i<3;i++) {
        top->clk_i=0;
        top->eval();
        main_time +=TIME_SLICE;
        tfp->dump(main_time);
        top->clk_i=1;
        top->eval();
        main_time +=TIME_SLICE;
        tfp->dump(main_time);
    }
    top->rst_i = 1; 
    for( int i=0; i<1;i++) {
        top->clk_i=0;
        top->eval();
        main_time +=TIME_SLICE;
        tfp->dump(main_time);
        top->clk_i=1;
        top->eval();
        main_time +=TIME_SLICE;
        tfp->dump(main_time);
    }
    top->rst_i = 0;    
    for( int i=0; i<3;i++) {
        top->clk_i=0;
        top->eval();
        main_time +=TIME_SLICE;
        tfp->dump(main_time);
        top->clk_i=1;
        top->eval();
        main_time +=TIME_SLICE;
        tfp->dump(main_time);
    }
    top->final();
    tfp->close();
    delete top;
    return 0;
}
