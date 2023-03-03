#include <string>

#include "VIF.h"

void sim_mem_write(VIF_rom *rom, VL_IN64(addr, 47, 0), size_t length,
                   const void *bytes);
void sim_mem_load_bin(VIF_rom *rom, std::string fn);