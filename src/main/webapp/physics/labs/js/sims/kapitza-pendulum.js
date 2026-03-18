/**
 * Kapitza Pendulum — Pendulum with Vibrating Pivot
 *
 * A pendulum whose pivot point vibrates vertically. At high vibration
 * frequency, the inverted (upside-down) position becomes STABLE —
 * the famous Kapitza effect, one of the most counterintuitive results
 * in classical mechanics.
 *
 * Physics:
 *   Pivot: y₀'' = A·sin(ω·t)  (vertical oscillation)
 *   Pendulum: θ'' = -(g + y₀'')/L · sin(θ) - (b/mL²)·ω_θ
 *
 * The key insight: y₀'' adds to effective gravity. When vibration is fast
 * enough, the time-averaged effect creates a restoring force at θ = π.
 *
 *
 * State: [θ, ω_θ, time, y₀, vy₀]
 */

export const KapitzaPendulumSim = {
  name: 'Kapitza Pendulum',
  slug: 'kapitza-pendulum',
  category: 'Mechanics',

  vars: {
    angle:     { index: 0, label: 'Angle (rad)',       symbol: 'θ' },
    angularVel:{ index: 1, label: 'Angular Vel',       symbol: 'ω' },
    time:      { index: 2, label: 'Time (s)',           symbol: 't' },
    pivotY:    { index: 3, label: 'Pivot Y (m)',        symbol: 'y₀' },
    pivotVY:   { index: 4, label: 'Pivot Vel Y',       symbol: 'vy₀' },
  },
  varCount: 5,

  params: {
    gravity:    { value: 9.81, min: 0, max: 25,    step: 0.1,  label: 'Gravity',          unit: 'm/s²' },
    length:     { value: 1.0,  min: 0.2, max: 3,   step: 0.1,  label: 'Length',           unit: 'm' },
    mass:       { value: 1.0,  min: 0.1, max: 10,  step: 0.1,  label: 'Mass',             unit: 'kg' },
    damping:    { value: 0.1,  min: 0, max: 5,     step: 0.01, label: 'Damping',           unit: '' },
    vibeAmp:    { value: 0,    min: 0, max: 300,   step: 5,    label: 'Vibration Amplitude',unit: '' },
    vibeFreq:   { value: 30,   min: 0, max: 80,    step: 1,    label: 'Vibration Frequency',unit: 'rad/s' },
    startAngle: { value: Math.PI / 4, min: -Math.PI, max: Math.PI, step: 0.05, label: 'Start Angle', unit: 'rad' },
  },

  views: ['sim', 'phase', 'time', 'energy', 'well'],

  graphDefaults: {
    phase: { x: 'angle', y: 'angularVel' },
    time: ['angle', 'angularVel'],
  },

  worldRect: { xMin: -2.5, xMax: 2.5, yMin: -3, yMax: 2 },

  presets: [
    { name: 'Normal',          params: { vibeAmp: 0, startAngle: Math.PI / 4 } },
    { name: 'Kapitza Inverted',params: { vibeAmp: 200, vibeFreq: 40, startAngle: Math.PI - 0.1, damping: 0.3 } },
    { name: 'Gentle Vibration',params: { vibeAmp: 50, vibeFreq: 20, startAngle: Math.PI / 4 } },
    { name: 'Parametric Resonance', params: { vibeAmp: 30, vibeFreq: 6.3, damping: 0.05, startAngle: 0.2 } },
    { name: 'Strong Vibration',params: { vibeAmp: 150, vibeFreq: 30, startAngle: Math.PI / 2 } },
    { name: 'Nearly Inverted', params: { vibeAmp: 200, vibeFreq: 40, startAngle: Math.PI * 0.95, damping: 0.3 } },
  ],

  init(p) {
    return [p.startAngle, 0, 0, 0, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[2] = 1; // time
    if (isDragging) {
      change[3] = 0; change[4] = 0;
      return;
    }

    const [angle, angVel, time, pivotY, pivotVY] = vars;
    const { gravity, length, mass, damping, vibeAmp, vibeFreq } = params;

    // Pivot vertical acceleration: y₀'' = A·sin(ω·t)
    // We model pivot as driven directly (no spring to mouse — pure vibration)
    const pivotAccelY = vibeAmp * Math.sin(vibeFreq * time);

    // Pivot dynamics
    change[3] = pivotVY;
    change[4] = pivotAccelY - 5 * pivotVY; // light damping on pivot to prevent drift

    // Effective gravity = g + y₀''
    // When y₀'' oscillates rapidly, time-averaged effective potential changes
    const gEff = gravity + pivotAccelY;

    // Pendulum: θ'' = -(gEff/L)·sin(θ) - (b/mL²)·ω
    change[0] = angVel;
    change[1] = -(gEff / length) * Math.sin(angle)
                - (damping / (mass * length * length)) * angVel;
  },

  energy(vars, params) {
    const [angle, angVel, , pivotY] = vars;
    const { gravity, length, mass } = params;
    const bobY = pivotY - length * Math.cos(angle);
    const KE = 0.5 * mass * (length * angVel) ** 2;
    const PE = mass * gravity * (bobY + length); // reference: bob hanging straight down from y=0
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  potentialEnergy(angle, params) {
    // Static PE (no vibration) for the well plot
    return params.mass * params.gravity * params.length * (1 - Math.cos(angle));
  },
  peWellConfig: { posVar: 0, posLabel: 'θ (rad)', range: { min: -Math.PI, max: Math.PI } },

  theoreticalPeriod(params) {
    if (params.vibeAmp > 0) return 0; // no simple formula when vibrating
    return 2 * Math.PI * Math.sqrt(params.length / params.gravity);
  },
  periodVar: 1,

  // --- Drag ---

  hitTest(wx, wy, vars, params) {
    const L = params.length;
    const pivotY = vars[3];
    const bobX = L * Math.sin(vars[0]);
    const bobY = pivotY - L * Math.cos(vars[0]);
    if (Math.hypot(wx - bobX, wy - bobY) < 0.3) return { id: 'bob' };
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    if (id === 'bob') {
      const pivotY = vars[3];
      vars[0] = Math.atan2(wx, -(wy - pivotY));
      vars[1] = 0;
    }
  },

  onRelease() {},

  trailPoint(vars, params) {
    const L = params.length;
    const pivotY = vars[3];
    return { wx: L * Math.sin(vars[0]), wy: pivotY - L * Math.cos(vars[0]) };
  },

  vectors(vars, params) {
    const [angle, angVel, , pivotY] = vars;
    const L = params.length;
    const bobX = L * Math.sin(angle);
    const bobY = pivotY - L * Math.cos(angle);
    const speed = L * angVel;
    return {
      pos: { x: bobX, y: bobY },
      velocity: { x: speed * Math.cos(angle), y: speed * Math.sin(angle), mag: Math.abs(speed) },
      accel: { x: 0, y: 0, mag: 0 },
    };
  },

  // --- Rendering ---

  render(canvas, vars, params) {
    const [angle, , , pivotY] = vars;
    const { length: L, mass, vibeAmp } = params;

    const pivotX = 0;
    const bobX = pivotX + L * Math.sin(angle);
    const bobY = pivotY - L * Math.cos(angle);

    // Vibration guide (faint vertical line showing pivot range)
    if (vibeAmp > 0) {
      const range = vibeAmp * 0.003; // approximate visual range
      canvas.line(pivotX, -range, pivotX, range, '#8B5CF620', 1);
    }

    // Rod
    canvas.line(pivotX, pivotY, bobX, bobY, '#94a3b8', 2);

    // Pivot (moves with vibration)
    canvas.circle(pivotX, pivotY, 0.05, '#F59E0B', '#FCD34D');

    // Bob
    canvas.circle(bobX, bobY, 0.08 * Math.sqrt(mass), '#8B5CF6', '#A78BFA');

    // Inverted indicator
    if (Math.abs(angle) > Math.PI * 0.7) {
      canvas.text(canvas.world.xMax - 1.5, canvas.world.yMax - 0.15, 'INVERTED', '#10B981', 11);
    }
  },

  info: `
    <h2>The Kapitza Pendulum — Defying Gravity with Vibration</h2>
    <p>A pendulum whose pivot point vibrates rapidly up and down. At sufficiently high frequency, the <strong>upside-down position becomes stable</strong> — the pendulum balances inverted, seemingly defying gravity. This is the <strong>Kapitza effect</strong>, first explained by Nobel laureate Pyotr Kapitza in 1951.</p>

    <h3>How It Works</h3>
    <p>The pivot oscillates vertically: <code>y₀ = A·sin(ωt)</code></p>
    <p>This modifies the effective gravity felt by the bob:</p>
    <p><code>θ'' = -(g + y₀'')/L · sin(θ) - (b/mL²)·ω_θ</code></p>
    <p>When <code>y₀'' = Aω²·sin(ωt)</code> oscillates rapidly, the <strong>time-averaged</strong> effect creates an additional restoring force at θ = π (inverted position).</p>

    <h3>The Stability Condition</h3>
    <p>The inverted position becomes stable when:</p>
    <p><code>Aω² > 2gL</code> (approximately)</p>
    <p>Meaning: vibration acceleration must exceed twice the gravitational pull. With our defaults (A=200, ω=40): Aω² = 320,000 >> 2·9.81·1 = 19.6. Far above the threshold.</p>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Normal pendulum first:</strong> Select "Normal" preset (no vibration). Standard swinging behavior</li>
      <li><strong>Kapitza inverted:</strong> Select "Kapitza Inverted" — the pendulum starts nearly upside-down and <em>stays there</em>, gently wobbling. It's stable!</li>
      <li><strong>Push the inverted pendulum:</strong> While in Kapitza mode, drag the bob slightly away from the top. It returns to the inverted position — a true stable equilibrium</li>
      <li><strong>Reduce frequency:</strong> Slowly decrease vibration frequency. At some point the inverted position destabilizes and the pendulum falls — you've crossed the stability threshold</li>
      <li><strong>Parametric resonance:</strong> Try the preset — vibration at twice the natural frequency pumps energy into the swing (amplitude grows). This is resonance, not chaos</li>
    </ol>

    <h3>Phase Space</h3>
    <p>Switch to the <strong>Phase tab</strong>:</p>
    <ul>
      <li><strong>No vibration:</strong> Normal elliptical orbits around θ=0</li>
      <li><strong>Kapitza inverted:</strong> Orbits around θ=π (the top!) — the phase portrait has shifted its center</li>
      <li>The direction field shows where the fixed points are — you can see the inverted fixed point become stable</li>
    </ul>

    <h3>Why It's Counterintuitive</h3>
    <p>Normally, balancing a pendulum upside-down is like balancing a ball on a hilltop — unstable. Vibration transforms the hilltop into a valley. The fast oscillations create a <strong>time-averaged potential well</strong> at the inverted position. The bob "sees" an effective landscape that's different from the static one.</p>

    <h3>Real-World Applications</h3>
    <ul>
      <li><strong>Paul trap:</strong> Uses oscillating electric fields to trap charged particles — same math as Kapitza pendulum</li>
      <li><strong>Particle accelerators:</strong> RF cavities use alternating fields to focus particle beams (strong focusing principle)</li>
      <li><strong>Insect flight:</strong> Some theories suggest rapidly vibrating wing hinges contribute to flight stability</li>
      <li><strong>Earthquake engineering:</strong> Base isolation systems use controlled oscillation to stabilize structures</li>
    </ul>
  `,
};
