/**
 * 74HC595 Shift Register Binding — connects to AVRRunner GPIO.
 *
 * The 74HC595 has 3 input pins:
 *   - DS (data/SER):    serial data input
 *   - SHCP (clock/SRCLK): shift register clock (rising edge shifts data in)
 *   - STCP (latch/RCLK):  storage register clock (rising edge latches to outputs)
 *
 * Outputs Q0–Q7 drive 8 LEDs (or other components).
 * This binding decodes the bit-bang protocol and updates
 * connected output bindings or a visual indicator.
 */

export class ShiftRegisterBinding {
  /**
   * @param {HTMLElement|null} element - optional visual element
   * @param {import('../runner.js').AVRRunner} runner
   * @param {{data: number, clock: number, latch: number}} pins
   * @param {function} [onOutput] - callback(outputByte) when latch updates
   */
  constructor(element, runner, pins, onOutput = null) {
    this.element = element;
    this.runner = runner;
    this.dataPin = pins.data;
    this.clockPin = pins.clock;
    this.latchPin = pins.latch;
    this.onOutput = onOutput;

    this._shiftReg = 0;   // 8-bit shift register
    this._outputReg = 0;  // 8-bit storage/output register
    this._dataState = false;
    this._clockState = false;
    this._latchState = false;
    this._cleanups = [];
  }

  attach() {
    const unsub = this.runner.addPinChangeListener((pin, high) => {
      if (pin === this.dataPin) {
        this._dataState = high;
      } else if (pin === this.clockPin) {
        // Rising edge of clock — shift data in (MSB first)
        if (!this._clockState && high) {
          this._shiftReg = ((this._shiftReg << 1) | (this._dataState ? 1 : 0)) & 0xFF;
        }
        this._clockState = high;
      } else if (pin === this.latchPin) {
        // Rising edge of latch — transfer shift register to output
        if (!this._latchState && high) {
          this._outputReg = this._shiftReg;
          if (this.onOutput) this.onOutput(this._outputReg);
          this._updateVisual();
        }
        this._latchState = high;
      }
    });

    this._cleanups = [unsub];
  }

  /** Get current output byte */
  getOutput() {
    return this._outputReg;
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
    this._shiftReg = 0;
    this._outputReg = 0;
  }

  _updateVisual() {
    // If element has a values property (e.g. led-bar-graph), update it
    if (this.element && this.element.values !== undefined) {
      const vals = [];
      for (let i = 0; i < 8; i++) {
        vals.push(!!(this._outputReg & (1 << i)));
      }
      this.element.values = vals;
    }
  }
}
