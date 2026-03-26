/**
 * Bullet–Block–Spring
 *
 * A bullet is fired into a block resting on a surface with friction.
 * The block is connected to a spring attached to a wall.
 *
 * TWO PHASES:
 *   1. Bullet approaches (visual: ~0.5s) — block at rest
 *   2. Collision (perfectly inelastic) → block+bullet oscillate on spring
 *
 * KEY INSIGHTS:
 *   - Momentum is conserved: m·v₀ = (m+M)·v₁
 *   - Most KE is LOST in the collision (often >99%)
 *   - Friction further dissipates remaining energy
 *   - Maximum compression: ½(m+M)v₁² = ½k·x² + μ(m+M)g·x
 *
 * Coordinate system:
 *   x = position of block along surface (from wall, positive = right)
 *   Wall at x = 0. Spring natural length = L₀.
 *   Block starts at x = L₀ (spring relaxed).
 *   Bullet approaches from the right.
 *
 * State: [x, vx, bulletX, time]
 */

const G = 9.81;

export const BulletBlockSim = {
  name: 'Bullet–Block–Spring',
  slug: 'bullet-block',
  category: 'Mechanics',

  vars: {
    position:  { index: 0, label: 'Block position (m)',   symbol: 'x' },
    velocity:  { index: 1, label: 'Block velocity (m/s)', symbol: 'v' },
    bulletPos: { index: 2, label: 'Bullet position (m)',  symbol: 'x_b' },
    time:      { index: 3, label: 'Time (s)',             symbol: 't' },
  },
  varCount: 4,

  params: {
    bulletMass:  { value: 0.01,  min: 0.001, max: 0.5,  step: 0.001, label: 'Bullet Mass m',   unit: 'kg' },
    bulletSpeed: { value: 400,   min: 50,    max: 1000, step: 10,    label: 'Bullet Speed v₀',  unit: 'm/s' },
    blockMass:   { value: 2.0,   min: 0.5,   max: 20,   step: 0.1,   label: 'Block Mass M',     unit: 'kg' },
    springMass:  { value: 0,     min: 0,     max: 2,    step: 0.05,  label: 'Spring Mass mₛ',   unit: 'kg' },
    stiffness:   { value: 500,   min: 10,    max: 5000, step: 10,    label: 'Spring k',         unit: 'N/m' },
    friction:    { value: 0.3,   min: 0,     max: 1.0,  step: 0.01,  label: 'Friction μ_k',     unit: '' },
    restLength:  { value: 1.5,   min: 0.5,   max: 3,    step: 0.1,   label: 'Spring Length L₀', unit: 'm' },
  },

  views: ['sim', 'phase', 'time', 'energy'],

  graphDefaults: {
    phase: { x: 'position', y: 'velocity' },
    time: ['position', 'velocity'],
  },

  worldRect: { xMin: -0.5, xMax: 5, yMin: -1.5, yMax: 2.5 },

  presets: [
    { name: 'Default (10g @ 400 m/s)',     params: {} },
    { name: 'Heavy Bullet (50g @ 200)',     params: { bulletMass: 0.05, bulletSpeed: 200 } },
    { name: 'Frictionless',                 params: { friction: 0 } },
    { name: 'High Friction (μ=0.8)',        params: { friction: 0.8 } },
    { name: 'Stiff Spring (k=5000)',        params: { stiffness: 5000 } },
    { name: 'Soft Spring (k=50)',           params: { stiffness: 50 } },
    { name: 'Massive Block (10 kg)',        params: { blockMass: 10 } },
    { name: 'Shotgun Slug (30g @ 500)',     params: { bulletMass: 0.03, bulletSpeed: 500 } },
    { name: 'Heavy Spring (mₛ=1 kg)',      params: { springMass: 1.0, friction: 0 } },
  ],

  // ── Internal tracking ──
  _collided: false,
  _maxCompression: 0,
  _collisionKELoss: 0,
  _frictionHeat: 0,
  _visualBulletSpeed: 4,  // m/s for approach animation

  init(p) {
    this._collided = false;
    this._maxCompression = 0;
    this._collisionKELoss = 0;
    this._frictionHeat = 0;
    const bulletStart = p.restLength + 2; // 2m to the right of block
    return [p.restLength, 0, bulletStart, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[3] = 1; // dt/dt
    if (isDragging) return;

    const [x, vx, bulletX] = vars;

    if (!this._collided) {
      // Phase 1: bullet approaching, block at rest
      change[0] = 0;
      change[1] = 0;
      change[2] = -this._visualBulletSpeed; // bullet moves left
    } else {
      // Phase 2: post-collision spring-mass-friction
      const { blockMass, bulletMass, springMass, stiffness, friction, restLength } = params;
      const ms = springMass || 0;

      // Inertial mass: block + bullet + spring/3 (spring coils move proportionally)
      const mEff = bulletMass + blockMass + ms / 3;

      // Gravitational mass for friction: full weight on surface
      const mGrav = bulletMass + blockMass + ms;

      const displacement = x - restLength; // positive = stretched, negative = compressed

      // Spring force: toward natural length
      const springF = -stiffness * displacement;

      // Kinetic friction: opposes motion (uses full gravitational mass)
      let frictionF = 0;
      if (Math.abs(vx) > 1e-5 && friction > 0) {
        frictionF = -friction * mGrav * G * Math.sign(vx);
      } else if (friction > 0) {
        // Static friction: check if spring force exceeds static limit
        const staticMax = friction * mGrav * G * 1.2; // μ_s ≈ 1.2μ_k
        if (Math.abs(springF) < staticMax) {
          frictionF = -springF; // cancels spring — stuck
        } else {
          frictionF = -friction * mGrav * G * Math.sign(springF);
        }
      }

      // F = ma uses effective (inertial) mass
      const accel = (springF + frictionF) / mEff;
      change[0] = vx;
      change[1] = accel;
      change[2] = vx; // bullet moves with block
    }
  },

  postStep(vars, params) {
    const [x, vx, bulletX] = vars;

    // ── Collision detection ──
    if (!this._collided && bulletX <= x) {
      const { bulletMass, bulletSpeed, blockMass } = params;
      const totalMass = bulletMass + blockMass;

      // KE before
      const KE_before = 0.5 * bulletMass * bulletSpeed * bulletSpeed;

      // Momentum conservation: m·v₀ = (m+M)·v₁
      const v_after = -bulletMass * bulletSpeed / totalMass; // negative = leftward

      // KE after
      const KE_after = 0.5 * totalMass * v_after * v_after;

      this._collisionKELoss = KE_before - KE_after;

      vars[1] = v_after;
      vars[2] = vars[0]; // bullet embeds at block position
      this._collided = true;
    }

    // Keep bullet with block after collision
    if (this._collided) {
      vars[2] = vars[0];

      // Track friction heat (uses gravitational mass for normal force)
      const { bulletMass, blockMass, springMass, friction } = params;
      const mGrav = bulletMass + blockMass + (springMass || 0);
      if (friction > 0 && Math.abs(vx) > 1e-5) {
        const dt = 0.01; // approximate timestep
        this._frictionHeat += friction * mGrav * G * Math.abs(vx) * dt;
      }
    }

    // Track max compression
    const compression = params.restLength - x;
    if (compression > this._maxCompression) {
      this._maxCompression = compression;
    }

    // Wall clamp: block can't go through the wall
    if (vars[0] < 0.05) {
      vars[0] = 0.05;
      vars[1] = Math.max(0, vars[1]); // stop or bounce right
    }
  },

  energy(vars, params) {
    const [x, vx] = vars;
    const { bulletMass, blockMass, springMass, stiffness, restLength } = params;
    const ms = springMass || 0;
    // Effective inertial mass: block + bullet + spring/3
    const mEff = this._collided ? bulletMass + blockMass + ms / 3 : blockMass;
    const displacement = x - restLength;
    const KE = 0.5 * mEff * vx * vx;
    const PE = 0.5 * stiffness * displacement * displacement;
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  theoreticalPeriod(params) {
    const mEff = params.bulletMass + params.blockMass + (params.springMass || 0) / 3;
    return 2 * Math.PI * Math.sqrt(mEff / params.stiffness);
  },
  periodVar: 1,

  hitTest(wx, wy, vars, params) {
    const blockW = 0.25;
    if (Math.abs(wx - vars[0]) < blockW + 0.2 && Math.abs(wy - 0.25) < 0.35) {
      return { id: 'block', offsetX: wx - vars[0] };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    if (id === 'block') {
      vars[0] = Math.max(0.05, wx - (offset.offsetX || 0));
      vars[1] = 0;
      if (!this._collided) {
        // If dragging before collision, trigger collision immediately
        this._collided = true;
        vars[2] = vars[0];
        const { bulletMass, bulletSpeed, blockMass } = params;
        this._collisionKELoss = 0.5 * bulletMass * bulletSpeed * bulletSpeed;
      }
    }
  },

  onRelease() {},

  render(canvas, vars, params) {
    const [x, vx, bulletX] = vars;
    const { bulletMass, bulletSpeed, blockMass, springMass, stiffness, friction, restLength } = params;
    const ms = springMass || 0;
    const totalMass = bulletMass + blockMass;
    const mEff = totalMass + ms / 3;
    const blockW = 0.25;
    const blockH = 0.4;

    // ── Wall ──
    canvas.rect(-0.4, -0.5, 0.4, 2.5, '#475569', '#334155');
    // Hatching
    for (let wy = -0.4; wy < 2; wy += 0.2) {
      canvas.line(-0.35, wy, 0, wy + 0.2, '#64748b', 1);
    }

    // ── Surface ──
    canvas.line(-0.5, 0, 5, 0, '#475569', 2);
    // Friction indicators
    if (friction > 0) {
      for (let fx = 0.2; fx < 4.8; fx += 0.3) {
        canvas.line(fx, 0, fx - 0.06, -0.06, '#64748b', 1);
      }
    }

    // ── Spring (from wall to block) ──
    canvas.spring(0, 0.25, x - blockW, 0.25, 12, 0.15, '#06B6D4');

    // ── Block ──
    const blockColor = this._collided ? '#7C3AED' : '#8B5CF6';
    canvas.rect(x - blockW, 0.05, blockW * 2, blockH, blockColor, '#A78BFA');
    canvas.text(x, 0.25, blockMass.toFixed(1) + 'kg', '#FFF', 8);

    // ── Bullet ──
    if (!this._collided) {
      // Approaching bullet
      canvas.circle(bulletX, 0.25, 0.06, '#EF4444', '#FCA5A5');
      // Velocity arrow
      canvas.line(bulletX + 0.1, 0.25, bulletX + 0.5, 0.25, '#EF4444', 1.5);
      canvas.text(bulletX + 0.3, 0.5, bulletMass * 1000 + 'g @ ' + bulletSpeed + ' m/s', '#EF4444', 8);
    } else {
      // Embedded bullet (dot inside block)
      canvas.circle(x - blockW * 0.3, 0.25, 0.05, '#EF4444', null);
    }

    // ── Natural length marker ──
    canvas.line(restLength, -0.1, restLength, 0.55, '#22C55E', 1);
    canvas.text(restLength, 0.65, 'L₀', '#22C55E', 7);

    // ── Max compression marker ──
    if (this._maxCompression > 0.001) {
      const mcX = restLength - this._maxCompression;
      canvas.line(mcX, -0.1, mcX, 0.55, '#F59E0B', 1);
      canvas.text(mcX, -0.25, 'x_max', '#F59E0B', 7);
    }

    // ── Info panel ──
    const v_after = bulletMass * bulletSpeed / totalMass;
    const KE_bullet = 0.5 * bulletMass * bulletSpeed * bulletSpeed;
    const KE_after = 0.5 * totalMass * v_after * v_after;
    const pctLost = ((KE_bullet - KE_after) / KE_bullet * 100).toFixed(1);

    canvas.text(2.5, 2.2, 'Momentum: p = mv₀ = ' + (bulletMass * bulletSpeed).toFixed(2) + ' kg·m/s', '#94A3B8', 9);

    if (this._collided) {
      canvas.text(2.5, 1.95, 'v_after = ' + v_after.toFixed(3) + ' m/s', '#06B6D4', 9);
      canvas.text(2.5, 1.7, 'KE lost in collision: ' + pctLost + '%', '#EF4444', 9);

      if (this._maxCompression > 0.001) {
        canvas.text(2.5, 1.45, 'Max compression: ' + (this._maxCompression * 100).toFixed(1) + ' cm', '#F59E0B', 9);
      }

      // Current state
      const speed = Math.abs(vars[1]);
      if (speed > 0.001) {
        canvas.text(2.5, 1.2, 'v = ' + speed.toFixed(3) + ' m/s', '#94A3B8', 8);
      } else if (this._collided) {
        canvas.text(2.5, 1.2, 'STOPPED', '#22C55E', 9);
      }
    } else {
      canvas.text(2.5, 1.95, 'KE_bullet = ' + KE_bullet.toFixed(1) + ' J', '#EF4444', 9);
      canvas.text(2.5, 1.7, 'Waiting for impact...', '#F59E0B', 9);
    }

    // Period (uses effective inertial mass)
    const T = 2 * Math.PI * Math.sqrt(mEff / stiffness);
    const massLabel = ms > 0 ? 'm_eff = m+M+mₛ/3 = ' + mEff.toFixed(2) + 'kg' : '';
    canvas.text(2.5, -0.5, 'T = 2π√(m_eff/k) = ' + T.toFixed(3) + 's', '#94A3B8', 8);
    if (ms > 0) {
      canvas.text(2.5, -0.75, massLabel, '#06B6D4', 8);
    }

    // Friction info
    const frictionY = ms > 0 ? -1.0 : -0.75;
    if (friction > 0) {
      canvas.text(2.5, frictionY, 'μ = ' + friction + '  (surface friction)', '#64748b', 8);
    } else {
      canvas.text(2.5, frictionY, 'Frictionless surface', '#22C55E', 8);
    }
  },

  info: `
    <h2>Bullet–Block–Spring</h2>
    <p>A bullet is fired into a wooden block resting on a surface. The block is attached to a spring. The bullet embeds (perfectly inelastic collision), and the combined mass oscillates while friction dissipates energy.</p>

    <h3>The Key Insight: Where Did the Energy Go?</h3>
    <p>A 10g bullet at 400 m/s has <strong>800 J</strong> of kinetic energy. After embedding in a 2 kg block, the combined mass has only <strong>~4 J</strong>. That's <strong>99.5% of the energy lost</strong> — converted to heat, sound, and deformation in the collision!</p>
    <p>Yet momentum IS conserved: <code>p = m·v₀ = (m+M)·v₁</code></p>

    <h3>Physics</h3>
    <p><strong>Collision (instantaneous):</strong></p>
    <p><code>v₁ = m·v₀ / (m + M)</code> — momentum conservation</p>
    <p><code>ΔKE = ½m·v₀²·M/(m+M)</code> — energy lost (always positive!)</p>

    <p><strong>Post-collision (spring + friction):</strong></p>
    <p><code>m_eff·ẍ = −k·(x−L₀) − μ·m_grav·g·sign(ẋ)</code></p>
    <p>where <code>m_eff = m + M + mₛ/3</code> (effective inertial mass) and <code>m_grav = m + M + mₛ</code> (total weight on surface).</p>

    <h3>Spring Mass Correction</h3>
    <p>A real spring has mass. Its coils move — the coil at the block moves at full speed, the coil at the wall doesn't move at all. Integrating the kinetic energy gives an <strong>effective mass contribution of mₛ/3</strong>. This increases the period:</p>
    <p><code>T = 2π√(m_eff/k) = 2π√((m + M + mₛ/3)/k)</code></p>
    <p>The spring mass does NOT participate in the collision (the bullet hits the block, not the spring). But it affects all subsequent oscillation dynamics and friction (the spring's full weight rests on the surface).</p>

    <h3>Maximum Compression</h3>
    <p>From energy conservation (post-collision):</p>
    <p><code>½·m_eff·v₁² = ½k·x²_max + μ·m_grav·g·x_max</code></p>
    <p>Without friction: <code>x_max = v₁·√(m_eff/k)</code></p>

    <h3>Try These</h3>
    <ol>
      <li><strong>Default:</strong> Watch 99.5% of energy vanish in the collision. The block barely moves despite the bullet's enormous KE.</li>
      <li><strong>Frictionless:</strong> Block oscillates forever with the tiny remaining KE.</li>
      <li><strong>Heavy bullet (50g):</strong> More momentum transferred → larger compression. But still huge energy loss.</li>
      <li><strong>High friction:</strong> Block may stop before returning to natural length!</li>
      <li><strong>Heavy Spring (mₛ=1 kg):</strong> Period increases ~15%. The spring's inertia slows oscillation.</li>
      <li><strong>Phase plot:</strong> Beautiful spiral as friction dissipates energy each cycle.</li>
      <li><strong>Energy tab:</strong> Watch the tiny post-collision KE convert to spring PE and back, shrinking each cycle.</li>
      <li><strong>Drag the block:</strong> Pull it to compress or stretch the spring, then release.</li>
    </ol>

    <h3>Why Is So Much Energy Lost?</h3>
    <p>The fraction of KE retained is <code>m/(m+M)</code>. For m = 10g and M = 2 kg, that's 0.01/2.01 ≈ 0.5%. The more massive the target relative to the projectile, the more energy is lost. This is why bulletproof vests work — they spread the bullet's momentum over a large mass (your body), so the velocity (and thus KE) becomes tiny.</p>
  `,
};
