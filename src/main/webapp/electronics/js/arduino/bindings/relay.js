/**
 * Relay Binding — connects <wokwi-ks2e-m-dc5> to AVRRunner.
 *
 * Simple digital output: pin HIGH = relay energized (coil on),
 * pin LOW = relay de-energized.
 */

export class RelayBinding {
  constructor(element, runner, pin) {
    this.element = element;
    this.runner = runner;
    this.pin = pin;
    this._cleanups = [];
  }

  attach() {
    const unsub = this.runner.addPinChangeListener((pin, high) => {
      if (pin === this.pin) {
        this.element.energized = high;
      }
    });

    this._cleanups = [unsub];
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
    this.element.energized = false;
  }
}
