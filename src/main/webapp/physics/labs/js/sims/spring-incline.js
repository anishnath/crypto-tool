/**
 * Spring on Inclined Plane
 *
 * A mass is connected to a spring on a frictionless inclined plane.
 * The spring is attached to the top of the ramp.
 *
 * KEY INSIGHT: Only the component of gravity along the ramp matters.
 *   g_eff = g·sin(θ)
 *   Equilibrium shift = m·g·sin(θ)/k
 *   Period T = 2π√(m/k) — INDEPENDENT of angle! Same as horizontal.
 *
 * This is the inclined-plane version of the vertical spring insight:
 *   θ = 0°  → horizontal spring (no gravity effect)
 *   θ = 90° → vertical spring (full gravity)
 *   Any θ   → same period, different equilibrium shift
 *
 * State: [s, vs, time]
 *   s  = displacement along ramp from anchor (positive = downhill)
 *   vs = velocity along ramp (positive = downhill)
 *
 * Coordinate system: ramp surface. Anchor at top.
 */

const G = 9.81;

export const SpringInclineSim = {
  name: 'Spring on Incline',
  slug: 'spring-incline',
  category: 'Mechanics',

  vars: {
    position: { index: 0, label: 'Position along ramp (m)', symbol: 's' },
    velocity: { index: 1, label: 'Velocity (m/s)',           symbol: 'v' },
    time:     { index: 2, label: 'Time (s)',                  symbol: 't' },
  },
  varCount: 3,

  params: {
    mass:       { value: 1.0, min: 0.1, max: 10,  step: 0.1, label: 'Mass',            unit: 'kg' },
    stiffness:  { value: 20,  min: 1,   max: 100, step: 1,   label: 'Spring Stiffness', unit: 'N/m' },
    angle:      { value: 30,  min: 0,   max: 90,  step: 1,   label: 'Ramp Angle θ',    unit: '°' },
    damping:    { value: 0.3, min: 0,   max: 5,   step: 0.05, label: 'Damping',         unit: '' },
    friction:   { value: 0,   min: 0,   max: 0.5, step: 0.01, label: 'Friction μ_k',   unit: '' },
    restLength: { value: 1.5, min: 0.5, max: 3,   step: 0.1, label: 'Rest Length L₀',  unit: 'm' },
    startStretch: { value: 0.5, min: -1, max: 2, step: 0.1, label: 'Initial Stretch',   unit: 'm' },
  },

  views: ['sim', 'phase', 'time', 'energy'],

  graphDefaults: {
    phase: { x: 'position', y: 'velocity' },
    time: ['position', 'velocity'],
  },

  worldRect: { xMin: -1, xMax: 7, yMin: -1, yMax: 5 },

  presets: [
    { name: '30° (default)',         params: { angle: 30 } },
    { name: '45°',                   params: { angle: 45 } },
    { name: '90° (vertical)',        params: { angle: 90 } },
    { name: '0° (horizontal)',       params: { angle: 0 } },
    { name: '10° (gentle slope)',    params: { angle: 10 } },
    { name: 'With Friction (μ=0.2)', params: { angle: 30, friction: 0.2 } },
    { name: 'Heavy on Steep',        params: { mass: 5, angle: 60 } },
    { name: 'No Damping',            params: { angle: 30, damping: 0, friction: 0 } },
  ],

  /** Equilibrium: s_eq = L₀ + mg·sin(θ)/k */
  _eqS(p) {
    const th = p.angle * Math.PI / 180;
    const g = G;
    return p.restLength + p.mass * g * Math.sin(th) / p.stiffness;
  },

  init(p) {
    const eq = this._eqS(p);
    return [eq + p.startStretch, 0, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[2] = 1;
    if (isDragging) return;

    const [s, vs] = vars;
    const { mass, stiffness, angle, damping, friction, restLength } = params;
    const th = angle * Math.PI / 180;
    const g = G;

    // Spring force (toward anchor when stretched)
    const stretch = s - restLength;
    const springF = -stiffness * stretch;

    // Gravity component along ramp (downhill = positive s)
    const gravF = mass * g * Math.sin(th);

    // Normal force (for friction)
    const N = mass * g * Math.cos(th);

    // Kinetic friction (opposes motion)
    let frictionF = 0;
    if (Math.abs(vs) > 1e-4 && friction > 0) {
      frictionF = -friction * N * Math.sign(vs);
    } else if (friction > 0) {
      // Static friction: check if net force exceeds static friction
      const netWithoutFriction = springF + gravF;
      const staticMax = friction * N * 1.2;  // μ_s ≈ 1.2 × μ_k
      if (Math.abs(netWithoutFriction) < staticMax) {
        frictionF = -netWithoutFriction;  // exactly cancels — stuck
      } else {
        frictionF = -friction * N * Math.sign(netWithoutFriction);
      }
    }

    const accel = (springF + gravF + frictionF - damping * vs) / mass;
    change[0] = vs;
    change[1] = accel;
  },

  energy(vars, params) {
    const [s, vs] = vars;
    const { mass, stiffness, angle, restLength } = params;
    const th = angle * Math.PI / 180;
    const stretch = s - restLength;
    const KE = 0.5 * mass * vs * vs;
    const springPE = 0.5 * stiffness * stretch * stretch;
    // Gravitational PE: height = -s·sin(θ) (lower = more negative PE)
    const height = -s * Math.sin(th);
    const gravPE = mass * G * height;
    return { kinetic: KE, potential: springPE + gravPE, total: KE + springPE + gravPE };
  },

  potentialEnergy(s, params) {
    const { mass, stiffness, angle, restLength } = params;
    const th = angle * Math.PI / 180;
    const stretch = s - restLength;
    return 0.5 * stiffness * stretch * stretch - mass * G * s * Math.sin(th);
  },
  peWellConfig: { posVar: 0, posLabel: 's (m)', range: { min: 0, max: 5 } },

  theoreticalPeriod(params) {
    return 2 * Math.PI * Math.sqrt(params.mass / params.stiffness);
  },
  periodVar: 1,

  hitTest(wx, wy, vars, params) {
    // Convert ramp position to world coords
    const th = params.angle * Math.PI / 180;
    const s = vars[0];
    const bx = s * Math.cos(th);
    const by = 3.5 - s * Math.sin(th);
    const blockW = 0.2 + Math.sqrt(params.mass) * 0.06;
    if (Math.hypot(wx - bx, wy - by) < blockW + 0.3) {
      return { id: 'block', offsetS: s };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    if (id === 'block') {
      const th = params.angle * Math.PI / 180;
      // Project world position onto ramp axis
      const s = wx * Math.cos(th) + (3.5 - wy) * Math.sin(th);
      vars[0] = Math.max(0.1, s);
      vars[1] = 0;
    }
  },

  onRelease() {},

  render(canvas, vars, params) {
    const [s, vs] = vars;
    const { mass, stiffness, angle, friction, restLength } = params;
    const th = angle * Math.PI / 180;
    const ct = Math.cos(th), st = Math.sin(th);
    const blockW = 0.2 + Math.sqrt(mass) * 0.06;

    // Ramp geometry
    const rampLen = 6;
    const rampBaseX = 0, rampBaseY = 0;
    const rampTopX = rampLen * ct, rampTopY = 3.5;
    const rampBottomX = rampLen * ct, rampBottomY = rampTopY - rampLen * st;

    // ── Ramp surface ──
    canvas.line(0, 3.5, rampLen * ct, 3.5 - rampLen * st, '#475569', 3);
    // Ramp fill (triangle)
    canvas.line(0, 3.5, rampLen * ct, 3.5 - rampLen * st, '#334155', 1);
    canvas.line(rampLen * ct, 3.5 - rampLen * st, rampLen * ct, 3.5, '#334155', 1);
    canvas.line(rampLen * ct, 3.5, 0, 3.5, '#334155', 1);

    // ── Ground ──
    canvas.line(-0.5, 3.5, 7, 3.5, '#334155', 2);

    // ── Anchor at top of ramp ──
    const anchorX = 0, anchorY = 3.5;
    canvas.line(anchorX - 0.15, anchorY + 0.15, anchorX + 0.15, anchorY - 0.15, '#64748b', 2);
    canvas.line(anchorX - 0.15, anchorY - 0.15, anchorX + 0.15, anchorY + 0.15, '#64748b', 2);

    // ── Block position on ramp ──
    const bx = s * ct;
    const by = 3.5 - s * st;

    // Normal offset (perpendicular to ramp, block sits ON the surface)
    const nx = -st * blockW;  // normal direction x
    const ny = -ct * blockW;  // normal direction y

    // ── Spring (along ramp from anchor to block) ──
    canvas.spring(anchorX, anchorY, bx + nx * 0.5, by + ny * 0.5, 12, 0.15, '#06B6D4');

    // ── Block (drawn as rotated square) ──
    canvas.rect(bx - blockW * ct + nx, by + blockW * st + ny,
                blockW * 2 * ct, blockW * 2 * ct, '#8B5CF6', '#A78BFA');
    canvas.text(bx + nx, by + ny, mass.toFixed(1) + 'kg', '#FFF', 9);

    // ── Equilibrium marker ──
    const eqS = this._eqS(params);
    const eqX = eqS * ct, eqY = 3.5 - eqS * st;
    canvas.circle(eqX - st * 0.3, eqY - ct * 0.3, 0.06, '#22C55E', null);
    canvas.text(eqX - st * 0.5, eqY - ct * 0.5, 'eq', '#22C55E', 7);

    // ── Natural length marker ──
    const natX = restLength * ct, natY = 3.5 - restLength * st;
    canvas.circle(natX - st * 0.3, natY - ct * 0.3, 0.04, '#F59E0B', null);
    canvas.text(natX - st * 0.5, natY - ct * 0.5, 'L₀', '#F59E0B', 7);

    // ── Angle arc ──
    canvas.text(1.2, 3.3, angle + '°', '#94A3B8', 10);

    // ── Force arrows (along ramp) ──
    // Gravity component (downhill)
    const gComp = mass * G * st;
    const gLen = Math.min(0.8, gComp / 30);
    if (gLen > 0.02) {
      const gx = bx + gLen * ct, gy = by - gLen * st;
      canvas.line(bx, by, gx, gy, '#EF4444', 2);
      canvas.text(gx + 0.2, gy, 'mg sinθ', '#EF4444', 7);
    }

    // ── Info ──
    const T = 2 * Math.PI * Math.sqrt(mass / stiffness);
    const eqShift = mass * G * st / stiffness;
    canvas.text(3.5, -0.3, 'T = 2π√(m/k) = ' + T.toFixed(3) + 's', '#94A3B8', 10);
    canvas.text(3.5, -0.55, 'Eq shift = mg sinθ/k = ' + eqShift.toFixed(3) + 'm', '#22C55E', 9);
    canvas.text(3.5, -0.8, 'Period is INDEPENDENT of angle!', '#F59E0B', 10);

    if (friction > 0) {
      canvas.text(3.5, 4.3, 'Friction μ = ' + friction + ' (energy lost to heat)', '#F59E0B', 9);
    }
  },

  info: `
    <h2>Spring on Inclined Plane</h2>
    <p>A mass attached to a spring slides on a ramp. The spring is anchored at the top of the incline. Gravity pulls the mass downhill with component <code>mg·sin(θ)</code>.</p>

    <h3>The Key Insight</h3>
    <p><strong>The period is independent of the ramp angle:</strong> <code>T = 2π√(m/k)</code> — exactly the same as horizontal or vertical. Only the equilibrium position shifts.</p>

    <h3>Why?</h3>
    <p>Along the ramp, the effective gravity is <code>g_eff = g·sin(θ)</code>. This is a constant force (like gravity in the vertical spring), so it shifts the equilibrium by <code>mg·sin(θ)/k</code> but doesn't change the restoring force's spring constant. The frequency depends only on k and m.</p>

    <h3>Equilibrium</h3>
    <p><code>s_eq = L₀ + mg·sin(θ)/k</code></p>
    <ul>
      <li>θ = 0° (horizontal) → no shift (eq at natural length)</li>
      <li>θ = 90° (vertical) → maximum shift = mg/k</li>
      <li>Any angle → proportional to sin(θ)</li>
    </ul>

    <h3>With Friction</h3>
    <p>Kinetic friction <code>f = μ·N = μ·mg·cos(θ)</code> opposes motion. It dissipates energy and the oscillation decays faster than damping alone. The mass may get "stuck" if static friction exceeds the net spring+gravity force.</p>

    <h3>Try These</h3>
    <ol>
      <li><strong>Change angle from 0° to 90°:</strong> Watch equilibrium shift downhill, but the oscillation frequency stays the same!</li>
      <li><strong>Compare 30° vs 45° vs 90°:</strong> Count oscillation cycles — same period for all.</li>
      <li><strong>Add friction (μ=0.2):</strong> Oscillation decays faster. Mass may stop short of equilibrium.</li>
      <li><strong>Phase tab:</strong> Without friction: ellipse. With friction: spirals inward and may collapse to a point (stuck).</li>
      <li><strong>Energy tab:</strong> With friction, total energy decreases steadily (lost to heat).</li>
    </ol>
  `,
};
