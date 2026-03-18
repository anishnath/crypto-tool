/**
 * Single Spring Simulation
 *
 * Physics: x'' = -(k/m)(x - L₀) - (b/m)v
 *
 * State: [position, velocity, time]
 */

export const SpringSim = {
  name: 'Spring Oscillator',
  slug: 'spring',
  category: 'Mechanics',

  vars: {
    position: { index: 0, label: 'Position (m)',  symbol: 'x' },
    velocity: { index: 1, label: 'Velocity (m/s)', symbol: 'v' },
    time:     { index: 2, label: 'Time (s)',        symbol: 't' },
  },
  varCount: 3,

  params: {
    mass:       { value: 1.0,  min: 0.1, max: 10, step: 0.1,  label: 'Mass',            unit: 'kg' },
    stiffness:  { value: 3.0,  min: 0.1, max: 30, step: 0.1,  label: 'Spring Stiffness', unit: 'N/m' },
    damping:    { value: 0.1,  min: 0, max: 5,    step: 0.01, label: 'Damping',          unit: '' },
    restLength: { value: 1.0,  min: 0.1, max: 3,  step: 0.1,  label: 'Rest Length',      unit: 'm' },
    fixedPoint: { value: -1.0, min: -3, max: 3,   step: 0.1,  label: 'Fixed Point',      unit: 'm' },
    startX:     { value: 2.0,  min: -3, max: 5,   step: 0.1,  label: 'Start Position',   unit: 'm' },
  },

  views: ['sim', 'phase', 'time', 'energy', 'well'],

  graphDefaults: {
    phase: { x: 'position', y: 'velocity' },
    time: ['position', 'velocity'],
  },

  worldRect: { xMin: -3, xMax: 5, yMin: -1.5, yMax: 1.5 },

  presets: [
    { name: 'Default',    params: {} },
    { name: 'Stiff',      params: { stiffness: 20 } },
    { name: 'Soft',       params: { stiffness: 0.5 } },
    { name: 'Heavy',      params: { mass: 8 } },
    { name: 'No Damping', params: { damping: 0 } },
    { name: 'Overdamped', params: { damping: 4, stiffness: 1 } },
  ],

  init(p) {
    return [p.startX, 0, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[2] = 1;
    if (isDragging) return;

    const [x, v] = vars;
    const { mass, stiffness, damping, restLength, fixedPoint } = params;
    const stretch = x - fixedPoint - restLength;

    change[0] = v;
    change[1] = (-stiffness * stretch - damping * v) / mass;
  },

  energy(vars, params) {
    const [x, v] = vars;
    const { mass, stiffness, restLength, fixedPoint } = params;
    const stretch = x - fixedPoint - restLength;
    const KE = 0.5 * mass * v * v;
    const PE = 0.5 * stiffness * stretch * stretch;
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  potentialEnergy(x, params) {
    const stretch = x - params.fixedPoint - params.restLength;
    return 0.5 * params.stiffness * stretch * stretch;
  },
  peWellConfig: { posVar: 0, posLabel: 'x (m)', range: { min: -2, max: 5 } },

  theoreticalPeriod(params) {
    return 2 * Math.PI * Math.sqrt(params.mass / params.stiffness);
  },
  periodVar: 1, // velocity

  vectors(vars, params) {
    const [x, v] = vars;
    const { mass, stiffness, damping, restLength, fixedPoint } = params;
    const stretch = x - fixedPoint - restLength;
    const force = -stiffness * stretch - damping * v;
    const accel = force / mass;
    return {
      pos: { x: x, y: 0 },
      velocity: { x: v, y: 0, mag: Math.abs(v) },
      accel: { x: accel, y: 0, mag: Math.abs(accel) },
    };
  },

  hitTest(wx, wy, vars, params) {
    const blockX = vars[0];
    if (Math.hypot(wx - blockX, wy) < 0.3) {
      return { id: 'block', offsetX: wx - blockX, offsetY: wy };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    if (id === 'block') {
      vars[0] = wx - offset.offsetX;
      vars[1] = 0;
    }
  },

  onRelease(id, vars, params) {},

  render(canvas, vars, params) {
    const [x] = vars;
    const { fixedPoint, restLength } = params;
    const blockW = 0.25 * Math.sqrt(params.mass);
    const y = 0;

    // Wall/fixed point
    canvas.line(fixedPoint, -0.4, fixedPoint, 0.4, '#475569', 3);

    // Spring (zigzag)
    canvas.spring(fixedPoint, y, x, y, 12, 0.15, '#06B6D4');

    // Block
    canvas.rect(x - blockW / 2, y - blockW / 2, blockW, blockW, '#8B5CF6', '#A78BFA');
  },

  info: `
    <h2>Spring-Mass Oscillator</h2>
    <p>A mass attached to a horizontal spring — the simplest model of oscillation in physics. This system appears everywhere: atoms in molecules, building vibrations, electrical circuits (LC), and car suspensions.</p>

    <h3>Hooke's Law</h3>
    <p><code>F = -k · x</code></p>
    <p>The spring exerts a <strong>restoring force</strong> proportional to displacement from equilibrium. The negative sign means the force always pushes back toward the rest position. The constant <code>k</code> (stiffness) is measured in N/m — larger k means a stiffer spring.</p>

    <h3>Equation of Motion</h3>
    <p><code>x'' = -(k/m)(x - x₀ - L₀) - (b/m)v</code></p>
    <p>Where <code>k</code> is spring stiffness, <code>m</code> is mass, <code>L₀</code> is the natural (rest) length, <code>x₀</code> is the fixed-point position, and <code>b</code> is the damping coefficient.</p>

    <h3>Period and Frequency</h3>
    <p><code>T = 2π √(m/k)</code> &nbsp;&nbsp; <code>f = 1/T</code> &nbsp;&nbsp; <code>ω₀ = √(k/m)</code></p>
    <p>Key insight: the period depends on mass and stiffness — <strong>not amplitude</strong>. Pull the block further and it oscillates with the same frequency, just a larger swing. Verify: drag the block to different distances, the period is identical.</p>

    <h3>Energy</h3>
    <p><code>KE = ½mv²</code> &nbsp;&nbsp; <code>PE = ½k(stretch)²</code></p>
    <p>Switch to the <strong>Energy tab</strong>:</p>
    <ul>
      <li>At maximum stretch/compression: all PE (block momentarily stops), KE = 0</li>
      <li>At equilibrium position: all KE (maximum speed), PE = 0</li>
      <li>Energy flows back and forth between KE and PE — the red and blue areas oscillate in anti-phase</li>
      <li>Without damping: the green Total line is perfectly flat (energy conserved)</li>
      <li>With damping: Total energy decreases over time — energy lost to friction as heat</li>
    </ul>

    <h3>Phase Space</h3>
    <p>Switch to the <strong>Phase tab</strong> (position vs velocity):</p>
    <ul>
      <li><strong>No damping:</strong> Perfect ellipse — the system cycles forever through the same states</li>
      <li><strong>Underdamped (b &lt; 2√km):</strong> Inward spiral — oscillations decay gradually</li>
      <li><strong>Critically damped (b = 2√km):</strong> No oscillation — fastest return to equilibrium. Try: set k=3, m=1, then damping = 2√3 ≈ 3.46</li>
      <li><strong>Overdamped (b &gt; 2√km):</strong> Sluggish return, even slower than critical. Use the "Overdamped" preset</li>
    </ul>

    <h3>Three Damping Regimes</h3>
    <p>The critical damping coefficient is <code>b_c = 2√(km)</code>. With the default k=3, m=1: b_c ≈ 3.46.</p>
    <ul>
      <li><strong>b = 0 (undamped):</strong> Perpetual oscillation. Phase plot is a closed ellipse.</li>
      <li><strong>b = 0.5 (underdamped):</strong> Oscillates with gradually decreasing amplitude. Most common in nature.</li>
      <li><strong>b ≈ 3.46 (critical):</strong> Returns to equilibrium in the shortest time without overshooting. Used in door closers and car shock absorbers.</li>
      <li><strong>b = 8 (overdamped):</strong> Returns slowly without oscillating. Like pushing through honey.</li>
    </ul>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Verify T = 2π√(m/k):</strong> Set damping=0, k=3, m=1. Period should be ~3.63s. Double the mass — period should increase by √2 ≈ 1.41×</li>
      <li><strong>Amplitude doesn't affect period:</strong> Drag the block to x=3, then x=5. Same frequency, just larger motion</li>
      <li><strong>Find critical damping:</strong> With k=3, m=1, set damping to 3.46. The block should return to rest without oscillating — the fastest possible</li>
      <li><strong>Stiff vs soft spring:</strong> Compare k=20 ("Stiff" preset) vs k=0.5 ("Soft" preset). Stiff spring oscillates much faster</li>
      <li><strong>Watch the phase spiral:</strong> Set damping=0.5, switch to Phase tab. Watch the ellipse spiral inward as energy drains</li>
    </ol>

    <h3>Real-World Applications</h3>
    <ul>
      <li><strong>Car suspension:</strong> Springs + shock absorbers (dampers) tuned for critical damping — smooth ride without bouncing</li>
      <li><strong>Atomic bonds:</strong> Atoms in molecules vibrate like tiny springs, with bond stiffness determining infrared absorption spectra</li>
      <li><strong>Electrical circuits:</strong> An LC circuit (inductor + capacitor) obeys the exact same equation — voltage oscillates like position</li>
      <li><strong>Building earthquake resistance:</strong> Tuned mass dampers (like Taipei 101's giant pendulum) use spring-mass principles to absorb seismic energy</li>
    </ul>
  `,
};
