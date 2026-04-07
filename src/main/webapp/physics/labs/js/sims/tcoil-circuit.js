/**
 * T-Coil Circuit — Transfer Function Analysis
 *
 * Analyzes the transfer function H(s) = V2/V1 of a bridged T-coil circuit
 * used for bandwidth extension. The T-coil consists of two mutually coupled
 * inductors (La, Lb) and a bridge capacitor (Cb), loaded by Ce and R2.
 *
 * Circuit topology:
 *   V1 ─[R1]─┬────[Cb]────┬─ V2
 *             │            │
 *            [La+Ra] ↕M [Lb+Rb]  [R2]
 *             │            │       │
 *             └─── ●B ─────┘      GND
 *                  │
 *                 [Ce]
 *                  │
 *                 GND
 *
 * H(s) is computed by solving 4 Kirchhoff equations in the Laplace domain.
 * Bode plot: evaluate H(jω) at many frequencies.
 * Step response: Talbot numerical inverse Laplace of H(s)/s.
 *
 * State: [time_ps, stepResponse]
 *   time_ps = animation time in picoseconds
 *   stepResponse = precomputed step response interpolated at current time
 */

// ── Complex arithmetic: [re, im] ──
const cAdd = (a, b) => [a[0] + b[0], a[1] + b[1]];
const cSub = (a, b) => [a[0] - b[0], a[1] - b[1]];
const cMul = (a, b) => [a[0] * b[0] - a[1] * b[1], a[0] * b[1] + a[1] * b[0]];
const cDiv = (a, b) => {
  const d = b[0] * b[0] + b[1] * b[1];
  return [(a[0] * b[0] + a[1] * b[1]) / d, (a[1] * b[0] - a[0] * b[1]) / d];
};

export const TCoilSim = {
  name: 'T-Coil Circuit',
  slug: 'tcoil-circuit',
  category: 'Circuits',

  vars: {
    time:      { index: 0, label: 'Time (ps)',              symbol: 't' },
    stepResp:  { index: 1, label: 'Step Response (V₂/V₁)',  symbol: 'h(t)' },
    sweepLogF: { index: 2, label: 'Sweep log₁₀(f)',        symbol: 'logf' },
  },
  varCount: 3,

  params: {
    R1:   { value: 50,  min: 10,  max: 200,  step: 1,    label: 'R₁ (source)',    unit: 'Ω' },
    R2:   { value: 50,  min: 10,  max: 200,  step: 1,    label: 'R₂ (load)',      unit: 'Ω' },
    Ra:   { value: 4,   min: 0,   max: 20,   step: 0.5,  label: 'Ra (parasitic)', unit: 'Ω' },
    Rb:   { value: 2,   min: 0,   max: 20,   step: 0.5,  label: 'Rb (parasitic)', unit: 'Ω' },
    La:   { value: 360, min: 50,  max: 1000, step: 10,   label: 'La',             unit: 'pH' },
    Lb:   { value: 240, min: 50,  max: 1000, step: 10,   label: 'Lb',             unit: 'pH' },
    k:    { value: 0.4, min: 0,   max: 0.95, step: 0.05, label: 'Coupling k',     unit: '' },
    Cb:   { value: 15,  min: 1,   max: 100,  step: 1,    label: 'Cb (bridge)',    unit: 'fF' },
    Ce:   { value: 300, min: 50,  max: 1000, step: 10,   label: 'Ce (load)',      unit: 'fF' },
    showIdeal: { value: true, type: 'bool', label: 'Compare: No Parasitics' },
  },

  views: ['sim', 'time'],

  graphDefaults: { time: ['stepResp'] },

  worldRect: { xMin: -8, xMax: 8, yMin: -5.5, yMax: 6 },

  presets: [
    { name: 'Default (MATLAB example)',  params: {} },
    { name: 'Ideal (no parasitics)',     params: { Ra: 0, Rb: 0, showIdeal: false } },
    { name: 'High Coupling (k=0.8)',     params: { k: 0.8 } },
    { name: 'Low Coupling (k=0.1)',      params: { k: 0.1 } },
    { name: 'Symmetric (La=Lb=300pH)',   params: { La: 300, Lb: 300 } },
    { name: 'Large Bridge Cap (Cb=50fF)',params: { Cb: 50 } },
    { name: 'Heavy Load (Ce=800fF)',     params: { Ce: 800 } },
    { name: 'Matched 75Ω',              params: { R1: 75, R2: 75 } },
  ],

  // ════════ Cache ════════
  _cache: null,
  _cacheKey: '',

  _paramKey(p) {
    return [p.R1, p.R2, p.Ra, p.Rb, p.La, p.Lb, p.k, p.Cb, p.Ce, p.showIdeal].join(',');
  },

  _ensureCache(p) {
    const key = this._paramKey(p);
    if (this._cacheKey !== key) {
      this._cache = this._buildCache(p);
      this._cacheKey = key;
    }
  },

  // ════════ Transfer function H(s) ════════
  /**
   * Evaluate H(s) = V2/V1 at complex s = [sr, si].
   * Solves the 3×3 system (after eliminating I1 via KCL) using Cramer's rule.
   */
  _evalH(sr, si, p) {
    const La = p.La * 1e-12, Lb = p.Lb * 1e-12;
    const M = p.k * Math.sqrt(La * Lb);
    const Cb_si = p.Cb * 1e-15, Ce_si = p.Ce * 1e-15;
    const { R1, R2, Ra, Rb } = p;
    const s = [sr, si];

    // Impedances
    const ZCb = cDiv([1, 0], [Cb_si * sr, Cb_si * si]);
    const ZCe = cDiv([1, 0], [Ce_si * sr, Ce_si * si]);
    const ZLa = [La * sr, La * si];
    const ZLb = [Lb * sr, Lb * si];
    const ZM  = [M * sr, M * si];

    // 3×3 matrix: A * [V2, I2, I3]^T = [1, 1, 0]^T
    // Row 1 (eqn1 with I1 eliminated): a11*V2 + a12*I2 + a13*I3 = 1
    const a11 = cAdd([R1 / R2 + 1, 0], cDiv(ZCb, [R2, 0]));
    const a12 = [R1, 0];
    const a13 = cMul([-1, 0], cAdd([R1, 0], ZCb));

    // Row 2 (eqn2 with I1 eliminated):
    const a21 = [R1 / R2, 0];
    const a22 = cAdd(cAdd([R1 + Ra, 0], ZLa), ZCe);
    const a23 = cAdd(cSub([-R1, 0], ZCe), ZM);

    // Row 3 (eqn4 rearranged): -V2 + a32*I2 + a33*I3 = 0
    const a31 = [-1, 0];
    const a32 = cSub(ZCe, ZM);
    const a33 = cMul([-1, 0], cAdd(cAdd([Rb, 0], ZLb), ZCe));

    // Cramer's rule cofactors
    const T1 = cSub(cMul(a22, a33), cMul(a23, a32));
    const T2 = cSub(cMul(a12, a33), cMul(a13, a32));
    const T3 = cSub(cMul(a12, a23), cMul(a13, a22));

    const detA  = cAdd(cSub(cMul(a11, T1), cMul(a21, T2)), cMul(a31, T3));
    const detAV = cSub(T1, T2); // RHS = [1, 1, 0]

    return cDiv(detAV, detA);
  },

  // ════════ Talbot inverse Laplace ════════
  /**
   * Compute L^{-1}[F(s)](t) using fixed Talbot contour with N=16 terms.
   * @param {number} t — time in seconds (must be > 0)
   * @param {function} evalF — (sr, si) => [re, im] of F(s)
   */
  _talbotInvLap(t, evalF) {
    if (t <= 0) return 0;
    const N = 16;
    const r = 2 * N / (5 * t);

    // k=0 term
    const F0 = evalF(r, 0);
    let sum = 0.5 * Math.exp(r * t) * F0[0];

    for (let k = 1; k < N; k++) {
      const theta = k * Math.PI / N;
      const sinT = Math.sin(theta), cosT = Math.cos(theta);
      const cotT = cosT / sinT;

      // Contour point s_k = r * θ * (cot θ + i)
      const sk_re = r * theta * cotT;
      const sk_im = r * theta;

      // Weight γ_k = 1 + i[θ/sin²θ − cot θ]
      const gk_im = theta / (sinT * sinT) - cotT;

      // F(s_k)
      const Fk = evalF(sk_re, sk_im);

      // exp(s_k * t)
      const expR = Math.exp(sk_re * t);
      const exp_re = expR * Math.cos(sk_im * t);
      const exp_im = expR * Math.sin(sk_im * t);

      // γ * F  (γ_re = 1)
      const gF_re = Fk[0] - gk_im * Fk[1];
      const gF_im = Fk[1] + gk_im * Fk[0];

      // Re[(γ * F) * exp(s*t)]
      sum += gF_re * exp_re - gF_im * exp_im;
    }
    return (r / N) * sum;
  },

  // ════════ Cache builder ════════
  _buildCache(p) {
    const { R1, R2, Ra, Rb } = p;

    // DC gain (analytical: at DC, inductors = short, caps = open)
    const dcGain = R2 / (R1 + Ra + Rb + R2);
    const dcGainDB = 20 * Math.log10(dcGain);
    const hfGain = R2 / (R1 + R2);
    const hfGainDB = 20 * Math.log10(hfGain);

    // ── Bode data ──
    const N_BODE = 300;
    const logFMin = 9, logFMax = 14.5;
    const freqs = [], magDB = [], phase = [];
    for (let i = 0; i < N_BODE; i++) {
      const logF = logFMin + (logFMax - logFMin) * i / (N_BODE - 1);
      const f = Math.pow(10, logF);
      const omega = 2 * Math.PI * f;
      const H = this._evalH(0, omega, p);
      const mag = Math.sqrt(H[0] * H[0] + H[1] * H[1]);
      freqs.push(f);
      magDB.push(20 * Math.log10(Math.max(mag, 1e-15)));
      phase.push(Math.atan2(H[1], H[0]) * 180 / Math.PI);
    }

    // Find bandwidth (−3dB from DC)
    const bwThreshold = dcGainDB - 3;
    let bwFreq = freqs[freqs.length - 1];
    for (let i = 0; i < N_BODE; i++) {
      if (magDB[i] < bwThreshold) { bwFreq = freqs[Math.max(0, i - 1)]; break; }
    }

    // Find dip (minimum magnitude)
    let dipDB = 0, dipFreq = 0;
    for (let i = 0; i < N_BODE; i++) {
      if (magDB[i] < dipDB || i === 0) { dipDB = magDB[i]; dipFreq = freqs[i]; }
    }

    // ── Ideal Bode (Ra=Rb=0) if showIdeal and there are parasitics ──
    let bodeIdeal = null;
    if (p.showIdeal && (Ra > 0 || Rb > 0)) {
      const pIdeal = { ...p, Ra: 0, Rb: 0 };
      const idealMagDB = [];
      for (let i = 0; i < N_BODE; i++) {
        const omega = 2 * Math.PI * freqs[i];
        const H = this._evalH(0, omega, pIdeal);
        idealMagDB.push(20 * Math.log10(Math.max(Math.sqrt(H[0] * H[0] + H[1] * H[1]), 1e-15)));
      }
      bodeIdeal = idealMagDB;
    }

    // ── Step response via Talbot ──
    const N_STEP = 300;
    const tMaxPS = 50; // picoseconds
    const stepTime = [], stepVal = [];
    stepTime.push(0);
    stepVal.push(hfGain); // initial value = D = lim_{s→∞} H(s) = R2/(R1+R2)

    for (let i = 1; i < N_STEP; i++) {
      const t_ps = tMaxPS * i / (N_STEP - 1);
      const t_s = t_ps * 1e-12;
      const y = this._talbotInvLap(t_s, (sr, si) => {
        const H = this._evalH(sr, si, p);
        const sMag2 = sr * sr + si * si;
        return [(H[0] * sr + H[1] * si) / sMag2, (H[1] * sr - H[0] * si) / sMag2];
      });
      stepTime.push(t_ps);
      stepVal.push(y);
    }

    return {
      dcGain, dcGainDB, hfGain, hfGainDB,
      freqs, magDB, phase,
      bodeIdeal,
      bwFreq, dipDB, dipFreq,
      stepTime, stepVal,
    };
  },

  // ════════ Framework hooks ════════
  init(params) {
    const hfGain = (params?.R2 ?? 50) / ((params?.R1 ?? 50) + (params?.R2 ?? 50));
    return [0, hfGain, 9]; // [time, stepResp, sweepLogF starting at 10^9 Hz]
  },

  evaluate(vars, change, params, isDragging) {
    change[0] = isDragging ? 0 : 5; // advance 5 ps per sim-second
    change[1] = 0; // computed in postStep
    change[2] = 0; // computed in postStep
  },

  postStep(vars, params) {
    this._ensureCache(params);
    const c = this._cache;
    const t = vars[0];
    // Interpolate step response
    if (t <= 0) { vars[1] = c.hfGain; return; }
    if (t >= c.stepTime[c.stepTime.length - 1]) {
      vars[1] = c.stepVal[c.stepVal.length - 1];
      return;
    }
    // Binary search for interval
    let lo = 0, hi = c.stepTime.length - 1;
    while (hi - lo > 1) {
      const mid = (lo + hi) >> 1;
      if (c.stepTime[mid] <= t) lo = mid; else hi = mid;
    }
    const frac = (t - c.stepTime[lo]) / (c.stepTime[hi] - c.stepTime[lo]);
    vars[1] = c.stepVal[lo] + frac * (c.stepVal[hi] - c.stepVal[lo]);

    // Sweep frequency: cycle log10(f) from 9 to 14.5 over ~11 ps, then repeat
    const sweepPeriod = 11; // ps per full sweep
    const logFMin = 9, logFMax = 14.5;
    const phase = (t % sweepPeriod) / sweepPeriod;
    vars[2] = logFMin + phase * (logFMax - logFMin);
  },

  energy() { return { kinetic: 0, potential: 0, total: 0 }; },
  theoreticalPeriod() { return Infinity; },

  hitTest() { return null; },
  onDrag() {},
  onRelease() {},

  // ════════ Rendering ════════
  render(canvas, vars, params) {
    this._ensureCache(params);
    const c = this._cache;

    // ── Circuit schematic (y: 3 to 5.5) ──
    this._renderCircuit(canvas, params);

    // ── Readouts (y: 2 to 3) ──
    const M_pH = (params.k * Math.sqrt(params.La * params.Lb)).toFixed(1);
    canvas.text(-7.5, 2.5, 'DC: ' + c.dcGainDB.toFixed(2) + ' dB (' + c.dcGain.toFixed(4) + ')', '#94A3B8', 9);
    canvas.text(-7.5, 2.1, 'HF: ' + c.hfGainDB.toFixed(2) + ' dB (' + c.hfGain.toFixed(4) + ')', '#64748B', 8);
    canvas.text(-1, 2.5, 'BW(-3dB): ' + this._fmtFreq(c.bwFreq), '#22C55E', 9);
    canvas.text(-1, 2.1, 'Dip: ' + c.dipDB.toFixed(1) + ' dB @ ' + this._fmtFreq(c.dipFreq), '#F59E0B', 8);
    canvas.text(4.5, 2.5, 'M = ' + M_pH + ' pH', '#94A3B8', 8);
    canvas.text(4.5, 2.1, 't = ' + vars[0].toFixed(1) + ' ps  h(t) = ' + vars[1].toFixed(4), '#64748B', 8);

    // ── Bode magnitude plot (y: -5 to 1.5) ──
    this._renderBode(canvas, c, vars[2]);

    // ── Phasor dial (top-right) ──
    this._renderPhasor(canvas, vars[2], params);

    // ── Animated current flow on circuit wires ──
    this._renderCurrentFlow(canvas, vars[0], vars[2], params);
  },

  _fmtFreq(f) {
    if (f >= 1e12) return (f / 1e12).toFixed(2) + ' THz';
    if (f >= 1e9) return (f / 1e9).toFixed(1) + ' GHz';
    return f.toExponential(2) + ' Hz';
  },

  _renderCircuit(canvas, p) {
    const { R1, R2, Ra, Rb, La, Lb, k, Cb, Ce } = p;
    const ty = 4.8; // top wire y
    const by = 3.5; // bottom wire y
    const COL_WIRE = '#475569';
    const COL_R = '#F59E0B';
    const COL_L = '#06B6D4';
    const COL_C = '#8B5CF6';
    const COL_LBL = '#94A3B8';

    // V1
    canvas.text(-7.8, ty, 'V₁', '#22C55E', 10);
    canvas.line(-7.2, ty, -6, ty, COL_WIRE, 2);

    // R1 (zigzag)
    this._drawResH(canvas, -6, ty, -4.2, COL_R);
    canvas.text(-5.4, ty + 0.35, 'R₁=' + R1 + 'Ω', COL_R, 6.5);
    canvas.line(-4.2, ty, -3.5, ty, COL_WIRE, 2);

    // Node A
    canvas.circle(-3.5, ty, 0.05, '#CBD5E1', null);
    canvas.text(-3.8, ty + 0.3, 'A', COL_LBL, 7);

    // Top path: Cb bridge
    canvas.line(-3.5, ty, -0.25, ty, COL_WIRE, 2);
    // Capacitor Cb
    canvas.line(-0.1, ty - 0.22, -0.1, ty + 0.22, COL_C, 2.5);
    canvas.line(0.1, ty - 0.22, 0.1, ty + 0.22, COL_C, 2.5);
    canvas.text(-0.5, ty + 0.4, 'Cb=' + Cb + 'fF', COL_C, 6.5);
    canvas.line(0.25, ty, 3.5, ty, COL_WIRE, 2);

    // Node C
    canvas.circle(3.5, ty, 0.05, '#CBD5E1', null);
    canvas.text(3.6, ty + 0.3, 'C', COL_LBL, 7);

    // V2 label
    canvas.line(3.5, ty, 4.5, ty, COL_WIRE, 2);
    canvas.text(4.6, ty, 'V₂', '#22C55E', 10);

    // R2 (vertical)
    canvas.line(5.5, ty, 5.5, ty - 0.3, COL_WIRE, 2);
    this._drawResV(canvas, 5.5, ty - 0.3, ty - 1.1, COL_R);
    canvas.text(5.9, ty - 0.7, 'R₂=' + R2 + 'Ω', COL_R, 6.5);
    canvas.line(5.5, ty - 1.1, 5.5, ty - 1.5, COL_WIRE, 2);
    this._drawGnd(canvas, 5.5, ty - 1.5);

    // Wire down from A
    canvas.line(-3.5, ty, -3.5, by, COL_WIRE, 2);

    // La inductor (bumps) + Ra resistor
    this._drawInductorH(canvas, -3.5, by, -1.2, COL_L);
    canvas.text(-2.8, by + 0.35, 'La=' + La + 'pH', COL_L, 6.5);
    if (Ra > 0) {
      this._drawResH(canvas, -1.2, by, -0.3, COL_R);
      canvas.text(-1, by - 0.35, 'Ra=' + Ra + 'Ω', COL_R, 5.5);
      canvas.line(-0.3, by, 0, by, COL_WIRE, 2);
    } else {
      canvas.line(-1.2, by, 0, by, COL_WIRE, 2);
    }

    // Node B
    canvas.circle(0, by, 0.05, '#CBD5E1', null);
    canvas.text(-0.3, by - 0.35, 'B', COL_LBL, 7);

    // Lb inductor + Rb resistor
    if (Rb > 0) {
      canvas.line(0, by, 0.3, by, COL_WIRE, 2);
      this._drawResH(canvas, 0.3, by, 1.2, COL_R);
      canvas.text(0.5, by - 0.35, 'Rb=' + Rb + 'Ω', COL_R, 5.5);
      this._drawInductorH(canvas, 1.2, by, 3.5, COL_L);
    } else {
      this._drawInductorH(canvas, 0, by, 3.5, COL_L);
    }
    canvas.text(1.8, by + 0.35, 'Lb=' + Lb + 'pH', COL_L, 6.5);

    // Wire up from Lb to C
    canvas.line(3.5, by, 3.5, ty, COL_WIRE, 2);

    // Mutual inductance M (arc between La and Lb)
    canvas.text(-0.4, by + 0.7, '↕ k=' + k, COL_LBL, 6.5);

    // Ce (vertical capacitor from B to GND)
    canvas.line(0, by, 0, by - 0.5, COL_WIRE, 2);
    canvas.line(-0.22, by - 0.6, 0.22, by - 0.6, COL_C, 2.5);
    canvas.line(-0.22, by - 0.78, 0.22, by - 0.78, COL_C, 2.5);
    canvas.text(0.35, by - 0.7, 'Ce=' + Ce + 'fF', COL_C, 6.5);
    canvas.line(0, by - 0.78, 0, by - 1.1, COL_WIRE, 2);
    this._drawGnd(canvas, 0, by - 1.1);

    // V2 tap wire
    canvas.line(4.5, ty, 5.5, ty, COL_WIRE, 2);

    // Current arrows (text)
    canvas.text(-6.5, ty - 0.35, 'I₁→', '#10B981', 6.5);
    canvas.text(-2.5, by - 0.25, 'I₂→', '#10B981', 6);
    canvas.text(2, by - 0.25, '←I₃', '#10B981', 6);
  },

  /** Draw horizontal zigzag resistor */
  _drawResH(canvas, x1, y, x2, color) {
    const n = 3, w = x2 - x1;
    const lead = w * 0.12, segW = (w - 2 * lead) / (2 * n);
    const amp = 0.1;
    canvas.line(x1, y, x1 + lead, y, color, 2);
    let cx = x1 + lead;
    for (let i = 0; i < n; i++) {
      canvas.line(cx, y, cx + segW * 0.5, y + amp, color, 2);
      canvas.line(cx + segW * 0.5, y + amp, cx + segW * 1.5, y - amp, color, 2);
      canvas.line(cx + segW * 1.5, y - amp, cx + segW * 2, y, color, 2);
      cx += segW * 2;
    }
    canvas.line(cx, y, x2, y, color, 2);
  },

  /** Draw vertical zigzag resistor */
  _drawResV(canvas, x, y1, y2, color) {
    const n = 3, h = y1 - y2; // y1 > y2 (world coords, y up)
    const lead = h * 0.12, segH = (h - 2 * lead) / (2 * n);
    const amp = 0.08;
    canvas.line(x, y1, x, y1 - lead, color, 2);
    let cy = y1 - lead;
    for (let i = 0; i < n; i++) {
      canvas.line(x, cy, x + amp, cy - segH * 0.5, color, 2);
      canvas.line(x + amp, cy - segH * 0.5, x - amp, cy - segH * 1.5, color, 2);
      canvas.line(x - amp, cy - segH * 1.5, x, cy - segH * 2, color, 2);
      cy -= segH * 2;
    }
    canvas.line(x, cy, x, y2, color, 2);
  },

  /** Draw horizontal inductor bumps */
  _drawInductorH(canvas, x1, y, x2, color) {
    const bumps = 3;
    const w = x2 - x1;
    const lead = w * 0.08;
    const bumpW = (w - 2 * lead) / bumps;
    const r = bumpW / 2;
    canvas.line(x1, y, x1 + lead, y, color, 2);
    for (let i = 0; i < bumps; i++) {
      const cx = x1 + lead + bumpW * i + r;
      canvas.arc(cx, y, r, 0, Math.PI, color, 2);
    }
    canvas.line(x2 - lead, y, x2, y, color, 2);
  },

  /** Draw ground symbol */
  _drawGnd(canvas, x, y) {
    canvas.line(x - 0.2, y, x + 0.2, y, '#475569', 2);
    canvas.line(x - 0.13, y - 0.07, x + 0.13, y - 0.07, '#475569', 1.5);
    canvas.line(x - 0.06, y - 0.14, x + 0.06, y - 0.14, '#475569', 1);
  },

  /** Phasor dial: shows |H| and phase at the sweep frequency */
  _renderPhasor(canvas, sweepLogF, params) {
    const f = Math.pow(10, sweepLogF);
    const omega = 2 * Math.PI * f;
    const H = this._evalH(0, omega, params);
    const mag = Math.sqrt(H[0] * H[0] + H[1] * H[1]);
    const phase = Math.atan2(H[1], H[0]);

    // Dial center
    const cx = 6.8, cy = 5.2, R = 0.7;

    // Background circle
    canvas.circle(cx, cy, R, 'rgba(15,23,42,0.6)', '#334155');
    // Tick marks at 0°, 90°, 180°, 270°
    for (let a = 0; a < 4; a++) {
      const ang = a * Math.PI / 2;
      canvas.line(cx + R * 0.85 * Math.cos(ang), cy + R * 0.85 * Math.sin(ang),
                  cx + R * Math.cos(ang), cy + R * Math.sin(ang), '#475569', 1);
    }

    // Phasor arrow (length proportional to |H|, max |H| ≈ 0.5)
    const arrowLen = R * 0.8 * Math.min(mag / 0.55, 1);
    const ax = cx + arrowLen * Math.cos(phase);
    const ay = cy + arrowLen * Math.sin(phase);
    canvas.line(cx, cy, ax, ay, '#06B6D4', 2.5);
    canvas.circle(ax, ay, 0.05, '#06B6D4', null);

    // Labels
    canvas.text(cx - 0.6, cy - R - 0.2, '|H|=' + mag.toFixed(3), '#94A3B8', 6);
    canvas.text(cx - 0.6, cy - R - 0.45, 'φ=' + (phase * 180 / Math.PI).toFixed(1) + '°', '#64748B', 6);
  },

  /** Animated current flow dashes on circuit wires */
  _renderCurrentFlow(canvas, time, sweepLogF, params) {
    const f = Math.pow(10, sweepLogF);
    const omega = 2 * Math.PI * f;
    const H = this._evalH(0, omega, params);
    const mag = Math.sqrt(H[0] * H[0] + H[1] * H[1]);

    // Animation phase: use time to create moving dashes
    const phase = (time * 2) % 1; // cycles per ps
    const brightness = Math.max(0.15, mag * 1.5);
    const color = 'rgba(16,185,129,' + brightness.toFixed(2) + ')';

    const ty = 4.8, by = 3.5;
    const dashLen = 0.3, gap = 0.4;
    const period = dashLen + gap;

    // Helper: draw moving dashes along a horizontal segment
    const dashH = (x1, x2, y, dir) => {
      const offset = (phase * period * dir + 100 * period) % period;
      for (let x = x1 + offset - period; x < x2; x += period) {
        const dx1 = Math.max(x, x1);
        const dx2 = Math.min(x + dashLen, x2);
        if (dx2 > dx1) canvas.line(dx1, y, dx2, y, color, 1.5);
      }
    };

    // Helper: draw moving dashes along a vertical segment
    const dashV = (x, y1, y2, dir) => {
      const offset = (phase * period * dir + 100 * period) % period;
      const yMin = Math.min(y1, y2), yMax = Math.max(y1, y2);
      for (let y = yMin + offset - period; y < yMax; y += period) {
        const dy1 = Math.max(y, yMin);
        const dy2 = Math.min(y + dashLen, yMax);
        if (dy2 > dy1) canvas.line(x, dy1, x, dy2, color, 1.5);
      }
    };

    // I1 path: V1 → R1 → Node A → Cb → Node C → V2
    dashH(-7.2, -3.5, ty, 1);  // V1 to Node A
    dashH(-3.5, 3.5, ty, 1);   // Top bridge (through Cb)
    dashH(3.5, 5.5, ty, 1);    // Node C to R2

    // I2 path: Node A → down → La+Ra → Node B
    dashV(-3.5, ty, by, -1);   // down from A
    dashH(-3.5, 0, by, 1);     // La+Ra to B

    // I3 path: Node B → Lb+Rb → up → Node C
    dashH(0, 3.5, by, 1);      // B to right
    dashV(3.5, by, ty, 1);     // up to C

    // Ce path: Node B → down to GND
    dashV(0, by, by - 1.1, -1);

    // R2 path: down to GND
    dashV(5.5, ty, ty - 1.5, -1);
  },

  _renderBode(canvas, c, sweepLogF) {
    // Plot area
    const px1 = -6.5, px2 = 6.5, py1 = -5, py2 = 1.5;
    const logFMin = 9, logFMax = 14.5;
    const dbMin = -18, dbMax = 2;

    const mapX = (logF) => px1 + (logF - logFMin) / (logFMax - logFMin) * (px2 - px1);
    const mapY = (db) => py1 + (db - dbMin) / (dbMax - dbMin) * (py2 - py1);

    // Background
    canvas.polygon([[px1, py1], [px2, py1], [px2, py2], [px1, py2]], 'rgba(15,23,42,0.4)', null);

    // Grid
    for (let lf = 9; lf <= 14; lf++) {
      const x = mapX(lf);
      canvas.line(x, py1, x, py2, '#1E293B', 0.8);
      const f = Math.pow(10, lf);
      const label = lf < 12 ? (f / 1e9).toFixed(0) + 'G' : (f / 1e12).toFixed(0) + 'T';
      canvas.text(x - 0.3, py1 - 0.25, label, '#64748B', 6);
    }
    for (let db = -18; db <= 0; db += 3) {
      const y = mapY(db);
      canvas.line(px1, y, px2, y, '#1E293B', 0.8);
      canvas.text(px1 - 0.8, y, db + '', '#64748B', 6);
    }

    // Axes
    canvas.line(px1, py1, px2, py1, '#475569', 1.5);
    canvas.line(px1, py1, px1, py2, '#475569', 1.5);

    // DC gain line
    const dcY = mapY(c.dcGainDB);
    for (let x = px1; x < px2; x += 0.4) {
      canvas.line(x, dcY, Math.min(x + 0.2, px2), dcY, '#22C55E', 0.8);
    }

    // −3dB threshold line
    const bwY = mapY(c.dcGainDB - 3);
    for (let x = px1; x < px2; x += 0.4) {
      canvas.line(x, bwY, Math.min(x + 0.2, px2), bwY, '#F59E0B', 0.7);
    }

    // Ideal curve (if available) — draw all segments, clamp y to plot bounds
    const clampY = (v) => Math.max(py1, Math.min(py2, v));
    if (c.bodeIdeal) {
      for (let i = 1; i < c.freqs.length; i++) {
        const x1 = mapX(Math.log10(c.freqs[i - 1]));
        const y1 = clampY(mapY(c.bodeIdeal[i - 1]));
        const x2 = mapX(Math.log10(c.freqs[i]));
        const y2 = clampY(mapY(c.bodeIdeal[i]));
        canvas.line(x1, y1, x2, y2, '#EF4444', 1.5);
      }
    }

    // Main magnitude curve — clamp y so deep dips don't leave gaps
    for (let i = 1; i < c.freqs.length; i++) {
      const x1 = mapX(Math.log10(c.freqs[i - 1]));
      const y1 = clampY(mapY(c.magDB[i - 1]));
      const x2 = mapX(Math.log10(c.freqs[i]));
      const y2 = clampY(mapY(c.magDB[i]));
      canvas.line(x1, y1, x2, y2, '#06B6D4', 2);
    }

    // Bandwidth marker
    const bwX = mapX(Math.log10(c.bwFreq));
    if (bwX >= px1 && bwX <= px2) {
      canvas.circle(bwX, bwY, 0.08, '#F59E0B', null);
    }

    // Dip marker
    const dipX = mapX(Math.log10(c.dipFreq));
    const dipY = mapY(c.dipDB);
    if (dipX >= px1 && dipX <= px2 && dipY >= py1 && dipY <= py2) {
      canvas.circle(dipX, dipY, 0.08, '#EF4444', null);
    }

    // ── Animated sweep marker ──
    if (sweepLogF >= logFMin && sweepLogF <= logFMax) {
      const sx = mapX(sweepLogF);
      // Vertical scan line
      canvas.line(sx, py1, sx, py2, 'rgba(255,255,255,0.12)', 1);
      // Interpolate magnitude at sweep frequency
      const sweepF = Math.pow(10, sweepLogF);
      let sweepDB = c.magDB[0];
      for (let i = 1; i < c.freqs.length; i++) {
        if (c.freqs[i] >= sweepF) {
          // Interpolate in log-frequency space (data is log-uniform)
          const logF0 = Math.log10(c.freqs[i - 1]);
          const logF1 = Math.log10(c.freqs[i]);
          const t = (sweepLogF - logF0) / (logF1 - logF0);
          sweepDB = c.magDB[i - 1] + t * (c.magDB[i] - c.magDB[i - 1]);
          break;
        }
      }
      const sy = mapY(sweepDB);
      // Glowing dot
      canvas.circle(sx, sy, 0.18, 'rgba(6,182,212,0.3)', null);
      canvas.circle(sx, sy, 0.1, '#06B6D4', '#FFF');
      // Frequency label at dot
      canvas.text(sx + 0.2, sy + 0.35, this._fmtFreq(sweepF), '#FFF', 7);
      canvas.text(sx + 0.2, sy + 0.05, sweepDB.toFixed(1) + ' dB', '#06B6D4', 7);
    }

    // Labels
    canvas.text(-1, py2 + 0.25, 'Magnitude Response (dB)', '#94A3B8', 9);
    canvas.text(0.5, py1 - 0.25, 'Frequency (Hz)', '#64748B', 7);
    canvas.text(px1 - 1.3, (py1 + py2) / 2, 'dB', '#64748B', 7);

    // Legend
    canvas.text(px2 - 3.5, py2 - 0.15, '── With parasitics', '#06B6D4', 6.5);
    if (c.bodeIdeal) {
      canvas.text(px2 - 3.5, py2 - 0.45, '── Without parasitics', '#EF4444', 6.5);
    }
    canvas.text(px2 - 3.5, py2 - 0.75, '--- DC gain', '#22C55E', 6.5);
    canvas.text(px2 - 3.5, py2 - 1.05, '--- −3dB threshold', '#F59E0B', 6.5);
  },

  info: `
    <h2>T-Coil Circuit — Transfer Function Analysis</h2>
    <p>The <strong>bridged T-coil</strong> extends signal bandwidth beyond what simple inductive peaking achieves.
    It consists of two mutually coupled inductors (L<sub>a</sub>, L<sub>b</sub>) and a bridge capacitor (C<sub>b</sub>),
    connecting a source resistor R<sub>1</sub> to a load R<sub>2</sub> with parasitic capacitance C<sub>e</sub>.</p>

    <h3>How It Works</h3>
    <p>At <strong>low frequencies</strong>, inductors are shorts and capacitors are open. The signal passes through
    L<sub>a</sub> and L<sub>b</sub>, giving gain H(0) = R<sub>2</sub>/(R<sub>1</sub>+R<sub>a</sub>+R<sub>b</sub>+R<sub>2</sub>).</p>
    <p>At <strong>high frequencies</strong>, inductors open and capacitors short. The signal bypasses the inductors
    entirely through C<sub>b</sub>, giving gain H(&infin;) = R<sub>2</sub>/(R<sub>1</sub>+R<sub>2</sub>).</p>
    <p>The T-coil maintains nearly flat response across a wide bandwidth by providing two parallel signal paths
    that complement each other: the inductive path for low frequencies and the capacitive bridge for high frequencies.</p>

    <h3>Circuit Equations (Laplace Domain)</h3>
    <p>Applying Kirchhoff's voltage and current laws:</p>
    <pre>
    V₁ = R₁·I₁ + (I₁−I₂)/(C_b·s) + V₂
    V₁ = R₁·I₁ + (R_a+L_a·s)·I₂ + M·s·I₃ + (I₂−I₃)/(C_e·s)
    V₂ = R₂·(I₁−I₂+I₃)
    V₂ = (I₂−I₃)/(C_e·s) − (R_b+L_b·s)·I₃ − M·s·I₂
    </pre>
    <p>where M = k·&radic;(L<sub>a</sub>·L<sub>b</sub>) is the mutual inductance.</p>

    <h3>Transfer Function</h3>
    <p>Solving these 4 equations for H(s) = V₂/V₁ yields a 4th-order rational function.
    The <strong>Bode plot</strong> shows |H(j&omega;)| vs frequency. Key features:</p>
    <ul>
      <li><strong style="color:#22C55E;">DC gain:</strong> R₂/(R₁+R_a+R_b+R₂). With default params: &approx; −6.5 dB.</li>
      <li><strong style="color:#F59E0B;">−3dB bandwidth:</strong> where the response drops 3 dB below DC. The T-coil extends this significantly compared to a direct R-C connection.</li>
      <li><strong style="color:#EF4444;">Dip:</strong> minimum attenuation, typically around 10¹³ Hz for these component values.</li>
    </ul>

    <h3>Step Response</h3>
    <p>The <strong>Time</strong> tab shows the step response computed via numerical inverse Laplace transform
    (Talbot method). At t=0, the output jumps to R₂/(R₁+R₂) = 0.5 (high-frequency feedthrough through C<sub>b</sub>),
    then settles to the DC gain over ~20−30 ps. The settling shape depends on the pole locations (damping).</p>

    <h3>Effect of Parasitic Resistances</h3>
    <p>Toggle <strong>"Compare: No Parasitics"</strong> to overlay the ideal (R<sub>a</sub>=R<sub>b</sub>=0) response in red.
    Parasitics reduce DC gain (since R<sub>a</sub>+R<sub>b</sub> add to the voltage divider) and slightly shift the
    bandwidth and dip frequency.</p>

    <h3>Try These</h3>
    <ol>
      <li><strong>Coupling coefficient k:</strong> Increase to 0.8 — stronger coupling changes the dip shape and can improve flatness. Decrease to 0.1 — the T-coil effect weakens.</li>
      <li><strong>Bridge capacitor C<sub>b</sub>:</strong> Increase to 50 fF — notice how the dip moves and the high-frequency path changes. Very small C<sub>b</sub> reduces the bridging effect.</li>
      <li><strong>Load capacitance C<sub>e</sub>:</strong> Increase to 800 fF — heavier load narrows bandwidth. The T-coil's job is to compensate for exactly this.</li>
      <li><strong>Symmetric coils:</strong> Set L<sub>a</sub>=L<sub>b</sub>=300 pH — see how balance affects the response.</li>
      <li><strong>Remove parasitics:</strong> Set R<sub>a</sub>=R<sub>b</sub>=0 — DC gain rises to exactly −6.02 dB and the response becomes more symmetric.</li>
    </ol>
  `,
};
