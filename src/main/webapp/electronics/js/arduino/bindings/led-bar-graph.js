/**
 * LED Bar Graph Binding — connects <wokwi-led-bar-graph> to AVRRunner.
 *
 * The bar graph has 10 LEDs, each connected to a digital pin.
 * Tracks GPIO state for each pin and updates the element's values array.
 */

export class LedBarGraphBinding {
  /**
   * @param {HTMLElement} element - <wokwi-led-bar-graph>
   * @param {import('../runner.js').AVRRunner} runner
   * @param {number[]} pins - Array of 10 Arduino pin numbers (index 0 = bottom LED)
   */
  constructor(element, runner, pins) {
    this.element = element;
    this.runner = runner;
    this.pins = pins; // e.g. [2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    this._values = new Array(10).fill(false);
    this._cleanups = [];
  }

  attach() {
    const pinSet = new Set(this.pins);

    const unsub = this.runner.addPinChangeListener((pin, high) => {
      if (!pinSet.has(pin)) return;
      const idx = this.pins.indexOf(pin);
      if (idx >= 0) {
        this._values[idx] = high;
        this._update();
      }
    });

    this._cleanups = [unsub];
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
    this._values.fill(false);
    this._update();
  }

  _update() {
    // wokwi-led-bar-graph expects .values as an array of booleans or numbers
    this.element.values = [...this._values];
  }
}
