#pragma once
#include "reg.hpp"
#include <stdint.h>

class Selector : public Reg {
public:
  void select(uint32_t ch) { set(0b1 << ch); }
  void unselect() { set(0); }
};
