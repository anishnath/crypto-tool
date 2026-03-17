/**
 * State helpers — clone, compare, energy tracking.
 */

/** Deep clone a state array */
export function cloneState(vars) {
  return Float64Array.from(vars);
}

/** Zero all elements */
export function zeroArray(arr) {
  for (let i = 0; i < arr.length; i++) arr[i] = 0;
}

/** Lerp between two state arrays (for smooth param transitions) */
export function lerpState(a, b, t, out) {
  for (let i = 0; i < a.length; i++) {
    out[i] = a[i] + t * (b[i] - a[i]);
  }
}

/**
 * Circular buffer for graph data collection.
 * Fixed capacity, overwrites oldest when full.
 */
export class RingBuffer {
  constructor(capacity) {
    this.capacity = capacity;
    this.data = new Array(capacity);
    this.head = 0;
    this.size = 0;
  }

  push(value) {
    this.data[this.head] = value;
    this.head = (this.head + 1) % this.capacity;
    if (this.size < this.capacity) this.size++;
  }

  clear() {
    this.head = 0;
    this.size = 0;
  }

  /** Iterate from oldest to newest */
  forEach(fn) {
    const start = this.size < this.capacity ? 0 : this.head;
    for (let i = 0; i < this.size; i++) {
      const idx = (start + i) % this.capacity;
      fn(this.data[idx], i);
    }
  }

  /** Get item by age (0 = oldest, size-1 = newest) */
  get(i) {
    const start = this.size < this.capacity ? 0 : this.head;
    return this.data[(start + i) % this.capacity];
  }

  last() {
    if (this.size === 0) return undefined;
    const idx = (this.head - 1 + this.capacity) % this.capacity;
    return this.data[idx];
  }
}
