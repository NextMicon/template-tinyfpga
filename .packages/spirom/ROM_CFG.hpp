#pragma once
#include "reg.hpp"
#include <stdint.h>

class ROM_CFG : Reg {
public:
  ROM_CFG(volatile uint32_t* addr) : Reg(addr) {}
  void dual_io() { Reg::set((Reg::get() & ~0x007F0000) | 0x00400000); };
};
