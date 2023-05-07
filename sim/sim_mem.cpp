#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>

// #include "VCore.h"
#include "VVpcb.h"
#include "VVpcb__Syms.h"
#include "conf_core.h"
#include "verilated_vcd_c.h"

#define bswap from_le

template <typename T>
static inline T from_le(T n) {
    return n;
}

void sim_mem_write(VVpcb_cache *cache, VL_IN64(addr, 47, 0), size_t length,
                   const void *bytes) {
    // Endian transfer
    // IF the host is Big Endian
#ifdef BIG_ENDIAN_HOST
    for (int i = 0; i < length; i++) {
        cache->writeByte(addr + i, *((unsigned char *)bytes + length - 1 - i));
    }
#else
    for (int i = 0; i < length; i++) {
        cache->writeByte(addr + i, *((unsigned char *)bytes + i));
    }
#endif
}

void sim_mem_load_bin(VVpcb_cache *cache, std::string fn) {
    std::ifstream bpfs(fn, std::ios_base::binary | std::ios::ate);
    int f_length = bpfs.tellg();
    // std::cout << "file size: " << f_length << "\n";
    bpfs.seekg(0, std::ios::beg);
    char c;
    for (int i = 0; i < f_length; i++) {
        bpfs.read(&c, 1);
        sim_mem_write(cache, bswap(i), 1, &c);
    }
    bpfs.close();
}

uint32_t sim_mem_read(VVpcb_cache *cache, uint32_t addr) {
    uint32_t val;
    cache->readByte(addr, val);
    return val;
}