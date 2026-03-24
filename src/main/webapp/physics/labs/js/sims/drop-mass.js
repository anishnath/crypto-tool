/**
 * Dropping a Mass on an Oscillating Mass
 *
 * A mass m₁ hangs from a spring attached to the ceiling and oscillates
 * vertically. A second mass m₂ is dropped from a shelf above m₁.
 * On contact: perfectly inelastic collision.
 *
 *   v_after = (m₁·v₁ + m₂·v₂) / (m₁ + m₂)
 *
 * Coordinate system: y increases UPWARD. Anchor at y = ANCHOR_Y.
 * Block hangs below anchor. Drop mass falls downward (y decreases).
 *
 * State: [y, vy, time]
 *   y  = vertical position of block center (upward positive)
 *   vy = velocity of block (upward positive)
 */

const G = 9.81;
const ANCHOR_Y = 4.0;  // ceiling anchor position

export const DropMassSim = {
  name: 'Drop Mass on Oscillator',
  slug: 'drop-mass',
  category: 'Mechanics',

  vars: {
    position: { index: 0, label: 'Position (m)',   symbol: 'y' },
    velocity: { index: 1, label: 'Velocity (m/s)', symbol: 'v' },
    time:     { index: 2, label: 'Time (s)',        symbol: 't' },
  },
  varCount: 3,

  params: {
    m1:         { value: 1.0, min: 0.2, max: 5,  step: 0.1,  label: 'Oscillating Mass m₁', unit: 'kg' },
    m2:         { value: 0.5, min: 0.1, max: 5,  step: 0.1,  label: 'Drop Mass m₂',        unit: 'kg' },
    k:          { value: 20,  min: 1,   max: 100, step: 1,    label: 'Spring Stiffness k',  unit: 'N/m' },
    damping:    { value: 0.2, min: 0,   max: 5,  step: 0.05, label: 'Damping b',           unit: '' },
    restLength: { value: 1.0, min: 0.3, max: 3,  step: 0.1,  label: 'Rest Length L₀',      unit: 'm' },
    dropHeight: { value: 1.2, min: 0.3, max: 3,  step: 0.1,  label: 'Drop Height h',       unit: 'm' },
    startStretch: { value: 0.3, min: -1, max: 2, step: 0.1,  label: 'Initial Stretch',     unit: 'm' },
  },

  views: ['sim', 'phase', 'time', 'energy'],

  graphDefaults: {
    phase: { x: 'position', y: 'velocity' },
    time: ['position', 'velocity'],
  },

  worldRect: { xMin: -2.5, xMax: 2.5, yMin: -1, yMax: 5 },

  presets: [
    { name: 'Default',           params: {} },
    { name: 'Equal Masses',      params: { m1: 1.0, m2: 1.0, k: 20, dropHeight: 1.2 } },
    { name: 'Heavy Drop',        params: { m1: 0.5, m2: 2.0, k: 20, dropHeight: 1.0 } },
    { name: 'Light Tap',         params: { m1: 2.0, m2: 0.2, k: 20, dropHeight: 0.5 } },
    { name: 'Stiff Spring',     params: { k: 80, m1: 1.0, m2: 1.0, dropHeight: 1.2 } },
    { name: 'Soft Spring',      params: { k: 5,  m1: 1.0, m2: 1.0, dropHeight: 1.2 } },
    { name: 'No Damping',       params: { damping: 0 } },
    { name: 'High Drop',        params: { m1: 1.0, m2: 1.0, dropHeight: 2.8, k: 30 } },
  ],

  // ─── Internal state ───
  _dropping: false,
  _landed: false,
  _dropY: 0,
  _dropVy: 0,
  _shelfY: 0,
  _massOnSpring: 0,
  _collisionTime: undefined,
  _energyLost: 0,

  _eqY(m, p) {
    // Equilibrium: y_eq = ANCHOR_Y - L₀ - mg/k
    return ANCHOR_Y - p.restLength - m * G / p.k;
  },

  init(p) {
    this._dropping = false;
    this._landed = false;
    this._dropY = 0;
    this._dropVy = 0;
    this._massOnSpring = p.m1;
    this._collisionTime = undefined;
    this._energyLost = 0;

    const eq = this._eqY(p.m1, p);
    // Shelf is above equilibrium by dropHeight
    this._shelfY = eq + p.dropHeight;

    // Start displaced below equilibrium
    return [eq - p.startStretch, 0, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[2] = 1;
    if (isDragging) return;

    const [y, vy] = vars;
    const m = this._massOnSpring;
    const { k, damping, restLength } = params;

    // Spring extension = (ANCHOR_Y - y) - restLength
    // Force up = k * extension, force down = mg
    const extension = (ANCHOR_Y - y) - restLength;
    const accel = (k * extension) / m - G - (damping / m) * vy;

    change[0] = vy;
    change[1] = accel;
  },

  postStep(vars, params, dt) {
    if (!this._dropping || this._landed) return;
    if (!dt) dt = 1 / 120;  // fallback to runner's default

    // Free fall: accelerate downward (vy becomes more negative)
    this._dropVy -= G * dt;
    this._dropY += this._dropVy * dt;

    // Collision: drop mass reaches block top
    const blockY = vars[0];
    const blockW = 0.18 * Math.sqrt(this._massOnSpring);
    const m2W = 0.12 * Math.sqrt(params.m2);
    const blockTop = blockY + blockW;
    const dropBottom = this._dropY - m2W;

    if (dropBottom <= blockTop) {
      const { m1, m2 } = params;
      const v1 = vars[1];
      const v2 = this._dropVy;
      const vAfter = (m1 * v1 + m2 * v2) / (m1 + m2);

      vars[1] = vAfter;
      this._massOnSpring = m1 + m2;
      this._landed = true;
      this._dropping = false;
      this._collisionTime = vars[2];
      this._energyLost = 0.5 * m1 * v1 * v1 + 0.5 * m2 * v2 * v2
                        - 0.5 * (m1 + m2) * vAfter * vAfter;
    }
  },

  energy(vars, params) {
    const [y, vy] = vars;
    const m = this._massOnSpring;
    const { k, restLength, m2 } = params;
    const extension = (ANCHOR_Y - y) - restLength;
    let KE = 0.5 * m * vy * vy;
    let PE = 0.5 * k * extension * extension + m * G * (ANCHOR_Y - y);
    // Include falling mass KE/PE before collision (so energy graph shows true total)
    if (this._dropping && !this._landed) {
      KE += 0.5 * m2 * this._dropVy * this._dropVy;
      PE += m2 * G * (ANCHOR_Y - this._dropY);
    }
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  theoreticalPeriod(params) {
    const m = this._landed ? params.m1 + params.m2 : params.m1;
    return 2 * Math.PI * Math.sqrt(m / params.k);
  },
  periodVar: 1,

  hitTest(wx, wy, vars, params) {
    const blockY = vars[0];
    const blockW = 0.18 * Math.sqrt(this._massOnSpring);
    if (Math.abs(wx) < blockW + 0.2 && Math.abs(wy - blockY) < blockW + 0.2) {
      return { id: 'block', offsetY: wy - blockY };
    }
    if (!this._dropping && !this._landed) {
      const m2W = 0.12 * Math.sqrt(params.m2);
      if (Math.abs(wx) < m2W + 0.3 && Math.abs(wy - this._shelfY) < m2W + 0.3) {
        return { id: 'dropMass' };
      }
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars) {
    if (id === 'block') {
      vars[0] = wy - offset.offsetY;
      vars[1] = 0;
    }
  },

  onRelease(id, vars, params) {
    if (id === 'dropMass') {
      if (this._dropping || this._landed) return;
      const eq = this._eqY(params.m1, params);
      this._shelfY = eq + params.dropHeight;
      this._dropY = this._shelfY;
      this._dropVy = 0;
      this._dropping = true;
    }
  },

  render(canvas, vars, params) {
    const [y] = vars;
    const { k, restLength, m1, m2, dropHeight } = params;
    const m = this._massOnSpring;

    const blockW = 0.18 * Math.sqrt(m);
    const m2W = 0.12 * Math.sqrt(m2);

    const eq1 = this._eqY(m1, params);
    const eq2 = this._eqY(m1 + m2, params);

    // ── Ceiling ──
    canvas.line(-2, ANCHOR_Y, 2, ANCHOR_Y, '#64748B', 4);
    for (let i = -1.8; i <= 1.8; i += 0.2) {
      canvas.line(i, ANCHOR_Y, i + 0.12, ANCHOR_Y + 0.12, '#64748B', 1);
    }

    // ── Spring (anchor down to block top) ──
    const blockTop = y + blockW;
    canvas.spring(0, ANCHOR_Y, 0, blockTop, 14, 0.25, '#06B6D4');

    // ── Oscillating block ──
    const blockColor = this._landed ? '#7C3AED' : '#8B5CF6';
    const blockStroke = this._landed ? '#6D28D9' : '#A78BFA';
    canvas.rect(-blockW, y - blockW, blockW * 2, blockW * 2, blockColor, blockStroke);
    const massLabel = this._landed ? (m1 + m2).toFixed(1) : m1.toFixed(1);
    canvas.text(0, y, massLabel + ' kg', '#FFF', 11);

    // ── Equilibrium markers ──
    canvas.line(-1.8, eq1, -0.8, eq1, '#22C55E', 1);
    canvas.text(-2.1, eq1, 'eq₁', '#22C55E', 9);
    canvas.line(0.8, eq2, 1.8, eq2, '#F59E0B', 1);
    canvas.text(1.9, eq2, 'eq₂', '#F59E0B', 9);

    // ── Drop mass m₂ ──
    if (!this._landed) {
      const dy = this._dropping ? this._dropY : this._shelfY;

      // Shelf (before drop)
      if (!this._dropping) {
        canvas.line(-0.7, this._shelfY - m2W, 0.7, this._shelfY - m2W, '#475569', 2);
        canvas.text(0, this._shelfY + m2W + 0.15, 'Click to drop!', '#94A3B8', 10);
      }

      // The red drop mass
      canvas.rect(-m2W, dy - m2W, m2W * 2, m2W * 2, '#EF4444', '#DC2626');
      canvas.text(0, dy, m2.toFixed(1) + ' kg', '#FFF', 10);

      // Height annotation
      if (!this._dropping) {
        const hTop = this._shelfY - m2W;
        const hBot = y + blockW;
        if (hTop - hBot > 0.15) {
          canvas.line(-1.0, hTop, -1.0, hBot, '#94A3B8', 1);
          canvas.line(-1.05, hTop, -0.95, hTop, '#94A3B8', 1);
          canvas.line(-1.05, hBot, -0.95, hBot, '#94A3B8', 1);
          canvas.text(-1.4, (hTop + hBot) / 2, 'h', '#94A3B8', 10);
        }
      }
    }

    // ── Collision flash ──
    if (this._landed && this._collisionTime !== undefined) {
      const dt = vars[2] - this._collisionTime;
      if (dt < 5) {
        const alpha = Math.max(0, 1 - dt / 5);
        canvas.text(1.2, y + 0.3, 'COLLISION!', `rgba(239,68,68,${alpha})`, 12);
        canvas.text(1.2, y + 0.05, `ΔKE = -${this._energyLost.toFixed(2)} J`, `rgba(245,158,11,${alpha})`, 10);
        canvas.text(1.2, y - 0.2, `ω₂ = ${Math.sqrt(k / (m1 + m2)).toFixed(2)} rad/s`, `rgba(34,197,94,${alpha})`, 10);
      }
    }

    // ── Period info ──
    const T1 = 2 * Math.PI * Math.sqrt(m1 / k);
    const T2 = 2 * Math.PI * Math.sqrt((m1 + m2) / k);
    canvas.text(-2.0, -0.4, `T₁ = ${T1.toFixed(3)}s`, '#22C55E', 10);
    canvas.text(-2.0, -0.65, `T₂ = ${T2.toFixed(3)}s`, '#F59E0B', 10);
  },

  info: `
    <h2>Dropping a Mass on an Oscillating Mass</h2>
    <p>A mass m₁ hangs from a spring and oscillates vertically. A second mass m₂ is dropped from a shelf above. When they collide, they stick together (perfectly inelastic collision) and oscillate as a combined system.</p>

    <h3>Before the Drop</h3>
    <ul>
      <li><strong>Frequency:</strong> <code>&omega;₁ = &radic;(k/m₁)</code></li>
      <li><strong>Period:</strong> <code>T₁ = 2&pi;&radic;(m₁/k)</code></li>
      <li><strong>Equilibrium:</strong> <code>y_eq₁</code> — where spring force balances gravity</li>
    </ul>

    <h3>The Collision</h3>
    <p>m₂ falls from height h, arriving with velocity <code>v₂ = &radic;(2gh)</code> downward.</p>
    <p><strong>Momentum conservation</strong> (perfectly inelastic):</p>
    <p><code>(m₁+m₂)&middot;v_after = m₁&middot;v₁ + m₂&middot;v₂</code></p>
    <p>Kinetic energy is <strong>lost</strong>:</p>
    <p><code>&Delta;KE = &frac12;m₁v₁&sup2; + &frac12;m₂v₂&sup2; &minus; &frac12;(m₁+m₂)v_after&sup2;</code></p>

    <h3>After the Drop</h3>
    <ul>
      <li><strong>Slower frequency:</strong> <code>&omega;₂ = &radic;(k/(m₁+m₂))</code></li>
      <li><strong>Longer period:</strong> <code>T₂ = 2&pi;&radic;((m₁+m₂)/k)</code></li>
      <li><strong>Lower equilibrium:</strong> eq₂ is below eq₁ by <code>m₂g/k</code></li>
      <li><strong>Amplitude</strong> depends on collision timing!</li>
    </ul>

    <h3>Try These</h3>
    <ol>
      <li><strong>Default:</strong> Watch m₁ oscillate, then click the red mass to drop it. Notice the frequency change.</li>
      <li><strong>Equal Masses:</strong> Frequency drops by &radic;2. Period increases ~41%.</li>
      <li><strong>Heavy Drop:</strong> m₂ &gt; m₁ — dramatic slowdown and large energy loss.</li>
      <li><strong>Light Tap:</strong> Tiny m₂ barely affects the oscillation.</li>
      <li><strong>Timing experiment:</strong> Reset several times. Drop m₂ at different phases — the resulting amplitude changes!</li>
      <li><strong>Energy tab:</strong> Watch total energy drop instantly at the collision moment.</li>
    </ol>

    <h3>Key Insight</h3>
    <p>Momentum is <strong>always conserved</strong>. Kinetic energy is <strong>not</strong> — the &ldquo;missing&rdquo; energy goes to deformation and heat. This is what makes inelastic collisions fundamentally different from elastic ones.</p>
  `,
};
