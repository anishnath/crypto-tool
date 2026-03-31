/**
 * Button Binding — connects <wokwi-pushbutton> to AVRRunner GPIO input.
 *
 * When user clicks/holds the button, pulls the pin LOW (INPUT_PULLUP pattern).
 * On release, pin returns HIGH (pull-up).
 */

import { PIN_MAP } from '../pin-map.js';

export class ButtonBinding {
  /**
   * @param {HTMLElement} element - <wokwi-pushbutton> element
   * @param {import('../runner.js').AVRRunner} runner
   * @param {number} pin - Arduino pin number
   */
  constructor(element, runner, pin) {
    this.element = element;
    this.runner = runner;
    this.pin = pin;
    this._cleanups = [];
  }

  attach() {
    const mapping = PIN_MAP[this.pin];
    if (!mapping) return;

    const onPress = () => {
      this.runner.setPinState(this.pin, false); // Pull LOW (button connects to GND)
    };
    const onRelease = () => {
      this.runner.setPinState(this.pin, true); // Pull-up returns HIGH
    };

    this.element.addEventListener('button-press', onPress);
    this.element.addEventListener('button-release', onRelease);

    this._cleanups = [
      () => this.element.removeEventListener('button-press', onPress),
      () => this.element.removeEventListener('button-release', onRelease),
    ];

    // Start HIGH (pull-up default)
    this.runner.setPinState(this.pin, true);
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
  }
}
