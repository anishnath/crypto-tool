/**
 * Compare Two Chaotic Pendulums
 *
 * Runs two driven pendulums simultaneously with a tiny difference in
 * initial angle (default 0.001 rad). Shows chaos divergence visually —
 * the pendulums start in sync then gradually separate.
 *
 * Uses the same driven pendulum ODE:
 *   θ'' = -(g/L)sin(θ) - (b/mL²)ω + (A/mL²)cos(ωt)
 *
 * State: [θ₁, ω₁, θ₂, ω₂, time]
 *   Pendulum A = vars[0,1], Pendulum B = vars[2,3]
 *
 */

export const ComparePendulumSim = {
  name: 'Two Chaotic Pendulums',
  slug: 'compare-pendulum',
  category: 'Chaos',

  vars: {
    angleA:  { index: 0, label: 'Angle A (rad)',    symbol: 'θ_A' },
    omegaA:  { index: 1, label: 'Angular Vel A',    symbol: 'ω_A' },
    angleB:  { index: 2, label: 'Angle B (rad)',    symbol: 'θ_B' },
    omegaB:  { index: 3, label: 'Angular Vel B',    symbol: 'ω_B' },
    time:    { index: 4, label: 'Time (s)',          symbol: 't' },
    diverge: { index: 5, label: 'Divergence (rad)',  symbol: 'Δθ' },
    logDiv:  { index: 6, label: 'log₁₀(Δθ)',        symbol: 'log Δθ' },
  },
  varCount: 7,

  params: {
    gravity:    { value: 9.81, min: 0, max: 25,   step: 0.1,  label: 'Gravity',          unit: 'm/s²' },
    length:     { value: 1.0,  min: 0.2, max: 5,  step: 0.1,  label: 'Length',           unit: 'm' },
    mass:       { value: 1.0,  min: 0.1, max: 10, step: 0.1,  label: 'Mass',             unit: 'kg' },
    damping:    { value: 0.5,  min: 0, max: 5,    step: 0.01, label: 'Damping',           unit: '' },
    driveAmp:   { value: 10.0, min: 0, max: 30,   step: 0.5,  label: 'Drive Amplitude',   unit: '' },
    driveFreq:  { value: 0.667,min: 0, max: 5,    step: 0.01, label: 'Drive Frequency',   unit: 'rad/s' },
    startAngle: { value: 0.1,  min: -Math.PI, max: Math.PI, step: 0.05, label: 'Start Angle', unit: 'rad' },
    angleDelta: { value: 0.001, min: 0, max: 0.5, step: 0.001, label: 'Δθ (A vs B)',     unit: 'rad' },
  },

  views: ['sim', 'phase', 'time'],

  graphDefaults: {
    phase: { x: 'angleA', y: 'omegaA' },
    time: ['diverge', 'logDiv'],
    time: ['angleA', 'angleB'],
  },

  worldRect: { xMin: -3, xMax: 3, yMin: -2.5, yMax: 1 },

  presets: [
    { name: 'Default Chaos',    params: {} },
    { name: 'Tiny Δθ = 0.001',  params: { angleDelta: 0.001 } },
    { name: 'Small Δθ = 0.01',  params: { angleDelta: 0.01 } },
    { name: 'Medium Δθ = 0.1',  params: { angleDelta: 0.1 } },
    { name: 'No Drive (sync)',  params: { driveAmp: 0, damping: 0.1 } },
    { name: 'Strong Drive',    params: { driveAmp: 20, damping: 0.5 } },
  ],

  init(p) {
    const delta = p.angleDelta;
    const logDelta = delta > 0 ? Math.log10(delta) : -10;
    return [p.startAngle, 0, p.startAngle + delta, 0, 0, delta, logDelta];
  },

  /** Compute divergence after each physics step */
  postStep(vars) {
    const delta = Math.abs(vars[0] - vars[2]);
    vars[5] = delta;
    vars[6] = delta > 1e-10 ? Math.log10(delta) : -10;
  },

  _evalSingle(angle, angVel, time, params) {
    const { gravity, length, mass, damping, driveAmp, driveFreq } = params;
    const dOmega = -(gravity / length) * Math.sin(angle)
                   - (damping / (mass * length * length)) * angVel
                   + (driveAmp / (mass * length * length)) * Math.cos(driveFreq * time);
    return dOmega;
  },

  evaluate(vars, change, params, isDragging) {
    change[4] = 1;
    change[5] = 0; change[6] = 0; // computed in postStep
    if (isDragging) return;

    const time = vars[4];

    // Pendulum A
    change[0] = vars[1];
    change[1] = this._evalSingle(vars[0], vars[1], time, params);

    // Pendulum B (same physics, different state)
    change[2] = vars[3];
    change[3] = this._evalSingle(vars[2], vars[3], time, params);
  },

  energy(vars, params) {
    const { gravity, length, mass } = params;
    // Energy of pendulum A only (for display)
    const KE = 0.5 * mass * (length * vars[1]) ** 2;
    const PE = mass * gravity * length * (1 - Math.cos(vars[0]));
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  // --- Drag ---

  hitTest(wx, wy, vars, params) {
    const L = params.length;
    // Bob A
    const axA = L * Math.sin(vars[0]), ayA = -L * Math.cos(vars[0]);
    if (Math.hypot(wx - axA, wy - ayA) < 0.3) return { id: 'bobA' };
    // Bob B
    const axB = L * Math.sin(vars[2]), ayB = -L * Math.cos(vars[2]);
    if (Math.hypot(wx - axB, wy - ayB) < 0.3) return { id: 'bobB' };
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    const angle = Math.atan2(wx, -wy);
    if (id === 'bobA') { vars[0] = angle; vars[1] = 0; }
    else if (id === 'bobB') { vars[2] = angle; vars[3] = 0; }
  },

  onRelease() {},

  // Trail: bob A position
  trailPoint(vars, params) {
    const L = params.length;
    return { wx: L * Math.sin(vars[0]), wy: -L * Math.cos(vars[0]) };
  },

  // --- Rendering ---

  render(canvas, vars, params) {
    const [thA, , thB] = vars;
    const L = params.length;
    const px = 0, py = 0;

    // Bob positions
    const axA = L * Math.sin(thA), ayA = -L * Math.cos(thA);
    const axB = L * Math.sin(thB), ayB = -L * Math.cos(thB);

    // Rod A (violet)
    canvas.line(px, py, axA, ayA, '#8B5CF680', 2);
    // Rod B (cyan)
    canvas.line(px, py, axB, ayB, '#06B6D480', 2);

    // Pivot
    canvas.circle(px, py, 0.04, '#475569', '#64748b');

    // Bob A (violet, solid)
    canvas.circle(axA, ayA, 0.08, '#8B5CF6', '#A78BFA');

    // Bob B (cyan, solid)
    canvas.circle(axB, ayB, 0.08, '#06B6D4', '#22D3EE');

    // Divergence readout
    const divergence = Math.abs(vars[0] - vars[2]);
    const label = 'Δθ = ' + divergence.toFixed(4) + ' rad';
    canvas.text(canvas.world.xMin + 0.2, canvas.world.yMax - 0.15, label,
      divergence > 0.1 ? '#EF4444' : divergence > 0.01 ? '#F59E0B' : '#10B981', 10);
  },

  info: `
    <h2>Two Chaotic Pendulums — Sensitivity to Initial Conditions</h2>
    <p>Two identical driven pendulums running simultaneously with a <strong>tiny difference</strong> in starting angle (default Δθ = 0.001 rad ≈ 0.06°). Watch them diverge — this is the essence of chaos.</p>

    <h3>What You See</h3>
    <ul>
      <li><strong>Violet pendulum (A)</strong> starts at the base angle</li>
      <li><strong>Cyan pendulum (B)</strong> starts just 0.001 rad more</li>
      <li>Initially they move in perfect sync — you can barely tell them apart</li>
      <li>After ~10-20 seconds, they're in completely different positions</li>
      <li>The <strong>Δθ readout</strong> (top-left) turns from green → yellow → red as they diverge</li>
    </ul>

    <h3>The Driven Pendulum Equation</h3>
    <p><code>θ'' = -(g/L)sin(θ) - (b/mL²)ω + (A/mL²)cos(ω_d · t)</code></p>
    <p>The driving force <code>A·cos(ω_d·t)</code> pumps energy into the system. Combined with damping and gravity's nonlinearity, this creates chaotic motion at the right parameters.</p>

    <h3>Why Chaos?</h3>
    <p>Three ingredients are needed:</p>
    <ol>
      <li><strong>Nonlinearity:</strong> sin(θ) in the gravity term — makes the force non-proportional to displacement</li>
      <li><strong>Damping:</strong> b > 0 — dissipates energy, preventing simple periodic orbits</li>
      <li><strong>Driving force:</strong> A > 0 — injects energy at a fixed frequency, competing with the natural frequency</li>
    </ol>
    <p>Without any one of these, the motion is regular. Together, they create chaos.</p>

    <h3>The Butterfly Effect</h3>
    <p>The divergence grows <strong>exponentially</strong> at first: Δθ(t) ≈ Δθ₀ · e^(λt) where λ is the <strong>Lyapunov exponent</strong>. This is why weather forecasts become unreliable beyond ~10 days — the atmosphere is a chaotic system.</p>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Watch divergence grow:</strong> Default settings. Count how many seconds until the two pendulums are visibly different (~15-20s)</li>
      <li><strong>Increase Δθ:</strong> Try 0.01 rad — divergence happens faster. Try 0.1 — almost immediate</li>
      <li><strong>Remove drive (no chaos):</strong> Set drive amplitude=0. Both pendulums damp down identically — no divergence. Chaos requires the drive!</li>
      <li><strong>Phase space:</strong> Switch to Phase tab — see two nearly identical trajectories slowly separate into distinct orbits</li>
      <li><strong>Time graph:</strong> Switch to Time tab — the two angle curves (violet=A, cyan=B) start overlapping then split apart</li>
    </ol>

    <h3>Real-World Chaos</h3>
    <ul>
      <li><strong>Weather:</strong> Edward Lorenz discovered chaos by re-running weather simulations with slightly rounded numbers — the famous "butterfly effect"</li>
      <li><strong>Three-body problem:</strong> Three gravitating bodies exhibit chaotic orbits — no exact solution exists</li>
      <li><strong>Heart rhythms:</strong> Cardiac arrhythmias can be modeled as transitions from regular to chaotic dynamics</li>
      <li><strong>Turbulence:</strong> Fluid flow transitions from smooth (laminar) to chaotic (turbulent) at high Reynolds numbers</li>
    </ul>
  `,
};
