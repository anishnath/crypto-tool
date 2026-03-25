/**
 * Circuit Simulator — Time-Stepping Engine
 *
 * For DC circuits: single solve (no time loop).
 * For AC/transient: steps through time, updating companion models each step.
 *
 * Loop per timestep:
 *   1. startIteration() on all elements (update history currents)
 *   2. Reset RHS (and matrix if nonlinear)
 *   3. doStep() on all elements (stamp time-varying values)
 *   4. Solve matrix
 *   5. Distribute results
 *   6. stepFinished() on all elements
 *   7. Advance time
 */

import { MNA } from './mna.js';

export class Simulator {
  constructor(circuit) {
    this.circuit = circuit;
    this.time = 0;
    this.timeStep = 5e-6;     // 5 μs default
    this.maxTimeStep = 5e-6;
    this.minTimeStep = 50e-12;
    this.running = false;
  }

  /** Run N timesteps. Returns array of {time, nodeVoltages, elementInfo}. */
  step(count = 1) {
    const ckt = this.circuit;
    if (!ckt.mna) ckt.analyze();

    const results = [];

    for (let s = 0; s < count; s++) {
      // Pass dt to MNA so companion models can use it
      ckt.mna._dt = this.timeStep;

      // 1. Start iteration — elements update history sources
      for (const elm of ckt.elements) {
        if (elm.type === 'wire' || elm.type === 'ground') continue;
        elm.startIteration();
      }

      // 2. Reset RHS to zero (matrix structure unchanged for linear circuits)
      ckt.mna.b.fill(0);

      // 3. Re-stamp elements that have time-varying components
      // For linear time-varying (C, L, AC): only RHS changes
      // For nonlinear (diode): full matrix re-stamp needed
      for (const elm of ckt.elements) {
        if (elm.type === 'wire' || elm.type === 'ground') continue;
        // Re-stamp the static matrix part (resistor stamps don't change)
        elm.stamp(ckt.mna);
      }

      // 4. doStep — elements stamp their time-varying current sources
      // (Need to clear and re-stamp since stamp() already wrote static parts)
      // Actually: we need to separate static stamp from dynamic doStep.
      // For now: clear matrix, re-stamp everything, then doStep.
      ckt.mna.b.fill(0);
      for (let i = 0; i < ckt.mna.size; i++) ckt.mna.a[i].fill(0);
      for (const elm of ckt.elements) {
        if (elm.type === 'wire' || elm.type === 'ground') continue;
        elm.stamp(ckt.mna);
        elm.doStep(ckt.mna);
      }

      // 5. Solve
      ckt.mna._dt = this.timeStep;
      const x = ckt.mna.solve();
      if (!x) break;

      // 6. Distribute
      for (let i = 1; i < ckt.nodeCount; i++) {
        ckt.nodeVoltages[i] = x[i - 1];
      }
      ckt.nodeVoltages[0] = 0;
      for (let n = 0; n < ckt.nodeCount; n++) {
        for (const link of ckt.nodeLinks[n]) {
          link.elm.setNodeVoltage(link.termIndex, ckt.nodeVoltages[n]);
        }
      }
      for (const elm of ckt.elements) {
        if (elm.type === 'wire' || elm.type === 'ground') continue;
        if (elm.voltSource >= 0 && elm.getVoltageSourceCount() > 0) {
          elm.current = x[(ckt.nodeCount - 1) + elm.voltSource];
        }
      }

      // 7. Step finished + advance time
      for (const elm of ckt.elements) {
        if (elm.type === 'wire' || elm.type === 'ground') continue;
        elm.stepFinished(this.timeStep);
      }
      this.time += this.timeStep;

      results.push({
        time: this.time,
        nodeVoltages: Float64Array.from(ckt.nodeVoltages),
      });
    }

    return results;
  }
}
