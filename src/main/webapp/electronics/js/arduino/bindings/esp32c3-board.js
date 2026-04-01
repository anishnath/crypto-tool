/**
 * ESP32-C3 Board Binding — connects ESP32C3Runner to <esp32c3-board>.
 *
 * Drives: led8 (GPIO8 = LED_BUILTIN), ledPower
 */

import { LED_BUILTIN } from '../esp32c3-pin-map.js';

export class ESP32C3BoardBinding {
  constructor(element, runner) {
    this.element = element;
    this.runner = runner;
    this._cleanups = [];
  }

  attach() {
    this.element.ledPower = true;

    const unsub = this.runner.addPinChangeListener((pin, high) => {
      if (pin === LED_BUILTIN) this.element.led8 = high;
    });
    this._cleanups.push(unsub);
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
    this.element.ledPower = false;
    this.element.led8 = false;
  }
}
