#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>

#include "VCore.h"
#include "VCore__Syms.h"
#include "verilated_vcd_c.h"

#define bswap from_le

template <typename T>
static inline T from_le(T n) {
    return n;
}


void sim_mem_write(VCore_rom *rom, VL_IN64(addr, 47, 0), size_t length,
                   const void *bytes) {
    // Endian transfer
    for (int i = 0; i < length; i += 4) {
        rom->writeByte(addr + i, *((unsigned char *)bytes + i + 3));
        rom->writeByte(addr + i + 1, *((unsigned char *)bytes + i + 2));
        rom->writeByte(addr + i + 2, *((unsigned char *)bytes + i + 1));
        rom->writeByte(addr + i + 3, *((unsigned char *)bytes + i + 0));
    }
}

void sim_mem_load_bin(VCore_rom *rom, std::string fn) {
    std::ifstream bpfs(fn, std::ios_base::binary | std::ios::ate);
    std::ifstream::pos_type pos = bpfs.tellg();
    int f_length = pos;
    char *buf = new char[f_length];
    bpfs.seekg(0, std::ios::beg);
    bpfs.read(buf, f_length);
    bpfs.close();
    std::cout << "file size: %d\n" << f_length;

    for (int i = 0; i < f_length; i += 4) {
        sim_mem_write(rom, bswap(i), 4, (uint8_t *)buf + i);
    }
}