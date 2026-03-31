/**
 * LED Binding — connects AVRRunner to <wokwi-led>
 *
 * Supports both digital on/off (GPIO) and PWM brightness (OCR polling).
 */

export class LedBinding {
  constructor(element, runner, pin) {
    this.element = element;
    this.runner = runner;
    this.pin = pin;
    this._cleanups = [];
  }

  attach() {
    const unsub1 = this.runner.addPinChangeListener((pin, high) => {
      if (pin === this.pin) {
        this.element.value = high;
        this.element.brightness = high ? 1.0 : 0;
      }
    });

    const unsub2 = this.runner.addPwmChangeListener((pin, duty) => {
      if (pin === this.pin) {
        this.element.value = duty > 0;
        this.element.brightness = duty / 255;
      }
    });

    this._cleanups = [unsub1, unsub2];
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
    this.element.value = false;
    this.element.brightness = 0;
  }
}
