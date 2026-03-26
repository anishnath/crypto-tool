/**
 * Bullet–Block–Spring
 *
 * A bullet is fired into a block resting on a surface with friction.
 * The block is connected to a spring attached to a wall.
 *
 * THREE OUTCOMES:
 *   1. Embed — bullet KE ≤ F_resist × d → perfectly inelastic collision
 *   2. Pass-through — bullet KE > F_resist × d → bullet exits with reduced speed
 *   3. Ricochet edge case — handled as embed with full momentum transfer
 *
 * KEY INSIGHTS:
 *   - Embed: m·v₀ = (m+M)·v₁  (all momentum to block+bullet)
 *   - Pass-through: impulse J = F·Δt, bullet keeps some momentum
 *     Block gets LESS momentum than embed → counterintuitive!
 *   - Work-energy: W = F_resist × d determines if bullet stops
 *   - Spring mass correction: m_eff = m + M + mₛ/3
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
    bulletMass:  { value: 0.01,  min: 0.001, max: 0.5,   step: 0.001, label: 'Bullet Mass m',      unit: 'kg' },
    bulletSpeed: { value: 400,   min: 50,    max: 1000,  step: 10,    label: 'Bullet Speed v₀',     unit: 'm/s' },
    blockMass:   { value: 2.0,   min: 0.5,   max: 20,    step: 0.1,   label: 'Block Mass M',        unit: 'kg' },
    blockWidth:  { value: 0.20,  min: 0.02,  max: 0.5,   step: 0.01,  label: 'Block Thickness d',   unit: 'm' },
    resistForce: { value: 8000,  min: 500,   max: 50000, step: 500,   label: 'Resist Force F',      unit: 'N' },
    springMass:  { value: 0,     min: 0,     max: 2,     step: 0.05,  label: 'Spring Mass mₛ',      unit: 'kg' },
    stiffness:   { value: 500,   min: 10,    max: 5000,  step: 10,    label: 'Spring k',            unit: 'N/m' },
    friction:    { value: 0.3,   min: 0,     max: 1.0,   step: 0.01,  label: 'Friction μ_k',        unit: '' },
    restLength:  { value: 1.5,   min: 0.5,   max: 3,     step: 0.1,   label: 'Spring Length L₀',    unit: 'm' },
  },

  views: ['sim', 'phase', 'time', 'energy'],

  graphDefaults: {
    phase: { x: 'position', y: 'velocity' },
    time: ['position', 'velocity'],
  },

  worldRect: { xMin: -0.5, xMax: 5, yMin: -1.5, yMax: 2.5 },

  presets: [
    // Default: KE=800J, stopping work=8000×0.2=1600J → embeds (800<1600)
    { name: 'Default (embeds)',             params: {} },
    { name: 'Pass-Through! (thin block)',   params: { blockWidth: 0.05, resistForce: 5000 } },
    { name: 'Pass-Through! (fast bullet)',  params: { bulletSpeed: 900, resistForce: 5000 } },
    { name: 'Barely Embeds',               params: { bulletSpeed: 400, blockWidth: 0.10, resistForce: 8000 } },
    { name: 'Heavy Bullet (50g @ 200)',     params: { bulletMass: 0.05, bulletSpeed: 200 } },
    { name: 'Frictionless',                 params: { friction: 0 } },
    { name: 'High Friction (μ=0.8)',        params: { friction: 0.8 } },
    { name: 'Massive Block (10 kg)',        params: { blockMass: 10 } },
    { name: 'Heavy Spring (mₛ=1 kg)',      params: { springMass: 1.0, friction: 0 } },
  ],

  // ── Internal tracking ──
  _collided: false,
  _passedThrough: false,
  _bulletExitSpeed: 0,
  _maxCompression: 0,
  _collisionKELoss: 0,
  _frictionHeat: 0,
  _visualBulletSpeed: 4,

  init(p) {
    this._collided = false;
    this._passedThrough = false;
    this._bulletExitSpeed = 0;
    this._blockInitialSpeed = 0;
    this._maxCompression = 0;
    this._collisionKELoss = 0;
    this._frictionHeat = 0;
    const bulletStart = p.restLength + 2;
    return [p.restLength, 0, bulletStart, 0];
  },

  /** Does the bullet pass through? */
  _willPassThrough(params) {
    const KE = 0.5 * params.bulletMass * params.bulletSpeed * params.bulletSpeed;
    const workToStop = params.resistForce * params.blockWidth;
    return KE > workToStop;
  },

  /** Bullet exit speed if it passes through */
  _exitSpeed(params) {
    const { bulletMass, bulletSpeed, resistForce, blockWidth } = params;
    const vSq = bulletSpeed * bulletSpeed - 2 * resistForce * blockWidth / bulletMass;
    return vSq > 0 ? Math.sqrt(vSq) : 0;
  },

  evaluate(vars, change, params, isDragging) {
    change[3] = 1;
    if (isDragging) return;

    const [x, vx, bulletX] = vars;

    if (!this._collided) {
      // Phase 1: bullet approaching, block at rest
      change[0] = 0;
      change[1] = 0;
      change[2] = -this._visualBulletSpeed;
    } else {
      // Phase 2: post-collision — block on spring with friction
      const { blockMass, bulletMass, springMass, stiffness, friction, restLength } = params;
      const ms = springMass || 0;

      // If bullet passed through, it doesn't add to block mass
      const blockTotal = this._passedThrough ? blockMass : bulletMass + blockMass;
      const mEff = blockTotal + ms / 3;   // inertial mass (spring coils contribute mₛ/3)
      const mGrav = blockTotal;            // friction: only block(+bullet) press on surface, not the spring

      const displacement = x - restLength;
      const springF = -stiffness * displacement;

      let frictionF = 0;
      if (Math.abs(vx) > 1e-5 && friction > 0) {
        frictionF = -friction * mGrav * G * Math.sign(vx);
      } else if (friction > 0) {
        const staticMax = friction * mGrav * G * 1.2;
        if (Math.abs(springF) < staticMax) {
          frictionF = -springF;
        } else {
          frictionF = -friction * mGrav * G * Math.sign(springF);
        }
      }

      const accel = (springF + frictionF) / mEff;
      change[0] = vx;
      change[1] = accel;

      // Bullet: moves with block if embedded, flies away if passed through
      if (this._passedThrough) {
        change[2] = -this._bulletExitSpeed; // continues leftward
      } else {
        change[2] = vx; // moves with block
      }
    }
  },

  postStep(vars, params, dt) {
    if (!dt) dt = 1 / 120;
    const [x, vx, bulletX] = vars;

    // ── Collision detection (at block's right face) ──
    const BLOCK_HALF_W = 0.25;
    if (!this._collided && bulletX <= x + BLOCK_HALF_W) {
      const { bulletMass, bulletSpeed, blockMass, blockWidth, resistForce } = params;
      const KE_before = 0.5 * bulletMass * bulletSpeed * bulletSpeed;
      const workToStop = resistForce * blockWidth;

      if (KE_before > workToStop) {
        // ── PASS-THROUGH ──
        // Bullet exits with reduced speed
        const vExit = this._exitSpeed(params);
        this._bulletExitSpeed = vExit;
        this._passedThrough = true;

        // Impulse on block = F_resist × (d / v_avg)
        // Using energy-momentum: Δp_bullet = m(v₀ - v_exit)
        // This momentum transfers to block
        const deltaP = bulletMass * (bulletSpeed - vExit);
        const v_block = -deltaP / blockMass; // negative = leftward

        // Energy accounting
        const KE_bulletAfter = 0.5 * bulletMass * vExit * vExit;
        const KE_blockAfter = 0.5 * blockMass * v_block * v_block;
        this._collisionKELoss = KE_before - KE_bulletAfter - KE_blockAfter;

        vars[1] = v_block;
        vars[2] = x - blockWidth; // bullet exits left side of block
        this._blockInitialSpeed = Math.abs(v_block);
      } else {
        // ── EMBED ──
        const totalMass = bulletMass + blockMass;
        const v_after = -bulletMass * bulletSpeed / totalMass;
        const KE_after = 0.5 * totalMass * v_after * v_after;
        this._collisionKELoss = KE_before - KE_after;
        this._passedThrough = false;
        this._bulletExitSpeed = 0;
        this._blockInitialSpeed = Math.abs(v_after);

        vars[1] = v_after;
        vars[2] = vars[0]; // embeds at block position
      }
      this._collided = true;
    }

    // Keep embedded bullet with block
    if (this._collided && !this._passedThrough) {
      vars[2] = vars[0];
    }

    // Track friction heat (normal force = block(+bullet) weight, no spring weight)
    if (this._collided) {
      const { bulletMass, blockMass, friction } = params;
      const blockTotal = this._passedThrough ? blockMass : bulletMass + blockMass;
      if (friction > 0 && Math.abs(vx) > 1e-5) {
        this._frictionHeat += friction * blockTotal * G * Math.abs(vx) * dt;
      }
    }

    // Track max compression
    const compression = params.restLength - x;
    if (compression > this._maxCompression) {
      this._maxCompression = compression;
    }

    // Wall clamp
    if (vars[0] < 0.05) {
      vars[0] = 0.05;
      vars[1] = Math.max(0, vars[1]);
    }
  },

  energy(vars, params) {
    const [x, vx] = vars;
    const { bulletMass, blockMass, springMass, stiffness, restLength } = params;
    const ms = springMass || 0;
    const blockTotal = this._passedThrough ? blockMass : (this._collided ? bulletMass + blockMass : blockMass);
    const mEff = blockTotal + ms / 3;
    const displacement = x - restLength;
    const KE = 0.5 * mEff * vx * vx;
    const PE = 0.5 * stiffness * displacement * displacement;
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  theoreticalPeriod(params) {
    // Period depends on whether bullet embeds or passes through
    const blockTotal = this._passedThrough ? params.blockMass : params.bulletMass + params.blockMass;
    const mEff = blockTotal + (params.springMass || 0) / 3;
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
        this._collided = true;
        this._passedThrough = false;
        vars[2] = vars[0];
        this._collisionKELoss = 0.5 * params.bulletMass * params.bulletSpeed * params.bulletSpeed;
      }
    }
  },

  onRelease() {},

  render(canvas, vars, params) {
    const [x, vx, bulletX] = vars;
    const { bulletMass, bulletSpeed, blockMass, blockWidth, resistForce, springMass, stiffness, friction, restLength } = params;
    const ms = springMass || 0;
    const totalMass = bulletMass + blockMass;
    const blockTotal = this._passedThrough ? blockMass : totalMass;
    const mEff = blockTotal + ms / 3;
    const blockW = 0.25;
    const blockH = 0.4;

    // ── Wall ──
    canvas.rect(-0.4, -0.5, 0.4, 2.5, '#475569', '#334155');
    for (let wy = -0.4; wy < 2; wy += 0.2) {
      canvas.line(-0.35, wy, 0, wy + 0.2, '#64748b', 1);
    }

    // ── Surface ──
    canvas.line(-0.5, 0, 5, 0, '#475569', 2);
    if (friction > 0) {
      for (let fx = 0.2; fx < 4.8; fx += 0.3) {
        canvas.line(fx, 0, fx - 0.06, -0.06, '#64748b', 1);
      }
    }

    // ── Spring ──
    canvas.spring(0, 0.25, x - blockW, 0.25, 12, 0.15, '#06B6D4');

    // ── Block ──
    const blockColor = this._collided
      ? (this._passedThrough ? '#DC2626' : '#7C3AED')
      : '#8B5CF6';
    canvas.rect(x - blockW, 0.05, blockW * 2, blockH, blockColor, this._passedThrough ? '#FCA5A5' : '#A78BFA');
    canvas.text(x, 0.25, blockMass.toFixed(1) + 'kg', '#FFF', 8);

    // ── Bullet hole if passed through ──
    if (this._passedThrough && this._collided) {
      // Entry hole (right side)
      canvas.circle(x + blockW * 0.7, 0.25, 0.03, '#1F2937', null);
      // Exit hole (left side)
      canvas.circle(x - blockW * 0.7, 0.25, 0.04, '#1F2937', null);
    }

    // ── Bullet ──
    if (!this._collided) {
      // Approaching
      canvas.circle(bulletX, 0.25, 0.06, '#EF4444', '#FCA5A5');
      canvas.line(bulletX + 0.1, 0.25, bulletX + 0.5, 0.25, '#EF4444', 1.5);
      canvas.text(bulletX + 0.3, 0.5, bulletMass * 1000 + 'g @ ' + bulletSpeed + ' m/s', '#EF4444', 8);
    } else if (this._passedThrough) {
      // Exited bullet (continues leftward)
      if (bulletX > -0.5) {
        canvas.circle(bulletX, 0.25, 0.05, '#EF4444', '#FCA5A5');
        if (this._bulletExitSpeed > 1) {
          canvas.text(bulletX, 0.5, (this._bulletExitSpeed).toFixed(0) + ' m/s', '#EF4444', 7);
        }
      }
    } else {
      // Embedded
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
    const KE_bullet = 0.5 * bulletMass * bulletSpeed * bulletSpeed;
    const workToStop = resistForce * blockWidth;
    const willPass = KE_bullet > workToStop;

    canvas.text(2.5, 2.2, 'p = mv₀ = ' + (bulletMass * bulletSpeed).toFixed(2) + ' kg·m/s', '#94A3B8', 9);

    if (this._collided) {
      if (this._passedThrough) {
        canvas.text(2.5, 1.95, 'PASS-THROUGH!', '#EF4444', 11);
        canvas.text(2.5, 1.7, 'v_exit = ' + this._bulletExitSpeed.toFixed(1) + ' m/s', '#EF4444', 9);
        const deltaP = bulletMass * (bulletSpeed - this._bulletExitSpeed);
        canvas.text(2.5, 1.45, 'Δp to block = ' + deltaP.toFixed(3) + ' kg·m/s', '#06B6D4', 9);
        // Compare initial post-impact speeds (stored at collision time)
        const vEmbed = bulletMass * bulletSpeed / totalMass;
        canvas.text(2.5, 1.2, 'v₀_block = ' + this._blockInitialSpeed.toFixed(3) + ' m/s (embed → ' + vEmbed.toFixed(3) + ')', '#F59E0B', 8);
      } else {
        const v_after = bulletMass * bulletSpeed / totalMass;
        const KE_after = 0.5 * totalMass * v_after * v_after;
        const pctLost = ((KE_bullet - KE_after) / KE_bullet * 100).toFixed(1);
        canvas.text(2.5, 1.95, 'EMBEDDED', '#7C3AED', 11);
        canvas.text(2.5, 1.7, 'v_after = ' + v_after.toFixed(3) + ' m/s', '#06B6D4', 9);
        canvas.text(2.5, 1.45, 'KE lost: ' + pctLost + '%', '#EF4444', 9);
      }

      if (this._maxCompression > 0.001) {
        canvas.text(2.5, 0.95, 'Max compression: ' + (this._maxCompression * 100).toFixed(1) + ' cm', '#F59E0B', 8);
      }

      const speed = Math.abs(vars[1]);
      if (speed < 0.001 && this._collided) {
        canvas.text(2.5, 0.7, 'STOPPED', '#22C55E', 9);
      }
    } else {
      canvas.text(2.5, 1.95, 'KE = ' + KE_bullet.toFixed(1) + ' J', '#EF4444', 9);
      canvas.text(2.5, 1.7, 'Stopping work F×d = ' + workToStop.toFixed(1) + ' J', '#06B6D4', 9);
      canvas.text(2.5, 1.45, willPass ? 'KE > F×d → will PASS THROUGH' : 'KE < F×d → will EMBED', willPass ? '#EF4444' : '#22C55E', 9);
    }

    // Period
    const T = 2 * Math.PI * Math.sqrt(mEff / stiffness);
    canvas.text(2.5, -0.5, 'T = 2π√(m_eff/k) = ' + T.toFixed(3) + 's', '#94A3B8', 8);
    if (ms > 0) {
      canvas.text(2.5, -0.75, 'm_eff = ' + mEff.toFixed(2) + 'kg (includes mₛ/3)', '#06B6D4', 8);
    }

    const frictionY = ms > 0 ? -1.0 : -0.75;
    if (friction > 0) {
      canvas.text(2.5, frictionY, 'μ = ' + friction, '#64748b', 8);
    } else {
      canvas.text(2.5, frictionY, 'Frictionless', '#22C55E', 8);
    }
  },

  info: `
    <h2>Bullet–Block–Spring</h2>
    <p>A bullet is fired into a wooden block on a spring. Depending on the bullet's energy vs the block's stopping power, the bullet either <strong>embeds</strong> or <strong>passes through</strong>.</p>

    <h3>Embed vs Pass-Through</h3>
    <p>The block exerts a resistive force <code>F</code> over its thickness <code>d</code>. The work to stop the bullet is <code>W = F × d</code>.</p>
    <ul>
      <li><strong>KE &lt; F×d → Embed:</strong> Bullet stops inside. Perfectly inelastic collision. Maximum momentum transferred.</li>
      <li><strong>KE &gt; F×d → Pass-through:</strong> Bullet exits with <code>v_exit = √(v₀² − 2Fd/m)</code>. Block gets LESS momentum than if the bullet had embedded!</li>
    </ul>
    <p><strong>Counterintuitive:</strong> A pass-through transfers LESS momentum to the block than embedding. The block moves less, compresses the spring less. This is why hollow-point bullets (designed to embed) are more effective at transferring energy to the target.</p>

    <h3>Physics — Embed</h3>
    <p><code>v₁ = m·v₀ / (m + M)</code> — all bullet momentum to block+bullet</p>
    <p><code>ΔKE = ½m·v₀²·M/(m+M)</code> — energy lost to deformation/heat</p>

    <h3>Physics — Pass-Through</h3>
    <p><code>v_exit = √(v₀² − 2Fd/m)</code> — bullet exits with reduced speed</p>
    <p><code>Δp = m·(v₀ − v_exit)</code> — momentum transferred to block</p>
    <p><code>v_block = Δp / M</code> — block velocity (less than embed case!)</p>

    <h3>Spring Mass Correction</h3>
    <p>The spring's own mass adds <code>mₛ/3</code> to the effective inertial mass (from integrating KE of spring coils). Note: the spring is anchored to the wall, so its weight does NOT press the block against the surface — only the block (and embedded bullet) weight contributes to friction. Period: <code>T = 2π√(m_eff/k)</code>.</p>

    <h3>Try These</h3>
    <ol>
      <li><strong>Default (embeds):</strong> 99.5% of energy lost. Tiny block motion.</li>
      <li><strong>Pass-Through (thin block):</strong> Bullet exits! Block moves even less than embed — surprising!</li>
      <li><strong>Pass-Through (fast bullet):</strong> High-speed bullet barely slows down. Almost no momentum transfer.</li>
      <li><strong>Barely Embeds:</strong> Right at the KE = F×d boundary. Small change in speed flips the outcome.</li>
      <li><strong>Before impact:</strong> The sim predicts "will EMBED" or "will PASS THROUGH" before the bullet arrives.</li>
      <li><strong>Phase plot:</strong> Embed spirals inward. Pass-through gives a much smaller spiral.</li>
    </ol>

    <h3>Why Embedding Transfers More Momentum</h3>
    <p>When the bullet embeds, ALL its momentum (mv₀) goes to the block+bullet system. When it passes through, it keeps some momentum (mv_exit), so the block only receives m(v₀ − v_exit). A faster bullet that passes through may deliver LESS impulse than a slower one that embeds.</p>
  `,
};
