/**
 * AC/DC Generator & Motor — Electromagnetic Induction
 *
 * A rectangular coil rotating in a uniform magnetic field.
 *
 * Generator mode (constant ω):
 *   Φ = N·B·A·cos(θ)                    (magnetic flux)
 *   EMF = N·B·A·ω·sin(θ)                (Faraday's law)
 *   RL load: L·dI/dt + R·I = EMF        (current dynamics)
 *   Torque required: τ = N·B·I·A·sin(θ) (mechanical input)
 *
 * Motor mode (driven by DC voltage):
 *   back_EMF = N·B·A·ω·|sin(θ)|         (rectified by commutator)
 *   V_dc = R·I + L·dI/dt + back_EMF     (circuit equation)
 *   τ = N·B·I·A·|sin(θ)|                (electromagnetic torque)
 *   J·dω/dt = τ - b·ω                   (angular dynamics)
 *
 * 3-phase: three coils offset by 120°.
 *
 * State: [θ, ω, time, I1, I2, I3, Φ, EMF1, EMF2, EMF3, torque, P]
 */

export const GeneratorSim = {
  name: 'AC Generator & Motor',
  slug: 'generator',
  category: 'Electromagnetism',

  vars: {
    theta:  { index: 0,  label: 'Coil Angle θ (rad)',     symbol: 'θ' },
    omega:  { index: 1,  label: 'Angular Speed ω (rad/s)', symbol: 'ω' },
    time:   { index: 2,  label: 'Time (s)',                symbol: 't' },
    I1:     { index: 3,  label: 'Current I₁ (A)',          symbol: 'I₁' },
    I2:     { index: 4,  label: 'Current I₂ (A)',          symbol: 'I₂' },
    I3:     { index: 5,  label: 'Current I₃ (A)',          symbol: 'I₃' },
    flux:   { index: 6,  label: 'Flux Φ₁ (Wb)',            symbol: 'Φ' },
    emf1:   { index: 7,  label: 'EMF ε₁ (V)',              symbol: 'ε₁' },
    emf2:   { index: 8,  label: 'EMF ε₂ (V)',              symbol: 'ε₂' },
    emf3:   { index: 9,  label: 'EMF ε₃ (V)',              symbol: 'ε₃' },
    torque: { index: 10, label: 'Torque τ (N·m)',          symbol: 'τ' },
    power:  { index: 11, label: 'Power P (W)',             symbol: 'P' },
  },
  varCount: 12,

  params: {
    fieldB:    { value: 0.5,   min: 0.05, max: 2,     step: 0.05, label: 'Field B',         unit: 'T' },
    turns:     { value: 100,   min: 1,    max: 500,    step: 1,    label: 'Turns N',         unit: '' },
    coilArea:  { value: 0.01,  min: 0.001, max: 0.1,   step: 0.001,label: 'Coil Area A',    unit: 'm²' },
    rpm:       { value: 60,    min: 5,    max: 3000,   step: 5,    label: 'Speed (gen)',     unit: 'RPM' },
    loadR:     { value: 10,    min: 0.5,  max: 1000,   step: 0.5,  label: 'Load R',          unit: 'Ω' },
    loadL:     { value: 0,     min: 0,    max: 0.5,    step: 0.01, label: 'Load L',          unit: 'H' },
    phases:    { value: 1,     min: 1,    max: 3,      step: 2,    label: 'Phases (1 or 3)', unit: '' },
    commutator:{ value: false, type: 'bool',                        label: 'DC Commutator' },
    mode:      { value: 0,     min: 0,    max: 1,      step: 1,    label: 'Mode (0=Gen 1=Motor)', unit: '' },
    motorV:    { value: 5,     min: 0,    max: 50,     step: 0.5,  label: 'Motor Voltage',   unit: 'V' },
    motorJ:    { value: 0.01,  min: 0.001, max: 0.1,   step: 0.001,label: 'Rotor Inertia J', unit: 'kg·m²' },
    motorFric: { value: 0.005, min: 0,    max: 0.05,   step: 0.001,label: 'Motor Friction',  unit: 'N·m·s' },
  },

  views: ['sim', 'phase', 'time'],

  graphDefaults: {
    phase: { x: 'flux', y: 'emf1' },
    time: ['emf1', 'I1', 'torque'],
  },

  worldRect: { xMin: -3.2, xMax: 3.2, yMin: -2.4, yMax: 2.4 },

  presets: [
    { name: 'Default AC (1 Hz)',              params: {} },
    { name: 'DC with Commutator',             params: { commutator: true } },
    { name: '3-Phase Generator',              params: { phases: 3 } },
    { name: 'RL Load (L=0.1H)',               params: { loadL: 0.1 } },
    { name: 'DC Motor',                       params: { mode: 1, motorV: 5, commutator: true } },
    { name: 'Motor — Heavy Load',             params: { mode: 1, motorV: 5, commutator: true, motorFric: 0.02 } },
    { name: 'Fast Generator (600 RPM)',        params: { rpm: 600 } },
    { name: 'Strong Field (B=1.5T)',           params: { fieldB: 1.5 } },
    { name: '3-Phase + RL Load',              params: { phases: 3, loadL: 0.05 } },
    { name: 'Low R High Power',               params: { loadR: 1, turns: 200 } },
  ],

  init(params) {
    const omega = (params?.rpm ?? 60) * 2 * Math.PI / 60;
    // Motor starts at small angle offset to avoid dead spot (sin(0)=0 → zero torque)
    const theta0 = (params?.mode ?? 0) === 1 ? 0.3 : 0;
    return [theta0, (params?.mode ?? 0) === 1 ? 0 : omega, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[2] = 1; // time
    for (let i = 6; i < 12; i++) change[i] = 0; // derived in postStep
    if (isDragging) { change[0] = 0; change[1] = 0; change[3] = change[4] = change[5] = 0; return; }

    const [theta, omega, , I1, I2, I3] = vars;
    const { fieldB: B, turns: N, coilArea: A, rpm, loadR: R, loadL: L,
            phases, commutator, mode, motorV, motorJ: J, motorFric: bf } = params;

    const NBA = N * B * A;
    const sinT = Math.sin(theta);
    const Leff = Math.max(L, 0.0001); // floor to avoid div-by-zero

    change[0] = omega; // dθ/dt = ω

    if (mode === 0) {
      // ── Generator: constant angular velocity ──
      change[1] = 0;
      // EMF for each phase
      const emf1 = NBA * omega * sinT;
      const emf2 = NBA * omega * Math.sin(theta + 2 * Math.PI / 3);
      const emf3 = NBA * omega * Math.sin(theta + 4 * Math.PI / 3);

      // Current dynamics: L·dI/dt + R·I = EMF
      if (L < 0.0001) {
        change[3] = 0; // set algebraically in postStep
      } else {
        let e1 = emf1, e2 = emf2, e3 = emf3;
        if (commutator) { e1 = Math.abs(e1); e2 = Math.abs(e2); e3 = Math.abs(e3); }
        change[3] = (e1 - R * I1) / Leff;
        if (phases >= 3) {
          change[4] = (e2 - R * I2) / Leff;
          change[5] = (e3 - R * I3) / Leff;
        }
      }
    } else {
      // ── Motor: DC voltage drives current, torque spins rotor ──
      const backEMF = NBA * omega * Math.abs(sinT);
      if (L < 0.0001) {
        // Pure R motor: algebraic current (set in postStep)
        change[3] = 0;
      } else {
        // RL motor: circuit ODE V_dc = R·I + L·dI/dt + backEMF
        change[3] = (motorV - backEMF - R * I1) / L;
      }
      // Torque: τ = N·B·I·A·|sin(θ)| (commutator keeps torque unidirectional)
      const Ieff = L < 0.0001 ? Math.max(0, (motorV - backEMF) / R) : I1;
      const tau = NBA * Ieff * Math.abs(sinT);
      // Angular dynamics: J·dω/dt = τ - friction
      change[1] = (tau - bf * omega) / J;
      change[4] = 0;
      change[5] = 0;
    }
  },

  postStep(vars, params) {
    const [theta, omega] = vars;
    const { fieldB: B, turns: N, coilArea: A, loadR: R, loadL: L,
            phases, commutator, mode } = params;
    const NBA = N * B * A;
    const sinT = Math.sin(theta);

    // Flux (phase 1)
    vars[6] = NBA * Math.cos(theta);

    // EMF for each phase
    let e1 = NBA * omega * sinT;
    let e2 = NBA * omega * Math.sin(theta + 2 * Math.PI / 3);
    let e3 = NBA * omega * Math.sin(theta + 4 * Math.PI / 3);
    // Rectify EMF for commutator or motor mode
    const rectify = commutator || mode === 1;
    if (rectify) { e1 = Math.abs(e1); e2 = Math.abs(e2); e3 = Math.abs(e3); }
    vars[7] = e1;
    vars[8] = phases >= 3 ? e2 : 0;
    vars[9] = phases >= 3 ? e3 : 0;

    // Current (algebraic for pure R load — both generator and motor modes)
    if (L < 0.0001) {
      if (mode === 0) {
        vars[3] = e1 / R;
        if (phases >= 3) { vars[4] = e2 / R; vars[5] = e3 / R; }
      } else {
        // Motor: I = (V - backEMF) / R
        const backEMF = NBA * omega * Math.abs(sinT);
        vars[3] = Math.max(0, (params.motorV - backEMF) / R);
      }
    }

    // Torque: τ = N·B·I·A·sin(θ)
    // With commutator/motor: use |sin| (always forward torque)
    // AC generator: use signed sin (torque oscillates with current)
    const s1 = rectify ? Math.abs(sinT) : sinT;
    let tau = NBA * vars[3] * s1;
    if (phases >= 3) {
      const sin2 = Math.sin(theta + 2 * Math.PI / 3);
      const sin3 = Math.sin(theta + 4 * Math.PI / 3);
      tau += NBA * vars[4] * (rectify ? Math.abs(sin2) : sin2);
      tau += NBA * vars[5] * (rectify ? Math.abs(sin3) : sin3);
    }
    vars[10] = tau;

    // Power: P = Σ(EMF_i · I_i)
    let P = e1 * vars[3];
    if (phases >= 3) { P += e2 * vars[4] + e3 * vars[5]; }
    vars[11] = P;
  },

  energy(vars) {
    return { kinetic: 0.5 * 0.01 * vars[1] * vars[1], potential: 0, total: Math.abs(vars[11]) };
  },

  theoreticalPeriod(params) { return 60 / params.rpm; },
  periodVar: 7,

  hitTest(wx, wy, vars) {
    const cy = 0.3;
    if (Math.abs(wx) < 1.5 && Math.abs(wy - cy) < 1.0) {
      return { id: 'coil' };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars) {
    if (id === 'coil') {
      vars[0] = Math.atan2(wx, wy - 0.3);
    }
  },

  onRelease() {},

  render(canvas, vars, params) {
    const [theta, omega, t, I1] = vars;
    const { fieldB: B, turns: N, coilArea: A, rpm, loadR: R, loadL: L,
            phases, commutator, mode, motorV } = params;
    const NBA = N * B * A;
    const peakEMF = NBA * Math.abs(omega);

    // ── Magnets ──
    canvas.rect(-2.8, -0.6, 0.6, 1.8, '#DC2626', null);
    canvas.text(-2.65, 0.3, 'N', '#FFF', 14);
    canvas.rect(2.2, -0.6, 0.6, 1.8, '#2563EB', null);
    canvas.text(2.35, 0.3, 'S', '#FFF', 14);

    // ── Field lines ──
    for (let fy = -0.3; fy <= 0.9; fy += 0.3) {
      canvas.line(-2.15, fy, 2.15, fy, 'rgba(239,68,68,0.2)', 1);
      canvas.line(0.1, fy, 0, fy + 0.04, 'rgba(239,68,68,0.3)', 1);
      canvas.line(0.1, fy, 0, fy - 0.04, 'rgba(239,68,68,0.3)', 1);
    }
    canvas.text(-0.3, 1.05, 'B →', '#EF4444', 9);

    const cw = 0.9, ch = 0.65, cy = 0.3;

    // ── Viewpoint: looking perpendicular to B (from above rotation axis).
    //    Rotation axis is INTO the screen (vertical on canvas = depth axis).
    //    Coil rotates in the horizontal plane.
    //    cos(θ) projects the coil width; sin(θ) gives the depth component.
    //    Normal vector n̂ lies in the horizontal plane → only horizontal on screen.

    const cosT = Math.cos(theta), sinT = Math.sin(theta);

    // ── 3-phase ghost coils ──
    if (phases >= 3) {
      const phaseOffsets = [2 * Math.PI / 3, 4 * Math.PI / 3];
      const phaseColors = ['rgba(239,68,68,0.25)', 'rgba(34,197,94,0.25)'];
      for (let p = 0; p < 2; p++) {
        const pth = theta + phaseOffsets[p];
        const pCos = Math.cos(pth), pSin = Math.sin(pth);
        const pw = cw * pCos;
        // Depth shading: front edge brighter, back edge dimmer
        const frontAlpha = (0.15 + 0.15 * Math.abs(pSin)).toFixed(2);
        const backAlpha = (0.08 + 0.08 * Math.abs(pSin)).toFixed(2);
        if (Math.abs(pw) > 0.02) {
          // Back edge (drawn first, dimmer)
          if (pSin < 0) {
            canvas.line(-pw, cy - ch, pw, cy - ch, phaseColors[p].replace('0.25', backAlpha), 1.5);
            canvas.line(-pw, cy + ch, pw, cy + ch, phaseColors[p].replace('0.25', backAlpha), 1.5);
          }
          // Side edges
          canvas.line(-pw, cy - ch, -pw, cy + ch, phaseColors[p], 2.5);
          canvas.line(pw, cy - ch, pw, cy + ch, phaseColors[p], 2.5);
          // Front edge (drawn last, brighter)
          if (pSin >= 0) {
            canvas.line(-pw, cy - ch, pw, cy - ch, phaseColors[p].replace('0.25', frontAlpha), 2);
            canvas.line(-pw, cy + ch, pw, cy + ch, phaseColors[p].replace('0.25', frontAlpha), 2);
          }
        }
      }
    }

    // ── Main coil (phase 1) ──
    const projW = cw * cosT;
    const fluxFrac = Math.abs(cosT);
    // Depth factor: |sin(θ)| indicates how much the coil faces us
    const depthFrac = Math.abs(sinT);

    if (Math.abs(projW) > 0.02) {
      // Fill: brighter when face-on (flux is max), dimmer when edge-on
      canvas.polygon([[-projW, cy - ch], [projW, cy - ch],
        [projW, cy + ch], [-projW, cy + ch]],
        'rgba(34,197,94,' + (fluxFrac * 0.15).toFixed(2) + ')', null);
    }

    const emfVal = vars[7];
    const curDir = emfVal > 0.001 ? 1 : emfVal < -0.001 ? -1 : 0;
    const ac1 = curDir > 0 ? '#EF4444' : curDir < 0 ? '#3B82F6' : '#64748B';
    const ac2 = curDir > 0 ? '#3B82F6' : curDir < 0 ? '#EF4444' : '#64748B';

    const lx = -projW, rx = projW;

    // Draw back horizontal edges dimmer (depth cue: further away)
    const backColor = 'rgba(148,163,184,' + (0.3 + 0.2 * depthFrac).toFixed(2) + ')';
    const frontColor = '#94A3B8';
    // Determine which horizontal edge is "back" based on sin(θ)
    if (sinT < 0) {
      // Bottom edge is back
      canvas.line(lx, cy + ch, rx, cy + ch, backColor, 1.5);
      canvas.line(lx, cy - ch, rx, cy - ch, frontColor, 2.5);
    } else {
      // Top edge is back
      canvas.line(lx, cy - ch, rx, cy - ch, backColor, 1.5);
      canvas.line(lx, cy + ch, rx, cy + ch, frontColor, 2.5);
    }

    // Side edges (always visible, carry current)
    canvas.line(lx, cy + ch, lx, cy - ch, ac1, 3.5);
    canvas.line(rx, cy + ch, rx, cy - ch, ac2, 3.5);

    // Current arrows on side edges
    if (curDir !== 0) {
      const d = curDir * 0.08;
      canvas.line(lx, cy - 0.15, lx, cy + 0.15, ac1, 2);
      canvas.line(lx, cy + 0.15, lx - 0.04, cy + 0.15 - d, ac1, 2);
      canvas.line(lx, cy + 0.15, lx + 0.04, cy + 0.15 - d, ac1, 2);
      canvas.line(rx, cy + 0.15, rx, cy - 0.15, ac2, 2);
      canvas.line(rx, cy - 0.15, rx - 0.04, cy - 0.15 + d, ac2, 2);
      canvas.line(rx, cy - 0.15, rx + 0.04, cy - 0.15 + d, ac2, 2);
    }

    // ── Normal vector n̂ — HORIZONTAL ONLY ──
    // The area normal lies in the horizontal plane (perpendicular to rotation axis).
    // In this side view, it projects as a purely horizontal oscillation.
    // Length is CONSTANT (it's a unit direction scaled for display).
    // The horizontal component = cos(θ) relative to B direction.
    const nLen = 0.6;
    const nx = nLen * cosT;
    // Arrow: horizontal line from coil center
    canvas.line(0, cy, nx, cy, '#22C55E', 2.5);
    // Arrowhead
    const aDir = cosT >= 0 ? 1 : -1;
    canvas.line(nx, cy, nx - aDir * 0.08, cy - 0.05, '#22C55E', 2);
    canvas.line(nx, cy, nx - aDir * 0.08, cy + 0.05, '#22C55E', 2);
    canvas.text(nx + aDir * 0.12, cy - 0.08, 'n̂', '#22C55E', 9);

    // Dotted circle showing n̂ traces a horizontal line (projection of circular path)
    // Draw faint reference circle to show the full rotation path of n̂
    canvas.arc(0, cy, nLen, 0, 2 * Math.PI, 'rgba(34,197,94,0.12)', 1);
    // Dot on the circle showing current n̂ position (3D view hint)
    canvas.circle(nLen * cosT, cy + nLen * sinT * 0.15, 0.03, '#22C55E', null);

    // ── Torque arrow (curved) ──
    const tau = vars[10];
    if (Math.abs(tau) > 0.0001) {
      const tauDir = tau > 0 ? 1 : -1;
      const tauArc = Math.min(Math.abs(tau) * 8, 1.2);
      canvas.arc(0, cy, 0.5, -0.2, tauArc * tauDir, '#F59E0B', 2);
      canvas.text(0.55, cy - 0.2, 'τ', '#F59E0B', 9);
    }

    // ── Angle θ between n̂ and B ──
    // θ is measured from the B-field direction (horizontal right) to n̂
    // In the side view, this is the angle of the projected normal
    if (Math.abs(theta % Math.PI) > 0.05) {
      const arcAngle = Math.min(Math.abs(theta % (2 * Math.PI)), Math.PI);
      canvas.arc(0, cy, 0.25, 0, theta > 0 ? Math.min(theta, Math.PI) : Math.max(theta, -Math.PI),
        'rgba(139,92,246,0.6)', 1.5);
      canvas.text(0.3, cy + 0.12, 'θ', '#8B5CF6', 10);
    }

    // ── Rotation axis (into screen — shown as ⊗ symbol) ──
    canvas.circle(0, cy, 0.04, '#475569', null);
    canvas.line(-0.03, cy - 0.03, 0.03, cy + 0.03, '#475569', 1);
    canvas.line(-0.03, cy + 0.03, 0.03, cy - 0.03, '#475569', 1);
    // Small label
    canvas.text(0.08, cy + ch + 0.25, 'axis ⊗', '#475569', 7);

    // ── Slip rings / Commutator ──
    const sry = cy - ch - 0.35;
    if (commutator || mode === 1) {
      canvas.arc(0, sry, 0.1, 0, Math.PI, '#F59E0B', 2.5);
      canvas.arc(0, sry, 0.1, Math.PI, 2 * Math.PI, '#06B6D4', 2.5);
      canvas.text(0.2, sry, 'Commutator', '#F59E0B', 7);
    } else {
      canvas.circle(0, sry - 0.04, 0.06, null, '#F59E0B');
      canvas.circle(0, sry + 0.04, 0.06, null, '#06B6D4');
      canvas.text(0.2, sry, 'Slip Rings', '#94A3B8', 7);
    }
    canvas.rect(-0.18, sry - 0.03, 0.06, 0.06, '#94A3B8', null);
    canvas.rect(0.12, sry - 0.03, 0.06, 0.06, '#94A3B8', null);

    // ── External circuit ──
    const ey = sry - 0.2;
    canvas.line(-0.15, sry, -0.15, ey, '#64748B', 1.5);
    canvas.line(0.15, sry, 0.15, ey, '#64748B', 1.5);
    canvas.line(-0.15, ey, -0.7, ey, '#64748B', 1.5);
    canvas.line(0.15, ey, 0.7, ey, '#64748B', 1.5);
    if (mode === 1) {
      // Motor: DC voltage source
      canvas.circle(0, ey, 0.1, '#1E293B', '#22C55E');
      canvas.text(-0.15, ey, motorV + 'V', '#22C55E', 7);
    } else {
      // Generator: R (+ L) load
      if (L > 0.001) {
        // RL load
        canvas.rect(-0.7, ey - 0.06, 0.65, 0.12, '#1E293B', '#F59E0B');
        canvas.text(-0.55, ey, 'R=' + R, '#F59E0B', 6);
        canvas.rect(0.05, ey - 0.06, 0.65, 0.12, '#1E293B', '#06B6D4');
        canvas.text(0.15, ey, 'L=' + L, '#06B6D4', 6);
      } else {
        canvas.rect(-0.5, ey - 0.06, 1.0, 0.12, '#1E293B', '#F59E0B');
        canvas.text(-0.2, ey, 'R=' + R + 'Ω', '#F59E0B', 7);
      }
    }

    // ── Mini waveform ──
    const wfL = -2.8, wfR = 2.8, wfB = -2.2, wfT = -1.2;
    const wfMid = (wfB + wfT) / 2;
    canvas.polygon([[wfL, wfB], [wfR, wfB], [wfR, wfT], [wfL, wfT]], 'rgba(15,23,42,0.5)', '#334155');
    canvas.line(wfL, wfMid, wfR, wfMid, '#334155', 1);

    const period = Math.abs(omega) > 0.01 ? 2 * Math.PI / Math.abs(omega) : 10;
    const tWindow = period * 2.5;
    const tStart = Math.max(0, t - tWindow);
    const wfW = wfR - wfL, wfH = (wfT - wfB) / 2 * 0.85;
    const nPts = 200;
    const phaseColors = ['#06B6D4', '#EF4444', '#22C55E'];
    const nPhases = phases >= 3 ? 3 : 1;

    // In motor mode during spinup, ω is changing so analytical waveform is inaccurate.
    // Show "Spinning up..." text instead of the curve until ω stabilizes.
    const motorSpinup = mode === 1 && Math.abs(omega) < Math.abs(params.rpm * 2 * Math.PI / 60) * 0.9 && t < 5;

    if (!motorSpinup) {
      for (let ph = 0; ph < nPhases; ph++) {
        const offset = ph * 2 * Math.PI / 3;
        for (let i = 1; i < nPts; i++) {
          const t1 = tStart + tWindow * (i - 1) / nPts;
          const t2 = tStart + tWindow * i / nPts;
          let e1 = Math.sin(omega * t1 + offset);
          let e2 = Math.sin(omega * t2 + offset);
          if (commutator || mode === 1) { e1 = Math.abs(e1); e2 = Math.abs(e2); }
          canvas.line(wfL + wfW * (i - 1) / nPts, wfMid + e1 * wfH,
                      wfL + wfW * i / nPts, wfMid + e2 * wfH, phaseColors[ph], 1.5);
        }
      }
    } else {
      canvas.text((wfL + wfR) / 2 - 0.5, wfMid, 'Spinning up...', '#F59E0B', 10);
    }

    // Tracking dot (always uses actual state, accurate even during spinup)
    const tFrac = (t - tStart) / tWindow;
    if (tFrac >= 0 && tFrac <= 1) {
      const meNorm = peakEMF > 0.001 ? vars[7] / peakEMF : 0;
      canvas.circle(wfL + tFrac * wfW, wfMid + meNorm * wfH, 0.05, '#F59E0B', '#FFF');
    }

    // Waveform labels
    const modeLabel = mode === 1 ? 'Motor back-EMF' : phases >= 3 ? '3-Phase AC' : commutator ? 'DC Output' : 'AC Output';
    canvas.text(wfL + 0.05, wfT - 0.05, modeLabel, '#94A3B8', 9);
    canvas.text(wfR - 0.7, wfT - 0.05,
      (commutator || mode === 1 ? '0–' : '±') + peakEMF.toFixed(1) + 'V', '#06B6D4', 8);

    // ── Readouts ──
    canvas.text(-3.1, 2.2, (mode === 1 ? 'back-EMF' : 'EMF') + ' = ' + vars[7].toFixed(2) + ' V', '#94A3B8', 12);
    canvas.text(-3.1, 1.95, 'I = ' + (vars[3] * 1000).toFixed(1) + ' mA', '#64748B', 10);
    canvas.text(-3.1, 1.7, 'Φ = ' + (vars[6] * 1000).toFixed(2) + ' mWb', '#22C55E', 10);

    if (mode === 0) {
      // Generator: RMS from AC phasor analysis
      const rmsV = peakEMF / Math.SQRT2;
      const Z = Math.sqrt(R * R + (omega * L) * (omega * L));
      const rmsCur = rmsV / (Z || 1);
      const pf = Z > 0.001 ? R / Z : 1;
      const phaseAngle = Math.atan2(omega * L, R) * 180 / Math.PI;
      canvas.text(0.8, 2.2, 'RMS: ' + rmsV.toFixed(2) + ' V  ' + (rmsCur * 1000).toFixed(1) + ' mA', '#F59E0B', 10);
      if (L > 0.001) {
        canvas.text(0.8, 1.7, 'PF = ' + pf.toFixed(2) + '  φ = ' + phaseAngle.toFixed(1) + '°', '#06B6D4', 9);
      }
    } else {
      // Motor: show actual DC current and applied voltage
      canvas.text(0.8, 2.2, 'I_dc = ' + (vars[3] * 1000).toFixed(1) + ' mA  V = ' + motorV + ' V', '#F59E0B', 10);
    }
    // Power + torque
    canvas.text(0.8, 1.95, 'P = ' + (vars[11] * 1000).toFixed(1) + ' mW  τ = ' + (vars[10] * 1000).toFixed(2) + ' mN·m', '#64748B', 9);

    // Mode + speed
    const degStr = (((theta * 180 / Math.PI) % 360 + 360) % 360).toFixed(0);
    const rpmActual = Math.abs(omega) * 60 / (2 * Math.PI);
    canvas.text(-3.1, 1.45, (mode === 1 ? 'MOTOR' : 'GENERATOR') + '  ' + rpmActual.toFixed(0) + ' RPM  θ=' + degStr + '°',
      mode === 1 ? '#22C55E' : '#06B6D4', 9);

    if (phases >= 3) {
      canvas.text(-3.1, 1.25, '3-PHASE  120° offset', '#EF4444', 8);
    }
  },

  info: `
    <h2>AC/DC Generator & Motor</h2>
    <p>A rectangular coil with N turns in a uniform magnetic field B. In <strong>generator mode</strong>,
    external rotation produces electricity via Faraday's law. In <strong>motor mode</strong>, applied DC voltage
    spins the coil via Lorentz force.</p>

    <h3>Faraday's Law (Generator)</h3>
    <p><code>Φ = N·B·A·cos(θ)</code> &nbsp; <code>EMF = N·B·A·ω·sin(θ)</code></p>
    <p>Peak EMF: <code>ε₀ = N·B·A·ω</code>. RMS voltage: <code>V_rms = ε₀/√2</code></p>

    <h3>RL Load & Power Factor</h3>
    <p>With inductance L in the load: <code>L·dI/dt + R·I = EMF</code></p>
    <p>Current lags EMF by <code>φ = arctan(ωL/R)</code>. Power factor = cos(φ) = R/Z where Z = √(R²+(ωL)²).</p>
    <p>Try setting L = 0.1 H and watch the current waveform lag behind the EMF on the Time tab.</p>

    <h3>Torque</h3>
    <p><code>τ = N·B·I·A·sin(θ)</code></p>
    <p>In generator mode, this is the <strong>reaction torque</strong> — the mechanical input needed to turn the coil
    against the electromagnetic braking. Lower R → higher I → harder to turn. Try R = 1Ω vs R = 100Ω.</p>

    <h3>DC Motor Mode</h3>
    <p>Apply DC voltage V. The commutator ensures current always produces forward torque:</p>
    <p><code>V = R·I + L·dI/dt + back_EMF</code></p>
    <p><code>J·dω/dt = τ − b·ω</code></p>
    <p>The motor accelerates until back-EMF ≈ V (steady state). Higher friction → slower speed → lower back-EMF → higher current → higher torque (self-regulating).</p>

    <h3>3-Phase</h3>
    <p>Three coils at 120° offsets produce three overlapping sine waves. The mini waveform shows all three
    (cyan, red, green). Total 3-phase power is smoother than single-phase (less torque ripple).</p>

    <h3>RMS Values</h3>
    <p><code>V_rms = V_peak/√2 ≈ 0.707·V_peak</code></p>
    <p>RMS (root-mean-square) is the equivalent DC voltage that delivers the same power to a resistive load.
    Displayed in the top-right readout alongside peak values.</p>

    <h3>Try These</h3>
    <ol>
      <li><strong>Phase shift:</strong> Set L=0.1H, switch to Time tab. Current lags EMF — the RL phase lag is visible.</li>
      <li><strong>3-phase:</strong> Set Phases=3. Three waveforms 120° apart. Total power is smoother.</li>
      <li><strong>DC motor:</strong> Set Mode=1. Watch the coil spin up from rest, reaching steady-state RPM.</li>
      <li><strong>Motor loading:</strong> Increase Motor Friction. RPM drops, current rises (motor works harder).</li>
      <li><strong>Power factor:</strong> With RL load, PF shows how much of the power is "real" vs "reactive".</li>
      <li><strong>Torque vs R:</strong> Decrease R to 1Ω in generator mode. Torque readout increases — harder to turn.</li>
      <li><strong>Commutator:</strong> Toggle DC mode. Waveform rectifies. Compare AC vs DC output.</li>
    </ol>
  `,
};
