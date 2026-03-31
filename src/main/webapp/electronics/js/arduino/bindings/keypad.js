/**
 * Keypad Binding — connects <wokwi-membrane-keypad> to AVRRunner.
 *
 * 4×4 matrix keypad uses 8 GPIO pins: 4 rows (outputs) + 4 columns (inputs).
 * Arduino scans by driving one row LOW at a time and reading columns.
 * When a key is pressed and its row is LOW, we pull the column LOW.
 */

const KEYMAP_4x4 = [
  ['1', '2', '3', 'A'],
  ['4', '5', '6', 'B'],
  ['7', '8', '9', 'C'],
  ['*', '0', '#', 'D'],
];

export class KeypadBinding {
  /**
   * @param {HTMLElement} element - <wokwi-membrane-keypad>
   * @param {import('../runner.js').AVRRunner} runner
   * @param {object} pins - { rows: [r0,r1,r2,r3], cols: [c0,c1,c2,c3] }
   */
  constructor(element, runner, pins) {
    this.element = element;
    this.runner = runner;
    this.rowPins = pins.rows;
    this.colPins = pins.cols;
    this._pressedKeys = new Set();
    this._rowStates = new Array(4).fill(true); // true = HIGH (not scanning)
    this._cleanups = [];
  }

  attach() {
    // Track which rows the MCU drives LOW (scanning)
    const rowSet = new Set(this.rowPins);
    const unsubPin = this.runner.addPinChangeListener((pin, high) => {
      if (rowSet.has(pin)) {
        const idx = this.rowPins.indexOf(pin);
        if (idx >= 0) {
          this._rowStates[idx] = high;
          this._updateColumns();
        }
      }
    });
    this._cleanups.push(unsubPin);

    // Track key presses from the wokwi element
    const onPress = (e) => {
      const key = e.detail?.key || e.detail;
      if (key) { this._pressedKeys.add(key); this._updateColumns(); }
    };
    const onRelease = (e) => {
      const key = e.detail?.key || e.detail;
      if (key) { this._pressedKeys.delete(key); this._updateColumns(); }
    };

    this.element.addEventListener('button-press', onPress);
    this.element.addEventListener('button-release', onRelease);
    this._cleanups.push(
      () => this.element.removeEventListener('button-press', onPress),
      () => this.element.removeEventListener('button-release', onRelease),
    );
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
    this._pressedKeys.clear();
  }

  _updateColumns() {
    // For each column, check if any pressed key in an active (LOW) row connects to it
    for (let c = 0; c < 4; c++) {
      let pullLow = false;
      for (let r = 0; r < 4; r++) {
        // Row is active when MCU drives it LOW
        if (!this._rowStates[r]) {
          const key = KEYMAP_4x4[r]?.[c];
          if (key && this._pressedKeys.has(key)) {
            pullLow = true;
            break;
          }
        }
      }
      this.runner.setPinState(this.colPins[c], !pullLow);
    }
  }
}
