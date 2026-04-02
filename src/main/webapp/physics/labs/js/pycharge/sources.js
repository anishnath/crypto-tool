import { Charge } from './charge.js';
import { ELECTRON_MASS, ELEMENTARY_CHARGE, PI, SPEED_OF_LIGHT, VACUUM_PERMITTIVITY } from './constants.js';
import { potentialsAndFields } from './potentials-and-fields.js';
import {
  addVector,
  crossVector,
  normVector,
  scaleVector,
  subtractVector,
  toVector3,
  zeroVector,
} from './vector3.js';

export class Source {
  constructor(initialCharges, odeFunc) {
    this.charges0 = initialCharges;
    this.odeFunc = odeFunc;
  }
}

export function dipoleSource(
  initialDipoleVector,
  naturalFrequency,
  originPoint,
  chargeValue = ELEMENTARY_CHARGE,
  massValue = ELECTRON_MASS,
) {
  const dipoleVector = toVector3(initialDipoleVector);
  const originVector = toVector3(originPoint);
  const dipoleNorm = Math.max(normVector(dipoleVector), 1e-30);

  const effectiveMass = massValue / 2;
  const damping =
    (chargeValue * chargeValue * naturalFrequency * naturalFrequency) /
    (6 * PI * VACUUM_PERMITTIVITY * SPEED_OF_LIGHT ** 3 * effectiveMass);
  const polarizationDirection = [
    Math.abs(dipoleVector[0] / dipoleNorm),
    Math.abs(dipoleVector[1] / dipoleNorm),
    Math.abs(dipoleVector[2] / dipoleNorm),
  ];

  const negativePosition = () => subtractVector(originVector, scaleVector(dipoleVector, 0.5));
  const positivePosition = () => addVector(originVector, scaleVector(dipoleVector, 0.5));

  const negativeCharge = new Charge(negativePosition, -chargeValue);
  const positiveCharge = new Charge(positivePosition, chargeValue);

  const source = new Source([negativeCharge, positiveCharge], (timeValue, sourceState, otherCharges) => {
    const negativeState = sourceState[0];
    const positiveState = sourceState[1];
    const negativePositionValue = negativeState[0];
    const negativeVelocityValue = negativeState[1];
    const positivePositionValue = positiveState[0];
    const positiveVelocityValue = positiveState[1];

    const center = scaleVector(addVector(negativePositionValue, positivePositionValue), 0.5);
    const fields =
      otherCharges.length > 0
        ? potentialsAndFields(otherCharges)(center[0], center[1], center[2], timeValue)
        : null;
    const electricField = fields ? fields.electric : zeroVector();
    const alignedField = [
      electricField[0] * polarizationDirection[0],
      electricField[1] * polarizationDirection[1],
      electricField[2] * polarizationDirection[2],
    ];

    const dipolePosition = subtractVector(positivePositionValue, negativePositionValue);
    const dipoleVelocity = subtractVector(positiveVelocityValue, negativeVelocityValue);
    const dipoleAcceleration = subtractVector(
      scaleVector(alignedField, chargeValue / effectiveMass),
      addVector(scaleVector(dipoleVelocity, damping), scaleVector(dipolePosition, naturalFrequency ** 2)),
    );

    const negativeDerivative = [negativeVelocityValue, scaleVector(dipoleAcceleration, -0.5)];
    const positiveDerivative = [positiveVelocityValue, scaleVector(dipoleAcceleration, 0.5)];

    return [negativeDerivative, positiveDerivative];
  });

  return source;
}

export function freeParticleSource(
  positionFn,
  chargeValue = ELEMENTARY_CHARGE,
  massValue = ELECTRON_MASS,
) {
  const particleCharge = new Charge(positionFn, chargeValue);

  return new Source([particleCharge], (timeValue, sourceState, otherCharges) => {
    const [particlePosition, particleVelocity] = sourceState[0];
    const fields =
      otherCharges.length > 0
        ? potentialsAndFields(otherCharges)(
            particlePosition[0],
            particlePosition[1],
            particlePosition[2],
            timeValue,
          )
        : null;

    const electricField = fields ? fields.electric : zeroVector();
    const magneticField = fields ? fields.magnetic : zeroVector();

    const positionDerivative = particleVelocity;
    const velocityDerivative = scaleVector(
      addVector(electricField, crossVector(particleVelocity, magneticField)),
      chargeValue / massValue,
    );

    return [[positionDerivative, velocityDerivative]];
  });
}

