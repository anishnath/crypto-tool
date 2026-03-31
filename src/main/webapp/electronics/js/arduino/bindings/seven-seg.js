/**
 * 7-Segment Display Binding — connects <wokwi-7segment> to AVRRunner.
 */

export class SevenSegBinding {
  constructor(element, runner, pins, commonAnode = false) {
    this.element = element;
    this.runner = runner;
    this.pins = pins; // { a, b, c, d, e, f, g, dp? }
    this.commonAnode = commonAnode;
    this._cleanups = [];
  }

  attach() {
    const pinToSeg = {};
    for (const [seg, pin] of Object.entries(this.pins)) {
      if (pin != null) pinToSeg[pin] = seg;
    }
    const segBits = { a: 0, b: 1, c: 2, d: 3, e: 4, f: 5, g: 6, dp: 7 };
    let currentValue = 0;

    const unsub = this.runner.addPinChangeListener((pin, high) => {
      const seg = pinToSeg[pin];
      if (seg == null) return;
      const on = this.commonAnode ? !high : high;
      const bit = segBits[seg];
      if (bit == null) return;
      if (on) currentValue |= (1 << bit);
      else currentValue &= ~(1 << bit);
      this.element.values = [currentValue];
    });

    this._cleanups = [unsub];
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
    this.element.values = [0];
  }
}
