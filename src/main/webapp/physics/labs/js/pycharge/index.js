export { Charge, SolverConfig } from './charge.js';
export { SPEED_OF_LIGHT, VACUUM_PERMITTIVITY, PI, ELEMENTARY_CHARGE, ELECTRON_MASS } from './constants.js';
export {
  interpolatePosition,
  position,
  velocity,
  acceleration,
  emissionTime,
  zeroField,
} from './functional.js';
export { potentialsAndFields } from './potentials-and-fields.js';
export { Source, dipoleSource, freeParticleSource } from './sources.js';
export { simulate, rk4Step } from './simulate.js';

