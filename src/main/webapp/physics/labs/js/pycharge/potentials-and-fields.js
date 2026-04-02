import { PI, SPEED_OF_LIGHT, VACUUM_PERMITTIVITY } from './constants.js';
import { acceleration, emissionTime, position, velocity, zeroField } from './functional.js';
import {
  addVector,
  crossVector,
  dotVector,
  normVector,
  scaleVector,
  subtractVector,
  toVector3,
  zeroVector,
} from './vector3.js';

function emptyQuantities() {
  return {
    scalar: 0,
    vector: zeroVector(),
    electric: zeroVector(),
    magnetic: zeroVector(),
    electricTerm1: zeroVector(),
    electricTerm2: zeroVector(),
    magneticTerm1: zeroVector(),
    magneticTerm2: zeroVector(),
  };
}

function addQuantities(left, right) {
  return {
    scalar: left.scalar + right.scalar,
    vector: addVector(left.vector, right.vector),
    electric: addVector(left.electric, right.electric),
    magnetic: addVector(left.magnetic, right.magnetic),
    electricTerm1: addVector(left.electricTerm1, right.electricTerm1),
    electricTerm2: addVector(left.electricTerm2, right.electricTerm2),
    magneticTerm1: addVector(left.magneticTerm1, right.magneticTerm1),
    magneticTerm2: addVector(left.magneticTerm2, right.magneticTerm2),
  };
}

function calculateIndividualSource(sourcePosition, sourceVelocity, sourceAcceleration, chargeValue, observationPoint) {
  const displacement = subtractVector(observationPoint, sourcePosition);
  const distance = normVector(displacement);
  if (distance <= 0) {
    return zeroField();
  }

  const observationDirection = scaleVector(displacement, 1 / distance);
  const beta = scaleVector(sourceVelocity, 1 / SPEED_OF_LIGHT);
  const betaDot = scaleVector(sourceAcceleration, 1 / SPEED_OF_LIGHT);

  const oneMinusBetaDotBeta = 1 - dotVector(beta, beta);
  const oneMinusDirectionDotBeta = 1 - dotVector(observationDirection, beta);
  const directionMinusBeta = subtractVector(observationDirection, beta);
  const directionDotBetaCubed = oneMinusDirectionDotBeta ** 3;

  if (Math.abs(oneMinusDirectionDotBeta) < 1e-16 || Math.abs(directionDotBetaCubed) < 1e-16) {
    return zeroField();
  }

  const coefficient = chargeValue / (4 * PI * VACUUM_PERMITTIVITY);

  const scalarPotential = coefficient / (oneMinusDirectionDotBeta * distance);
  const vectorPotential = scaleVector(beta, scalarPotential / SPEED_OF_LIGHT);

  const electricTerm1 = scaleVector(
    directionMinusBeta,
    (coefficient * oneMinusBetaDotBeta) / (directionDotBetaCubed * distance * distance),
  );

  const electricTerm2 = scaleVector(
    crossVector(observationDirection, crossVector(directionMinusBeta, betaDot)),
    coefficient / (SPEED_OF_LIGHT * directionDotBetaCubed * distance),
  );

  const electricField = addVector(electricTerm1, electricTerm2);
  const magneticTerm1 = scaleVector(crossVector(observationDirection, electricTerm1), 1 / SPEED_OF_LIGHT);
  const magneticTerm2 = scaleVector(crossVector(observationDirection, electricTerm2), 1 / SPEED_OF_LIGHT);
  const magneticField = addVector(magneticTerm1, magneticTerm2);

  return {
    scalar: scalarPotential,
    vector: vectorPotential,
    electric: electricField,
    magnetic: magneticField,
    electricTerm1,
    electricTerm2,
    magneticTerm1,
    magneticTerm2,
  };
}

function evaluatePoint(charges, xValue, yValue, zValue, timeValue) {
  const observationPoint = [xValue, yValue, zValue];
  let total = emptyQuantities();

  for (const charge of charges) {
    const sourceTime = emissionTime(observationPoint, timeValue, charge);
    const sourcePosition = position(sourceTime, charge);
    const sourceVelocity = velocity(sourceTime, charge);
    const sourceAcceleration = acceleration(sourceTime, charge);
    const contribution = calculateIndividualSource(
      sourcePosition,
      sourceVelocity,
      sourceAcceleration,
      charge.q,
      observationPoint,
    );
    total = addQuantities(total, contribution);
  }

  return total;
}

export function potentialsAndFields(chargeInput) {
  const charges = Array.isArray(chargeInput) ? [...chargeInput] : [chargeInput];
  if (charges.length === 0) {
    throw new Error('At least one charge must be provided.');
  }

  return (xInput, yInput, zInput, tInput) => {
    const isVectorized = Array.isArray(xInput) || ArrayBuffer.isView(xInput);
    if (!isVectorized) {
      return evaluatePoint(charges, Number(xInput), Number(yInput), Number(zInput), Number(tInput));
    }

    const xValues = Array.from(xInput);
    const yValues = Array.from(yInput);
    const zValues = Array.from(zInput);
    const tValues = Array.from(tInput);

    if (xValues.length !== yValues.length || yValues.length !== zValues.length || zValues.length !== tValues.length) {
      throw new Error('x, y, z, and t must have matching lengths.');
    }

    return xValues.map((xValue, index) =>
      evaluatePoint(charges, xValue, yValues[index], zValues[index], tValues[index]),
    );
  };
}

export function asObservationPoint(vectorLike) {
  return toVector3(vectorLike);
}

