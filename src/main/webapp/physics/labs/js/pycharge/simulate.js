import { Charge } from './charge.js';
import { interpolatePosition, position, velocity } from './functional.js';
import { addVector, scaleVector } from './vector3.js';

function cloneState(sourceState) {
  return sourceState.map((chargeState) => [
    [chargeState[0][0], chargeState[0][1], chargeState[0][2]],
    [chargeState[1][0], chargeState[1][1], chargeState[1][2]],
  ]);
}

function addScaledState(baseState, deltaState, scaleFactor) {
  const result = [];
  for (let chargeIndex = 0; chargeIndex < baseState.length; chargeIndex += 1) {
    const basePos = baseState[chargeIndex][0];
    const baseVel = baseState[chargeIndex][1];
    const deltaPos = deltaState[chargeIndex][0];
    const deltaVel = deltaState[chargeIndex][1];
    result.push([
      addVector(basePos, scaleVector(deltaPos, scaleFactor)),
      addVector(baseVel, scaleVector(deltaVel, scaleFactor)),
    ]);
  }
  return result;
}

function combineRk4(baseState, stepSize, k1, k2, k3, k4) {
  const result = [];
  for (let chargeIndex = 0; chargeIndex < baseState.length; chargeIndex += 1) {
    const kPosition = addVector(
      addVector(k1[chargeIndex][0], scaleVector(k2[chargeIndex][0], 2)),
      addVector(scaleVector(k3[chargeIndex][0], 2), k4[chargeIndex][0]),
    );
    const kVelocity = addVector(
      addVector(k1[chargeIndex][1], scaleVector(k2[chargeIndex][1], 2)),
      addVector(scaleVector(k3[chargeIndex][1], 2), k4[chargeIndex][1]),
    );

    result.push([
      addVector(baseState[chargeIndex][0], scaleVector(kPosition, stepSize / 6)),
      addVector(baseState[chargeIndex][1], scaleVector(kVelocity, stepSize / 6)),
    ]);
  }

  return result;
}

export function rk4Step(odeTerm, currentTime, currentState, stepSize, otherCharges) {
  const k1 = odeTerm(currentTime, currentState, otherCharges);
  const k2 = odeTerm(
    currentTime + stepSize / 2,
    addScaledState(currentState, k1, stepSize / 2),
    otherCharges,
  );
  const k3 = odeTerm(
    currentTime + stepSize / 2,
    addScaledState(currentState, k2, stepSize / 2),
    otherCharges,
  );
  const k4 = odeTerm(currentTime + stepSize, addScaledState(currentState, k3, stepSize), otherCharges);
  return combineRk4(currentState, stepSize, k1, k2, k3, k4);
}

function createInitialState(times, source) {
  return source.charges0.map((charge) => {
    const initialPosition = position(times[0], charge);
    const initialVelocity = velocity(times[0], charge);
    return [initialPosition, initialVelocity];
  });
}

function createChargeSnapshot(
  source,
  sourceTimeSeries,
  sourceIndex,
  timeIndex,
  times,
  currentTime,
) {
  return source.charges0.map((baseCharge, chargeIndex) => {
    const positionSeries = sourceTimeSeries[sourceIndex].map((stateAtTime) => stateAtTime[chargeIndex][0]);
    const velocitySeries = sourceTimeSeries[sourceIndex].map((stateAtTime) => stateAtTime[chargeIndex][1]);

    const updatedPositionFn = interpolatePosition(
      times,
      positionSeries,
      velocitySeries,
      baseCharge.positionFn,
      currentTime,
    );
    return new Charge(updatedPositionFn, baseCharge.q, baseCharge.solverConfig);
  });
}

export function simulate(sources, times, printEvery = 100) {
  const stepSizes = times.slice(1).map((timeValue, index) => timeValue - times[index]);

  return () => {
    const sourceTimeSeries = sources.map((source) => [createInitialState(times, source)]);

    for (let timeIndex = 0; timeIndex < times.length - 1; timeIndex += 1) {
      if (printEvery > 0 && timeIndex % printEvery === 0) {
        console.log(`Timestep ${timeIndex}`);
      }

      const currentTime = times[timeIndex];
      const nextStates = [];

      const chargeGroups = sources.map((source, sourceIndex) =>
        createChargeSnapshot(source, sourceTimeSeries, sourceIndex, timeIndex, times, currentTime),
      );

      for (let sourceIndex = 0; sourceIndex < sources.length; sourceIndex += 1) {
        const source = sources[sourceIndex];
        const currentState = cloneState(sourceTimeSeries[sourceIndex][timeIndex]);
        const otherCharges = chargeGroups
          .filter((_, index) => index !== sourceIndex)
          .flat();

        const steppedState = rk4Step(
          source.odeFunc,
          currentTime,
          currentState,
          stepSizes[timeIndex],
          otherCharges,
        );
        nextStates.push(steppedState);
      }

      for (let sourceIndex = 0; sourceIndex < sources.length; sourceIndex += 1) {
        sourceTimeSeries[sourceIndex].push(nextStates[sourceIndex]);
      }
    }

    return sourceTimeSeries;
  };
}

