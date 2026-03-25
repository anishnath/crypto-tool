/**
 * Subcircuit — Composite element wrapping multiple internal elements.
 *
 * Exposes N external terminals. Internal nodes are auto-numbered.
 * When stamped, all internal elements are stamped into the parent MNA.
 *
 * Usage:
 *   const sub = new Subcircuit('my-block', [nA, nB, nC], (pins, nodeAlloc) => {
 *     // pins[0], pins[1], pins[2] are the external terminal node IDs
 *     // nodeAlloc() returns a fresh internal node ID
 *     const n1 = nodeAlloc();
 *     return [
 *       new Resistor(pins[0], n1, 1000),
 *       new Resistor(n1, pins[1], 2000),
 *       new Capacitor(n1, pins[2], 1e-6),
 *     ];
 *   });
 */
import { CircuitElement } from '../element.js';

let _nextInternalId = 900000;

export class Subcircuit extends CircuitElement {
  /**
   * @param {string} name - subcircuit name
   * @param {number[]} externalNodes - array of external terminal node IDs
   * @param {function} builder - (pins, nodeAlloc) => CircuitElement[]
   */
  constructor(name, externalNodes, builder) {
    super('subcircuit', externalNodes[0], externalNodes[1] || externalNodes[0]);
    this.subName = name;
    this.nodes = [...externalNodes];
    this.volts = new Array(externalNodes.length).fill(0);
    this._builder = builder;
    this._internalElements = [];
    this._built = false;
  }

  getPostCount() { return this.nodes.length; }

  /** Allocate internal node IDs and build child elements */
  _ensureBuilt() {
    if (this._built) return;
    const nodeAlloc = () => _nextInternalId++;
    this._internalElements = this._builder(this.nodes, nodeAlloc);
    this._built = true;
  }

  getVoltageSourceCount() {
    this._ensureBuilt();
    let count = 0;
    for (const elm of this._internalElements) {
      if (elm.getVoltageSourceCount) count += elm.getVoltageSourceCount();
    }
    return count;
  }

  isNonLinear() {
    this._ensureBuilt();
    return this._internalElements.some(e => e.isNonLinear && e.isNonLinear());
  }

  stamp(mna) {
    this._ensureBuilt();
    let vsOffset = this.voltSource;
    for (const elm of this._internalElements) {
      if (elm.getVoltageSourceCount && elm.getVoltageSourceCount() > 0) {
        elm.voltSource = vsOffset;
        vsOffset += elm.getVoltageSourceCount();
      }
      elm.stamp(mna);
    }
  }

  doStep(mna) {
    let converged = true;
    for (const elm of this._internalElements) {
      if (elm.doStep && !elm.doStep(mna)) converged = false;
    }
    return converged;
  }

  startIteration() {
    for (const elm of this._internalElements) {
      if (elm.startIteration) elm.startIteration();
    }
  }

  stepFinished(dt) {
    for (const elm of this._internalElements) {
      if (elm.stepFinished) elm.stepFinished(dt);
    }
  }

  setNodeVoltage(i, v) {
    this.volts[i] = v;
    // Propagate to internal elements connected to this external pin
    for (const elm of this._internalElements) {
      for (let j = 0; j < elm.nodes.length; j++) {
        if (elm.nodes[j] === this.nodes[i]) {
          elm.setNodeVoltage(j, v);
        }
      }
    }
  }

  calculateCurrent() {
    // Sum current from internal elements at the first external terminal
    this.current = 0;
    for (const elm of this._internalElements) {
      if (elm.current) this.current += Math.abs(elm.current);
    }
  }

  getInfo() {
    return {
      name: this.subName,
      internalElements: this._internalElements.length,
      current: this.current,
    };
  }
}
