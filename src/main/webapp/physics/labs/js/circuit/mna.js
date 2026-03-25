/**
 * Modified Nodal Analysis (MNA) Matrix
 *
 * Manages the conductance matrix A and right-hand side b for Ax = b.
 * Includes built-in LU solver (Crout's method with partial pivoting).
 *
 * Matrix layout:
 *   Rows/cols 0..N-2:       KCL at each node (node 0 = ground, excluded)
 *   Rows/cols N-1..N-1+V-1: KVL for each voltage source
 *
 * x = [V₁, V₂, ..., Vₙ₋₁, I_vs0, I_vs1, ...]
 */

// ─── Built-in LU Solver (no external dependency) ───

function lu_factor(A, n) {
  const pivot = new Int32Array(n);
  for (let j = 0; j < n; j++) {
    for (let i = 0; i < j; i++) {
      let s = A[i][j]; for (let k = 0; k < i; k++) s -= A[i][k] * A[k][j]; A[i][j] = s;
    }
    let mx = 0, mr = j;
    for (let i = j; i < n; i++) {
      let s = A[i][j]; for (let k = 0; k < j; k++) s -= A[i][k] * A[k][j]; A[i][j] = s;
      if (Math.abs(s) > mx) { mx = Math.abs(s); mr = i; }
    }
    if (mr !== j) { const t = A[mr]; A[mr] = A[j]; A[j] = t; }
    pivot[j] = mr;
    if (A[j][j] === 0) A[j][j] = 1e-18;
    if (j < n - 1) { const d = 1 / A[j][j]; for (let i = j + 1; i < n; i++) A[i][j] *= d; }
  }
  return pivot;
}

function lu_solve(A, n, pivot, b) {
  for (let i = 0; i < n; i++) {
    if (pivot[i] !== i) { const t = b[pivot[i]]; b[pivot[i]] = b[i]; b[i] = t; }
    for (let j = 0; j < i; j++) b[i] -= A[i][j] * b[j];
  }
  for (let i = n - 1; i >= 0; i--) {
    for (let j = i + 1; j < n; j++) b[i] -= A[i][j] * b[j];
    b[i] /= A[i][i];
  }
}

export class MNA {
  /**
   * @param {number} nodeCount - total nodes including ground (node 0)
   * @param {number} vsCount  - number of independent voltage sources
   */
  constructor(nodeCount, vsCount) {
    this.nodeCount = nodeCount;
    this.vsCount = vsCount;
    this.size = (nodeCount - 1) + vsCount;  // matrix dimension

    // Raw arrays for stamping (faster than Matrix methods for incremental updates)
    this.a = [];       // size × size
    this.b = [];       // size × 1
    this.origA = [];   // backup for nonlinear re-solve
    this.origB = [];   // backup

    for (let i = 0; i < this.size; i++) {
      this.a[i] = new Float64Array(this.size);
      this.origA[i] = new Float64Array(this.size);
    }
    this.b = new Float64Array(this.size);
    this.origB = new Float64Array(this.size);

    this._lu = null;        // cached LU factorization
    this._isLinear = true;  // can reuse LU across solves
  }

  /** Reset matrix and rhs to zero */
  clear() {
    for (let i = 0; i < this.size; i++) {
      this.a[i].fill(0);
    }
    this.b.fill(0);
    this._lu = null;
  }

  // ─── Stamp helpers (node indices are 1-based; 0 = ground = skip) ───

  /** Map node number to matrix row/col (node 0 → -1 = skip) */
  _idx(node) { return node - 1; }

  /** Stamp a value into matrix A at (r, c). Skips ground node. */
  stampMatrix(node1, node2, value) {
    const r = this._idx(node1), c = this._idx(node2);
    if (r >= 0 && c >= 0) this.a[r][c] += value;
  }

  /** Stamp a value into right-hand side b at row. Skips ground. */
  stampRHS(node, value) {
    const r = this._idx(node);
    if (r >= 0) this.b[r] += value;
  }

  /** Stamp resistor (conductance G = 1/R) between nodes n1, n2 */
  stampResistor(n1, n2, resistance) {
    if (resistance === 0) return;  // wire — handled by node merging
    const g = 1.0 / resistance;
    this.stampMatrix(n1, n1, g);
    this.stampMatrix(n2, n2, g);
    this.stampMatrix(n1, n2, -g);
    this.stampMatrix(n2, n1, -g);
  }

  /** Stamp conductance G between nodes n1, n2 */
  stampConductance(n1, n2, g) {
    this.stampMatrix(n1, n1, g);
    this.stampMatrix(n2, n2, g);
    this.stampMatrix(n1, n2, -g);
    this.stampMatrix(n2, n1, -g);
  }

  /**
   * Stamp independent voltage source: V volts from n1(−) to n2(+).
   * vsIndex = which voltage source (0-based), maps to extra row/col.
   */
  stampVoltageSource(nNeg, nPos, vsIndex, voltage) {
    const vn = (this.nodeCount - 1) + vsIndex;  // extra row/col index
    const rn = this._idx(nNeg), rp = this._idx(nPos);

    // KVL row: V(nPos) - V(nNeg) = voltage
    if (rp >= 0) this.a[vn][rp] += 1;
    if (rn >= 0) this.a[vn][rn] -= 1;
    this.b[vn] += voltage;

    // Current flows out of nNeg, into nPos
    if (rp >= 0) this.a[rp][vn] -= 1;
    if (rn >= 0) this.a[rn][vn] += 1;
  }

  /** Stamp independent current source: I amps from n1 to n2 */
  stampCurrentSource(n1, n2, current) {
    this.stampRHS(n1, -current);
    this.stampRHS(n2, current);
  }

  // ─── Solve ───

  /** Save current matrix as the "original" for nonlinear re-iteration */
  saveOriginal() {
    for (let i = 0; i < this.size; i++) {
      this.origA[i].set(this.a[i]);
    }
    this.origB.set(this.b);
  }

  /** Restore matrix from saved original (for NR sub-iteration reset) */
  restoreOriginal() {
    for (let i = 0; i < this.size; i++) {
      this.a[i].set(this.origA[i]);
    }
    this.b.set(this.origB);
  }

  /**
   * Solve Ax = b using built-in LU decomposition.
   * Returns solution array [V1, V2, ..., I_vs0, I_vs1, ...], or null if singular.
   */
  solve() {
    const n = this.size;
    if (n === 0) return new Float64Array(0);

    try {
      // Copy matrix (LU factorizes in-place)
      const A = [];
      for (let i = 0; i < n; i++) A[i] = Array.from(this.a[i]);
      const b = Array.from(this.b);

      const pivot = lu_factor(A, n);
      lu_solve(A, n, pivot, b);

      // Check for NaN
      for (let i = 0; i < n; i++) {
        if (isNaN(b[i])) return null;
      }

      return Float64Array.from(b);
    } catch (e) {
      console.warn('MNA solve failed:', e.message);
      return null;
    }
  }
}
