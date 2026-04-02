import { ELEMENTARY_CHARGE } from './constants.js';

export class SolverConfig {
  constructor(options = {}) {
    this.fixedPointRtol = options.fixedPointRtol ?? 0.0;
    this.fixedPointAtol = options.fixedPointAtol ?? 1e-20;
    this.fixedPointMaxSteps = options.fixedPointMaxSteps ?? 256;
    this.fixedPointThrow = options.fixedPointThrow ?? false;

    this.rootFindRtol = options.rootFindRtol ?? 0.0;
    this.rootFindAtol = options.rootFindAtol ?? 1e-20;
    this.rootFindMaxSteps = options.rootFindMaxSteps ?? 256;
    this.rootFindThrow = options.rootFindThrow ?? true;

    this.derivativeStep = options.derivativeStep ?? 1e-8;
  }
}

export class Charge {
  constructor(positionFn, chargeValue = ELEMENTARY_CHARGE, solverConfig = new SolverConfig()) {
    this.positionFn = positionFn;
    this.q = chargeValue;
    this.solverConfig = solverConfig;
  }
}

