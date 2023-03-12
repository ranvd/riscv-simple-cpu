#include <string>

#include "VCore.h"

void sim_mem_write(VCore_cache *cache, VL_IN64(addr, 47, 0), size_t length,
                   const void *bytes);
void sim_mem_load_bin(VCore_cache *cache, std::string fn);

void init_regfile(VCore_regfile *regfile, int data[32]);