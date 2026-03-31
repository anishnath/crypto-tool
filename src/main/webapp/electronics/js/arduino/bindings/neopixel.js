/**
 * NeoPixel Binding — connects <wokwi-neopixel> to AVRRunner.
 *
 * WS2812B protocol: 800KHz bit-banged on a single GPIO pin.
 *   - Bit 0: HIGH ~400ns, LOW ~850ns
 *   - Bit 1: HIGH ~800ns, LOW ~450ns
 *   - Reset: LOW > 50µs
 *
 * At 16MHz, 1 cycle = 62.5ns:
 *   - Bit 0 HIGH: ~6 cycles,  LOW: ~14 cycles
 *   - Bit 1 HIGH: ~13 cycles, LOW: ~7 cycles
 *   - Threshold: ~10 cycles HIGH = bit boundary
 *
 * This binding monitors pin transitions to decode the bit stream.
 * Each pixel is 24 bits (GRB order): G7..G0, R7..R0, B7..B0.
 */

const CPU_HZ = 16_000_000;
const NS_PER_CYCLE = 1_000_000_000 / CPU_HZ; // 62.5ns
const THRESHOLD_CYCLES = 10; // ~625ns — bit 0/1 boundary
const RESET_CYCLES = 800;    // ~50µs LOW = reset

export class NeoPixelBinding {
  /**
   * @param {HTMLElement|HTMLElement[]} elements - <wokwi-neopixel> element(s) — single or array
   * @param {import('../runner.js').AVRRunner} runner
   * @param {number} pin - Arduino digital pin
   * @param {number} [numPixels=1] - number of pixels in the strip
   */
  constructor(elements, runner, pin, numPixels = 1) {
    this.elements = Array.isArray(elements) ? elements : [elements];
    this.runner = runner;
    this.pin = pin;
    this.numPixels = numPixels;

    this._bits = [];
    this._lastRise = 0;
    this._lastFall = -RESET_CYCLES - 1; // prevent false reset on first edge
    this._cleanups = [];
  }

  attach() {
    const unsub = this.runner.addPinChangeListener((pin, high) => {
      if (pin !== this.pin) return;

      const cycles = this.runner.cpu.cycles;

      if (high) {
        // Rising edge
        const lowDuration = cycles - this._lastFall;
        if (lowDuration > RESET_CYCLES && this._bits.length > 0) {
          // Reset — process accumulated bits
          this._processBits();
          this._bits = [];
        }
        this._lastRise = cycles;
      } else {
        // Falling edge — measure HIGH duration
        const highDuration = cycles - this._lastRise;
        this._bits.push(highDuration > THRESHOLD_CYCLES ? 1 : 0);
        this._lastFall = cycles;
      }
    });
    this._cleanups = [unsub];
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
    for (const el of this.elements) {
      el.r = 0; el.g = 0; el.b = 0;
    }
  }

  _processBits() {
    // Convert bits to bytes (GRB order, MSB first)
    const bytes = [];
    for (let i = 0; i + 7 < this._bits.length; i += 8) {
      let byte = 0;
      for (let b = 0; b < 8; b++) {
        byte = (byte << 1) | this._bits[i + b];
      }
      bytes.push(byte);
    }

    // Each pixel = 3 bytes (G, R, B)
    for (let px = 0; px < this.numPixels && px * 3 + 2 < bytes.length; px++) {
      const g = bytes[px * 3];
      const r = bytes[px * 3 + 1];
      const b = bytes[px * 3 + 2];

      if (px < this.elements.length) {
        const el = this.elements[px];
        el.r = r / 255; el.g = g / 255; el.b = b / 255;
      }
    }
  }
}
