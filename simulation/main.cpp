#include "firmware.hpp"
#include "test_class/test_class.hpp"

TestClass test_class(5);

void main() {
  mcu::init();
  gpio_blink(mcu::gpio, test_class.get());
  test_class.set(test_class.get() + 5);
  gpio_blink(mcu::gpio, test_class.get());
}
