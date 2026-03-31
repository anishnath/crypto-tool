/**
 * DHT22 Binding — connects <wokwi-dht22> to AVRRunner.
 *
 * The DHT22 uses a custom 1-wire protocol on a single GPIO pin:
 *   1. MCU pulls pin LOW for ≥1ms (start signal)
 *   2. MCU releases pin (goes HIGH via pull-up)
 *   3. DHT responds: LOW 80µs, HIGH 80µs
 *   4. DHT sends 40 bits (5 bytes): humidity_H, humidity_L, temp_H, temp_L, checksum
 *      - Bit 0: LOW 50µs, HIGH 26-28µs
 *      - Bit 1: LOW 50µs, HIGH 70µs
 *
 * Since we can't easily detect the MCU start signal with GPIO port listeners,
 * we use a simplified approach: expose temperature/humidity as user-adjustable
 * values, and when the sketch reads the pin, we respond with a pre-built
 * pulse sequence using scheduled pin changes.
 *
 * For V1, this is a visual-only placeholder. The <wokwi-dht22> element
 * shows temperature and humidity values that the user can adjust.
 */

export class Dht22Binding {
  /**
   * @param {HTMLElement} element - <wokwi-dht22> element
   * @param {import('../runner.js').AVRRunner} runner
   * @param {number} pin - Arduino digital pin
   */
  constructor(element, runner, pin) {
    this.element = element;
    this.runner = runner;
    this.pin = pin;
    this.temperature = 22.5; // default °C
    this.humidity = 55.0;    // default %
  }

  attach() {
    // Set initial display values on the element
    if (this.element.temperature !== undefined) {
      this.element.temperature = this.temperature;
    }
    if (this.element.humidity !== undefined) {
      this.element.humidity = this.humidity;
    }
  }

  /** Update simulated temperature (°C) */
  setTemperature(t) {
    this.temperature = t;
    if (this.element.temperature !== undefined) {
      this.element.temperature = t;
    }
  }

  /** Update simulated humidity (%) */
  setHumidity(h) {
    this.humidity = h;
    if (this.element.humidity !== undefined) {
      this.element.humidity = h;
    }
  }

  detach() {
    // Nothing to clean up for V1
  }
}
