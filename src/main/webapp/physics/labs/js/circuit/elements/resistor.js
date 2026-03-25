/**
 * Resistor Element
 * Stamps conductance G = 1/R between two nodes.
 */
import { CircuitElement } from '../element.js';

export class Resistor extends CircuitElement {
  constructor(n1, n2, resistance = 1000) {
    super('resistor', n1, n2);
    this.resistance = resistance;
  }

  stamp(mna) {
    mna.stampResistor(this.nodes[0], this.nodes[1], this.resistance);
  }

  calculateCurrent() {
    this.current = this.getVoltageDiff() / this.resistance;
  }

  getInfo() {
    const v = this.getVoltageDiff();
    const i = this.current;
    return { voltage: v, current: i, power: v * i, resistance: this.resistance };
  }
}
