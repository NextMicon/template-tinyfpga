#include "uart/UART.hpp"
#include <stdint.h>

class TestClass {
private:
  uint32_t _data;
  UART* _uart;
public:
  TestClass(uint32_t data, UART* uart) {
    _data = data;
    _uart = uart;
    _uart->print("Constructor called");
  }
  uint32_t get() {
    _uart->print("Get called");
    return _data;
  }
  void set(uint32_t data) {
    _data = data;
    _uart->print("Set called");
  }
};
