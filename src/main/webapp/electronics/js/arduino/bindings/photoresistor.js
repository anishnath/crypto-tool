/**
 * Photoresistor (LDR) Binding — connects <wokwi-photoresistor-sensor> to AVRRunner ADC.
 *
 * Reuses the same pattern as potentiometer — user adjusts light level,
 * value maps to ADC voltage.
 */

import { ANALOG_PINS } from '../pin-map.js';

export class PhotoresistorBinding {
  constructor(element, runner, pin) {
    this.element = element;
    this.runner = runner;

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
      const raw = this.element.value || 0;
      const vRef = this.runner.vRef || 5.0;
      const voltage = (raw / 1023) * vRef;
      this.runner.setADCValue(this.channel, voltage);
    };

    this.element.addEventListener('input', onInput);
    onInput();

    this._cleanup = () => this.element.removeEventListener('input', onInput);
  }

  detach() {
    if (this._cleanup) this._cleanup();
    this._cleanup = null;
  }
}
