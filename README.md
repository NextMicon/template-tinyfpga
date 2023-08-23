# template-tinyfpga

## [GPIO](.packages/gpio/)

![](.packages/gpio/img/gpio.dio.svg)

- `void mode(Mode)`
  - `Mode::IN`
  - `Mode::OUT`
- `uint32_t read()`
- `void write(uint32_t)`

## [PWM](.packages/pwm/)

![](.packages/pwm/img/pwm.dio.svg)

- `void duty(uint32_t)`

## [UART](.packages/uart/)

![](.packages/uart/img/uart.dio.svg)

### MIDI

### PWM

## [RAM](.packages/ram/)

## [SPI ROM](.packages/spirom/)

### ROM_CFG

- `void dual_io()`

## [Random](.packages/random/)

32bit LFSR : 32,22,2,1

参考：http://zakii.la.coocan.jp/signal/41_lfsr.htm

## [Counter](.packages/counter/)

## [Oscilator](.packages/oscilator/)

## [Mixier](.packages/mixier/)

![](.packages/mixier/img/mixier.dio.svg)

8bit 入力をシフトして加算します．
出力は上位 12 ビットを見ます．

### `Mixier`

- `void set_vol(uint32_t ch, uint32_t vol)`

## [SPI DAC](.packages/spidac/)
