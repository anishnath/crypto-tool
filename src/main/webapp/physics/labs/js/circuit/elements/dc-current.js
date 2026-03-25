/**
 * DC Current Source
 * Stamps current on the right-hand side only. I amps from node[0] to node[1].
 */
import { CircuitElement } from '../element.js';

export class DCCurrentSource extends CircuitElement {
  constructor(n1, n2, current = 0.01) {
    super('dc-current', n1, n2);
    this.sourceCurrent = current;
  }

  stamp(mna) {
    mna.stampCurrentSource(this.nodes[0], this.nodes[1], this.sourceCurrent);
  }

  calculateCurrent() {
    this.current = this.sourceCurrent;
  }

  getInfo() {
    const v = this.getVoltageDiff();
    return { voltage: v, current: this.sourceCurrent, power: v * this.sourceCurrent };
  }
}
