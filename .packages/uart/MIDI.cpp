#include "MIDI.hpp"
#include "cpu.hpp"

// Receive

char MIDI::read() {
  int32_t c = -1;
  uint32_t cycles_begin, cycles_now, cycles;

  cycles_begin = rdcycle_l();
  while(c == -1) {
    cycles_now = rdcycle_l();
    cycles = cycles_now - cycles_begin;
    if(cycles > 12000000) {
      cycles_begin = cycles_now;
    }
    c = get(1);
  }
  return c;
}
