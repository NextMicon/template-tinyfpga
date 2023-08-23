#pragma once
#include "reg.hpp"
#include <stdint.h>

class PWM : public Reg {
public:
  void duty(uint32_t val) { set(val); }
};

void pwm_blink(PWM& pwm_out, uint32_t rpt = 5, uint32_t delay_us = 1000);
