/**
 * Raspberry Pi Pico (RP2040) Pin Mapping
 *
 * Arduino-pico (Earle Philhower) pin mapping:
 *   D0 = GPIO0  … D29 = GPIO29
 *   A0 = GPIO26 … A3 = GPIO29
 *   LED_BUILTIN = GPIO25
 *
 * Default peripherals:
 *   UART0: GPIO0 (TX), GPIO1 (RX)
 *   I2C0:  GPIO4 (SDA), GPIO5 (SCL)
 *   SPI0:  GPIO16 (MISO), GPIO19 (MOSI), GPIO18 (SCK), GPIO17 (CS)
 *
 * PWM: any GPIO can do PWM (16 slices × 2 channels)
 */

/** Total GPIO count on RP2040 */
export const GPIO_COUNT = 30;

/** LED_BUILTIN pin */
export const LED_BUILTIN = 25;

/** Arduino analog pin mapping: A0–A3 → GPIO26–29 (ADC channels 0–3) */
export const RP2040_ANALOG_PINS = {
  A0: { gpio: 26, channel: 0 },
  A1: { gpio: 27, channel: 1 },
  A2: { gpio: 28, channel: 2 },
  A3: { gpio: 29, channel: 3 },
  // Numeric aliases (Arduino pin 26–29)
  26: { gpio: 26, channel: 0 },
  27: { gpio: 27, channel: 1 },
  28: { gpio: 28, channel: 2 },
  29: { gpio: 29, channel: 3 },
};

/** Internal temperature sensor is ADC channel 4 */
export const TEMP_SENSOR_CHANNEL = 4;

/** Default UART0 pins */
export const UART0_TX = 0;
export const UART0_RX = 1;

/** Default I2C0 pins */
export const I2C0_SDA = 4;
export const I2C0_SCL = 5;

/** Default SPI0 pins */
export const SPI0_MISO = 16;
export const SPI0_MOSI = 19;
export const SPI0_SCK = 18;
export const SPI0_CS = 17;

/**
 * All 30 GPIO pins. On RP2040, every GPIO pin supports:
 *   - Digital I/O
 *   - PWM (any pin)
 *   - PIO (programmable I/O)
 */
export const RP2040_PINS = Array.from({ length: GPIO_COUNT }, (_, i) => ({
  gpio: i,
  label: i === LED_BUILTIN ? `D${i} (LED)` :
         i === UART0_TX ? `D${i} (TX)` :
         i === UART0_RX ? `D${i} (RX)` :
         i >= 26 && i <= 29 ? `A${i - 26} / D${i}` :
         `D${i}`,
}));
