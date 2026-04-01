/**
 * ESP32-C3 Pin Mapping
 *
 * ESP32-C3 is a single-core RISC-V (RV32IMC) MCU with:
 *   - 22 GPIO pins (GPIO0–GPIO21)
 *   - 6 ADC channels (GPIO0–GPIO4 on ADC1, GPIO5 on ADC2)
 *   - 2 UART, 1 I2C, 1 SPI
 *   - All GPIOs support PWM via LEDC (6 channels)
 *   - 3.3V logic, 12-bit ADC
 *
 * Arduino-ESP32 core pin mapping:
 *   D0 = GPIO0  … D21 = GPIO21
 *   A0 = GPIO0  … A4 = GPIO4  (ADC1 channels 0–4)
 *   A5 = GPIO5  (ADC2 channel 0)
 *   LED_BUILTIN = GPIO8 (on most ESP32-C3 dev boards)
 *
 * Default peripherals (ESP32-C3-DevKitM-1):
 *   UART0: GPIO21 (TX), GPIO20 (RX) — USB-JTAG/Serial
 *   I2C0:  GPIO8 (SDA), GPIO9 (SCL)
 *   SPI2:  GPIO2 (MISO), GPIO7 (MOSI), GPIO6 (SCK), GPIO10 (CS)
 */

/** Total usable GPIO count on ESP32-C3 */
export const GPIO_COUNT = 22;

/** LED_BUILTIN pin (GPIO8 on most C3 dev boards) */
export const LED_BUILTIN = 8;

/**
 * Arduino analog pin mapping: A0–A4 → GPIO0–4 (ADC1), A5 → GPIO5 (ADC2)
 * ESP32-C3 ADC: 12-bit, 0–3.3V (with default 11dB attenuation)
 */
export const ESP32C3_ANALOG_PINS = {
  A0: { gpio: 0, channel: 0, unit: 1 },
  A1: { gpio: 1, channel: 1, unit: 1 },
  A2: { gpio: 2, channel: 2, unit: 1 },
  A3: { gpio: 3, channel: 3, unit: 1 },
  A4: { gpio: 4, channel: 4, unit: 1 },
  A5: { gpio: 5, channel: 0, unit: 2 },
  // Numeric aliases
  0: { gpio: 0, channel: 0, unit: 1 },
  1: { gpio: 1, channel: 1, unit: 1 },
  2: { gpio: 2, channel: 2, unit: 1 },
  3: { gpio: 3, channel: 3, unit: 1 },
  4: { gpio: 4, channel: 4, unit: 1 },
  5: { gpio: 5, channel: 0, unit: 2 },
};

/** Internal temperature sensor (ADC channel, reported as separate) */
export const TEMP_SENSOR_CHANNEL = 6;

/** Default UART0 pins (USB-Serial) */
export const UART0_TX = 21;
export const UART0_RX = 20;

/** Default UART1 pins */
export const UART1_TX = 0;
export const UART1_RX = 1;

/** Default I2C0 pins */
export const I2C0_SDA = 8;
export const I2C0_SCL = 9;

/** Default SPI2 pins */
export const SPI2_MISO = 2;
export const SPI2_MOSI = 7;
export const SPI2_SCK = 6;
export const SPI2_CS = 10;

/** Boot-mode strapping pins (active during reset) */
export const STRAPPING_PINS = [2, 8, 9];

/**
 * All 22 GPIO pins with labels.
 * On ESP32-C3, every GPIO supports digital I/O and PWM (via LEDC).
 * GPIO0–GPIO5 additionally support ADC input.
 */
export const ESP32C3_PINS = Array.from({ length: GPIO_COUNT }, (_, i) => ({
  gpio: i,
  label: i === LED_BUILTIN ? `D${i} (LED)` :
         i === UART0_TX ? `D${i} (TX0)` :
         i === UART0_RX ? `D${i} (RX0)` :
         i <= 4 ? `A${i} / D${i}` :
         i === 5 ? `A5 / D${i}` :
         `D${i}`,
}));
