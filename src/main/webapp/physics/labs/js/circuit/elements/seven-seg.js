/**
 * 7-Segment Display — Shows a digit based on 7 input pins + common ground.
 *
 * 8 terminals: a(0), b(1), c(2), d(3), e(4), f(5), g(6), common(7)
 *
 * Each segment is an LED (modeled as a resistor that sinks current when HIGH).
 * Segment is ON when V(pin) - V(common) > threshold (2V).
 *
 *    ─a─
 *   |   |
 *   f   b
 *   |   |
 *    ─g─
 *   |   |
 *   e   c
 *   |   |
 *    ─d─
 *
 * Common cathode: common = GND, segments driven HIGH to light up.
 */
import { CircuitElement } from '../element.js';

const SEG_R = 200;       // internal resistance per segment (models LED)
const THRESHOLD = 2.0;   // voltage to turn on segment

export class SevenSegDisplay extends CircuitElement {
  constructor(nA, nB, nC, nD, nE, nF, nG, nCommon) {
    super('seven-seg', nA, nB);
    this.nodes = [nA, nB, nC, nD, nE, nF, nG, nCommon];
    this.volts = new Array(8).fill(0);
    this.segments = [false, false, false, false, false, false, false]; // a-g
  }

  getPostCount() { return 8; }

  stamp(mna) {
    // Each segment: resistor from pin to common (always present, models LED load)
    const nCom = this.nodes[7];
    for (let i = 0; i < 7; i++) {
      mna.stampResistor(this.nodes[i], nCom, SEG_R);
    }
  }

  doStep(mna) {
    const vCom = this.volts[7];
    for (let i = 0; i < 7; i++) {
      this.segments[i] = (this.volts[i] - vCom) > THRESHOLD;
    }
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }

  calculateCurrent() {
    const vCom = this.volts[7];
    this.current = 0;
    for (let i = 0; i < 7; i++) {
      this.current += (this.volts[i] - vCom) / SEG_R;
    }
  }

  /** Get the digit being displayed (0-9, or -1 if unrecognized) */
  getDigit() {
    const s = this.segments;
    const key = s.map(v => v ? '1' : '0').join('');
    const DIGITS = {
      '1111110': 0, '0110000': 1, '1101101': 2, '1111001': 3,
      '0110011': 4, '1011011': 5, '1011111': 6, '1110000': 7,
      '1111111': 8, '1111011': 9,
    };
    return DIGITS[key] ?? -1;
  }

  getInfo() {
    return {
      segments: this.segments.map((v, i) => 'abcdefg'[i] + ':' + (v ? 'ON' : 'off')).join(' '),
      digit: this.getDigit(),
      current: this.current,
    };
  }
}
