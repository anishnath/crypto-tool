/**
 * Molecule Simulation — N-Body 2D Spring Network
 *
 * 2 to 6 atoms connected by springs in 2D with gravity, damping,
 * and elastic wall collisions. Fully connected: N atoms → N(N-1)/2 springs.
 *
 * Physics per atom i:
 *   x_i'' = (ΣF_springs + F_gravity + F_damping) / m_i
 *   y_i'' = same for y
 *
 * Spring force between atoms i,j:
 *   F = -k * (|r_ij| - L₀) * r̂_ij
 *
 * Reference: myphysicslab/src/sims/springs/MoleculeSim.ts
 *
 * State layout: [x1,y1,vx1,vy1, x2,y2,vx2,vy2, ..., time]
 *   Each atom uses 4 vars. Last var is time.
 */

const ATOM_COLORS = ['#8B5CF6', '#06B6D4', '#EF4444', '#F59E0B', '#10B981', '#EC4899'];
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
    // time is always last
    time: { index: -1, label: 'Time (s)', symbol: 't' }, // index set dynamically
  },

  // varCount is dynamic: 4*N + 1. We set a max for buffer allocation.
  varCount: 4 * 6 + 1, // max 6 atoms

  params: {
    numAtoms:   { value: 3, min: 2, max: 6, step: 1, label: 'Atoms', resetsState: true },
    mass:       { value: 0.5, min: 0.1, max: 5, step: 0.1, label: 'Mass', unit: 'kg' },
    stiffness:  { value: 6.0, min: 0.1, max: 30, step: 0.5, label: 'Stiffness', unit: 'N/m' },
    restLength: { value: 2.0, min: 0.5, max: 5, step: 0.1, label: 'Rest Length', unit: 'm' },
    gravity:    { value: 2.0, min: 0, max: 10, step: 0.1, label: 'Gravity', unit: 'm/s²' },
    damping:    { value: 0.0, min: 0, max: 2, step: 0.01, label: 'Damping' },
    wallSize:   { value: 5.0, min: 2, max: 10, step: 0.5, label: 'Wall Size', unit: 'm' },
    elasticity: { value: 0.8, min: 0, max: 1, step: 0.05, label: 'Wall Elasticity' },
  },

  views: ['sim', 'phase', 'time', 'energy'],

  graphDefaults: {
    phase: { x: 'x1', y: 'vx1' },
    time: ['x1', 'y1'],
  },

  get worldRect() {
    return { xMin: -6, xMax: 6, yMin: -6, yMax: 6 };
  },

  presets: [
    { name: '3 Atoms',     params: { numAtoms: 3 } },
    { name: '2 Atoms',     params: { numAtoms: 2 } },
    { name: '4 Atoms',     params: { numAtoms: 4 } },
    { name: '6 Atoms',     params: { numAtoms: 6 } },
    { name: 'No Gravity',  params: { gravity: 0, numAtoms: 3 } },
    { name: 'Stiff',       params: { stiffness: 20, numAtoms: 3 } },
    { name: 'Bouncy Walls',params: { elasticity: 1.0, numAtoms: 4, damping: 0 } },
  ],

  _getN(params) { return Math.round(params.numAtoms); },
  _timeIdx(params) { return 4 * this._getN(params); },

  init(p) {
    const N = this._getN(p);
    const state = new Array(4 * N + 1).fill(0);
    // Place atoms in a circle
    const radius = p.restLength * 0.8;
    for (let i = 0; i < N; i++) {
      const angle = (2 * Math.PI * i) / N - Math.PI / 2;
      state[i * 4] = radius * Math.cos(angle);     // x
      state[i * 4 + 1] = radius * Math.sin(angle) + 1; // y (shifted up)
      // Give slight initial velocities for interesting motion
      state[i * 4 + 2] = (Math.random() - 0.5) * 2; // vx
      state[i * 4 + 3] = (Math.random() - 0.5) * 2; // vy
    }
    state[4 * N] = 0; // time
    return state;
  },

  evaluate(vars, change, params, isDragging) {
    const N = this._getN(params);
    const tIdx = 4 * N;
    change[tIdx] = 1; // time
    if (isDragging) return;

    const { mass, stiffness: k, restLength: L0, gravity: g, damping: b } = params;

    // Zero force accumulators
    for (let i = 0; i < N; i++) {
      change[i * 4] = vars[i * 4 + 2];     // dx/dt = vx
      change[i * 4 + 1] = vars[i * 4 + 3]; // dy/dt = vy
      change[i * 4 + 2] = 0;               // dvx/dt (accumulate forces)
      change[i * 4 + 3] = -g;              // dvy/dt starts with gravity (down)
    }

    // Spring forces between all pairs
    for (let i = 0; i < N; i++) {
      for (let j = i + 1; j < N; j++) {
        const xi = vars[i * 4], yi = vars[i * 4 + 1];
        const xj = vars[j * 4], yj = vars[j * 4 + 1];
        const dx = xj - xi, dy = yj - yi;
        const dist = Math.hypot(dx, dy);
        if (dist < 1e-10) continue;
        const stretch = dist - L0;
        const force = k * stretch / dist; // force per unit displacement direction
        const fx = force * dx;
        const fy = force * dy;

        change[i * 4 + 2] += fx / mass;  // atom i pulled toward j
        change[i * 4 + 3] += fy / mass;
        change[j * 4 + 2] -= fx / mass;  // atom j pulled toward i
        change[j * 4 + 3] -= fy / mass;
      }
    }

    // Damping
    if (b > 0) {
      for (let i = 0; i < N; i++) {
        change[i * 4 + 2] -= b * vars[i * 4 + 2] / mass;
        change[i * 4 + 3] -= b * vars[i * 4 + 3] / mass;
      }
    }
  },

  /** Wall collision — called after each solver step by the runner */
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
    const { mass, stiffness: k, restLength: L0, gravity: g } = params;
    let KE = 0, PE = 0;
    for (let i = 0; i < N; i++) {
      const vx = vars[i * 4 + 2], vy = vars[i * 4 + 3];
      KE += 0.5 * mass * (vx * vx + vy * vy);
      PE += mass * g * (vars[i * 4 + 1] + params.wallSize); // reference: bottom wall
    }
    // Spring PE
    for (let i = 0; i < N; i++) {
      for (let j = i + 1; j < N; j++) {
        const dx = vars[j * 4] - vars[i * 4];
        const dy = vars[j * 4 + 1] - vars[i * 4 + 1];
        const stretch = Math.hypot(dx, dy) - L0;
        PE += 0.5 * k * stretch * stretch;
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

  onDrag(id, wx, wy, offset, vars, params) {
    const i = id;
    vars[i * 4] = wx - offset.offsetX;
    vars[i * 4 + 1] = wy - offset.offsetY;
    vars[i * 4 + 2] = 0; // zero velocity
    vars[i * 4 + 3] = 0;
  },

  onRelease() {},

  // Trail for atom 0
  trailPoint(vars) {
    return { wx: vars[0], wy: vars[1] };
  },

  // --- Rendering ---

  render(canvas, vars, params) {
    const N = this._getN(params);
    const W = params.wallSize;

    // Walls
    canvas.line(-W, -W, W, -W, '#475569', 1.5);
    canvas.line(-W, W, W, W, '#475569', 1.5);
    canvas.line(-W, -W, -W, W, '#475569', 1.5);
    canvas.line(W, -W, W, W, '#475569', 1.5);

    // Springs between all pairs
    for (let i = 0; i < N; i++) {
      for (let j = i + 1; j < N; j++) {
        const xi = vars[i * 4], yi = vars[i * 4 + 1];
        const xj = vars[j * 4], yj = vars[j * 4 + 1];
        const dist = Math.hypot(xj - xi, yj - yi);
        const stretch = Math.abs(dist - params.restLength);
        // Color: green at rest, red when stretched, blue when compressed
        const ratio = (dist - params.restLength) / params.restLength;
        const color = ratio > 0.1 ? '#EF444480' : ratio < -0.1 ? '#3B82F680' : '#10B98180';
        canvas.line(xi, yi, xj, yj, color, 1.5);
      }
    }

    // Atoms
    for (let i = 0; i < N; i++) {
      const ax = vars[i * 4], ay = vars[i * 4 + 1];
      const r = 0.15 * Math.sqrt(params.mass);
      canvas.circle(ax, ay, r, ATOM_COLORS[i % ATOM_COLORS.length], '#ffffff40');
      canvas.text(ax + r + 0.1, ay, ATOM_LABELS[i], ATOM_COLORS[i % ATOM_COLORS.length], 9);
    }
  },

  info: `
    <h2>Molecular Dynamics — N-Body Spring Network</h2>
    <p>2 to 6 atoms connected by springs in 2D, bouncing inside a box with gravity. This is the simplest model of molecular dynamics — the same principles used in drug design, materials science, and protein folding simulations.</p>

    <h3>Physics</h3>
    <p>Each atom obeys Newton's second law. Forces on atom i:</p>
    <ul>
      <li><strong>Spring force</strong> from each connected atom j: <code>F = -k(|r_ij| - L₀) · r̂_ij</code></li>
      <li><strong>Gravity:</strong> <code>F_y = -m·g</code></li>
      <li><strong>Damping:</strong> <code>F = -b·v</code></li>
    </ul>
    <p>With N atoms, there are N(N-1)/2 springs (fully connected):</p>
    <ul>
      <li>2 atoms → 1 spring (dumbbell)</li>
      <li>3 atoms → 3 springs (triangle)</li>
      <li>4 atoms → 6 springs (tetrahedron-like)</li>
      <li>6 atoms → 15 springs (complex network)</li>
    </ul>

    <h3>Spring Colors</h3>
    <ul>
      <li><strong style="color:#10B981">Green:</strong> near rest length (relaxed)</li>
      <li><strong style="color:#EF4444">Red:</strong> stretched (tension)</li>
      <li><strong style="color:#3B82F6">Blue:</strong> compressed</li>
    </ul>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Add atoms:</strong> Start with 2, slide to 3 → triangle oscillations. Slide to 6 → complex coupled motion</li>
      <li><strong>Grab and throw:</strong> Drag an atom and release with velocity — watch the energy propagate through the springs</li>
      <li><strong>No gravity:</strong> Select "No Gravity" preset — pure spring dynamics, symmetric vibrations</li>
      <li><strong>Stiff springs:</strong> Increase stiffness — the molecule vibrates faster and holds its shape tighter</li>
      <li><strong>Wall bouncing:</strong> Try "Bouncy Walls" — elastic collisions with the box boundaries</li>
    </ol>

    <h3>Normal Modes</h3>
    <p>With zero gravity and damping, the system has distinct <strong>vibrational modes</strong>:</p>
    <ul>
      <li><strong>Breathing mode:</strong> All atoms move radially in/out together (symmetric)</li>
      <li><strong>Rocking modes:</strong> The molecule tilts or rotates</li>
      <li><strong>Stretching modes:</strong> Individual bonds oscillate asymmetrically</li>
    </ul>
    <p>These are directly analogous to the infrared absorption modes measured in molecular spectroscopy.</p>

    <h3>Real-World Applications</h3>
    <ul>
      <li><strong>Molecular dynamics (MD):</strong> Software like GROMACS simulates millions of atoms this way to predict protein structure</li>
      <li><strong>Crystal lattices:</strong> Extend to a grid → phonon model for heat conduction and sound in solids</li>
      <li><strong>Drug design:</strong> Simulating how drug molecules fit into protein binding sites</li>
      <li><strong>Materials science:</strong> Predicting mechanical properties of new materials from atomic-level simulations</li>
    </ul>
  `,
};
