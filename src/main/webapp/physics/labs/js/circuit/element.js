/**
 * Base Circuit Element
 *
 * Every component (resistor, voltage source, etc.) extends this.
 * Each element knows its node connections and how to stamp into the MNA matrix.
 */

export class CircuitElement {
  /**
   * @param {string} type - element type name
   * @param {number} n1 - first terminal node (or post index before node assignment)
   * @param {number} n2 - second terminal node
   */
  constructor(type, n1, n2) {
    this.type = type;
    this.nodes = [n1, n2];   // node numbers (assigned during analysis)
    this.volts = [0, 0];     // voltage at each terminal (set after solve)
    this.current = 0;        // branch current (positive: n1 → n2)
    this.voltSource = -1;    // voltage source index (if this element owns one)
  }

  /** Number of external terminals (posts) */
  getPostCount() { return 2; }

  /** Number of voltage sources this element contributes to the matrix */
  getVoltageSourceCount() { return 0; }

  /** Number of internal nodes (not visible on canvas) */
  getInternalNodeCount() { return 0; }

  /** Whether this element requires Newton-Raphson iteration */
  isNonLinear() { return false; }

  /**
   * Stamp this element into the MNA matrix. Called once during circuit analysis
   * (or each sub-iteration for nonlinear elements).
   * @param {MNA} mna
   */
  stamp(mna) { /* override */ }

  /**
   * Called at the start of each timestep before sub-iterations.
   * Capacitors/inductors update their history current sources here.
   */
  startIteration() { /* override */ }

  /**
   * Called during each Newton-Raphson sub-iteration.
   * Nonlinear elements re-stamp their linearized conductance here.
   * @param {MNA} mna
   * @returns {boolean} true if converged
   */
  doStep(mna) { return true; }

  /**
   * Called after each timestep completes.
   */
  stepFinished() { /* override */ }

  /** Set node voltage after solve. Called by circuit for each node link. */
  setNodeVoltage(termIndex, voltage) {
    this.volts[termIndex] = voltage;
    this.calculateCurrent();
  }

  /** Recalculate branch current from terminal voltages. Override per element. */
  calculateCurrent() { /* override */ }

  /** Voltage across element (V_n1 - V_n2) */
  getVoltageDiff() { return this.volts[0] - this.volts[1]; }

  /** Get display info: { voltage, current, power, extra } */
  getInfo() {
    const v = this.getVoltageDiff();
    const i = this.current;
    return { voltage: v, current: i, power: v * i };
  }
}
