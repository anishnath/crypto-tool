/**
 * Spring Pendulum (Elastic Pendulum / 2D Spring-Mass)
 *
 * A mass hangs from a fixed pivot on a spring. It can BOTH:
 *   - stretch/compress radially (spring mode)
 *   - swing side-to-side (pendulum mode)
 *
 * This creates coupled oscillations with energy transfer between modes.
 *
 * KEY INSIGHT: When ω_spring ≈ 2×ω_pendulum, dramatic parametric
 *   resonance occurs — energy sloshes between radial and angular modes.
 *
 * Equations of motion (polar coordinates: r, θ):
 *   r̈ = r·θ̇² - (k/m)(r - L₀) + g·cos(θ) - (b/m)·ṙ
 *   θ̈ = -(g/r)·sin(θ) - (2/r)·ṙ·θ̇ - (b/m)·θ̇
 *
 * State: [r, vr, θ, ω, time]
 *   r  = radial distance from pivot (positive downward)
 *   vr = radial velocity
 *   θ  = angle from vertical (positive = right)
 *   ω  = angular velocity (dθ/dt)
 *
 * Coordinate system: pivot at top. r points from pivot to mass.
 *   θ measured from downward vertical (positive = counterclockwise for rendering).
 */

const G = 9.81;

export const SpringPendulumSim = {
  name: 'Spring Pendulum',
  slug: 'spring-pendulum',
  category: 'Mechanics',

  vars: {
    radius:   { index: 0, label: 'Radial distance (m)',  symbol: 'r' },
    radVel:   { index: 1, label: 'Radial velocity (m/s)', symbol: 'ṙ' },
    angle:    { index: 2, label: 'Angle (rad)',            symbol: 'θ' },
    angVel:   { index: 3, label: 'Angular velocity (rad/s)', symbol: 'ω' },
    time:     { index: 4, label: 'Time (s)',               symbol: 't' },
  },
  varCount: 5,

  params: {
    mass:       { value: 1.0, min: 0.1, max: 10,  step: 0.1, label: 'Mass',              unit: 'kg' },
    stiffness:  { value: 40,  min: 1,   max: 200, step: 1,   label: 'Spring Stiffness k', unit: 'N/m' },
    restLength: { value: 1.5, min: 0.3, max: 3,   step: 0.1, label: 'Rest Length L₀',    unit: 'm' },
    damping:    { value: 0.1, min: 0,   max: 5,   step: 0.05, label: 'Damping b',         unit: 'N·s/m' },
    initAngle:  { value: 30,  min: -90, max: 90,  step: 1,   label: 'Initial Angle',      unit: '°' },
    initStretch:{ value: 0.3, min: -1,  max: 2,   step: 0.1, label: 'Initial Stretch',    unit: 'm' },
  },

  views: ['sim', 'phase', 'time', 'energy'],

  graphDefaults: {
    phase: { x: 'angle', y: 'angVel' },
    time: ['radius', 'angle'],
  },

  worldRect: { xMin: -4, xMax: 4, yMin: -5, yMax: 1 },

  presets: [
    { name: 'Gentle Swing (30°)',          params: { initAngle: 30, initStretch: 0.3, damping: 0.1 } },
    { name: 'Pure Pendulum (no stretch)',   params: { initAngle: 30, initStretch: 0, stiffness: 200, damping: 0.1 } },
    { name: 'Pure Spring (no angle)',       params: { initAngle: 0, initStretch: 0.5, damping: 0.1 } },
    { name: 'Energy Transfer (resonance)',  params: { mass: 1.0, stiffness: 19.6, restLength: 1.5, initAngle: 30, initStretch: 0, damping: 0 } },
    { name: 'Large Angle (60°)',            params: { initAngle: 60, initStretch: 0.3, damping: 0.05 } },
    { name: 'Heavy Mass (5 kg)',            params: { mass: 5, initAngle: 20, initStretch: 0.5, damping: 0.2 } },
    { name: 'Stiff Spring (k=200)',         params: { stiffness: 200, initAngle: 20, initStretch: 0.1, damping: 0.1 } },
    { name: 'No Damping (forever)',         params: { damping: 0, initAngle: 30, initStretch: 0.3 } },
  ],

  /** Equilibrium radial distance: r_eq = L₀ + mg/k */
  _eqR(p) {
    return p.restLength + p.mass * G / p.stiffness;
  },

  init(p) {
    const eq = this._eqR(p);
    const r0 = eq + p.initStretch;
    const th0 = p.initAngle * Math.PI / 180;
    return [r0, 0, th0, 0, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[4] = 1; // dt/dt = 1
    if (isDragging) return;

    const [r, vr, theta, omega] = vars;
    const { mass, stiffness, restLength, damping } = params;

    // Clamp r to avoid singularity at r=0
    const rSafe = Math.max(r, 0.01);

    // Radial: r̈ = r·ω² - (k/m)(r - L₀) + g·cos(θ) - (b/m)·vr
    const springF = -stiffness * (rSafe - restLength) / mass;
    const centripetal = rSafe * omega * omega;
    const gravRadial = G * Math.cos(theta);
    const dampRadial = -damping * vr / mass;
    const ar = centripetal + springF + gravRadial + dampRadial;

    // Angular: θ̈ = -(g/r)·sin(θ) - (2/r)·vr·ω - (b/m)·ω
    const gravAngular = -G * Math.sin(theta) / rSafe;
    const coriolis = -2 * vr * omega / rSafe;
    const dampAngular = -damping * omega / mass;
    const alpha = gravAngular + coriolis + dampAngular;

    change[0] = vr;
    change[1] = ar;
    change[2] = omega;
    change[3] = alpha;
  },

  energy(vars, params) {
    const [r, vr, theta, omega] = vars;
    const { mass, stiffness, restLength } = params;

    // Kinetic: ½m(ṙ² + r²ω²)
    const KE = 0.5 * mass * (vr * vr + r * r * omega * omega);

    // Spring PE: ½k(r - L₀)²
    const springPE = 0.5 * stiffness * (r - restLength) * (r - restLength);

    // Gravitational PE: -mgr·cos(θ)  (pivot is at top, height = -r·cos(θ))
    const gravPE = -mass * G * r * Math.cos(theta);

    return { kinetic: KE, potential: springPE + gravPE, total: KE + springPE + gravPE };
  },

  theoreticalPeriod(params) {
    // Pendulum period (for small angle): T_p = 2π√(r_eq/g)
    const rEq = this._eqR(params);
    return 2 * Math.PI * Math.sqrt(rEq / G);
  },
  periodVar: 3, // measure period from angular velocity

  hitTest(wx, wy, vars, params) {
    const [r, , theta] = vars;
    const bx = r * Math.sin(theta);
    const by = -r * Math.cos(theta);
    const blockR = 0.2 + Math.sqrt(params.mass) * 0.06;
    if (Math.hypot(wx - bx, wy - by) < blockR + 0.3) {
      return { id: 'mass', offsetX: wx - bx, offsetY: wy - by };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    if (id === 'mass') {
      const cx = wx - (offset.offsetX || 0);
      const cy = wy - (offset.offsetY || 0);
      const r = Math.sqrt(cx * cx + cy * cy);
      const theta = Math.atan2(cx, -cy);
      vars[0] = Math.max(0.1, r);
      vars[1] = 0;
      vars[2] = theta;
      vars[3] = 0;
    }
  },

  onRelease() {},

  render(canvas, vars, params) {
    const [r, vr, theta, omega] = vars;
    const { mass, stiffness, restLength, damping } = params;
    const blockR = 0.2 + Math.sqrt(mass) * 0.06;

    // Mass position in Cartesian (pivot at origin)
    const bx = r * Math.sin(theta);
    const by = -r * Math.cos(theta);

    // ── Pivot ──
    canvas.circle(0, 0, 0.1, '#64748b', '#94A3B8');
    canvas.line(-0.3, 0.05, 0.3, 0.05, '#475569', 2);

    // ── Spring (from pivot to mass) ──
    canvas.spring(0, 0, bx, by, 14, 0.2, '#06B6D4');

    // ── Mass ──
    canvas.circle(bx, by, blockR, '#8B5CF6', '#A78BFA');
    canvas.text(bx, by, mass.toFixed(1) + 'kg', '#FFF', 9);

    // ── Equilibrium position (vertical, at r_eq) ──
    const eqR = this._eqR(params);
    const eqY = -eqR;
    canvas.circle(0, eqY, 0.06, '#22C55E', null);
    canvas.text(0.3, eqY, 'eq', '#22C55E', 8);

    // ── Natural length marker (vertical) ──
    const natY = -restLength;
    canvas.circle(0, natY, 0.04, '#F59E0B', null);
    canvas.text(0.3, natY, 'L₀', '#F59E0B', 7);

    // ── Vertical reference line (dashed feel) ──
    canvas.line(0, 0, 0, -4.5, '#334155', 1);

    // ── Angle arc indicator ──
    if (Math.abs(theta) > 0.02) {
      const arcR = 0.8;
      const arcEndX = arcR * Math.sin(theta);
      const arcEndY = -arcR * Math.cos(theta);
      canvas.line(0, -arcR, arcEndX, arcEndY, '#F59E0B', 1);
      const deg = (theta * 180 / Math.PI).toFixed(1);
      canvas.text(arcEndX * 1.6, arcEndY * 1.4, deg + '°', '#F59E0B', 9);
    }

    // ── Trail (last few positions for visual path) ──
    // No internal trail storage — the phase/time graphs serve this purpose.

    // ── Info text ──
    const Tp = 2 * Math.PI * Math.sqrt(eqR / G);
    const Ts = 2 * Math.PI * Math.sqrt(mass / stiffness);
    const ratio = Ts > 0 ? Tp / Ts : 0;

    canvas.text(0, 0.5, 'T_pend = ' + Tp.toFixed(3) + 's', '#94A3B8', 9);
    canvas.text(0, 0.75, 'T_spring = ' + Ts.toFixed(3) + 's', '#06B6D4', 9);
    canvas.text(0, 1.0, 'Ratio T_p/T_s = ' + ratio.toFixed(2), '#F59E0B', 9);

    if (Math.abs(ratio - 2) < 0.15) {
      canvas.text(0, -4.5, '⚡ Near 2:1 resonance — watch energy transfer!', '#EF4444', 10);
    }

    // Stretch info
    const stretch = r - restLength;
    canvas.text(-3, 0.5, 'r = ' + r.toFixed(3) + 'm', '#94A3B8', 8);
    canvas.text(-3, 0.75, 'stretch = ' + stretch.toFixed(3) + 'm', '#06B6D4', 8);
  },

  info: `
    <h2>Spring Pendulum (Elastic Pendulum)</h2>
    <p>A mass hangs from a pivot on an elastic spring. It can swing like a pendulum AND bounce up and down. This creates fascinating <strong>coupled oscillations</strong> where energy flows between the two modes.</p>

    <h3>Two Modes</h3>
    <ul>
      <li><strong>Spring mode:</strong> radial oscillation with period <code>T_s = 2π√(m/k)</code></li>
      <li><strong>Pendulum mode:</strong> angular oscillation with period <code>T_p ≈ 2π√(r_eq/g)</code></li>
    </ul>

    <h3>The Key Insight: 2:1 Resonance</h3>
    <p>When <code>T_pendulum ≈ 2 × T_spring</code> (i.e., <code>ω_spring ≈ 2ω_pendulum</code>), a dramatic <strong>parametric resonance</strong> occurs. Energy sloshes back and forth between radial and angular motion. The pendulum swing can nearly stop, then restart as energy flows back from the spring mode.</p>
    <p>This happens when: <code>k ≈ 3mg/L₀</code> (try the "Energy Transfer" preset).</p>

    <h3>Equations of Motion</h3>
    <p>In polar coordinates (r = distance from pivot, θ = angle from vertical):</p>
    <p><code>m·r̈ = m·r·θ̇² − k(r−L₀) + mg·cos(θ)</code></p>
    <p><code>m·r·θ̈ = −mg·sin(θ) − 2m·ṙ·θ̇</code> (Coriolis term!)</p>

    <h3>Try These</h3>
    <ol>
      <li><strong>Pure Spring:</strong> Set angle = 0°. Pure vertical bouncing — just a vertical spring.</li>
      <li><strong>Pure Pendulum:</strong> Set stretch = 0, high stiffness. Nearly rigid pendulum.</li>
      <li><strong>Energy Transfer (resonance):</strong> Watch the swing amplitude grow and shrink as energy moves between modes. The phase plot shows beautiful flower-like patterns.</li>
      <li><strong>No Damping:</strong> Energy transfer continues forever. With damping, both modes decay.</li>
      <li><strong>Drag the mass:</strong> Pull it to any position and release. Try large angles!</li>
    </ol>
  `,
};
