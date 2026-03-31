/**
 * Rotary Encoder Binding — connects <wokwi-ky-040> to AVRRunner.
 *
 * Generates quadrature A/B signals when the user rotates the encoder.
 * The KY-040 has 3 pins: CLK (A), DT (B), and SW (push button).
 *
 * Quadrature encoding:
 *   Clockwise:     A leads B  (A falls first)
 *   Counter-CW:    B leads A  (B falls first)
 *
 * wokwi-ky-040 emits 'rotate' events with { direction: 'cw' | 'ccw' }.
 */

export class EncoderBinding {
  /**
   * @param {HTMLElement} element - <wokwi-ky-040> element
   * @param {import('../runner.js').AVRRunner} runner
   * @param {object} pins - { clk, dt, sw } Arduino pin numbers
   */
  constructor(element, runner, pins) {
    this.element = element;
    this.runner = runner;
    this.clkPin = pins.clk;
    this.dtPin = pins.dt;
    this.swPin = pins.sw; // optional push button
    this._cleanups = [];
    this._state = 0; // quadrature state 0–3
  }

  attach() {
    // Initialize both pins HIGH
    this.runner.setPinState(this.clkPin, true);
    this.runner.setPinState(this.dtPin, true);
    if (this.swPin != null) {
      this.runner.setPinState(this.swPin, true); // pull-up
    }

    // Quadrature states: [A, B] for each step
    // State 0: [H, H] → State 1: [L, H] → State 2: [L, L] → State 3: [H, L] → back to 0
    const states = [
      [true,  true],   // 0
      [false, true],   // 1
      [false, false],  // 2
      [true,  false],  // 3
    ];

    const advance = (delta) => {
      this._state = (this._state + delta + 4) % 4;
      const [a, b] = states[this._state];
      this.runner.setPinState(this.clkPin, a);
      this.runner.setPinState(this.dtPin, b);
    };

    const onCW = () => advance(1);
    const onCCW = () => advance(-1);

    const onPress = () => {
      if (this.swPin != null) this.runner.setPinState(this.swPin, false);
    };
    const onRelease = () => {
      if (this.swPin != null) this.runner.setPinState(this.swPin, true);
    };

    this.element.addEventListener('rotate-cw', onCW);
    this.element.addEventListener('rotate-ccw', onCCW);
    this.element.addEventListener('button-press', onPress);
    this.element.addEventListener('button-release', onRelease);

    this._cleanups = [
      () => this.element.removeEventListener('rotate-cw', onCW),
      () => this.element.removeEventListener('rotate-ccw', onCCW),
      () => this.element.removeEventListener('button-press', onPress),
      () => this.element.removeEventListener('button-release', onRelease),
    ];
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
  }
}
