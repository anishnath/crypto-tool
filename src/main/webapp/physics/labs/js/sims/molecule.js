/**
 * Molecule Simulation — N-Body 2D Spring Network
 *
 * 2 to 6 atoms connected by springs in 2D with gravity, damping,
 * and elastic wall collisions. Fully connected: N atoms → N(N-1)/2 springs.
 *
 * Spring types:
 *   LINEAR:        F = -k * (|r| - L₀) * r̂  (Hooke's law)
 *   NON_LINEAR:    F = -k * (|r| - L₀)³ * r̂  (cubic restoring force)
 *   ATTRACT:       F = -k / |r|²  * r̂  (gravitational-like attraction)
 *
 * Special springs: first atom ("red atom") can have different mass,
 * and its springs can have different stiffness and rest length.
 *
 * Reference: myphysicslab/src/sims/springs/MoleculeSim.ts, Molecule3App.ts
 *
 * State: [x1,y1,vx1,vy1, x2,y2,vx2,vy2, ..., time]
 */

const ATOM_COLORS = ['#EF4444', '#06B6D4', '#8B5CF6', '#F59E0B', '#10B981', '#EC4899'];
const ATOM_LABELS = ['A', 'B', 'C', 'D', 'E', 'F'];

export const MoleculeSim = {
  name: 'Molecule',
  slug: 'molecule',
  category: 'Mechanics',

  vars: {
    x1: { index: 0, label: 'x₁ (m)', symbol: 'x₁' },
    y1: { index: 1, label: 'y₁ (m)', symbol: 'y₁' },
    vx1:{ index: 2, label: 'vx₁',    symbol: 'vx₁' },
    vy1:{ index: 3, label: 'vy₁',    symbol: 'vy₁' },
    x2: { index: 4, label: 'x₂ (m)', symbol: 'x₂' },
    y2: { index: 5, label: 'y₂ (m)', symbol: 'y₂' },
    time: { index: -1, label: 'Time (s)', symbol: 't' },
  },

  varCount: 4 * 6 + 1,

  params: {
    numAtoms:      { value: 3, min: 2, max: 6, step: 1, label: 'Atoms', resetsState: true },
    springType:    { value: 'linear', type: 'choice', options: ['linear', 'nonlinear', 'attract'], label: 'Spring Type' },
    mass:          { value: 0.5, min: 0.1, max: 5, step: 0.1, label: 'Mass', unit: 'kg' },
    redMass:       { value: 0.5, min: 0.1, max: 5, step: 0.1, label: 'Red Mass (A)', unit: 'kg' },
    stiffness:     { value: 6.0, min: 0.1, max: 30, step: 0.5, label: 'Stiffness', unit: 'N/m' },
    redStiffness:  { value: 6.0, min: 0.1, max: 30, step: 0.5, label: 'Red Stiffness', unit: 'N/m' },
    restLength:    { value: 2.0, min: 0.5, max: 5, step: 0.1, label: 'Rest Length', unit: 'm' },
    redRestLength: { value: 2.0, min: 0.5, max: 5, step: 0.1, label: 'Red Rest Length', unit: 'm' },
    gravity:       { value: 2.0, min: 0, max: 10, step: 0.1, label: 'Gravity', unit: 'm/s²' },
    damping:       { value: 0.0, min: 0, max: 2, step: 0.01, label: 'Damping' },
    wallSize:      { value: 5.0, min: 2, max: 10, step: 0.5, label: 'Wall Size', unit: 'm' },
    elasticity:    { value: 0.8, min: 0, max: 1, step: 0.05, label: 'Wall Elasticity' },
  },

  views: ['sim', 'phase', 'time', 'energy'],

  graphDefaults: {
    phase: { x: 'x1', y: 'y1' },   // 2D trajectory of atom A — the natural view for N-body
    time: ['x1', 'x2'],             // compare atom A vs B x-positions — shows coupling
  },

  get worldRect() {
    return { xMin: -6, xMax: 6, yMin: -6, yMax: 6 };
  },

  presets: [
    { name: '3 Atoms',        params: { numAtoms: 3 } },
    { name: '2 Atoms',        params: { numAtoms: 2 } },
    { name: '4 Atoms',        params: { numAtoms: 4 } },
    { name: '6 Atoms',        params: { numAtoms: 6 } },
    { name: 'No Gravity',     params: { gravity: 0, numAtoms: 3 } },
    { name: 'Nonlinear',      params: { springType: 'nonlinear', stiffness: 2, numAtoms: 3 } },
    { name: 'Attract',        params: { springType: 'attract', stiffness: 10, gravity: 0, numAtoms: 4 } },
    { name: 'Heavy Red Atom', params: { redMass: 3, numAtoms: 3 } },
    { name: 'Stiff Red',      params: { redStiffness: 20, numAtoms: 3 } },
    { name: 'Bouncy Walls',   params: { elasticity: 1.0, numAtoms: 4, damping: 0 } },
  ],

  _getN(params) { return Math.round(params.numAtoms); },

  init(p) {
    const N = this._getN(p);
    const state = new Array(4 * N + 1).fill(0);
    const radius = p.restLength * 0.8;
    for (let i = 0; i < N; i++) {
      const angle = (2 * Math.PI * i) / N - Math.PI / 2;
      state[i * 4] = radius * Math.cos(angle);
      state[i * 4 + 1] = radius * Math.sin(angle) + 1;
      state[i * 4 + 2] = (Math.random() - 0.5) * 2;
      state[i * 4 + 3] = (Math.random() - 0.5) * 2;
    }
    state[4 * N] = 0;
    return state;
  },

  /** Get mass for atom i (atom 0 = red atom with separate mass) */
  _atomMass(i, params) {
    return i === 0 ? params.redMass : params.mass;
  },

  /** Get spring params between atoms i,j (springs touching atom 0 use red params) */
  _springParams(i, j, params) {
    const isRed = i === 0 || j === 0;
    return {
      k: isRed ? params.redStiffness : params.stiffness,
      L0: isRed ? params.redRestLength : params.restLength,
    };
  },

  /** Compute spring force magnitude between two atoms */
  _springForce(dist, k, L0, springType) {
    if (springType === 'attract') {
      // Gravitational-like attraction: F = -k / r²
      if (dist < 0.1) return k / (0.1 * 0.1); // clamp to prevent infinity
      return k / (dist * dist);
    }
    const stretch = dist - L0;
    if (springType === 'nonlinear') {
      // Cubic: F = k * stretch³
      return k * stretch * stretch * stretch / dist;
    }
    // Linear (Hooke): F = k * stretch
    return k * stretch / dist;
  },

  evaluate(vars, change, params, isDragging) {
    const N = this._getN(params);
    const tIdx = 4 * N;
    change[tIdx] = 1;
    if (isDragging) return;

    const { gravity: g, damping: b, springType } = params;

    // Init: position derivatives = velocity, acceleration starts with gravity
    for (let i = 0; i < N; i++) {
      const mi = this._atomMass(i, params);
      change[i * 4] = vars[i * 4 + 2];
      change[i * 4 + 1] = vars[i * 4 + 3];
      change[i * 4 + 2] = 0;
      change[i * 4 + 3] = -g;
      // Damping
      if (b > 0) {
        change[i * 4 + 2] -= b * vars[i * 4 + 2] / mi;
        change[i * 4 + 3] -= b * vars[i * 4 + 3] / mi;
      }
    }

    // Spring forces between all pairs
    for (let i = 0; i < N; i++) {
      for (let j = i + 1; j < N; j++) {
        const xi = vars[i * 4], yi = vars[i * 4 + 1];
        const xj = vars[j * 4], yj = vars[j * 4 + 1];
        const dx = xj - xi, dy = yj - yi;
        const dist = Math.hypot(dx, dy);
        if (dist < 1e-10) continue;

        const { k, L0 } = this._springParams(i, j, params);
        const forceMag = this._springForce(dist, k, L0, springType);
        const fx = forceMag * dx;
        const fy = forceMag * dy;

        const mi = this._atomMass(i, params);
        const mj = this._atomMass(j, params);
        change[i * 4 + 2] += fx / mi;
        change[i * 4 + 3] += fy / mi;
        change[j * 4 + 2] -= fx / mj;
        change[j * 4 + 3] -= fy / mj;
      }
    }
  },

  postStep(vars, params) {
    const N = this._getN(params);
    const W = params.wallSize;
    const e = params.elasticity;
    for (let i = 0; i < N; i++) {
      const xi = i * 4, yi = i * 4 + 1, vxi = i * 4 + 2, vyi = i * 4 + 3;
      if (vars[xi] < -W) { vars[xi] = -W; vars[vxi] = Math.abs(vars[vxi]) * e; }
      if (vars[xi] > W)  { vars[xi] = W;  vars[vxi] = -Math.abs(vars[vxi]) * e; }
      if (vars[yi] < -W) { vars[yi] = -W; vars[vyi] = Math.abs(vars[vyi]) * e; }
      if (vars[yi] > W)  { vars[yi] = W;  vars[vyi] = -Math.abs(vars[vyi]) * e; }
    }
  },

  energy(vars, params) {
    const N = this._getN(params);
    const { gravity: g, wallSize, springType } = params;
    let KE = 0, PE = 0;
    for (let i = 0; i < N; i++) {
      const mi = this._atomMass(i, params);
      const vx = vars[i * 4 + 2], vy = vars[i * 4 + 3];
      KE += 0.5 * mi * (vx * vx + vy * vy);
      PE += mi * g * (vars[i * 4 + 1] + wallSize);
    }
    // Spring PE
    for (let i = 0; i < N; i++) {
      for (let j = i + 1; j < N; j++) {
        const dx = vars[j * 4] - vars[i * 4];
        const dy = vars[j * 4 + 1] - vars[i * 4 + 1];
        const dist = Math.hypot(dx, dy);
        const { k, L0 } = this._springParams(i, j, params);
        if (springType === 'attract') {
          PE += dist > 0.1 ? -k / dist : -k / 0.1;
        } else if (springType === 'nonlinear') {
          PE += 0.25 * k * (dist - L0) ** 4;
        } else {
          PE += 0.5 * k * (dist - L0) ** 2;
        }
      }
    }
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  // --- Drag ---

  hitTest(wx, wy, vars, params) {
    const N = this._getN(params);
    for (let i = N - 1; i >= 0; i--) {
      const ax = vars[i * 4], ay = vars[i * 4 + 1];
      if (Math.hypot(wx - ax, wy - ay) < 0.5) {
        return { id: i, offsetX: wx - ax, offsetY: wy - ay };
      }
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars) {
    const i = id;
    vars[i * 4] = wx - offset.offsetX;
    vars[i * 4 + 1] = wy - offset.offsetY;
    vars[i * 4 + 2] = 0;
    vars[i * 4 + 3] = 0;
  },

  onRelease() {},

  trailPoint(vars) {
    return { wx: vars[0], wy: vars[1] };
  },

  // --- Rendering ---

  render(canvas, vars, params) {
    const N = this._getN(params);
    const W = params.wallSize;
    const { springType } = params;

    // Walls
    canvas.line(-W, -W, W, -W, '#475569', 1.5);
    canvas.line(-W, W, W, W, '#475569', 1.5);
    canvas.line(-W, -W, -W, W, '#475569', 1.5);
    canvas.line(W, -W, W, W, '#475569', 1.5);

    // Springs / connections between all pairs
    for (let i = 0; i < N; i++) {
      for (let j = i + 1; j < N; j++) {
        const xi = vars[i * 4], yi = vars[i * 4 + 1];
        const xj = vars[j * 4], yj = vars[j * 4 + 1];
        const dist = Math.hypot(xj - xi, yj - yi);
        const { L0 } = this._springParams(i, j, params);
        const ratio = (dist - L0) / L0;
        // Color: green at rest, red when stretched, blue when compressed
        const color = ratio > 0.1 ? '#EF444480' : ratio < -0.1 ? '#3B82F680' : '#10B98180';
        const isRed = i === 0 || j === 0;

        if (springType === 'attract') {
          // Dashed line for gravitational attraction
          canvas.line(xi, yi, xj, yj, '#F59E0B40', 1);
        } else {
          // Zigzag spring
          canvas.spring(xi, yi, xj, yj, isRed ? 8 : 10, 0.12, isRed ? '#EF444480' : color);
        }
      }
    }

    // Atoms
    for (let i = 0; i < N; i++) {
      const ax = vars[i * 4], ay = vars[i * 4 + 1];
      const mi = this._atomMass(i, params);
      const r = 0.15 * Math.sqrt(mi);
      canvas.circle(ax, ay, r, ATOM_COLORS[i % ATOM_COLORS.length], '#ffffff40');
      canvas.text(ax + r + 0.1, ay, ATOM_LABELS[i], ATOM_COLORS[i % ATOM_COLORS.length], 9);
    }
  },

  info: `
    <h2>Molecular Dynamics — N-Body Spring Network</h2>
    <p>2 to 6 atoms connected by springs in 2D, bouncing inside a box with gravity. This is the simplest model of molecular dynamics — the same principles used in drug design, materials science, and protein folding simulations.</p>

    <h3>Spring Types</h3>
    <ul>
      <li><strong>Linear (Hooke's law):</strong> <code>F = -k(r - L₀)</code> — proportional restoring force. The standard spring model</li>
      <li><strong>Nonlinear (cubic):</strong> <code>F = -k(r - L₀)³</code> — much stiffer at large displacements, softer at small. Models real molecular bonds more accurately</li>
      <li><strong>Attract (pseudo-gravity):</strong> <code>F = -k/r²</code> — gravitational-like attraction, no rest length. Atoms orbit and cluster. Models gravity or electrostatic attraction</li>
    </ul>

    <h3>Red Atom (Special)</h3>
    <p>Atom A (red) can have a <strong>different mass, spring stiffness, and rest length</strong> from the other atoms. Springs connected to atom A use the "Red" parameters. This models molecules with a central heavy atom (like iron in hemoglobin) or different bond types.</p>

    <h3>Physics</h3>
    <p>Each atom obeys Newton's second law. Forces on atom i:</p>
    <ul>
      <li><strong>Spring force</strong> from each connected atom j (type depends on Spring Type setting)</li>
      <li><strong>Gravity:</strong> <code>F_y = -m·g</code></li>
      <li><strong>Damping:</strong> <code>F = -b·v</code></li>
    </ul>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Add atoms:</strong> Start with 2, slide to 6 — see increasingly complex coupled motion</li>
      <li><strong>Nonlinear springs:</strong> Select "Nonlinear" preset — springs feel softer near equilibrium, much stiffer when stretched far</li>
      <li><strong>Attract mode:</strong> Select "Attract" — atoms orbit each other like a mini solar system (no gravity for clearest effect)</li>
      <li><strong>Heavy red atom:</strong> Set Red Mass to 3+ — atom A barely moves while others bounce around it (like a heavy nucleus)</li>
      <li><strong>Different red stiffness:</strong> Set Red Stiffness to 20 — atom A's bonds are rigid while others are floppy</li>
    </ol>

    <h3>Real-World Applications</h3>
    <ul>
      <li><strong>Molecular dynamics (MD):</strong> Software like GROMACS simulates millions of atoms this way to predict protein structure</li>
      <li><strong>Crystal lattices:</strong> Extend to a grid → phonon model for heat conduction and sound in solids</li>
      <li><strong>Drug design:</strong> Simulating how drug molecules fit into protein binding sites</li>
      <li><strong>Materials science:</strong> Predicting mechanical properties of new materials from atomic-level simulations</li>
    </ul>
  `,
};
