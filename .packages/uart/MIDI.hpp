#pragma once
#include "cpu.hpp"
#include "reg.hpp"
#include <stdint.h>

class MIDI : public Reg {
public:
  static const char endl = '\n';

  void baud(int baudrate = 31250) { set(0, CLK_FREQ / baudrate); }

  char read();
};
