/**
 * Switch Element
 * Closed = wire (nodes merged). Open = element removed from circuit.
 * Toggle via .closed property, then re-analyze.
 */
import { CircuitElement } from '../element.js';

export class Switch extends CircuitElement {
  constructor(n1, n2, closed = false) {
    super(closed ? 'wire' : 'switch-open', n1, n2);
    this.closed = closed;
    this._n1 = n1;  // store original nodes for re-analysis
    this._n2 = n2;
  }

  toggle() {
    this.closed = !this.closed;
    this.type = this.closed ? 'wire' : 'switch-open';
    // Restore original node IDs (analyze() will re-assign)
    this.nodes[0] = this._n1;
    this.nodes[1] = this._n2;
  }

  stamp() { /* closed = wire (merged), open = not in circuit */ }

  getInfo() {
    return { voltage: this.getVoltageDiff(), current: this.current, closed: this.closed };
  }
}
