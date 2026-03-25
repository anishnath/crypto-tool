/**
 * Potentiometer — Variable Resistor (3-terminal)
 *
 * Terminals: node[0]=top, node[1]=wiper, node[2]=bottom
 * Total resistance R. Wiper position p (0..1).
 *   R_top = R * (1 - p)     (top to wiper)
 *   R_bot = R * p            (wiper to bottom)
 *
 * Stamped as two resistors.
 */
import { CircuitElement } from '../element.js';

export class Potentiometer extends CircuitElement {
  constructor(nTop, nWiper, nBottom, resistance = 10000, position = 0.5) {
    super('potentiometer', nTop, nWiper);
    this.nodes = [nTop, nWiper, nBottom];
    this.volts = [0, 0, 0];
    this.resistance = resistance;
    this.position = position;  // 0..1
  }

  getPostCount() { return 3; }

  stamp(mna) {
    const p = Math.max(0.001, Math.min(0.999, this.position));
    const rTop = this.resistance * (1 - p);
    const rBot = this.resistance * p;
    mna.stampResistor(this.nodes[0], this.nodes[1], rTop);
    mna.stampResistor(this.nodes[1], this.nodes[2], rBot);
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {
    // Current through the full pot (top to bottom)
    this.current = (this.volts[0] - this.volts[2]) / this.resistance;
  }

  getInfo() {
    const p = this.position;
    return {
      vTop: this.volts[0], vWiper: this.volts[1], vBottom: this.volts[2],
      resistance: this.resistance, position: p,
      rTop: this.resistance * (1 - p), rBottom: this.resistance * p,
    };
  }
}
