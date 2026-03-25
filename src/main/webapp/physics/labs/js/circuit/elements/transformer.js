/**
 * Ideal Transformer
 *
 * 4 terminals: primary+ (node[0]), primary- (node[1]),
 *              secondary+ (node[2]), secondary- (node[3])
 *
 * Turns ratio N = Ns/Np:
 *   V_secondary = N * V_primary
 *   I_primary = N * I_secondary  (power conserved)
 *
 * Implementation: Two coupled voltage sources.
 *   VS1 enforces V_primary (measured)
 *   VS2 enforces V_secondary = N * V_primary
 *   Current coupling: I_primary = -N * I_secondary
 */
import { CircuitElement } from '../element.js';

export class Transformer extends CircuitElement {
  /**
   * @param {number} nP1 - primary +
   * @param {number} nP2 - primary -
   * @param {number} nS1 - secondary +
   * @param {number} nS2 - secondary -
   * @param {number} [ratio] - turns ratio Ns/Np
   */
  constructor(nP1, nP2, nS1, nS2, ratio = 2) {
    super('transformer', nP1, nP2);
    this.nodes = [nP1, nP2, nS1, nS2];
    this.volts = [0, 0, 0, 0];
    this.ratio = ratio;
    this.iPrimary = 0;
    this.iSecondary = 0;
  }

  getPostCount() { return 4; }
  getVoltageSourceCount() { return 2; }

  stamp(mna) {
    const nc = mna.nodeCount - 1;
    const vs1 = nc + this.voltSource;      // primary VS row
    const vs2 = nc + this.voltSource + 1;  // secondary VS row
    const n = this.ratio;

    const rP1 = mna._idx(this.nodes[0]), rP2 = mna._idx(this.nodes[1]);
    const rS1 = mna._idx(this.nodes[2]), rS2 = mna._idx(this.nodes[3]);

    // VS2 row: enforces V_secondary = N * V_primary
    // KVL: V_S1 - V_S2 - N*(V_P1 - V_P2) = 0
    if (rS1 >= 0) mna.a[vs2][rS1] += 1;
    if (rS2 >= 0) mna.a[vs2][rS2] -= 1;
    if (rP1 >= 0) mna.a[vs2][rP1] -= n;
    if (rP2 >= 0) mna.a[vs2][rP2] += n;
    // VS2 current column: secondary current flows through nS1→nS2
    if (rS1 >= 0) mna.a[rS1][vs2] += 1;
    if (rS2 >= 0) mna.a[rS2][vs2] -= 1;

    // VS1 row: enforces current coupling I_primary + N * I_secondary = 0
    // This row contains ONLY current terms (no voltage terms)
    mna.a[vs1][vs1] += 1;   // I_vs1 coefficient
    mna.a[vs1][vs2] += n;   // N * I_vs2 coefficient
    // VS1 current column: primary current flows through nP1→nP2
    if (rP1 >= 0) mna.a[rP1][vs1] += 1;
    if (rP2 >= 0) mna.a[rP2][vs1] -= 1;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}

  getInfo() {
    return {
      vPrimary: this.volts[0] - this.volts[1],
      vSecondary: this.volts[2] - this.volts[3],
      iPrimary: this.iPrimary,
      iSecondary: this.iSecondary,
      ratio: this.ratio,
    };
  }
}
