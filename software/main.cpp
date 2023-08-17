#include "firmware.hpp"

void init() {
  static const char* kanade_micon
      = "   _  __                  _       __  __ _             \n"
        "  | |/ /__ _ _ _  __ _ __| |___  |  \\/  (_)__ ___ _ _  \n"
        "  | ' </ _` | ' \\/ _` / _` / -_) | |\\/| | / _/ _ \\ ' \\ \n"
        "  |_|\\_\\__,_|_||_\\__,_\\__,_\\___| |_|  |_|_\\__\\___/_||_|\n";
  set_irq_mask(0);
  uart.baud(460800);
  gpio.mode(GPIO::Mode::OUT);
  uart << kanade_micon << "\n"
       << " 32bit RISC-V Microcontroller @kanade_k_1228 " << __DATE__ << "\n\n";
}

void loop() {
  char cmd = uart.read();
  if(cmd == '\n') {
    uart << "Blink LED\n";
    gpio_blink(gpio);
  }
}

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
