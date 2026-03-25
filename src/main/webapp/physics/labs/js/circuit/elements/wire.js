/**
 * Wire Element
 * Not stamped into matrix — nodes are merged during analysis (Union-Find).
 */
import { CircuitElement } from '../element.js';

export class Wire extends CircuitElement {
  constructor(n1, n2) {
    super('wire', n1, n2);
  }

  stamp() { /* wires are merged, not stamped */ }
  calculateCurrent() { /* current determined by adjacent elements */ }
}
