import { SPEED_OF_LIGHT } from './constants.js';
import {
  addVector,
  normVector,
  scaleVector,
  subtractVector,
  toVector3,
  zeroVector,
} from './vector3.js';

function hasConverged(nextValue, prevValue, relativeTolerance, absoluteTolerance) {
  const error = Math.abs(nextValue - prevValue);
  const threshold = absoluteTolerance + relativeTolerance * Math.abs(prevValue);
  return error <= threshold;
}

function rightSearchIndex(sortedTimes, timeValue) {
  let lowIndex = 0;
  let highIndex = sortedTimes.length;
  while (lowIndex < highIndex) {
    const midIndex = (lowIndex + highIndex) >> 1;
    if (timeValue < sortedTimes[midIndex]) {
      highIndex = midIndex;
    } else {
      lowIndex = midIndex + 1;
    }
  }
  return lowIndex;
}

export function interpolatePosition(
  times,
  positionArray,
  velocityArray,
  positionBeforeStart,
  timeEnd = null,
) {
  const startTime = times[0];
  const finalTime = timeEnd ?? times[times.length - 1];
  const finalIndex = Math.max(0, rightSearchIndex(times, finalTime) - 1);

  return (timeValue) => {
    if (timeValue <= startTime) {
      return toVector3(positionBeforeStart(timeValue));
    }
    if (timeValue >= finalTime) {
      return toVector3(positionArray[finalIndex]);
    }

    const timeIndex = rightSearchIndex(times, timeValue) - 1;
    const t0 = times[timeIndex];
    const t1 = times[timeIndex + 1];
    const deltaTime = t1 - t0;
    const normalizedTime = (timeValue - t0) / deltaTime;

    const pos0 = toVector3(positionArray[timeIndex]);
    const pos1 = toVector3(positionArray[timeIndex + 1]);
    const vel0 = toVector3(velocityArray[timeIndex]);
    const vel1 = toVector3(velocityArray[timeIndex + 1]);

    const deltaPos = subtractVector(pos1, pos0);
    const coeffA = subtractVector(scaleVector(addVector(vel0, vel1), deltaTime), scaleVector(deltaPos, 2));
    const coeffB = subtractVector(
      scaleVector(deltaPos, 3),
      scaleVector(addVector(scaleVector(vel0, 2), vel1), deltaTime),
    );
    const coeffC = scaleVector(vel0, deltaTime);
    const coeffD = pos0;

    return addVector(
      addVector(scaleVector(coeffA, normalizedTime ** 3), scaleVector(coeffB, normalizedTime ** 2)),
      addVector(scaleVector(coeffC, normalizedTime), coeffD),
    );
  };
}

export function position(timeValue, charge) {
  return toVector3(charge.positionFn(timeValue));
}

export function velocity(timeValue, charge) {
  const step = charge.solverConfig?.derivativeStep ?? 1e-8;
  const posForward = position(timeValue + step, charge);
  const posBackward = position(timeValue - step, charge);
  return scaleVector(subtractVector(posForward, posBackward), 1 / (2 * step));
}

export function acceleration(timeValue, charge) {
  const step = charge.solverConfig?.derivativeStep ?? 1e-8;
  const posForward = position(timeValue + step, charge);
  const posCurrent = position(timeValue, charge);
  const posBackward = position(timeValue - step, charge);
  return [
    (posForward[0] - 2 * posCurrent[0] + posBackward[0]) / (step * step),
    (posForward[1] - 2 * posCurrent[1] + posBackward[1]) / (step * step),
    (posForward[2] - 2 * posCurrent[2] + posBackward[2]) / (step * step),
  ];
}

export function emissionTime(observationPoint, observationTime, charge) {
  const config = charge.solverConfig;
  const currentPosition = position(observationTime, charge);
  const initialGuess =
    observationTime - normVector(subtractVector(observationPoint, currentPosition)) / SPEED_OF_LIGHT;

  let fixedPointTime = initialGuess;
  for (let stepIndex = 0; stepIndex < config.fixedPointMaxSteps; stepIndex += 1) {
    const nextTime =
      observationTime -
      normVector(subtractVector(observationPoint, position(fixedPointTime, charge))) / SPEED_OF_LIGHT;
    if (hasConverged(nextTime, fixedPointTime, config.fixedPointRtol, config.fixedPointAtol)) {
      fixedPointTime = nextTime;
      break;
    }
    fixedPointTime = nextTime;

    if (stepIndex === config.fixedPointMaxSteps - 1 && config.fixedPointThrow) {
      throw new Error('Fixed-point iteration did not converge for emissionTime.');
    }
  }

  let rootTime = fixedPointTime;
  for (let stepIndex = 0; stepIndex < config.rootFindMaxSteps; stepIndex += 1) {
    const sourcePosition = position(rootTime, charge);
    const distance = normVector(subtractVector(observationPoint, sourcePosition));
    const residual = (observationTime - rootTime) - distance / SPEED_OF_LIGHT;

    const derivativeStep = config.derivativeStep ?? 1e-8;
    const plusPosition = position(rootTime + derivativeStep, charge);
    const minusPosition = position(rootTime - derivativeStep, charge);
    const plusResidual =
      (observationTime - (rootTime + derivativeStep)) -
      normVector(subtractVector(observationPoint, plusPosition)) / SPEED_OF_LIGHT;
    const minusResidual =
      (observationTime - (rootTime - derivativeStep)) -
      normVector(subtractVector(observationPoint, minusPosition)) / SPEED_OF_LIGHT;
    const derivative = (plusResidual - minusResidual) / (2 * derivativeStep);

    if (Math.abs(derivative) < 1e-20) {
      break;
    }

    const nextTime = rootTime - residual / derivative;
    if (hasConverged(nextTime, rootTime, config.rootFindRtol, config.rootFindAtol)) {
      rootTime = nextTime;
      return rootTime;
    }
    rootTime = nextTime;

    if (stepIndex === config.rootFindMaxSteps - 1 && config.rootFindThrow) {
      throw new Error('Newton root-finding did not converge for emissionTime.');
    }
  }

  return rootTime;
}

export function zeroField() {
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
