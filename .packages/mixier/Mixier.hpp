#pragma once
#include "reg.hpp"
#include <stdint.h>

class Mixier : Reg {
public:
  Mixier(volatile uint32_t* addr) : Reg(addr) {}
  // vol = 0 ~ 16
  void set_vol(uint32_t ch, uint32_t vol) {
    if(0 <= ch && ch < 8) set(ch, vol);
  }
};
