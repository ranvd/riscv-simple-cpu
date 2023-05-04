#include"verilated_vcd_c.h"
#include "Vmul_32.h"

vluint64_t main_time = 0;

void clock(Vmul_32 *top, VerilatedVcdC *tfp, int n){
    for (int i =0; i < n; i++){
        top->clk_i = 1;
        top->eval();
        main_time += 1;
        tfp->dump(main_time);

        top->clk_i = 0;
        top->eval();
        main_time += 1;
        tfp->dump(main_time);
    }
    return;
}

int main(){
    // Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true); 
    VerilatedVcdC *tfp = new VerilatedVcdC();

    Vmul_32 *top = new Vmul_32();
    top->trace(tfp, 0);
    tfp->open("wave.vcd");

    top->ce_i = 0;
    clock(top, tfp, 2);
    
    for (int i= 0 ;i < 6; i++){
        top->ce_i = 1;
        top->rs1_i = 1431655765;
        top->rs2_i = 196221;
        clock(top, tfp, 1);
        if (top->ready_o){
            printf("value: %ld\n", top->result_o);
        } else {
            printf("no done yet\n");
        }
    }

    top->final();
    tfp->close();
    delete top;
    delete tfp;

}