export function toVector3(value) {
  if (Array.isArray(value) || ArrayBuffer.isView(value)) {
    return [Number(value[0]), Number(value[1]), Number(value[2])];
  }
  return [0, 0, 0];
}

export function addVector(left, right) {
  return [left[0] + right[0], left[1] + right[1], left[2] + right[2]];
}

export function subtractVector(left, right) {
  return [left[0] - right[0], left[1] - right[1], left[2] - right[2]];
}

export function scaleVector(vector, factor) {
  return [vector[0] * factor, vector[1] * factor, vector[2] * factor];
}

export function dotVector(left, right) {
  return left[0] * right[0] + left[1] * right[1] + left[2] * right[2];
}

export function crossVector(left, right) {
  return [
    left[1] * right[2] - left[2] * right[1],
    left[2] * right[0] - left[0] * right[2],
    left[0] * right[1] - left[1] * right[0],
  ];
}

export function normVector(vector) {
  return Math.sqrt(dotVector(vector, vector));
}

export function normalizeVector(vector) {
  const magnitude = normVector(vector);
  if (magnitude <= 0) {
    return [0, 0, 0];
  }
  return scaleVector(vector, 1 / magnitude);
}

export function zeroVector() {
  return [0, 0, 0];
}

