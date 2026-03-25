/**
 * Ground Element
 * Single-terminal element that designates its node as ground (node 0).
 * Not stamped — handled during node numbering in circuit.analyze().
 */
import { CircuitElement } from '../element.js';

export class Ground extends CircuitElement {
  constructor(node) {
    super('ground', node, node);
  }

  getPostCount() { return 1; }
  stamp() { /* ground is handled by node assignment, not stamping */ }
}
