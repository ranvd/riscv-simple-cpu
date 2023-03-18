#include <assert.h>
#include <stdio.h>

#include <iostream>
#include <string>

#include "VCore.h"
#include "VCore__Syms.h"
#include "conf_testbench.h"
#include "sim_mem.h"
#include "verilated_vcd_c.h"

#define MAX_SIM_CYCLE 20
#define TIME_SLICE 1

vluint64_t main_time = 0;

double sc_time_stamp() { return (main_time); }

void Vclocks(VCore *top, VerilatedVcdC *tfp, int n) {
    for (int i = 0; i < n; i++) {
        top->clk_i = 0;
        top->eval();
        main_time += TIME_SLICE;
        tfp->dump(main_time);

        top->clk_i = 1;
        top->eval();
        main_time += TIME_SLICE;
        tfp->dump(main_time);

#ifdef TRACE_REGs
        /*
         * "\033[1;32m" will set the terminal color to green
         * "\033[0m\n" will reset the terminal color.
         * \033 equal \e which means ESC in the keyboard.
         */
        VlUnpacked<unsigned int, 32> regVal;
        std::cout << "-------------" << main_time << "-------------"
                  << std::endl;
        top->Core->regfile1->readRegs(regVal);
        for (int reg = 0; reg < 32; reg++) {
            if (regVal[reg]) {
                if (reg / 10)
                    printf("X%d: \033[1;32m0x%08X\033[0m\n", reg, regVal[reg]);
                else
                    printf("X%d:  \033[1;32m0x%08X\033[0m\n", reg, regVal[reg]);
            } else {
                if (reg / 10)
                    printf("X%d: 0x%08X\n", reg, regVal[reg]);
                else
                    printf("X%d:  0x%08X\n", reg, regVal[reg]);
            }
        }
        std::cout << "|||||||||||||||||||||||||||||||||||\n";
#endif
    }
}

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    if (argc < 2) {
        printf("Please provide riscv test elf file\n");
        return -1;
    }

    VerilatedVcdC *tfp = new VerilatedVcdC();

    VCore *top = new VCore("top");
    top->trace(tfp, 0);
    tfp->open("wave.vcd");

    int regfile[32];
    for (int i = 0; i < 32; i++) {
        regfile[i] = i;
    }
    sim_mem_load_bin(top->Core->IF1->instr_cache1, std::string(argv[1]));
    sim_mem_load_bin(top->Core->MEM1->data_cache1, std::string(argv[1]));
    // init_regfile(top->Core->regfile1, regfile);

    top->rst_i = 1;

    Vclocks(top, tfp, 1);

    top->rst_i = 0;
    Vclocks(top, tfp, 20);

#ifdef END_REGs
        /*
         * "\033[1;32m" will set the terminal color to green
         * "\033[0m\n" will reset the terminal color.
         * \033 equal \e which means ESC in the keyboard.
         */
        VlUnpacked<unsigned int, 32> regVal;
        std::cout << "-------------" << main_time << "-------------"
                  << std::endl;
        top->Core->regfile1->readRegs(regVal);
        for (int reg = 0; reg < 32; reg++) {
            if (regVal[reg]) {
                if (reg / 10)
                    printf("X%d: \033[1;32m0x%08X\033[0m\n", reg, regVal[reg]);
                else
                    printf("X%d:  \033[1;32m0x%08X\033[0m\n", reg, regVal[reg]);
            } else {
                if (reg / 10)
                    printf("X%d: 0x%08X\n", reg, regVal[reg]);
                else
                    printf("X%d:  0x%08X\n", reg, regVal[reg]);
            }
        }
        std::cout << "|||||||||||||||||||||||||||||||||||\n";
#endif
    int base = 0x1c;
    printf("read data cache: %x\n", sim_mem_read(top->Core->MEM1->data_cache1 , base));
    printf("read data cache: %x\n", sim_mem_read(top->Core->MEM1->data_cache1, base+1));
    printf("read data cache: %x\n", sim_mem_read(top->Core->MEM1->data_cache1, base+2));
    printf("read data cache: %x\n", sim_mem_read(top->Core->MEM1->data_cache1, base+3));
    top->final();
    tfp->close();

    delete top;
    delete tfp;
    return 0;
}
