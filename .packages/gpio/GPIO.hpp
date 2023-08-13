#pragma once
#include "reg.hpp"
#include <stdint.h>

class GPIO : Reg {
  enum Regs {
    Reg_IOSEL = 0,
    Reg_OUT = 1,
    Reg_IN = 2
  };
public:
  enum Mode {
    IN = 0,
    OUT = 1
  };
  GPIO(volatile uint32_t* addr) : Reg(addr) {}
  void mode(Mode mode) { Reg::set(Reg_IOSEL, mode); }
  void write(uint32_t val) { Reg::set(Reg_OUT, val); }
  void on() { write(1); }
  void off() { write(0); }
  uint32_t read() { return Reg::get(Reg_IN); }
};

void gpio_blink(GPIO& gpio_out, uint32_t rpt = 5, uint32_t delay_ms = 500);
void gpio_test(GPIO& gpio_out, GPIO& gpio_in, uint32_t time = 0x1'0000);
