/**
 * Double Spring Simulation
 *
 * Two masses connected by springs between two fixed walls.
 *
 *   wall1 ---spring1--- block1 ---spring2--- block2 [---spring3--- wall2]
 *
 * Physics: 1D horizontal, no gravity.
 *   ü₁ = (-k·L₁ + k·L₂ - b·u̇₁) / m₁
 *   ü₂ = (-k·L₂ + k·L₃ - b·u̇₂) / m₂
 *
 *
 * State: [x1, x2, v1, v2, time]
 */

export const DoubleSpringSim = {
  name: 'Double Spring',
  slug: 'double-spring',
  category: 'Mechanics',

  vars: {
    x1: { index: 0, label: 'Position 1 (m)',  symbol: 'x₁' },
    x2: { index: 1, label: 'Position 2 (m)',  symbol: 'x₂' },
    v1: { index: 2, label: 'Velocity 1 (m/s)', symbol: 'v₁' },
    v2: { index: 3, label: 'Velocity 2 (m/s)', symbol: 'v₂' },
    time: { index: 4, label: 'Time (s)',        symbol: 't' },
  },
  varCount: 5,

  params: {
    mass1:       { value: 1.0,  min: 0.2, max: 10, step: 0.1,  label: 'Mass 1',         unit: 'kg' },
    mass2:       { value: 1.0,  min: 0.2, max: 10, step: 0.1,  label: 'Mass 2',         unit: 'kg' },
    stiffness:   { value: 6.0,  min: 0.1, max: 50, step: 0.1,  label: 'Stiffness',      unit: 'N/m' },
    springMass:  { value: 0,    min: 0, max: 2,    step: 0.05, label: 'Spring Mass',    unit: 'kg' },
    damping:     { value: 0.0,  min: 0, max: 5,    step: 0.01, label: 'Damping',         unit: '' },
    restLength:  { value: 2.0,  min: 0.5, max: 5,  step: 0.1,  label: 'Rest Length',     unit: 'm' },
    thirdSpring: { value: true, type: 'bool',                   label: 'Third Spring (wall₂)' },
    wallLeft:    { value: -0.5, hidden: true },
    wallRight:   { value: 9.5,  hidden: true },
  },

  views: ['sim', 'phase', 'time', 'energy'],

  graphDefaults: {
    phase: { x: 'x1', y: 'v1' },
    time: ['x1', 'x2'],
  },

  worldRect: { xMin: -2, xMax: 11, yMin: -3, yMax: 3 },

  presets: [
    { name: 'Default',       params: {} },
    { name: 'Symmetric',     params: { mass1: 1, mass2: 1, stiffness: 6 } },
    { name: 'Heavy + Light', params: { mass1: 5, mass2: 0.5 } },
    { name: 'Stiff',         params: { stiffness: 30 } },
    { name: 'Soft',          params: { stiffness: 1 } },
    { name: 'No Wall₂',     params: { thirdSpring: false } },
    { name: 'Damped',        params: { damping: 0.5 } },
  ],

  // Compute equilibrium positions for given params
  _equilibrium(p) {
    const { stiffness: k, restLength: R, wallLeft: w1, wallRight: w2, thirdSpring } = p;
    const k3 = thirdSpring ? k : 0;
    if (k3 > 0) {
      // Both walls connected: solve force balance
      // k(x1 - w1 - R) = k(x2 - x1 - R)  and  k(x2 - x1 - R) = k3(w2 - x2 - R)
      const totalSpace = w2 - w1;
      const x1 = w1 + totalSpace / 3;
      const x2 = w1 + 2 * totalSpace / 3;
      return [x1, x2];
    }
    // No third spring: blocks at rest lengths from wall
    const x1 = w1 + R;
    const x2 = x1 + R;
    return [x1, x2];
  },

  init(p) {
    const [x1eq, x2eq] = this._equilibrium(p);
    // Start block2 with initial velocity (like reference)
    return [x1eq, x2eq, 0, -2.3, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[4] = 1; // time
    if (isDragging) return;

    const [x1, x2, v1, v2] = vars;
    const { mass1, mass2, springMass, stiffness: k, damping: b, restLength: R, wallLeft: w1, wallRight: w2, thirdSpring } = params;

    // Spring stretches (positive = stretched beyond rest length)
    const L1 = (x1 - w1) - R;   // spring1: wall1 → block1
    const L2 = (x2 - x1) - R;   // spring2: block1 → block2
    const k3 = thirdSpring ? k : 0;
    const L3 = thirdSpring ? (w2 - x2) - R : 0; // spring3: block2 → wall2

    // Effective mass: each block gets +ms/3 for each spring attached to it
    // Block 1 is connected to spring1 + spring2 → +2*(ms/3)
    // Block 2 is connected to spring2 + (spring3 if enabled) → +(1 or 2)*(ms/3)
    const ms3 = (springMass || 0) / 3;
    const mEff1 = mass1 + 2 * ms3;
    const mEff2 = mass2 + (thirdSpring ? 2 : 1) * ms3;

    // Forces: Hooke's law + damping
    change[0] = v1;
    change[1] = v2;
    change[2] = (-k * L1 + k * L2 - b * v1) / mEff1;
    change[3] = (-k * L2 + k3 * L3 - b * v2) / mEff2;
  },

  energy(vars, params) {
    const [x1, x2, v1, v2] = vars;
    const { mass1, mass2, springMass, stiffness: k, restLength: R, wallLeft: w1, wallRight: w2, thirdSpring } = params;

    const L1 = (x1 - w1) - R;
    const L2 = (x2 - x1) - R;
    const L3 = thirdSpring ? (w2 - x2) - R : 0;
    const k3 = thirdSpring ? k : 0;

    const ms3 = (springMass || 0) / 3;
    const mEff1 = mass1 + 2 * ms3;
    const mEff2 = mass2 + (thirdSpring ? 2 : 1) * ms3;
    const KE = 0.5 * mEff1 * v1 * v1 + 0.5 * mEff2 * v2 * v2;
    const PE = 0.5 * k * L1 * L1 + 0.5 * k * L2 * L2 + 0.5 * k3 * L3 * L3;
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  // --- Drag ---

  hitTest(wx, wy, vars, params) {
    const [x1, x2] = vars;
    if (Math.hypot(wx - x1, wy) < 0.4) return { id: 'block1', offsetX: wx - x1, offsetY: wy };
    if (Math.hypot(wx - x2, wy) < 0.4) return { id: 'block2', offsetX: wx - x2, offsetY: wy };
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    if (id === 'block1') {
      vars[0] = wx - offset.offsetX;
      vars[2] = 0;
    } else if (id === 'block2') {
      vars[1] = wx - offset.offsetX;
      vars[3] = 0;
    }
  },

  onRelease() {},

  // Vectors: velocity arrows on both blocks
  vectors(vars, params) {
    // Show block1 vectors (primary)
    const [x1, x2, v1, v2] = vars;
    const { mass1, springMass, stiffness: k, damping: b, restLength: R, wallLeft: w1, wallRight: w2, thirdSpring } = params;
    const ms3 = (springMass || 0) / 3;
    const mEff1 = mass1 + 2 * ms3;
    const L1 = (x1 - w1) - R;
    const L2 = (x2 - x1) - R;
    const F1 = -k * L1 + k * L2 - b * v1;
    return {
      pos: { x: x1, y: 0 },
      velocity: { x: v1, y: 0, mag: Math.abs(v1) },
      accel: { x: F1 / mEff1, y: 0, mag: Math.abs(F1 / mEff1) },
    };
  },

  // --- Rendering ---

  render(canvas, vars, params) {
    const [x1, x2] = vars;
    const { wallLeft: w1, wallRight: w2, thirdSpring, mass1, mass2 } = params;
    const y = 0;
    const blockH = 0.35;

    // Walls
    canvas.rect(w1 - 0.15, -1.2, 0.15, 2.4, '#475569', null);
    if (thirdSpring) canvas.rect(w2, -1.2, 0.15, 2.4, '#475569', null);

    // Springs
    canvas.spring(w1, y, x1, y, 14, 0.2, '#10B981');
    canvas.spring(x1, y, x2, y, 14, 0.2, '#06B6D4');
    if (thirdSpring) canvas.spring(x2, y, w2, y, 14, 0.2, '#10B981');

    // Block 1 (violet)
    const bw1 = blockH * Math.sqrt(mass1);
    canvas.rect(x1 - bw1 / 2, y - bw1 / 2, bw1, bw1, '#8B5CF6', '#A78BFA');

    // Block 2 (cyan)
    const bw2 = blockH * Math.sqrt(mass2);
    canvas.rect(x2 - bw2 / 2, y - bw2 / 2, bw2, bw2, '#06B6D4', '#22D3EE');

    // Labels
    canvas.text(x1, y + bw1 / 2 + 0.25, 'm₁', '#A78BFA', 10);
    canvas.text(x2, y + bw2 / 2 + 0.25, 'm₂', '#22D3EE', 10);
  },

  info: `
    <h2>Double Spring System</h2>
    <p>Two masses connected by springs between fixed walls. This system demonstrates <strong>coupled oscillations</strong> — two objects that influence each other through shared springs, producing complex motion from simple ingredients.</p>

    <h3>Configuration</h3>
    <p><code>wall₁ ─── spring₁ ─── m₁ ─── spring₂ ─── m₂ [─── spring₃ ─── wall₂]</code></p>
    <p>The third spring (to the right wall) is optional — toggle it to see how boundary conditions change the motion.</p>

    <h3>Equations of Motion</h3>
    <p><code>m₁ · x₁'' = -k·L₁ + k·L₂ - b·x₁'</code></p>
    <p><code>m₂ · x₂'' = -k·L₂ + k₃·L₃ - b·x₂'</code></p>
    <p>Where L₁, L₂, L₃ are the spring stretches (current length minus rest length), k is stiffness, and b is damping.</p>

    <h3>Normal Modes</h3>
    <p>With equal masses and symmetric springs, the system has two <strong>normal modes</strong>:</p>
    <ul>
      <li><strong>Symmetric mode:</strong> Both blocks move together in the same direction — like a single spring. Lower frequency.</li>
      <li><strong>Antisymmetric mode:</strong> Blocks move in opposite directions — the middle spring stretches and compresses twice as much. Higher frequency.</li>
    </ul>
    <p>General motion is a superposition of both modes, creating complex-looking oscillations that are actually simple underneath.</p>

    <h3>Energy</h3>
    <p><code>KE = ½m₁v₁² + ½m₂v₂²</code></p>
    <p><code>PE = ½k·L₁² + ½k·L₂² + ½k₃·L₃²</code></p>
    <p>Switch to the <strong>Energy tab</strong> — without damping, total energy stays constant even as it flows between kinetic and potential forms and between the two blocks.</p>

    <h3>Phase Space</h3>
    <p>The <strong>Phase tab</strong> shows x₁ vs v₁ by default. Use the variable picker to switch to x₂ vs v₂, or x₁ vs x₂ to see how the blocks' positions correlate.</p>
    <ul>
      <li><strong>No damping:</strong> Trajectories are complex closed curves (Lissajous-like patterns when the normal mode frequencies are incommensurate)</li>
      <li><strong>With damping:</strong> Spirals inward to the equilibrium point</li>
    </ul>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Normal modes:</strong> Set equal masses, no damping. Drag both blocks the same direction by the same amount → symmetric mode (slow oscillation). Drag them in opposite directions → antisymmetric mode (fast)</li>
      <li><strong>Energy transfer:</strong> Set no damping. Hold block1 still, pull block2 and release. Watch energy transfer back and forth between the blocks — a "beat" pattern</li>
      <li><strong>Heavy + Light:</strong> Use the preset. The heavy block barely moves while the light block bounces rapidly</li>
      <li><strong>Remove wall₂:</strong> Uncheck "Third Spring" — block2 swings freely off the right end, completely different dynamics</li>
      <li><strong>Phase correlation:</strong> Switch phase graph to X: x₁, Y: x₂ — see how the two blocks' positions correlate over time</li>
    </ol>

    <h3>Real-World Applications</h3>
    <ul>
      <li><strong>Molecular vibrations:</strong> CO₂ has symmetric and antisymmetric stretch modes — same physics as this system</li>
      <li><strong>Coupled oscillators:</strong> Two pendulum clocks on the same shelf synchronize through mechanical coupling</li>
      <li><strong>Phonons:</strong> Extend to N masses → a model for sound waves and heat conduction in solids</li>
      <li><strong>Electrical filters:</strong> LC ladder circuits follow the same equations, used in radio frequency filters</li>
    </ul>
  `,
};
