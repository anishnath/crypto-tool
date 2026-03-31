/**
 * Analog Sensor Binding — generic binding for any analog input component.
 *
 * Reusable for: NTC temperature sensor, LDR/photoresistor, slide potentiometer,
 * or any wokwi-element that outputs a numeric value on an ADC channel.
 *
 * The component must emit 'input' events and have a .value property (0–1023).
 */

import { ANALOG_PINS } from '../pin-map.js';

export class AnalogSensorBinding {
  /**
   * @param {HTMLElement} element - wokwi sensor element
   * @param {import('../runner.js').AVRRunner} runner
   * @param {number|string} pin - Arduino analog pin (A0–A5, 14–19, or 0–5 as channel)
   * @param {object} [options]
   * @param {number} [options.min=0] - minimum raw value from element
   * @param {number} [options.max=1023] - maximum raw value from element
   */
  constructor(element, runner, pin, options = {}) {
    this.element = element;
    this.runner = runner;
    this.min = options.min ?? 0;
    this.max = options.max ?? 1023;

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
      const raw = this.element.value ?? 0;
      // Normalize to 0–5V range
      const normalized = (raw - this.min) / (this.max - this.min);
      const voltage = Math.max(0, Math.min(5, normalized * 5.0));
      this.runner.setADCValue(this.channel, voltage);
    };

    this.element.addEventListener('input', onInput);
    onInput();

    this._cleanup = () => {
      this.element.removeEventListener('input', onInput);
    };
  }

  /** Set the sensor value programmatically (e.g. slider UI for temperature) */
  setValue(raw) {
    this.element.value = raw;
    const normalized = (raw - this.min) / (this.max - this.min);
    const voltage = Math.max(0, Math.min(5, normalized * 5.0));
    this.runner.setADCValue(this.channel, voltage);
  }

  detach() {
    if (this._cleanup) this._cleanup();
    this._cleanup = null;
  }
}
