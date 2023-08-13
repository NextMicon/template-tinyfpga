#pragma once
#include "reg.hpp"
#include <stdint.h>

class Counter : Reg {
public:
  Counter(volatile uint32_t* addr) : Reg(addr) {}
  void set(uint32_t clk) { Reg::set(clk); }
};
