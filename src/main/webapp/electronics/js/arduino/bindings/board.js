/**
 * Board Binding — connects AVRRunner to <wokwi-arduino-uno>
 *
 * Drives: led13, ledPower, ledRX, ledTX, reset button
 */

export class BoardBinding {
  constructor(element, runner) {
    this.element = element;
    this.runner = runner;
    this._cleanups = [];
  }

  attach() {
    this.element.ledPower = true;

    // LED13 — pin 13 (portB bit 5)
    const unsub = this.runner.addPinChangeListener((pin, high) => {
      if (pin === 13) this.element.led13 = high;
    });
    this._cleanups.push(unsub);

    // Reset button on the board SVG
    const onReset = () => {
      this.runner.reset();
      this.element.led13 = false;
    };
    this.element.addEventListener('reset-pressed', onReset);
    this._cleanups.push(() => this.element.removeEventListener('reset-pressed', onReset));
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
    this.element.ledPower = false;
    this.element.led13 = false;
  }
}
