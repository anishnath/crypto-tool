/**
 * Pico Board Binding — connects RP2040Runner to <pico-board>.
 *
 * Drives: led25 (GPIO25 = LED_BUILTIN), ledPower
 */

import { LED_BUILTIN } from '../rp2040-pin-map.js';

export class PicoBoardBinding {
  constructor(element, runner) {
    this.element = element;
    this.runner = runner;
    this._cleanups = [];
  }

  attach() {
    this.element.ledPower = true;

    const unsub = this.runner.addPinChangeListener((pin, high) => {
      if (pin === LED_BUILTIN) this.element.led25 = high;
    });
    this._cleanups.push(unsub);
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
    this.element.ledPower = false;
    this.element.led25 = false;
  }
}
