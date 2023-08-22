#include "firmware.hpp"
#include "test_class/test_class.hpp"

void init() {
  gpio_blink(gpio);
}

void loop() {}

uint32_t* irq(uint32_t* regs, uint32_t irqs) {
  static uint32_t irq_counts[32] = {0};
  uart << "\nIRQ:";
  for(uint32_t i = 0; i < 32; ++i) {
    if((irqs & (1 << i)) != 0) {
      ++irq_counts[i];
      uart << " #" << i << "*" << irq_counts[i];
    }
  }
  uart << "\n";
  return regs;
}
