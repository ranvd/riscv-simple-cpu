#include <string>

#include "VVpcb.h"
#include "VVpcb__Syms.h"

void sim_mem_write(VVpcb_cache *cache, VL_IN64(addr, 47, 0), size_t length,
                   const void *bytes);
void sim_mem_load_bin(VVpcb_cache *cache, std::string fn);

// void init_regfile(VCore_regfile *regfile, int data[32]);

uint32_t sim_mem_read(VVpcb_cache *cache, uint32_t addr);