/**
 * RGB LED Binding — connects <wokwi-rgb-led> to AVRRunner.
 *
 * Supports both digital (on/off) and PWM (analogWrite brightness).
 * Each color channel (R, G, B) maps to a separate Arduino pin.
 */

export class RgbLedBinding {
  /**
   * @param {HTMLElement} element - <wokwi-rgb-led> element
   * @param {import('../runner.js').AVRRunner} runner
   * @param {{r: number, g: number, b: number}} pins - Arduino pin numbers for each channel
   */
  constructor(element, runner, pins) {
    this.element = element;
    this.runner = runner;
    this.pins = pins; // { r: 9, g: 10, b: 11 }
    this._cleanups = [];
  }

  attach() {
    const { r, g, b } = this.pins;
    const el = this.element;

    // Digital fallback
    const unsub1 = this.runner.addPinChangeListener((pin, high) => {
      if (pin === r) el.ledRed = high ? 255 : 0;
      if (pin === g) el.ledGreen = high ? 255 : 0;
      if (pin === b) el.ledBlue = high ? 255 : 0;
    });

    // PWM override (analogWrite)
    const unsub2 = this.runner.addPwmChangeListener((pin, duty) => {
      if (pin === r) el.ledRed = duty;
      if (pin === g) el.ledGreen = duty;
      if (pin === b) el.ledBlue = duty;
    });

    this._cleanups = [unsub1, unsub2];
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
    this.element.ledRed = 0;
    this.element.ledGreen = 0;
    this.element.ledBlue = 0;
  }
}
