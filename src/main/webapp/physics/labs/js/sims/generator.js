/**
 * AC Generator — Electromagnetic Induction
 *
 * A rectangular coil rotating in a uniform magnetic field.
 *
 * Faraday's Law:
 *   Φ = N·B·A·cos(θ)          (magnetic flux)
 *   EMF = -dΦ/dt = N·B·A·ω·sin(θ)  (induced voltage)
 *   I = EMF / R                (current through load)
 *   P = EMF² / R              (power delivered)
 *
 * Peak EMF: ε₀ = N·B·A·ω = N·B·A·(2π·RPM/60)
 *
 * With commutator (DC mode): EMF_dc = |EMF|
 *
 * State: [θ, time, Φ, EMF, I, P]
 */

export const GeneratorSim = {
  name: 'AC Generator',
  slug: 'generator',
  category: 'Electromagnetism',

  vars: {
    theta: { index: 0, label: 'Coil Angle θ (rad)',   symbol: 'θ' },
    time:  { index: 1, label: 'Time (s)',              symbol: 't' },
    flux:  { index: 2, label: 'Magnetic Flux Φ (Wb)',  symbol: 'Φ' },
    emf:   { index: 3, label: 'EMF ε (V)',             symbol: 'ε' },
    current:{ index: 4, label: 'Current I (A)',        symbol: 'I' },
    power: { index: 5, label: 'Power P (W)',           symbol: 'P' },
  },
  varCount: 6,

  params: {
    fieldB:    { value: 0.5,  min: 0.05, max: 2,    step: 0.05, label: 'Field B',       unit: 'T' },
    turns:     { value: 100,  min: 1,    max: 500,   step: 1,    label: 'Turns N',       unit: '' },
    coilArea:  { value: 0.01, min: 0.001, max: 0.1,  step: 0.001,label: 'Coil Area A',  unit: 'm²' },
    rpm:       { value: 60,   min: 5,    max: 3000,  step: 5,    label: 'Speed',         unit: 'RPM' },
    loadR:     { value: 10,   min: 0.5,  max: 1000,  step: 0.5,  label: 'Load R',        unit: 'Ω' },
    commutator:{ value: false, type: 'bool',                      label: 'DC Commutator' },
  },

  views: ['sim', 'phase', 'time'],

  graphDefaults: {
    phase: { x: 'flux', y: 'emf' },
    time: ['flux', 'emf', 'current'],
  },

  worldRect: { xMin: -3.2, xMax: 3.2, yMin: -2.4, yMax: 2.4 },

  presets: [
    { name: 'Default (1 Hz, 3.1 V peak)',   params: {} },
    { name: 'Slow (10 RPM)',                  params: { rpm: 10 } },
    { name: 'Fast (600 RPM)',                 params: { rpm: 600 } },
    { name: 'Strong Field (B=1.5T)',          params: { fieldB: 1.5 } },
    { name: 'Many Turns (N=500)',             params: { turns: 500 } },
    { name: 'DC with Commutator',             params: { commutator: true } },
    { name: 'High Power (large A)',           params: { coilArea: 0.05, turns: 200 } },
    { name: 'Low Resistance (R=1Ω)',          params: { loadR: 1 } },
  ],

  init() {
    return [0, 0, 0, 0, 0, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[1] = 1;
    for (let i = 2; i < 6; i++) change[i] = 0;
    if (isDragging) { change[0] = 0; return; }
    change[0] = params.rpm * 2 * Math.PI / 60;
  },

  postStep(vars, params) {
    const theta = vars[0];
    const { fieldB: B, turns: N, coilArea: A, rpm, loadR: R, commutator } = params;
    const omega = rpm * 2 * Math.PI / 60;

    vars[2] = N * B * A * Math.cos(theta);
    let emf = N * B * A * omega * Math.sin(theta);
    if (commutator) emf = Math.abs(emf);
    vars[3] = emf;
    vars[4] = emf / R;
    vars[5] = emf * emf / R;
  },

  energy(vars) {
    return { kinetic: 0, potential: 0, total: Math.abs(vars[5]) };
  },

  theoreticalPeriod(params) {
    return 60 / params.rpm;
  },
  periodVar: 3,

  hitTest(wx, wy, vars) {
    // Drag the coil to set angle (circular motion around coil center)
    const cy = 0.3;
    if (Math.abs(wx) < 1.5 && Math.abs(wy - cy) < 1.0) {
      return { id: 'coil', startAngle: vars[0], startMX: wx, startMY: wy - cy };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars) {
    if (id === 'coil') {
      // Full 360° rotation: angle from mouse position relative to coil center
      const cy = 0.3;
      vars[0] = Math.atan2(wx, wy - cy);
    }
  },

  onRelease() {},

  render(canvas, vars, params) {
    const theta = vars[0];
    const { fieldB: B, turns: N, coilArea: A, rpm, loadR: R, commutator } = params;
    const omega = rpm * 2 * Math.PI / 60;
    const emfVal = vars[3];
    const fluxVal = vars[2];
    const curVal = vars[4];
    const peakEMF = N * B * A * omega;
    const t = vars[1];

    // ── Magnets ──
    canvas.rect(-2.8, -0.6, 0.6, 1.8, '#DC2626', null); // N pole (red)
    canvas.text(-2.65, 0.3, 'N', '#FFF', 14);
    canvas.rect(2.2, -0.6, 0.6, 1.8, '#2563EB', null);  // S pole (blue)
    canvas.text(2.35, 0.3, 'S', '#FFF', 14);

    // ── Field lines (B arrows) ──
    for (let fy = -0.3; fy <= 0.9; fy += 0.3) {
      canvas.line(-2.15, fy, 2.15, fy, 'rgba(239,68,68,0.2)', 1);
      // Arrowheads at center
      canvas.line(0.1, fy, 0, fy + 0.04, 'rgba(239,68,68,0.3)', 1);
      canvas.line(0.1, fy, 0, fy - 0.04, 'rgba(239,68,68,0.3)', 1);
    }
    canvas.text(-0.3, 1.05, 'B →', '#EF4444', 9);

    // ── Rotating coil (projected rectangle) ──
    const cw = 0.9;  // visual half-width
    const ch = 0.65; // visual half-height
    const cy = 0.3;  // coil center y
    const projW = cw * Math.cos(theta);

    // Coil shading (flux indicator)
    const fluxFrac = Math.abs(Math.cos(theta));
    if (Math.abs(projW) > 0.02) {
      canvas.polygon([
        [-projW, cy - ch], [projW, cy - ch],
        [projW, cy + ch], [-projW, cy + ch],
      ], 'rgba(34,197,94,' + (fluxFrac * 0.15).toFixed(2) + ')', null);
    }

    // Current direction on active sides
    const curDir = emfVal > 0.001 ? 1 : emfVal < -0.001 ? -1 : 0;
    const activeColor = curDir > 0 ? '#EF4444' : curDir < 0 ? '#3B82F6' : '#64748B';
    const activeColor2 = curDir > 0 ? '#3B82F6' : curDir < 0 ? '#EF4444' : '#64748B';

    // Draw coil edges
    const lx = -projW, rx = projW;
    const ty = cy + ch, by = cy - ch;
    canvas.line(lx, ty, rx, ty, '#94A3B8', 2.5); // top edge
    canvas.line(lx, by, rx, by, '#94A3B8', 2.5); // bottom edge
    canvas.line(lx, ty, lx, by, activeColor, 3.5); // left active side
    canvas.line(rx, ty, rx, by, activeColor2, 3.5); // right active side

    // Current arrows on active sides
    if (curDir !== 0) {
      const arrY1 = cy - 0.15, arrY2 = cy + 0.15;
      const d = curDir * 0.08;
      // Left side arrow
      canvas.line(lx, arrY1, lx, arrY2, activeColor, 2);
      canvas.line(lx, arrY2, lx - 0.04, arrY2 - d, activeColor, 2);
      canvas.line(lx, arrY2, lx + 0.04, arrY2 - d, activeColor, 2);
      // Right side arrow (opposite direction)
      canvas.line(rx, arrY2, rx, arrY1, activeColor2, 2);
      canvas.line(rx, arrY1, rx - 0.04, arrY1 + d, activeColor2, 2);
      canvas.line(rx, arrY1, rx + 0.04, arrY1 + d, activeColor2, 2);
    }

    // ── Coil normal vector (flux direction) ──
    // Normal is perpendicular to coil face; at θ=0 it aligns with B (horizontal)
    const nx = 0.6 * Math.cos(theta);
    const ny = 0.6 * Math.sin(theta);
    canvas.line(0, cy, nx, cy + ny, '#22C55E', 2.5);
    // Arrowhead
    const nLen = 0.6;
    const cosT = Math.cos(theta), sinT = Math.sin(theta);
    canvas.line(nx, cy + ny, nx - cosT * 0.08 + sinT * 0.05, cy + ny - sinT * 0.08 - cosT * 0.05, '#22C55E', 2);
    canvas.line(nx, cy + ny, nx - cosT * 0.08 - sinT * 0.05, cy + ny - sinT * 0.08 + cosT * 0.05, '#22C55E', 2);
    canvas.text(nx + 0.1, cy + ny + 0.1, 'n̂', '#22C55E', 9);

    // ── Angle arc ──
    if (Math.abs(theta % Math.PI) > 0.05) {
      const arcR = 0.3;
      const a1 = Math.PI / 2; // x-direction in canvas (B direction)... actually 0 is right
      // The normal direction angle from x-axis = pi/2 - theta (since normal is sin(theta) in x)
      // In canvas world coords: angle 0 = right. Normal vector has angle = atan2(0, sin(theta))
      // Simplify: just show the angle between B (horizontal) and the normal
      canvas.arc(0, cy, arcR, 0, Math.min(Math.abs(theta), Math.PI/2) * Math.sign(theta),
        'rgba(139,92,246,0.6)', 1.5);
      canvas.text(0.35, cy + 0.15, 'θ', '#8B5CF6', 10);
    }

    // ── Rotation axis ──
    canvas.line(0, cy + ch + 0.15, 0, cy - ch - 0.15, '#475569', 1);
    canvas.circle(0, cy + ch + 0.15, 0.03, '#475569', null);
    canvas.circle(0, cy - ch - 0.15, 0.03, '#475569', null);

    // ── Slip rings / Commutator ──
    const sry = cy - ch - 0.35;
    if (commutator) {
      // Split ring
      canvas.arc(0, sry, 0.1, 0, Math.PI, '#F59E0B', 2.5);
      canvas.arc(0, sry, 0.1, Math.PI, 2 * Math.PI, '#06B6D4', 2.5);
      canvas.text(0.2, sry, 'Commutator', '#F59E0B', 7);
    } else {
      canvas.circle(0, sry - 0.04, 0.06, null, '#F59E0B');
      canvas.circle(0, sry + 0.04, 0.06, null, '#06B6D4');
      canvas.text(0.2, sry, 'Slip Rings', '#94A3B8', 7);
    }
    // Brushes
    canvas.rect(-0.18, sry - 0.03, 0.06, 0.06, '#94A3B8', null);
    canvas.rect(0.12, sry - 0.03, 0.06, 0.06, '#94A3B8', null);

    // ── External circuit (simple R load) ──
    const ey = sry - 0.2;
    canvas.line(-0.15, sry, -0.15, ey, '#64748B', 1.5);
    canvas.line(0.15, sry, 0.15, ey, '#64748B', 1.5);
    canvas.line(-0.15, ey, -0.5, ey, '#64748B', 1.5);
    canvas.line(0.15, ey, 0.5, ey, '#64748B', 1.5);
    // Resistor
    canvas.rect(-0.5, ey - 0.06, 1.0, 0.12, '#1E293B', '#F59E0B');
    canvas.text(-0.2, ey, 'R=' + R + 'Ω', '#F59E0B', 7);

    // ── Mini waveform (bottom of canvas) ──
    const wfLeft = -2.8, wfRight = 2.8, wfBot = -2.2, wfTop = -1.2;
    const wfMid = (wfBot + wfTop) / 2;
    // Background
    canvas.polygon([[wfLeft, wfBot], [wfRight, wfBot],
                    [wfRight, wfTop], [wfLeft, wfTop]], 'rgba(15,23,42,0.5)', '#334155');
    // Zero line
    canvas.line(wfLeft, wfMid, wfRight, wfMid, '#334155', 1);
    // Draw 2 periods of the waveform analytically
    const period = 60 / rpm;
    const tWindow = period * 2.5;
    const tStart = Math.max(0, t - tWindow);
    const wfW = wfRight - wfLeft;
    const wfH = (wfTop - wfBot) / 2 * 0.85;
    const ampNorm = peakEMF > 0.001 ? peakEMF : 1;
    const nPts = 200;
    for (let i = 1; i < nPts; i++) {
      const t1 = tStart + tWindow * (i - 1) / nPts;
      const t2 = tStart + tWindow * i / nPts;
      let e1 = Math.sin(omega * t1);
      let e2 = Math.sin(omega * t2);
      if (commutator) { e1 = Math.abs(e1); e2 = Math.abs(e2); }
      const x1 = wfLeft + wfW * (i - 1) / nPts;
      const x2 = wfLeft + wfW * i / nPts;
      const y1 = wfMid + e1 * wfH;
      const y2 = wfMid + e2 * wfH;
      canvas.line(x1, y1, x2, y2, '#06B6D4', 1.5);
    }
    // Current time marker (uses actual EMF from state, not analytical formula)
    const tFrac = (t - tStart) / tWindow;
    if (tFrac >= 0 && tFrac <= 1) {
      const mx = wfLeft + tFrac * wfW;
      const meNorm = peakEMF > 0.001 ? emfVal / peakEMF : 0;
      canvas.circle(mx, wfMid + meNorm * wfH, 0.05, '#F59E0B', '#FFF');
    }
    // Waveform labels
    canvas.text(wfLeft + 0.05, wfTop - 0.05, commutator ? 'DC Output' : 'AC Output', '#94A3B8', 9);
    canvas.text(wfRight - 0.6, wfTop - 0.05,
      (commutator ? '0–' : '±') + peakEMF.toFixed(1) + 'V', '#06B6D4', 8);

    // ── Readouts ──
    canvas.text(-3.1, 2.2, 'EMF = ' + emfVal.toFixed(2) + ' V', '#94A3B8', 12);
    canvas.text(-3.1, 1.9, 'I = ' + (curVal * 1000).toFixed(1) + ' mA', '#64748B', 10);
    canvas.text(-3.1, 1.65, 'Φ = ' + (fluxVal * 1000).toFixed(2) + ' mWb', '#22C55E', 10);

    canvas.text(1.0, 2.2, 'Peak: ' + peakEMF.toFixed(2) + ' V', '#F59E0B', 11);
    canvas.text(1.0, 1.9, 'f = ' + (rpm / 60).toFixed(1) + ' Hz', '#64748B', 10);
    canvas.text(1.0, 1.65, 'P = ' + (vars[5] * 1000).toFixed(1) + ' mW', '#64748B', 10);

    const degStr = (((theta * 180 / Math.PI) % 360 + 360) % 360).toFixed(0);
    canvas.text(1.0, 1.4, 'θ = ' + degStr + '°', '#8B5CF6', 10);
  },

  info: `
    <h2>AC Generator — Electromagnetic Induction</h2>
    <p>A rectangular coil with N turns rotates at constant angular speed ω in a uniform magnetic field B.
    The changing flux through the coil induces an alternating voltage (EMF) by <strong>Faraday's Law</strong>.</p>

    <h3>Faraday's Law</h3>
    <p><code>EMF = −dΦ/dt</code></p>
    <p>The magnetic flux through the coil is <code>Φ = N·B·A·cos(θ)</code>, where θ is the angle between the
    coil's normal vector and the field direction. As the coil rotates, Φ changes sinusoidally, inducing:</p>
    <p><code>EMF = N·B·A·ω·sin(θ)</code></p>

    <h3>Peak EMF</h3>
    <p><code>ε₀ = N·B·A·ω = N·B·A·(2π·RPM/60)</code></p>
    <p>The peak voltage depends on the number of turns, field strength, coil area, and rotation speed.
    Doubling any one of these doubles the peak EMF.</p>

    <h3>Phase Relationship</h3>
    <p>The flux Φ and EMF are <strong>90° out of phase</strong>:</p>
    <ul>
      <li>When Φ is maximum (coil face perpendicular to B, θ=0°): EMF = 0 (flux isn't changing)</li>
      <li>When Φ is zero (coil edge-on to B, θ=90°): EMF is maximum (flux changing fastest)</li>
    </ul>
    <p>The <strong>Phase tab</strong> shows this as an ellipse (Φ vs EMF).</p>

    <h3>Visualization</h3>
    <ul>
      <li><strong style="color:#EF4444;">Red/</strong><strong style="color:#3B82F6;">Blue sides:</strong> Current direction in the active coil edges — reverses each half cycle</li>
      <li><strong style="color:#22C55E;">Green arrow (n̂):</strong> Coil normal vector — when aligned with B, flux is maximum</li>
      <li><strong>Green shading:</strong> Flux through the coil — brightest when coil faces the field</li>
      <li><strong>Bottom waveform:</strong> EMF output in real time with a tracking dot</li>
    </ul>

    <h3>DC Commutator</h3>
    <p>Toggle <strong>DC Commutator</strong> to add a split-ring commutator that rectifies the output.
    The EMF becomes |ε₀·sin(θ)| — always positive, producing pulsating DC. Compare the waveforms.</p>

    <h3>Try These</h3>
    <ol>
      <li><strong>Drag the coil:</strong> Rotate it manually and watch EMF change. At θ=0° (max flux), EMF=0. At θ=90° (zero flux), EMF is maximum.</li>
      <li><strong>Double the speed:</strong> Increase RPM from 60 to 120. Peak EMF doubles (ε₀ ∝ ω).</li>
      <li><strong>Double the turns:</strong> Change N from 100 to 200. Peak EMF doubles (ε₀ ∝ N).</li>
      <li><strong>Phase tab:</strong> The Φ-vs-EMF plot is an ellipse. Its tilt and shape show the 90° phase relationship.</li>
      <li><strong>Commutator:</strong> Toggle DC mode. The waveform becomes rectified — all positive pulses.</li>
      <li><strong>Power:</strong> With R=1Ω and high N or B, watch the power readout grow. P = EMF²/R.</li>
    </ol>
  `,
};
