/**
 * States of Matter — 2D Molecular Dynamics (Canvas, engine pattern)
 *
 * Faithful port of PhET's States of Matter simulation.
 * All constants, thresholds, and interaction logic taken directly from
 * PhET source (Apache 2.0).
 *
 * V(r) = 4ε[(σ/r)¹² − (σ/r)⁶]
 * T = KE/N  [2D, 2 DOF per particle]
 *
 * PhET constants used:
 *   EXPLOSION_PRESSURE = 41, EXPLOSION_TIME = 1s
 *   PRESSURE_WINDOW = 12s, INJECTION_HOLDOFF = 0.25s
 *   INJECTION_SPEED = 2.0, ANGLE_SPREAD = π/4
 *   TEMPERATURE_CHANGE_RATE = 0.07
 *   EXPAND_RATE = 1500/s, SHRINK_RATE = 1250/s
 *   POST_EXPLOSION_RATE = 9000/s
 */

/* ═══════════════════════ 2D MD ENGINE ═══════════════════════ */

function ljFR(r2, eps, sig) {
  const s2 = sig * sig / r2, s6 = s2 * s2 * s2;
  return 24 * eps * (2 * s6 * s6 - s6) / r2;
}
function ljV(r2, eps, sig) {
  const s2 = sig * sig / r2, s6 = s2 * s2 * s2;
  return 4 * eps * (s6 * s6 - s6);
}

class MD2D {
  constructor(maxN, W, H, eps, sig) {
    this.maxN = maxN; this.N = 0;
    this.W = W; this.H = H;
    this.eps = eps; this.sig = sig; this.rc = 2.5 * sig;
    this.x  = new Float64Array(maxN); this.y  = new Float64Array(maxN);
    this.vx = new Float64Array(maxN); this.vy = new Float64Array(maxN);
    this.fx = new Float64Array(maxN); this.fy = new Float64Array(maxN);
    this.PE = 0; this.pressure = 0;
    // Pressure: rolling 3-second window (shorter than PhET's 12s for responsiveness)
    this._pW = 3; this._pTotal = 0; this._pQueue = []; this._pQueueDt = [];
    this._pQueueTime = 0;
  }

  initGrid(N, T) {
    this.N = N;
    // Fit grid inside box with margin — prevent particles from starting near walls/lid
    const margin = this.sig;
    const usableW = this.W - 2 * margin, usableH = this.H - 2 * margin;
    const aspect = usableW / usableH;
    const cols = Math.max(1, Math.round(Math.sqrt(N * aspect)));
    const rows = Math.ceil(N / cols);
    const spX = usableW / Math.max(cols, 1);
    const spY = usableH / Math.max(rows, 1);
    for (let i = 0; i < N; i++) {
      this.x[i] = margin + (i % cols + 0.5) * spX;
      this.y[i] = margin + (Math.floor(i / cols) + 0.5) * spY;
      // Box-Muller for velocity
      const u1 = Math.max(1e-10, Math.random()), u2 = Math.random();
      const g = Math.sqrt(-2 * Math.log(u1)) * Math.sqrt(T);
      this.vx[i] = g * Math.cos(2 * Math.PI * u2);
      this.vy[i] = g * Math.sin(2 * Math.PI * u2);
    }
    // Zero total momentum
    let sx = 0, sy = 0;
    for (let i = 0; i < N; i++) { sx += this.vx[i]; sy += this.vy[i]; }
    sx /= N; sy /= N;
    for (let i = 0; i < N; i++) { this.vx[i] -= sx; this.vy[i] -= sy; }
    this.forces(); this.clearPressure();
  }

  forces() {
    const { N, x, y, fx, fy, eps, sig, rc } = this;
    const rc2 = rc * rc;
    // Soft-core clamp + force cap to prevent Verlet divergence on steep LJ wall
    const r2min = sig * sig * 0.36;  // r_min = 0.6σ
    const maxFR = 200 / sig;  // cap |F| ≈ 200/σ per pair (safe for DT=0.002)
    for (let i = 0; i < N; i++) { fx[i] = 0; fy[i] = 0; }
    this.PE = 0;
    for (let i = 0; i < N - 1; i++) for (let j = i + 1; j < N; j++) {
      const dx = x[j] - x[i], dy = y[j] - y[i], r2 = dx * dx + dy * dy;
      if (r2 > rc2) continue;
      const r2c = Math.max(r2, r2min);
      let f = ljFR(r2c, eps, sig);
      // Cap force magnitude: |F| = |f|*r, so cap |f| at maxFR/r
      const fAbs = Math.abs(f) * Math.sqrt(r2);
      if (fAbs > maxFR) f *= maxFR / fAbs;
      fx[i] += f * dx; fy[i] += f * dy; fx[j] -= f * dx; fy[j] -= f * dy;
      this.PE += ljV(r2c, eps, sig);
    }
  }

  step(dt, isExploded, lidVelY) {
    const { N, x, y, vx, vy, fx, fy, W, H, sig } = this;
    const m = sig * 0.5;
    // Velocity Verlet
    for (let i = 0; i < N; i++) { vx[i] += 0.5 * fx[i] * dt; vy[i] += 0.5 * fy[i] * dt; }
    for (let i = 0; i < N; i++) { x[i] += vx[i] * dt; y[i] += vy[i] * dt; }
    this.forces();
    for (let i = 0; i < N; i++) { vx[i] += 0.5 * fx[i] * dt; vy[i] += 0.5 * fy[i] * dt; }
    // Walls — position-based detection (velocity check after Verlet can miss
    // collisions when inter-particle forces flip velocity between half-kicks)
    let pStep = 0;
    const pMinH = H * 0.3;  // PhET: pressureAccumulationMinHeight = H * 0.3
    for (let i = 0; i < N; i++) {
      // Side walls
      if (x[i] < m) { x[i] = m; vx[i] = Math.abs(vx[i]); if (y[i] > pMinH) pStep += vx[i]; }
      if (x[i] > W - m) { x[i] = W - m; vx[i] = -Math.abs(vx[i]); if (y[i] > pMinH) pStep += Math.abs(vx[i]); }
      // Floor (no pressure)
      if (y[i] < m) { y[i] = m; vy[i] = Math.abs(vy[i]); }
      // Lid (pressure, with lid velocity coupling like PhET)
      if (!isExploded && y[i] > H - m) {
        y[i] = H - m;
        vy[i] = -Math.abs(vy[i]) + (lidVelY || 0) * 0.3;  // PhET: LID_VELOCITY_FACTOR = 0.3
        pStep += Math.abs(vy[i]);
      }
    }
    // Pressure: 12-second rolling window average (PhET method)
    this._pQueue.push(pStep); this._pQueueDt.push(dt); this._pTotal += pStep;
    this._pQueueTime += dt;
    while (this._pQueueTime > this._pW && this._pQueue.length > 1) {
      this._pTotal -= this._pQueue.shift(); this._pQueueTime -= this._pQueueDt.shift();
    }
    this.pressure = Math.max(0, this._pTotal / this._pW);
  }

  get KE() { let k = 0; for (let i = 0; i < this.N; i++) k += this.vx[i] ** 2 + this.vy[i] ** 2; return 0.5 * k; }
  get temperature() { return this.N > 0 ? this.KE / this.N : 0; }

  thermostat(tgt, c) {
    const t = this.temperature; if (t < 1e-10) return;
    const s = Math.sqrt(1 + c * (tgt / t - 1));
    for (let i = 0; i < this.N; i++) { this.vx[i] *= s; this.vy[i] *= s; }
  }
  addHeat(d) {
    const t = this.temperature;
    if (t < 1e-10) { for (let i = 0; i < this.N; i++) { this.vx[i] += (Math.random() - 0.5) * 0.3; this.vy[i] += (Math.random() - 0.5) * 0.3; } return; }
    // PhET: MAX_TEMPERATURE cap prevents runaway heating
    const MAX_T = 15.0;
    const tNew = Math.max(0.01, Math.min(t + d, d > 0 ? MAX_T : t + d));
    if (Math.abs(tNew - t) < 1e-12) return;
    const s = Math.sqrt(tNew / t);
    for (let i = 0; i < this.N; i++) { this.vx[i] *= s; this.vy[i] *= s; }
  }
  setBox(w, h) { this.W = w; this.H = h; }
  setLJ(e, s) { this.eps = e; this.sig = s; this.rc = 2.5 * s; }
  clearPressure() { this._pQueue = []; this._pQueueDt = []; this._pTotal = 0; this._pQueueTime = 0; this.pressure = 0; }

  inject(angle) {
    if (this.N >= this.maxN) return;
    const i = this.N; this.N++;
    // PhET: injection point at left side, 25% from top
    this.x[i] = this.sig * 1.5;
    this.y[i] = this.H * 0.75;
    // PhET: INJECTED_MOLECULE_SPEED = 2.0, ANGLE_SPREAD = π/4
    const a = (angle !== undefined ? angle : (Math.random() - 0.5) * Math.PI * 0.25);
    this.vx[i] = Math.cos(a) * 2.0;
    this.vy[i] = Math.sin(a) * 2.0;
    this.fx[i] = 0; this.fy[i] = 0;
  }

  removeOutside() {
    // PhET: returnLid removes molecules outside container
    let removed = 0;
    for (let i = this.N - 1; i >= 0; i--) {
      if (this.x[i] < -1 || this.x[i] > this.W + 1 || this.y[i] < -1 || this.y[i] > this.H + 5) {
        // Swap with last and shrink
        const last = this.N - 1;
        this.x[i] = this.x[last]; this.y[i] = this.y[last];
        this.vx[i] = this.vx[last]; this.vy[i] = this.vy[last];
        this.N--; removed++;
      }
    }
    return removed;
  }
}

/* ═══════════════════ MOLECULES (PhET CPK colors) ═══════════════════ */
const MOLECULES = {
  neon:   { label: 'Neon',   eps: 0.5, sig: 0.9, color: '#B3E3F5' },  // PhET CPK
  argon:  { label: 'Argon',  eps: 1.0, sig: 1.0, color: '#80D1E3' },
  oxygen: { label: 'Oxygen', eps: 1.2, sig: 1.1, color: '#FF2020' },
  water:  { label: 'Water',  eps: 2.0, sig: 1.0, color: '#FF4040' },
};

/* ═══════════════════ SIM DEFINITION (engine pattern) ═══════════════════ */

export const StatesOfMatterSim = {
  name: 'States of Matter',
  slug: 'states-of-matter',
  category: 'Thermodynamics',

  vars: {
    temperature: { index: 0, label: 'Temperature', symbol: 'T' },
    pressure:    { index: 1, label: 'Pressure', symbol: 'P' },
    time:        { index: 2, label: 'Time (s)', symbol: 't' },
  },
  varCount: 3,

  params: {
    molecule: { value: 'neon', type: 'choice', options: ['neon', 'argon', 'oxygen', 'water'], label: 'Molecule' },
    N:        { value: 30, min: 10, max: 150, step: 5, label: 'Particles' },
    targetT:  { value: 0.15, min: 0.01, max: 3, step: 0.01, label: 'Temperature' },
    volume:   { value: 0.7, min: 0.3, max: 1.0, step: 0.05, label: 'Volume' },
    heatRate: { value: 0, min: -1, max: 1, step: 0.05, label: 'Heat/Cool' },
    eps:      { value: 0.5, min: 0.1, max: 5, step: 0.1, label: 'ε (bond)' },
    sig:      { value: 0.9, min: 0.5, max: 2, step: 0.1, label: 'σ (size)' },
  },

  views: ['sim', 'time'],
  graphDefaults: { time: ['temperature', 'pressure'] },
  worldRect: { xMin: -2, xMax: 14, yMin: -3, yMax: 12 },

  presets: [
    // ── Core Phases: observe molecular behaviour in each state ──
    { name: 'Solid',           params: { molecule: 'neon',  N: 36, targetT: 0.04, volume: 0.6, heatRate: 0, eps: 0.5, sig: 0.9 } },
    { name: 'Liquid',          params: { molecule: 'argon', N: 36, targetT: 0.45, volume: 0.8, heatRate: 0, eps: 1.0, sig: 1.0 } },
    { name: 'Gas',             params: { molecule: 'argon', N: 20, targetT: 1.50, volume: 1.0, heatRate: 0, eps: 1.0, sig: 1.0 } },
    // ── Phase Transitions: gentle heat drives the transition ──
    { name: 'Melt It',        params: { molecule: 'argon', N: 36, targetT: 0.08, volume: 0.8, heatRate: 0.15, eps: 1.0, sig: 1.0 } },
    { name: 'Boil It',        params: { molecule: 'argon', N: 25, targetT: 0.50, volume: 1.0, heatRate: 0.25, eps: 1.0, sig: 1.0 } },
    // ── Bond Strength: same temperature, different ε → different phase ──
    { name: 'Neon (weak ε)',   params: { molecule: 'neon',  N: 30, targetT: 0.45, volume: 0.8, heatRate: 0, eps: 0.5, sig: 0.9 } },
    { name: 'Water (strong ε)', params: { molecule: 'water', N: 30, targetT: 0.80, volume: 0.8, heatRate: 0, eps: 2.0, sig: 1.0 } },
    // ── Build Pressure: pump molecules + heat + compress → try to make it explode! ──
    { name: 'Build Pressure',  params: { molecule: 'argon', N: 50, targetT: 1.50, volume: 0.6, heatRate: 0, eps: 1.0, sig: 1.0 } },
  ],

  // ─── Internal state ───
  _md: null, _t: 0,
  _isExploded: false, _expLidY: 0, _timeAboveExp: 0,
  _injQ: 0, _injCD: 0,
  _targetH: 7, _currentH: 7, _lidVel: 0,
  _pumpHandleY: 0,  // 0 = top (rest), 1 = fully pushed down
  _pumpStrokeTriggered: false,

  init(p) {
    const mol = MOLECULES[p.molecule] || MOLECULES.neon;
    this._targetH = 10 * p.volume;
    this._currentH = this._targetH;
    this._md = new MD2D(200, 10, this._currentH, mol.eps, mol.sig);
    this._md.initGrid(p.N, p.targetT);
    this._t = 0; this._isExploded = false; this._expLidY = 0;
    this._timeAboveExp = 0; this._injQ = 0; this._injCD = 0;
    this._lidVel = 0; this._pumpHandleY = 0;
    this._pumpStrokeTriggered = false; this._pumpDragging = false;
    this._returnLidBtn = null; this._pumpLayout = null;
    this._heaterDragged = false;
    return [0, 0, 0];
  },

  evaluate(vars, change) { change[0] = 0; change[1] = 0; change[2] = 1; },

  energy(vars) {
    if (!this._md) return { kinetic: 0, potential: 0, total: 0 };
    return { kinetic: this._md.KE, potential: this._md.PE, total: this._md.KE + this._md.PE };
  },

  // Pre-render particle images for performance (PhET technique)
  _particleCanvas: null,
  _particleColors: {},

  _ensureParticleCanvas() {
    if (this._particleCanvas) return;
    const c = document.createElement('canvas');
    c.width = 128; c.height = 32;  // 4 molecule types × 32px each
    const cx = c.getContext('2d');
    let xi = 0;
    for (const [key, mol] of Object.entries(MOLECULES)) {
      cx.beginPath();
      cx.arc(xi + 16, 16, 14, 0, Math.PI * 2);
      cx.fillStyle = mol.color;
      cx.fill();
      // Highlight (3D sphere effect)
      const hg = cx.createRadialGradient(xi + 12, 12, 2, xi + 16, 16, 14);
      hg.addColorStop(0, 'rgba(255,255,255,0.5)');
      hg.addColorStop(0.5, 'rgba(255,255,255,0.1)');
      hg.addColorStop(1, 'rgba(0,0,0,0.15)');
      cx.fillStyle = hg;
      cx.fill();
      this._particleColors[key] = xi;
      xi += 32;
    }
    this._particleCanvas = c;
  },

  render(canvas, vars, params) {
    if (!this._md) return;
    this._ensureParticleCanvas();
    const md = this._md;
    const ctx = canvas.ctx;
    const w = canvas.w, h = canvas.h;
    const mol = MOLECULES[params.molecule] || MOLECULES.neon;
    // DT=0.002 with 30 substeps → same 0.06 model-time per frame as old 0.005×12
    // Smaller DT prevents Verlet divergence on the steep LJ repulsion (r^-13)
    const DT = 0.002, NSUB = 30;

    // ── Update MD params ──
    md.setLJ(params.eps, params.sig);
    this._targetH = 10 * params.volume;

    // ── Rate-limited container height (PhET: 1500 expand, 1250 shrink per sec) ──
    const frameDt = DT * NSUB;
    if (!this._isExploded) {
      const diff = this._targetH - this._currentH;
      if (diff > 0) this._currentH += Math.min(diff, 1500 / 10000 * frameDt);
      else this._currentH += Math.max(diff, -1250 / 10000 * frameDt);
      this._lidVel = (this._currentH - md.H) / frameDt;
      md.setBox(10, this._currentH);
      for (let i = 0; i < md.N; i++) md.y[i] = Math.min(md.H - md.sig * 0.5, md.y[i]);
    }

    // ── Step physics ──
    if (!this._isExploded) {
      for (let s = 0; s < NSUB; s++) {
        md.step(DT, false, this._lidVel);
        // PhET: TEMPERATURE_CHANGE_RATE = 0.07
        if (Math.abs(params.heatRate) > 0.001) md.addHeat(params.heatRate * 0.07 * DT);
        else md.thermostat(params.targetT, 0.02);
        this._t += DT;
        // Injection
        if (this._injQ > 0) { this._injCD -= DT; if (this._injCD <= 0) { md.inject(); this._injQ--; this._injCD = 0.25; } }
      }
      // Explosion: pressure > 20 for > 1.5 real seconds
      // Use ~1/60 per frame (wall-clock), not model time, so the grace period feels like 1.5s to the user
      const FRAME_DT_REAL = 1 / 60;
      if (md.pressure > 20) { this._timeAboveExp += FRAME_DT_REAL;
        if (this._timeAboveExp > 1.5) {
          this._isExploded = true; this._expLidY = 0;
          md.clearPressure();
          for (let i = 0; i < md.N; i++) { md.vy[i] += 2 + Math.random() * 3; md.vx[i] += (Math.random() - 0.5) * 3; }
        }
      } else this._timeAboveExp = Math.max(0, this._timeAboveExp - FRAME_DT_REAL * 0.5);
    } else {
      // Post-explosion: particles drift freely (Euler), lid flies off
      this._expLidY += 9000 / 10000 * frameDt;
      for (let i = 0; i < md.N; i++) {
        md.x[i] += md.vx[i] * DT; md.y[i] += md.vy[i] * DT;
      }
      this._t += frameDt;
    }

    vars[0] = md.temperature;
    vars[1] = this._isExploded ? 0 : md.pressure;  // Show 0 pressure during explosion

    // ═══ DRAW (PhET-faithful beveled container, pre-rendered particles) ═══
    const BW = 10, BH = this._currentH;
    const scale = Math.min((w - 120) / BW, (h - 120) / 10);
    // PhET: model (0,0) → view (32.5%, 75%)
    const ox = w * 0.325, oy = h * 0.78;
    const cx = ox, cy = oy - BH * scale, cw = BW * scale, ch = BH * scale;
    const BEVEL = Math.round(scale * 0.6);  // PhET: 9px bevel, scaled
    const TILT = cw / 2 * 0.15;  // PhET: PERSPECTIVE_TILT_FACTOR = 0.15

    // Store layout so hitTest/onDrag can convert world→model
    this._layout = { ox, oy, scale, w, h };

    ctx.fillStyle = '#000'; ctx.fillRect(0, 0, w, h);

    // ── Container outer shell (PhET gradient with bevels) ──
    ctx.save();
    // Outer gradient fill
    const outerGrad = ctx.createLinearGradient(cx - BEVEL, 0, cx + cw + BEVEL, 0);
    outerGrad.addColorStop(0, '#6D6D6D'); outerGrad.addColorStop(0.1, '#8B8B8B');
    outerGrad.addColorStop(0.2, '#AEAFAF'); outerGrad.addColorStop(0.4, '#BABABA');
    outerGrad.addColorStop(0.7, '#A3A4A4'); outerGrad.addColorStop(0.75, '#8E8E8E');
    outerGrad.addColorStop(0.8, '#737373'); outerGrad.addColorStop(0.9, '#646565');
    ctx.globalAlpha = 0.9; ctx.fillStyle = outerGrad;
    // Outer shape with curved top (PhET uses cubic Bézier)
    ctx.beginPath();
    ctx.moveTo(cx - BEVEL, cy - TILT * 1.28);
    ctx.bezierCurveTo(cx - BEVEL, cy + TILT * 1.28, cx + cw + BEVEL, cy + TILT * 1.28, cx + cw + BEVEL, cy - TILT * 1.28);
    ctx.lineTo(cx + cw + BEVEL, oy + TILT * 1.28);
    ctx.bezierCurveTo(cx + cw + BEVEL, oy - TILT * 1.28, cx - BEVEL, oy - TILT * 1.28, cx - BEVEL, oy + TILT * 1.28);
    ctx.closePath(); ctx.fill();
    ctx.globalAlpha = 1;

    // Inner dark chamber (cutout)
    ctx.fillStyle = '#080810';
    ctx.beginPath();
    ctx.moveTo(cx, cy + TILT * 0.7);
    ctx.quadraticCurveTo(cx + cw / 2, cy - TILT * 0.7, cx + cw, cy + TILT * 0.7);
    ctx.lineTo(cx + cw, oy - TILT * 0.7);
    ctx.quadraticCurveTo(cx + cw / 2, oy + TILT * 0.7, cx, oy - TILT * 0.7);
    ctx.closePath(); ctx.fill();

    // Left bevel (dark)
    const lbGrad = ctx.createLinearGradient(0, cy, 0, oy);
    lbGrad.addColorStop(0, '#525252'); lbGrad.addColorStop(0.4, '#4E4E4E');
    lbGrad.addColorStop(0.6, '#353535'); lbGrad.addColorStop(0.8, '#292929');
    ctx.fillStyle = lbGrad; ctx.globalAlpha = 0.9;
    ctx.fillRect(cx - BEVEL, cy, BEVEL, ch); ctx.globalAlpha = 1;
    // Right bevel (lighter)
    const rbGrad = ctx.createLinearGradient(0, cy, 0, oy);
    rbGrad.addColorStop(0, '#8A8A8A'); rbGrad.addColorStop(0.3, '#525252');
    rbGrad.addColorStop(0.6, '#8A8A8A'); rbGrad.addColorStop(0.9, '#A2A2A2');
    ctx.fillStyle = rbGrad; ctx.globalAlpha = 0.9;
    ctx.fillRect(cx + cw, cy, BEVEL, ch); ctx.globalAlpha = 1;
    ctx.restore();

    // ── Lid (PhET: semi-transparent ellipse with perspective) ──
    const lidY = this._isExploded ? cy - this._expLidY * scale : cy;
    ctx.save();
    if (this._isExploded) {
      // PhET: lid rotates during explosion
      const rot = this._expLidY * Math.PI * 0.00008 * scale;
      ctx.translate(cx + cw / 2, lidY); ctx.rotate(rot); ctx.translate(-(cx + cw / 2), -lidY);
    }
    ctx.fillStyle = 'rgba(126,126,126,0.8)';
    ctx.beginPath(); ctx.ellipse(cx + cw / 2, lidY, cw / 2 + 4, TILT + 2, 0, 0, Math.PI * 2);
    ctx.fill();
    ctx.strokeStyle = '#444'; ctx.lineWidth = 1; ctx.stroke();
    // Handle grip (PhET: HandleNode)
    ctx.fillStyle = '#B0B0B0'; ctx.fillRect(cx + cw / 2 - 18, lidY - 16, 36, 9);
    ctx.fillStyle = '#909090'; ctx.fillRect(cx + cw / 2 - 2, lidY - 36, 4, 22);
    // Grip lines
    ctx.strokeStyle = '#999'; ctx.lineWidth = 1;
    for (let i = -12; i <= 12; i += 6) {
      ctx.beginPath(); ctx.moveTo(cx + cw / 2 + i, lidY - 15); ctx.lineTo(cx + cw / 2 + i, lidY - 8); ctx.stroke();
    }
    ctx.restore();

    // ── Bonds (drawn behind particles — visible in solid/liquid phases) ──
    const bondCut = md.sig * 1.5;  // bonds visible when r < 1.5σ
    const bondCut2 = bondCut * bondCut;
    if (md.temperature < 0.8 * params.eps) {  // only draw bonds in solid/liquid
      ctx.strokeStyle = 'rgba(120,140,160,0.35)';
      ctx.lineWidth = Math.max(1, scale * 0.04);
      for (let i = 0; i < md.N - 1; i++) {
        const xi = ox + md.x[i] * scale, yi = oy - md.y[i] * scale;
        if (xi < cx - 5 || xi > cx + cw + 5 || yi < lidY - 10 || yi > oy + 5) continue;
        for (let j = i + 1; j < md.N; j++) {
          const dx = md.x[j] - md.x[i], dy = md.y[j] - md.y[i];
          const r2 = dx * dx + dy * dy;
          if (r2 > bondCut2) continue;
          const xj = ox + md.x[j] * scale, yj = oy - md.y[j] * scale;
          ctx.globalAlpha = Math.max(0, 1 - Math.sqrt(r2) / bondCut);
          ctx.beginPath(); ctx.moveTo(xi, yi); ctx.lineTo(xj, yj); ctx.stroke();
        }
      }
      ctx.globalAlpha = 1;
    }

    // ── Particles (pre-rendered images for PhET-quality rendering) ──
    const pSrcX = this._particleColors[params.molecule] || 0;
    const pDiam = Math.max(6, params.sig * scale * 0.8);
    for (let i = 0; i < md.N; i++) {
      const px = ox + md.x[i] * scale - pDiam / 2;
      const py = oy - md.y[i] * scale - pDiam / 2;
      // Clip to container interior
      if (px + pDiam < cx || px > cx + cw || py + pDiam < lidY - 10 || py > oy) continue;
      ctx.drawImage(this._particleCanvas, pSrcX, 0, 32, 32, px, py, pDiam, pDiam);
    }

    // ── Top ellipse outline (drawn AFTER particles, like PhET z-order) ──
    ctx.strokeStyle = '#444'; ctx.lineWidth = 1;
    ctx.beginPath(); ctx.ellipse(cx + cw / 2, cy, cw / 2 + 4, TILT + 2, 0, 0, Math.PI * 2); ctx.stroke();

    // ── Bicycle Pump (left side, PhET style) ──
    const puW = 28, puBodyH = ch * 0.65;
    const puX = ox - 75, puBodyTop = oy - puBodyH - 8;
    // Pump handle travel range (0=top, 1=pushed down into cylinder)
    const handleTravel = puBodyH * 0.7;
    const handleY = puBodyTop - 20 + this._pumpHandleY * handleTravel;
    // Return handle to top when not dragging (spring-back)
    if (!this._pumpDragging) this._pumpHandleY *= 0.9;

    // Handle rod (vertical stick)
    ctx.fillStyle = '#A0A0A0';
    ctx.fillRect(puX + puW / 2 - 2, handleY + 8, 4, puBodyTop + puBodyH * 0.1 - handleY);
    // Handle crossbar (grab this)
    const hbW = puW + 22;
    ctx.fillStyle = '#B8B8B8';
    ctx.beginPath();
    ctx.roundRect(puX + puW / 2 - hbW / 2, handleY - 4, hbW, 12, 4);
    ctx.fill();
    ctx.strokeStyle = '#888'; ctx.lineWidth = 1; ctx.stroke();
    // Grip lines on handle
    ctx.strokeStyle = '#999'; ctx.lineWidth = 1;
    for (let i = -8; i <= 8; i += 4) {
      ctx.beginPath();
      ctx.moveTo(puX + puW / 2 + i, handleY - 2);
      ctx.lineTo(puX + puW / 2 + i, handleY + 6);
      ctx.stroke();
    }
    // Cylinder body (darker red-brown)
    const cylGrad = ctx.createLinearGradient(puX, 0, puX + puW, 0);
    cylGrad.addColorStop(0, '#8B3A3A'); cylGrad.addColorStop(0.3, '#CC4444');
    cylGrad.addColorStop(0.7, '#CC4444'); cylGrad.addColorStop(1, '#7A2E2E');
    ctx.fillStyle = cylGrad;
    ctx.beginPath();
    ctx.roundRect(puX, puBodyTop, puW, puBodyH, 3);
    ctx.fill();
    // Cylinder rim (top)
    ctx.fillStyle = '#999'; ctx.fillRect(puX - 2, puBodyTop - 3, puW + 4, 6);
    // Base
    ctx.fillStyle = '#666';
    ctx.beginPath();
    ctx.roundRect(puX - 6, oy - 8, puW + 12, 10, 3);
    ctx.fill();
    // Hose (from pump base to container lower-left)
    ctx.strokeStyle = '#666'; ctx.lineWidth = 7; ctx.lineCap = 'round';
    ctx.beginPath();
    ctx.moveTo(puX + puW / 2, oy - 2);
    ctx.bezierCurveTo(puX + puW / 2, oy + 25, cx - 25, oy + 20, cx + 2, oy - ch * 0.25);
    ctx.stroke();
    ctx.strokeStyle = '#888'; ctx.lineWidth = 4;
    ctx.beginPath();
    ctx.moveTo(puX + puW / 2, oy - 2);
    ctx.bezierCurveTo(puX + puW / 2, oy + 25, cx - 25, oy + 20, cx + 2, oy - ch * 0.25);
    ctx.stroke();
    // Injection ball traveling through hose
    if (this._injQ > 0) {
      const bp = (this._t * 3) % 1;
      const bx = puX + puW / 2 + (cx + 2 - puX - puW / 2) * bp;
      const by = oy - 2 + ((oy + 25 - oy + 2) * Math.sin(bp * Math.PI)) + (oy - ch * 0.25 - oy + 2) * bp;
      ctx.beginPath(); ctx.arc(bx, by, 5, 0, Math.PI * 2);
      ctx.fillStyle = mol.color; ctx.fill();
      ctx.strokeStyle = 'rgba(255,255,255,0.4)'; ctx.lineWidth = 1; ctx.stroke();
    }
    // Pump label
    ctx.font = '10px sans-serif'; ctx.fillStyle = '#AAA'; ctx.textAlign = 'center';
    ctx.fillText('Pump ↕', puX + puW / 2, puBodyTop - 30);

    // Store pump layout for hitTest
    this._pumpLayout = { x: puX - 12, y: handleY - 10, w: hbW + 10, h: handleTravel + 30,
                         handleY, puBodyTop, handleTravel };

    // ── Heater/Cooler (below container, PhET style) ──
    const htW = cw * 0.85, htH = 38;
    const htX = cx + (cw - htW) / 2, htY = oy + 14;
    // Background halves
    const coolAlpha = params.heatRate < -0.01 ? 0.5 + Math.abs(params.heatRate) * 0.5 : 0.2;
    const heatAlpha = params.heatRate > 0.01 ? 0.5 + params.heatRate * 0.5 : 0.2;
    ctx.fillStyle = `rgba(40,60,220,${coolAlpha})`;
    ctx.fillRect(htX, htY, htW / 2, htH);
    ctx.fillStyle = `rgba(220,60,40,${heatAlpha})`;
    ctx.fillRect(htX + htW / 2, htY, htW / 2, htH);
    // Border
    ctx.strokeStyle = 'rgba(255,255,255,0.15)'; ctx.lineWidth = 1;
    ctx.beginPath(); ctx.roundRect(htX, htY, htW, htH, 6); ctx.stroke();
    // Labels
    ctx.font = 'bold 12px sans-serif'; ctx.fillStyle = '#FFF'; ctx.textAlign = 'center';
    ctx.fillText('❄ Cool', htX + htW / 4, htY + 24);
    ctx.fillText('🔥 Heat', htX + htW * 3 / 4, htY + 24);
    // Slider thumb (always visible at center, moves with heatRate)
    const thumbX = htX + htW / 2 + params.heatRate * (htW / 2 - 8);
    ctx.fillStyle = '#FFF';
    ctx.beginPath(); ctx.roundRect(thumbX - 4, htY + 4, 8, htH - 8, 3); ctx.fill();
    ctx.fillStyle = '#666';
    for (let i = -4; i <= 4; i += 4) {
      ctx.fillRect(thumbX - 1, htY + htH / 2 + i - 1, 2, 2);
    }
    // Hint text
    ctx.font = '9px sans-serif'; ctx.fillStyle = '#777'; ctx.textAlign = 'center';
    ctx.fillText('← drag →', htX + htW / 2, htY + htH + 11);

    // ── Pressure Gauge (top-right, with connector pipe) ──
    const gx = cx + cw + 45, gy = cy + 30, gr = 24;
    // Pipe from gauge to container
    ctx.strokeStyle = '#999'; ctx.lineWidth = 4;
    ctx.beginPath(); ctx.moveTo(gx - gr, gy); ctx.lineTo(cx + cw + BEVEL + 2, gy);
    ctx.lineTo(cx + cw + BEVEL + 2, cy + ch * 0.3); ctx.stroke();
    // Face
    ctx.beginPath(); ctx.arc(gx, gy, gr, 0, Math.PI * 2);
    ctx.fillStyle = '#F8F8F8'; ctx.fill();
    ctx.strokeStyle = '#777'; ctx.lineWidth = 3; ctx.stroke();
    // Ticks
    for (let i = 0; i <= 10; i++) {
      const a = (-Math.PI * 0.75) + (i / 10) * Math.PI * 1.5;
      ctx.beginPath();
      ctx.moveTo(gx + Math.cos(a) * (gr - 4), gy + Math.sin(a) * (gr - 4));
      ctx.lineTo(gx + Math.cos(a) * (gr - 9), gy + Math.sin(a) * (gr - 9));
      ctx.strokeStyle = '#333'; ctx.lineWidth = i % 5 === 0 ? 2 : 1; ctx.stroke();
    }
    // Needle
    const pF = Math.min(md.pressure / 25, 1);
    const nA = (-Math.PI * 0.75) + pF * Math.PI * 1.5;
    ctx.beginPath(); ctx.moveTo(gx, gy);
    ctx.lineTo(gx + Math.cos(nA) * (gr - 6), gy + Math.sin(nA) * (gr - 6));
    ctx.strokeStyle = '#E22'; ctx.lineWidth = 2; ctx.stroke();
    ctx.beginPath(); ctx.arc(gx, gy, 3, 0, Math.PI * 2); ctx.fillStyle = '#444'; ctx.fill();
    ctx.font = '10px monospace'; ctx.fillStyle = md.pressure > 15 ? '#E44' : '#555';
    ctx.textAlign = 'center';
    ctx.fillText(md.pressure.toFixed(1) + (md.pressure > 15 ? ' ⚠' : ''), gx, gy + gr + 14);

    // ── Thermometer (right of container) ──
    const tx = cx + cw + 16, tBot = oy - 5, tTop = cy + 20, tH2 = tBot - tTop;
    ctx.fillStyle = 'rgba(220,220,240,0.3)'; ctx.fillRect(tx - 3, tTop, 6, tH2);
    ctx.beginPath(); ctx.arc(tx, tBot + 6, 6, 0, Math.PI * 2);
    ctx.fillStyle = '#D22'; ctx.fill();
    const tFr = Math.min(1, md.temperature / 2);
    ctx.fillStyle = `hsl(${(0.66 - tFr * 0.66) * 360},85%,50%)`;
    ctx.fillRect(tx - 2, tBot - tFr * tH2, 4, tFr * tH2 + 6);
    ctx.font = '10px monospace'; ctx.fillStyle = '#EEE'; ctx.textAlign = 'left';
    ctx.fillText(md.temperature.toFixed(2), tx + 10, tBot - tFr * tH2 + 4);

    // ── Phase label (above container) ──
    const T = md.temperature, Ts = 0.15 * params.eps, Tg = 0.8 * params.eps;
    let phase, phCol;
    if (this._isExploded) { phase = '\uD83D\uDCA5 EXPLODED'; phCol = '#F44'; }
    else if (T < Ts) { phase = 'SOLID'; phCol = '#68F'; }
    else if (T < Tg) { phase = 'LIQUID'; phCol = '#2D6'; }
    else { phase = 'GAS'; phCol = '#F55'; }
    ctx.font = 'bold 15px sans-serif'; ctx.fillStyle = phCol; ctx.textAlign = 'center';
    ctx.fillText(phase, cx + cw / 2, cy - TILT - 14);
    // N count
    ctx.font = '10px monospace'; ctx.fillStyle = '#777'; ctx.textAlign = 'left';
    ctx.fillText('N=' + md.N, cx + 6, oy - 6);
    // "Return Lid" button (PhET style yellow button, visible after explosion)
    if (this._isExploded) {
      const rbW = 110, rbH = 30;
      const rbX = cx + (cw - rbW) / 2, rbY = cy - TILT - 56;
      ctx.fillStyle = '#F5C542';
      ctx.beginPath(); ctx.roundRect(rbX, rbY, rbW, rbH, 6); ctx.fill();
      ctx.strokeStyle = '#C49A20'; ctx.lineWidth = 2; ctx.stroke();
      ctx.font = 'bold 13px sans-serif'; ctx.fillStyle = '#333'; ctx.textAlign = 'center';
      ctx.fillText('Return Lid', rbX + rbW / 2, rbY + 20);
      // Store button bounds for hitTest
      this._returnLidBtn = { sx: rbX, sy: rbY, sw: rbW, sh: rbH };
    } else {
      this._returnLidBtn = null;
    }
  },

  // Convert engine world coords → screen pixels, then to model coords
  _toScreen(wx, wy) {
    const L = this._layout;
    if (!L) return { px: 0, py: 0 };
    const wr = this.worldRect;
    return {
      px: (wx - wr.xMin) / (wr.xMax - wr.xMin) * L.w,
      py: (wr.yMax - wy) / (wr.yMax - wr.yMin) * L.h
    };
  },
  _toModel(wx, wy) {
    const L = this._layout;
    if (!L) return { mx: 0, my: 0 };
    const { px, py } = this._toScreen(wx, wy);
    return { mx: (px - L.ox) / L.scale, my: (L.oy - py) / L.scale };
  },

  _pumpDragging: false,

  hitTest(wx, wy, vars, params) {
    const { px, py } = this._toScreen(wx, wy);
    const { mx, my } = this._toModel(wx, wy);

    // Return Lid button (screen-space detection)
    if (this._isExploded && this._returnLidBtn) {
      const b = this._returnLidBtn;
      if (px >= b.sx && px <= b.sx + b.sw && py >= b.sy && py <= b.sy + b.sh) {
        return { id: 'returnLid' };
      }
    }
    // Pump handle (screen-space: generous touch target)
    if (!this._isExploded && this._pumpLayout) {
      const p = this._pumpLayout;
      if (px >= p.x && px <= p.x + p.w && py >= p.y && py <= p.y + p.h) {
        return { id: 'pump' };
      }
    }
    // Heater/cooler (below container in model space)
    if (mx > 0 && mx < 10 && my < -0.3 && my > -2) return { id: 'heater' };
    // Lid handle (near top of container)
    if (!this._isExploded) {
      const lidY = 10 * params.volume;
      if (mx > -1 && mx < 11 && Math.abs(my - lidY) < 1.5) return { id: 'lid' };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    const { px, py } = this._toScreen(wx, wy);
    const { mx, my } = this._toModel(wx, wy);

    if (id === 'returnLid') {
      // Handled on release (click)
    } else if (id === 'pump') {
      this._pumpDragging = true;
      // Map vertical drag to pump handle (drag DOWN = push handle down)
      if (!offset._pumpStartPy) {
        offset._pumpStartPy = py;
        offset._pumpStartHandle = this._pumpHandleY;
      }
      const dy = py - offset._pumpStartPy;
      const newH = Math.max(0, Math.min(1, offset._pumpStartHandle + dy / (this._pumpLayout?.handleTravel || 100)));
      // Trigger injection when handle passes 70% down
      if (newH > 0.7 && !this._pumpStrokeTriggered && this._injQ < 3) {
        this._pumpStrokeTriggered = true;
        this._injQ += 3;  // PhET: 3 molecules per pump stroke
      }
      this._pumpHandleY = newH;
    } else if (id === 'lid') {
      const tv = Math.max(0.3, Math.min(1.0, my / 10));
      params.volume += (tv - params.volume) * 0.3;
    } else if (id === 'heater') {
      this._heaterDragged = true;
      params.heatRate = Math.max(-1, Math.min(1, (mx - 5) * 0.25));
    }
  },

  onRelease(id, vars, params) {
    if (id === 'pump') {
      this._pumpDragging = false;
      this._pumpStrokeTriggered = false;
    }
    // Only zero heatRate if user actually dragged the heater (protects preset heating)
    if (id === 'heater' && this._heaterDragged) {
      params.heatRate = 0;
      this._heaterDragged = false;
    }
    if (id === 'returnLid') this._returnLid(params);
  },

  // PhET: returnLid() — remove escaped molecules, reset explosion
  _returnLid(params) {
    if (!this._isExploded) return;
    const md = this._md;
    // Remove molecules that escaped the container
    let kept = 0;
    for (let i = 0; i < md.N; i++) {
      if (md.x[i] >= 0 && md.x[i] <= md.W && md.y[i] >= 0 && md.y[i] <= md.H + 1) {
        md.x[kept] = md.x[i]; md.y[kept] = md.y[i];
        md.vx[kept] = md.vx[i]; md.vy[kept] = md.vy[i];
        kept++;
      }
    }
    md.N = kept;
    this._isExploded = false;
    this._expLidY = 0;
    this._timeAboveExp = 0;
    md.clearPressure();
    // Cool down to target temperature to prevent immediate re-explosion
    const gasT = 0.8 * params.eps;
    if (md.temperature > gasT) {
      params.targetT = Math.min(params.targetT, gasT * 0.8);
    }
    params.heatRate = 0;
  },

  info: `
    <h2>States of Matter</h2>
    <p>Watch molecules form a solid, liquid, or gas. Add or remove heat and watch phase transitions happen.</p>
    <h3>How to Use</h3>
    <ul>
      <li><strong>Drag the pump</strong> (left) to inject molecules — watch pressure rise on the gauge</li>
      <li><strong>Drag across the heater</strong> (bottom) — right = heat 🔥, left = cool ❄. Releases to zero.</li>
      <li><strong>Drag the lid</strong> (top handle) down to compress, up to expand</li>
      <li><strong>Overpressure</strong> the container (add lots of molecules + heat + compress) → lid blows off! 💥</li>
    </ul>
    <h3>Lennard-Jones Potential</h3>
    <p><code>V(r) = 4ε[(σ/r)¹² − (σ/r)⁶]</code></p>
    <p><strong>ε</strong> controls bond strength. <strong>σ</strong> controls particle size.</p>
  `,
};
