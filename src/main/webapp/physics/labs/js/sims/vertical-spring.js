/**
 * Vertical Spring with Gravity
 *
 * A mass hangs from a spring attached to the ceiling.
 * Unlike the horizontal spring, gravity shifts the equilibrium:
 *   x_eq = L₀ + mg/k
 *
 * KEY INSIGHT: Gravity does NOT change the period!
 *   T = 2π√(m/k) — same as horizontal. Only the center shifts.
 *
 * Coordinate system: y increases UPWARD.
 *   Ceiling anchor at y = ANCHOR_Y
 *   Mass hangs below: y = ANCHOR_Y - (natural length + stretch)
 *
 * State: [y, vy, time]
 *   y  = vertical position of mass center (upward positive)
 *   vy = velocity (upward positive)
 */

const G = 9.81;
const ANCHOR_Y = 4.5;

export const VerticalSpringSim = {
  name: 'Vertical Spring',
  slug: 'vertical-spring',
  category: 'Mechanics',

  vars: {
    position: { index: 0, label: 'Position (m)',   symbol: 'y' },
    velocity: { index: 1, label: 'Velocity (m/s)', symbol: 'v' },
    time:     { index: 2, label: 'Time (s)',        symbol: 't' },
  },
  varCount: 3,

  params: {
    mass:       { value: 1.0, min: 0.1, max: 10, step: 0.1, label: 'Mass',            unit: 'kg' },
    stiffness:  { value: 20,  min: 1,   max: 100, step: 1,  label: 'Spring Stiffness', unit: 'N/m' },
    damping:    { value: 0.2, min: 0,   max: 5,  step: 0.05, label: 'Damping',         unit: '' },
    restLength: { value: 1.0, min: 0.3, max: 3,  step: 0.1, label: 'Rest Length L₀',  unit: 'm' },
    gravity:    { value: 9.81, min: 0.1, max: 25, step: 0.1, label: 'Gravity g',       unit: 'm/s²' },
    startStretch: { value: 0.5, min: -1, max: 3, step: 0.1, label: 'Initial Stretch',  unit: 'm' },
  },

  views: ['sim', 'phase', 'time', 'energy', 'well'],

  graphDefaults: {
    phase: { x: 'position', y: 'velocity' },
    time: ['position', 'velocity'],
  },

  worldRect: { xMin: -2.5, xMax: 2.5, yMin: -1, yMax: 5.5 },

  presets: [
    { name: 'Default',           params: {} },
    { name: 'No Damping',        params: { damping: 0 } },
    { name: 'Heavy Mass',        params: { mass: 5, stiffness: 20 } },
    { name: 'Soft Spring',       params: { stiffness: 5, startStretch: 1.0 } },
    { name: 'Stiff Spring',      params: { stiffness: 80 } },
    { name: 'Overdamped',        params: { damping: 5, stiffness: 5 } },
    { name: 'Moon (g=1.62)',     params: { gravity: 1.62 } },
    { name: 'Large Amplitude',   params: { startStretch: 2.0, damping: 0 } },
  ],

  /** Equilibrium position: y_eq = ANCHOR_Y - L₀ - mg/k */
  _eqY(p) {
    const g = p.gravity || G;
    return ANCHOR_Y - p.restLength - p.mass * g / p.stiffness;
  },

  init(p) {
    const eqY = this._eqY(p);
    return [eqY - p.startStretch, 0, 0];  // start displaced below equilibrium
  },

  evaluate(vars, change, params, isDragging) {
    change[2] = 1;
    if (isDragging) return;

    const [y, vy] = vars;
    const { mass, stiffness, damping, restLength } = params;
    const g = params.gravity || G;

    // Spring extension = (ANCHOR_Y - y) - restLength
    // Force up = k × extension, Force down = mg
    const extension = (ANCHOR_Y - y) - restLength;
    const accel = (stiffness * extension) / mass - g - (damping / mass) * vy;

    change[0] = vy;
    change[1] = accel;
  },

  energy(vars, params) {
    const [y, vy] = vars;
    const { mass, stiffness, restLength } = params;
    const g = params.gravity || G;
    const extension = (ANCHOR_Y - y) - restLength;
    const KE = 0.5 * mass * vy * vy;
    const springPE = 0.5 * stiffness * extension * extension;
    const gravPE = mass * g * y;  // gravitational PE (reference at y=0)
    return { kinetic: KE, potential: springPE + gravPE, total: KE + springPE + gravPE };
  },

  potentialEnergy(y, params) {
    const { mass, stiffness, restLength } = params;
    const g = params.gravity || G;
    const extension = (ANCHOR_Y - y) - restLength;
    return 0.5 * stiffness * extension * extension + mass * g * y;
  },
  peWellConfig: { posVar: 0, posLabel: 'y (m)', range: { min: 0, max: 5 } },

  theoreticalPeriod(params) {
    return 2 * Math.PI * Math.sqrt(params.mass / params.stiffness);
  },
  periodVar: 1,

  hitTest(wx, wy, vars, params) {
    const blockY = vars[0];
    const blockW = 0.15 + Math.sqrt(params.mass) * 0.06;
    if (Math.abs(wx) < blockW + 0.2 && Math.abs(wy - blockY) < blockW + 0.2) {
      return { id: 'block', offsetY: wy - blockY };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars) {
    if (id === 'block') {
      vars[0] = wy - offset.offsetY;
      vars[1] = 0;
    }
  },

  onRelease() {},

  render(canvas, vars, params) {
    const [y] = vars;
    const { mass, stiffness, restLength } = params;
    const g = params.gravity || G;
    const blockW = 0.15 + Math.sqrt(mass) * 0.06;

    const eqY = this._eqY(params);
    const natY = ANCHOR_Y - restLength;  // natural (unstretched) position

    // ── Ceiling ──
    canvas.line(-2, ANCHOR_Y, 2, ANCHOR_Y, '#64748B', 4);
    for (let i = -1.8; i <= 1.8; i += 0.2) {
      canvas.line(i, ANCHOR_Y, i + 0.12, ANCHOR_Y + 0.12, '#64748B', 1);
    }

    // ── Spring (zigzag from ceiling to block top) ──
    const blockTop = y + blockW;
    canvas.spring(0, ANCHOR_Y, 0, blockTop, 14, 0.2, '#06B6D4');

    // ── Block ──
    canvas.rect(-blockW, y - blockW, blockW * 2, blockW * 2, '#8B5CF6', '#A78BFA');
    canvas.text(0, y, mass.toFixed(1) + ' kg', '#FFF', 10);

    // ── Equilibrium marker ──
    canvas.line(-1.5, eqY, -0.5, eqY, '#22C55E', 1);
    canvas.text(-1.8, eqY, 'eq', '#22C55E', 8);

    // ── Natural length marker ──
    canvas.line(0.5, natY, 1.5, natY, '#F59E0B', 1);
    canvas.text(1.7, natY, 'L₀', '#F59E0B', 8);

    // ── Force arrows ──
    // Gravity (down)
    const gForce = mass * g;
    const gLen = Math.min(1.0, gForce / 50);
    canvas.line(blockW + 0.2, y, blockW + 0.2, y - gLen, '#EF4444', 2);
    canvas.line(blockW + 0.14, y - gLen + 0.08, blockW + 0.2, y - gLen, '#EF4444', 2);
    canvas.line(blockW + 0.26, y - gLen + 0.08, blockW + 0.2, y - gLen, '#EF4444', 2);
    canvas.text(blockW + 0.5, y - gLen / 2, 'mg', '#EF4444', 8);

    // Spring force (up when stretched, down when compressed)
    const extension = (ANCHOR_Y - y) - restLength;
    const sForce = stiffness * extension;
    const sLen = Math.min(1.0, Math.abs(sForce) / 50);
    const sDir = sForce > 0 ? 1 : -1;  // positive = upward (restoring)
    canvas.line(-blockW - 0.2, y, -blockW - 0.2, y + sDir * sLen, '#06B6D4', 2);
    canvas.line(-blockW - 0.14, y + sDir * sLen - sDir * 0.08, -blockW - 0.2, y + sDir * sLen, '#06B6D4', 2);
    canvas.line(-blockW - 0.26, y + sDir * sLen - sDir * 0.08, -blockW - 0.2, y + sDir * sLen, '#06B6D4', 2);
    canvas.text(-blockW - 0.5, y + sDir * sLen / 2, 'kx', '#06B6D4', 8);

    // ── Info ──
    const T = 2 * Math.PI * Math.sqrt(mass / stiffness);
    canvas.text(0, -0.3, 'T = 2π√(m/k) = ' + T.toFixed(3) + 's', '#94A3B8', 10);
    canvas.text(0, -0.6, 'eq shift = mg/k = ' + (mass * g / stiffness).toFixed(3) + 'm below L₀', '#22C55E', 9);
    canvas.text(0, -0.85, 'Period is INDEPENDENT of gravity!', '#F59E0B', 10);

    // Gravity label
    const gLabel = g === 9.81 ? 'Earth' : g === 1.62 ? 'Moon' : g === 3.72 ? 'Mars' : g === 24.79 ? 'Jupiter' : '';
    if (gLabel) canvas.text(1.8, -0.3, 'g = ' + g.toFixed(2) + ' (' + gLabel + ')', '#64748b', 8);
  },

  info: `
    <h2>Vertical Spring with Gravity</h2>
    <p>A mass hangs from a spring attached to the ceiling. Unlike a horizontal spring, gravity shifts the equilibrium position downward — but <strong>does NOT change the period</strong>.</p>

    <h3>The Key Insight</h3>
    <p><strong>Period is independent of gravity:</strong> <code>T = 2π√(m/k)</code> — exactly the same formula as the horizontal spring. Gravity only shifts WHERE the mass oscillates, not HOW FAST.</p>

    <h3>Why?</h3>
    <p>Gravity is a constant force. It shifts the equilibrium from L₀ to L₀ + mg/k. If you measure displacement from the NEW equilibrium, the equation of motion is identical to the horizontal case — gravity cancels out.</p>

    <h3>Equilibrium Position</h3>
    <p><code>y_eq = anchor − L₀ − mg/k</code></p>
    <p>The green "eq" marker shows this position. The yellow "L₀" marker shows the natural (unstretched) length. The gap between them is <code>mg/k</code>.</p>

    <h3>Try These</h3>
    <ol>
      <li><strong>Default:</strong> Watch the mass oscillate around the equilibrium (green line), NOT around L₀ (yellow line).</li>
      <li><strong>Heavy Mass:</strong> Equilibrium shifts down (more stretch), but period increases because T ∝ √m.</li>
      <li><strong>Stiff vs Soft:</strong> Stiff spring → small eq shift + fast oscillation. Soft spring → large shift + slow.</li>
      <li><strong>Moon gravity:</strong> Equilibrium shifts UP (less stretch) but the period stays EXACTLY the same! This proves T is g-independent.</li>
      <li><strong>Large Amplitude:</strong> Even with big swings, period doesn't change (SHM is isochronous).</li>
      <li><strong>Energy tab:</strong> Watch KE + (spring PE + gravitational PE) = constant. The PE well is shifted by gravity.</li>
      <li><strong>Phase tab:</strong> Ellipse centered at the equilibrium, not at L₀.</li>
    </ol>

    <h3>Compared to Horizontal Spring</h3>
    <table style="border-collapse:collapse;font-size:14px;">
      <tr><th style="padding:4px 12px;border:1px solid #334;text-align:left;">Property</th><th style="padding:4px 12px;border:1px solid #334;">Horizontal</th><th style="padding:4px 12px;border:1px solid #334;">Vertical</th></tr>
      <tr><td style="padding:4px 12px;border:1px solid #334;">Period T</td><td style="padding:4px 12px;border:1px solid #334;">2π√(m/k)</td><td style="padding:4px 12px;border:1px solid #334;">2π√(m/k) — <strong>same!</strong></td></tr>
      <tr><td style="padding:4px 12px;border:1px solid #334;">Equilibrium</td><td style="padding:4px 12px;border:1px solid #334;">At natural length L₀</td><td style="padding:4px 12px;border:1px solid #334;">L₀ + mg/k (shifted down)</td></tr>
      <tr><td style="padding:4px 12px;border:1px solid #334;">Gravity effect</td><td style="padding:4px 12px;border:1px solid #334;">None</td><td style="padding:4px 12px;border:1px solid #334;">Shifts center only</td></tr>
      <tr><td style="padding:4px 12px;border:1px solid #334;">PE</td><td style="padding:4px 12px;border:1px solid #334;">½kx²</td><td style="padding:4px 12px;border:1px solid #334;">½k(extension)² + mgy</td></tr>
    </table>
  `,
};
