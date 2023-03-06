#include <string>

#include "VCore.h"

void sim_mem_write(VCore_rom *rom, VL_IN64(addr, 47, 0), size_t length,
                   const void *bytes);
void sim_mem_load_bin(VCore_rom *rom, std::string fn);