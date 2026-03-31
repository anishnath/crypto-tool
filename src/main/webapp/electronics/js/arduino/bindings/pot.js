/**
 * Potentiometer Binding — connects <wokwi-potentiometer> to AVRRunner ADC.
 *
 * Drag the knob → value 0–1023 → fed into AVRADC channel as voltage 0–5V.
 * Also works with <wokwi-slide-potentiometer>.
 */

import { ANALOG_PINS } from '../pin-map.js';

export class PotBinding {
  /**
   * @param {HTMLElement} element - <wokwi-potentiometer> or <wokwi-slide-potentiometer>
   * @param {import('../runner.js').AVRRunner} runner
   * @param {number|string} pin - Arduino analog pin (A0–A5, or 14–19, or 0–5 as channel)
   */
  constructor(element, runner, pin) {
    this.element = element;
    this.runner = runner;

    // Resolve pin to ADC channel number (0–5)
    if (typeof pin === 'string' && pin.startsWith('A')) {
      this.channel = ANALOG_PINS[pin];
    } else {
      const n = Number(pin);
      this.channel = n >= 14 ? ANALOG_PINS[n] : n;
    }

    this._cleanup = null;
  }

  attach() {
    const onInput = () => {
      // wokwi-potentiometer .value is 0–1023 (or custom min/max)
      const raw = this.element.value || 0;
      // Convert to voltage: 0–1023 maps to 0–5V
      const voltage = (raw / 1023) * 5.0;
      this.runner.setADCValue(this.channel, voltage);
    };

    // Listen for input events (drag)
    this.element.addEventListener('input', onInput);

    // Set initial value
    onInput();

    this._cleanup = () => {
      this.element.removeEventListener('input', onInput);
    };
  }

  detach() {
    if (this._cleanup) this._cleanup();
    this._cleanup = null;
  }
}
