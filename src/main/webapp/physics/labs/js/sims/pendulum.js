/**
 * Simple Pendulum Simulation
 *
 * Physics: θ'' = -(g/L)sin(θ) - (b/mL²)ω
 * Reference: myphysicslab/src/sims/pendulum/PendulumSim.ts evaluate()
 *
 * State: [angle, angularVelocity, time]
 */

export const PendulumSim = {
  name: 'Simple Pendulum',
  slug: 'pendulum',
  category: 'Mechanics',

  vars: {
    angle:      { index: 0, label: 'Angle (rad)',         symbol: 'θ' },
    angularVel: { index: 1, label: 'Angular Velocity',    symbol: 'ω' },
    time:       { index: 2, label: 'Time (s)',             symbol: 't' },
  },
  varCount: 3,

  params: {
    gravity:  { value: 9.81, min: 0, max: 25,   step: 0.01, label: 'Gravity',    unit: 'm/s²' },
    length:   { value: 1.0,  min: 0.1, max: 5,  step: 0.1,  label: 'Length',     unit: 'm' },
    mass:     { value: 1.0,  min: 0.1, max: 10, step: 0.1,  label: 'Mass',       unit: 'kg' },
    damping:  { value: 0.1,  min: 0, max: 5,    step: 0.01, label: 'Damping',    unit: '' },
    startAngle: { value: Math.PI / 3, min: -Math.PI, max: Math.PI, step: 0.05, label: 'Start Angle', unit: 'rad' },
  },

  views: ['sim', 'phase', 'time', 'energy', 'well'],

  graphDefaults: {
    phase: { x: 'angle', y: 'angularVel' },
    time: ['angle', 'angularVel'],
  },

  worldRect: { xMin: -2.5, xMax: 2.5, yMin: -2.8, yMax: 0.5 },

  presets: [
    { name: 'Default',      params: {} },
    { name: 'Moon',         params: { gravity: 1.62 } },
    { name: 'Jupiter',      params: { gravity: 24.79 } },
    { name: 'No Damping',   params: { damping: 0 } },
    { name: 'Heavy Damp',   params: { damping: 2.0 } },
    { name: 'Long String',  params: { length: 3.0 } },
    { name: 'Large Angle',  params: { startAngle: Math.PI * 0.95, damping: 0 } },
  ],

  init(p) {
    return [p.startAngle, 0, 0];
  },

  /**
   * The physics: compute derivatives.
   * change[0] = dθ/dt = ω
   * change[1] = dω/dt = -(g/L)sin(θ) - (b/mL²)ω
   * change[2] = dt/dt = 1
   */
  evaluate(vars, change, params, isDragging) {
    change[2] = 1; // time always advances
    if (isDragging) return;

    const [angle, angVel] = vars;
    const { gravity, length, mass, damping } = params;

    change[0] = angVel;
    change[1] = -(gravity / length) * Math.sin(angle)
                - (damping / (mass * length * length)) * angVel;
  },

  energy(vars, params) {
    const [angle, angVel] = vars;
    const { gravity, length, mass } = params;
    const KE = 0.5 * mass * (length * angVel) ** 2;
    const PE = mass * gravity * length * (1 - Math.cos(angle));
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  // Potential energy as function of position (for PE well plot)
  potentialEnergy(angle, params) {
    return params.mass * params.gravity * params.length * (1 - Math.cos(angle));
  },
  peWellConfig: { posVar: 0, posLabel: 'θ (rad)', range: { min: -Math.PI, max: Math.PI } },

  // Theoretical period (small angle approximation)
  theoreticalPeriod(params) {
    return 2 * Math.PI * Math.sqrt(params.length / params.gravity);
  },
  // Which var to detect zero-crossings for period measurement
  periodVar: 1, // angular velocity

  // Vectors for display on sim canvas: velocity + acceleration at bob
  vectors(vars, params) {
    const [angle, angVel] = vars;
    const { gravity, length, mass, damping } = params;
    const bobX = length * Math.sin(angle);
    const bobY = -length * Math.cos(angle);
    // Velocity is tangent to arc: v = L*ω, direction perpendicular to rod
    const speed = length * angVel;
    const vx = speed * Math.cos(angle);
    const vy = speed * Math.sin(angle);
    // Acceleration: tangential + centripetal
    const accel = -(gravity / length) * Math.sin(angle) - (damping / (mass * length * length)) * angVel;
    const aT = length * accel; // tangential
    const aC = length * angVel * angVel; // centripetal (toward pivot)
    const atx = aT * Math.cos(angle);
    const aty = aT * Math.sin(angle);
    const acx = -aC * Math.sin(angle);
    const acy = aC * Math.cos(angle);
    return {
      pos: { x: bobX, y: bobY },
      velocity: { x: vx, y: vy, mag: Math.abs(speed) },
      accel: { x: atx + acx, y: aty + acy, mag: Math.hypot(atx + acx, aty + acy) },
    };
  },

  // --- Drag interaction ---

  hitTest(wx, wy, vars, params) {
    const angle = vars[0];
    const L = params.length;
    const bobX = L * Math.sin(angle);
    const bobY = -L * Math.cos(angle);
    const dist = Math.hypot(wx - bobX, wy - bobY);
    if (dist < 0.3) {
      return { id: 'bob' };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    if (id === 'bob') {
      // Constrain to circular arc
      vars[0] = Math.atan2(wx, -wy);
      vars[1] = 0; // zero angular velocity while dragging
    }
  },

  onRelease(id, vars, params) {
    // physics resumes naturally
  },

  // --- Rendering ---

  render(canvas, vars, params) {
    const [angle] = vars;
    const L = params.length;
    const pivotX = 0, pivotY = 0;
    const bobX = pivotX + L * Math.sin(angle);
    const bobY = pivotY - L * Math.cos(angle);
    const bobRadius = 0.08 * Math.sqrt(params.mass);

    // Rod
    canvas.line(pivotX, pivotY, bobX, bobY, '#94a3b8', 2);

    // Pivot
    canvas.circle(pivotX, pivotY, 0.04, '#475569', '#64748b');

    // Bob
    canvas.circle(bobX, bobY, bobRadius, '#8B5CF6', '#A78BFA');
  },

  info: `
    <h2>The Simple Pendulum</h2>
    <p>A mass (bob) suspended from a fixed pivot by a rigid rod, swinging under gravity. One of the most fundamental systems in physics — it connects mechanics, energy, and oscillations.</p>

    <h3>Equation of Motion</h3>
    <p><code>θ'' = -(g/L) sin(θ) - (b/mL²) ω</code></p>
    <p>Where <code>θ</code> is the angle from vertical, <code>g</code> is gravitational acceleration, <code>L</code> is the rod length,
    <code>b</code> is the damping coefficient, <code>m</code> is the bob mass, and <code>ω = θ'</code> is the angular velocity.</p>

    <h3>Period</h3>
    <p>For small angles (θ &lt; ~15°), sin(θ) ≈ θ and the motion is simple harmonic:</p>
    <p><code>T = 2π √(L/g)</code></p>
    <p>Key insight: the period depends only on length and gravity — <strong>not mass, not amplitude</strong>. This is why pendulum clocks work. Verify it: change the mass slider and watch the period stay the same.</p>
    <p>For large angles, the period increases. Drag the bob near the top (use the "Large Angle" preset) and compare — the swing is visibly slower and non-sinusoidal.</p>

    <h3>Energy</h3>
    <p><code>KE = ½ m (Lω)²</code> &nbsp;&nbsp; <code>PE = mgL(1 - cos θ)</code></p>
    <p>Switch to the <strong>Energy tab</strong> to see this in action:</p>
    <ul>
      <li>At the highest point: all PE (bob momentarily stops), KE = 0</li>
      <li>At the bottom of the swing: all KE (maximum speed), PE = minimum</li>
      <li>The green Total line stays <strong>flat</strong> without damping — energy is conserved</li>
      <li>With damping: Total energy gradually decreases as friction dissipates energy as heat</li>
    </ul>

    <h3>Phase Space</h3>
    <p>Switch to the <strong>Phase tab</strong> (θ vs ω):</p>
    <ul>
      <li><strong>No damping:</strong> The trajectory is a closed curve (ellipse for small angles, distorted for large angles) — the system returns to the same state each cycle</li>
      <li><strong>With damping:</strong> The trajectory spirals inward toward the origin (θ=0, ω=0) — the rest position</li>
      <li>The <strong>dot</strong> shows where the pendulum is right now on the phase curve</li>
    </ul>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Verify T = 2π√(L/g):</strong> Set damping=0, length=1m, gravity=9.81. The period should be ~2.0s. Use the clock to count. Then double the length — the period should increase by √2 ≈ 1.41×</li>
      <li><strong>Mass doesn't matter:</strong> Change mass from 1 to 10 with damping=0. The motion is identical (period unchanged)</li>
      <li><strong>Small vs large angle:</strong> Compare start angle π/6 (30°) vs the "Large Angle" preset (~170°). Notice the period is much longer for large swings</li>
      <li><strong>Moon vs Jupiter:</strong> Try the Moon preset (g=1.62) — the pendulum swings in slow motion. Jupiter (g=24.79) — very fast</li>
      <li><strong>Damping regimes:</strong> Set damping=0 (perpetual), 0.5 (slow decay), 2.0 (fast decay). Watch the phase spiral tighten</li>
    </ol>

    <h3>Real-World Applications</h3>
    <ul>
      <li><strong>Pendulum clocks:</strong> Galileo discovered the period is independent of amplitude, making pendulums ideal timekeepers</li>
      <li><strong>Foucault pendulum:</strong> A large pendulum that demonstrates Earth's rotation</li>
      <li><strong>Seismometers:</strong> Use pendulum principles to detect ground motion during earthquakes</li>
      <li><strong>Metronomes:</strong> Musicians use adjustable pendulums to set tempo</li>
    </ul>
  `,
};
