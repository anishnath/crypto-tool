/**
 * Stepper Motor Binding — connects <wokwi-stepper-motor> to AVRRunner.
 *
 * Tracks 4 control pins (IN1–IN4) and decodes half-step or full-step
 * sequences to update the visual angle.
 *
 * Full-step sequence (4 phases):
 *   Step 0: 1010  Step 1: 0110  Step 2: 0101  Step 3: 1001
 *
 * Each step = 1.8° for a standard 200-step motor.
 */

const STEP_ANGLE = 1.8; // degrees per step (200 steps/rev)

// Full-step sequence patterns (IN1, IN2, IN3, IN4)
const FULL_STEPS = [
  [true,  false, true,  false], // step 0
  [false, true,  true,  false], // step 1
  [false, true,  false, true],  // step 2
  [true,  false, false, true],  // step 3
];

export class StepperBinding {
  /**
   * @param {HTMLElement} element - <wokwi-stepper-motor>
   * @param {import('../runner.js').AVRRunner} runner
   * @param {{in1: number, in2: number, in3: number, in4: number}} pins
   */
  constructor(element, runner, pins) {
    this.element = element;
    this.runner = runner;
    this.pins = pins; // { in1, in2, in3, in4 }
    this._pinStates = [false, false, false, false];
    this._lastStep = -1;
    this._angle = 0;
    this._cleanups = [];
  }

  attach() {
    const pinOrder = [this.pins.in1, this.pins.in2, this.pins.in3, this.pins.in4];
    const pinSet = new Set(pinOrder);

    const unsub = this.runner.addPinChangeListener((pin, high) => {
      if (!pinSet.has(pin)) return;
      const idx = pinOrder.indexOf(pin);
      this._pinStates[idx] = high;
      this._detectStep();
    });

    this._cleanups = [unsub];
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
  }

  _detectStep() {
    // Match current pin states against full-step patterns
    for (let s = 0; s < FULL_STEPS.length; s++) {
      const pattern = FULL_STEPS[s];
      if (this._pinStates[0] === pattern[0] &&
          this._pinStates[1] === pattern[1] &&
          this._pinStates[2] === pattern[2] &&
          this._pinStates[3] === pattern[3]) {

        if (this._lastStep < 0) {
          this._lastStep = s;
          return;
        }

        const fwd = (this._lastStep + 1) % 4;
        const bwd = (this._lastStep + 3) % 4;

        if (s === fwd) {
          this._angle = (this._angle + STEP_ANGLE) % 360;
        } else if (s === bwd) {
          this._angle = (this._angle - STEP_ANGLE + 360) % 360;
        }

        this._lastStep = s;
        this.element.angle = this._angle;
        return;
      }
    }
  }
}
