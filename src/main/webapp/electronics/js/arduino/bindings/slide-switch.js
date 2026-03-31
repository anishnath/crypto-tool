/**
 * Slide Switch Binding — connects <wokwi-slide-switch> to AVRRunner.
 *
 * Toggles between HIGH and LOW on each change event.
 */

export class SlideSwitchBinding {
  constructor(element, runner, pin) {
    this.element = element;
    this.runner = runner;
    this.pin = pin;
    this._cleanups = [];
  }

  attach() {
    const update = () => {
      const state = this.element.value === 1;
      this.runner.setPinState(this.pin, state);
    };

    this.element.addEventListener('change', update);
    update(); // set initial state

    this._cleanups = [() => this.element.removeEventListener('change', update)];
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
  }
}
