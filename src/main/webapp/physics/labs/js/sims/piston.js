/**
 * Automotive Piston — Slider-Crank Mechanism
 *
 * Simulates a piston connected to a crankshaft via a connecting rod.
 * The user controls crank radius (a), connecting rod length (L),
 * bore diameter (B), angular speed (RPM), and piston mass.
 *
 * Kinematics (origin at crankshaft center):
 *   Piston height:  H(θ) = a·cos(θ) + √(L² − a²·sin²(θ))
 *   TDC (top dead center):  L + a   (θ = 0)
 *   BDC (bottom dead center): L − a   (θ = π)
 *   Stroke S = 2a
 *
 * Piston velocity (exact derivative):
 *   Ḣ = dH/dθ · ω = −a·ω·sin(θ)·[1 + a·cos(θ) / √(L² − a²·sin²(θ))]
 *
 * Piston acceleration (exact second derivative):
 *   Ḧ = d²H/dθ² · ω²
 *   d²H/dθ² = −a·cos(θ) − a²/L · [sin²(θ)·(…) + cos(2θ)] (full form below)
 *   Simplified (first two harmonics): Ḧ ≈ −a·ω²·[cos(θ) + (a/L)·cos(2θ)]
 *
 * Cylinder volume:
 *   V = π·(B/2)² · (L + a − H)
 *
 * State: [crankAngle, time, height, velocity, acceleration, volume]
 *   Indices 2–5 are computed in postStep (not integrated by RK4).
 */

export const PistonSim = {
  name: 'Automotive Piston',
  slug: 'piston',
  category: 'Mechanics',

  vars: {
    crankAngle: { index: 0, label: 'Crank Angle (rad)',          symbol: 'θ' },
    time:       { index: 1, label: 'Time (s)',                   symbol: 't' },
    height:     { index: 2, label: 'Piston Height (mm)',         symbol: 'H' },
    velocity:   { index: 3, label: 'Piston Velocity (mm/s)',     symbol: 'Ḣ' },
    accel:      { index: 4, label: 'Piston Acceleration (mm/s²)',symbol: 'Ḧ' },
    volume:     { index: 5, label: 'Cylinder Volume (cm³)',      symbol: 'V' },
  },
  varCount: 6,

  params: {
    rodLength:   { value: 150,  min: 80,  max: 300, step: 5,    label: 'Rod Length L',     unit: 'mm' },
    crankRadius: { value: 50,   min: 20,  max: 100, step: 1,    label: 'Crank Radius a',   unit: 'mm' },
    bore:        { value: 86,   min: 50,  max: 150, step: 1,    label: 'Bore Diameter B',   unit: 'mm' },
    rpm:         { value: 60,   min: 5,   max: 600, step: 5,    label: 'Engine Speed',      unit: 'RPM' },
    pistonMass:  { value: 0.5,  min: 0.1, max: 3.0, step: 0.05, label: 'Piston Mass',      unit: 'kg' },
  },

  views: ['sim', 'phase', 'time', 'energy'],

  graphDefaults: {
    phase: { x: 'height', y: 'velocity' },
    time: ['height', 'velocity', 'volume'],
  },

  worldRect: { xMin: -3.5, xMax: 3.5, yMin: -2.5, yMax: 4.5 },

  presets: [
    { name: 'Default',                     params: {} },
    { name: 'Long Rod (L=250)',             params: { rodLength: 250, crankRadius: 50 } },
    { name: 'Short Rod (L=100)',            params: { rodLength: 100, crankRadius: 40 } },
    { name: 'High RPM (300)',               params: { rpm: 300 } },
    { name: 'Large Bore (B=120)',           params: { bore: 120 } },
    { name: 'Small Engine',                 params: { rodLength: 90, crankRadius: 25, bore: 60, rpm: 120 } },
    { name: 'Low Speed (10 RPM)',           params: { rpm: 10 } },
    { name: 'L/a Ratio 2:1 (short rod)',    params: { rodLength: 100, crankRadius: 50 } },
  ],

  /** Piston height: H(θ) = a·cos(θ) + √(L² − a²·sin²(θ)) */
  _pistonHeight(theta, L, a) {
    const sinT = Math.sin(theta);
    return a * Math.cos(theta) + Math.sqrt(L * L - a * a * sinT * sinT);
  },

  /**
   * Piston velocity: dH/dt = dH/dθ · ω
   *   dH/dθ = −a·sin(θ) · [1 + a·cos(θ) / √(L² − a²·sin²(θ))]
   */
  _pistonVelocity(theta, omega, L, a) {
    const sinT = Math.sin(theta);
    const cosT = Math.cos(theta);
    const root = Math.sqrt(L * L - a * a * sinT * sinT);
    return -a * omega * sinT * (1 + a * cosT / root);
  },

  /**
   * Piston acceleration: d²H/dt² = d²H/dθ² · ω²
   * Exact second derivative of H with respect to θ:
   *   d²H/dθ² = −a·cos(θ) − a²·cos(2θ)/D − a⁴·sin²(θ)·cos²(θ)/D³
   *   where D = √(L² − a²·sin²θ)
   *
   * Derivation: differentiate dH/dθ = −a·sinθ − a²·sinθ·cosθ/D
   *   Term 1: d/dθ[−a·sinθ] = −a·cosθ
   *   Term 2: d/dθ[−a²·sinθ·cosθ/D] via quotient rule
   *           = −a²·cos(2θ)/D − a⁴·sin²θ·cos²θ/D³
   */
  _pistonAccel(theta, omega, L, a) {
    const sinT = Math.sin(theta);
    const cosT = Math.cos(theta);
    const sin2 = sinT * sinT;
    const cos2 = cosT * cosT;
    const D2 = L * L - a * a * sin2;
    const D = Math.sqrt(D2);
    const D3 = D * D2;
    // d²H/dθ²
    const d2H = -a * cosT
                - a * a * (cos2 - sin2) / D   // cos(2θ) = cos²θ − sin²θ
                - a * a * a * a * sin2 * cos2 / D3;
    return d2H * omega * omega;
  },

  /** Cylinder volume in mm³ */
  _cylinderVolume(theta, L, a, B) {
    const H = this._pistonHeight(theta, L, a);
    return Math.PI * (B / 2) * (B / 2) * (L + a - H);
  },

  init(params) {
    const L = params?.rodLength ?? 150;
    const a = params?.crankRadius ?? 50;
    const B = params?.bore ?? 86;
    const H0 = this._pistonHeight(0, L, a);
    const V0 = Math.PI * (B / 2) * (B / 2) * (L + a - H0) / 1000;
    // [crankAngle, time, height, velocity, accel, volume]
    return [0, 0, H0, 0, 0, V0];
  },

  /** Compute derived quantities after each RK4 step */
  postStep(vars, params) {
    const theta = vars[0];
    const { rodLength: L, crankRadius: a, bore: B, rpm } = params;
    const omega = rpm * 2 * Math.PI / 60;

    vars[2] = this._pistonHeight(theta, L, a);
    vars[3] = this._pistonVelocity(theta, omega, L, a);
    vars[4] = this._pistonAccel(theta, omega, L, a);
    vars[5] = this._cylinderVolume(theta, L, a, B) / 1000; // mm³ → cm³
  },

  evaluate(vars, change, params, isDragging) {
    change[1] = 1; // dt/dt = 1
    // Zero out computed vars (set in postStep, not integrated)
    change[2] = 0;
    change[3] = 0;
    change[4] = 0;
    change[5] = 0;
    if (isDragging) { change[0] = 0; return; }
    const omega = params.rpm * 2 * Math.PI / 60;
    change[0] = omega;
  },

  energy(vars, params) {
    const theta = vars[0];
    const { rodLength: L, crankRadius: a, pistonMass: m, rpm } = params;
    const omega = rpm * 2 * Math.PI / 60;
    const vPiston = this._pistonVelocity(theta, omega, L, a) / 1000; // mm/s → m/s
    const KE = 0.5 * m * vPiston * vPiston;
    // No potential energy — crankshaft constrains the motion
    return { kinetic: KE, potential: 0, total: KE };
  },

  theoreticalPeriod(params) {
    return 60 / params.rpm;
  },
  periodVar: 0,

  hitTest(wx, wy, vars, params) {
    const theta = vars[0];
    const { crankRadius: a } = params;
    const sc = 1 / 80;
    const cpx = a * sc * Math.sin(theta);
    const cpy = a * sc * Math.cos(theta);
    if (Math.hypot(wx - cpx, wy - cpy) < 0.3) {
      return { id: 'crank', offsetAngle: theta - Math.atan2(wx, wy) };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars) {
    if (id === 'crank') {
      vars[0] = Math.atan2(wx, wy);
      if (vars[0] < 0) vars[0] += 2 * Math.PI;
    }
  },

  onRelease() {},

  render(canvas, vars, params) {
    const theta = vars[0];
    const { rodLength: L, crankRadius: a, bore: B, rpm, pistonMass: mP } = params;
    const omega = rpm * 2 * Math.PI / 60;

    // Scale: convert mm to world units
    const sc = 1 / 80;
    const H = vars[2] || this._pistonHeight(theta, L, a);
    const vPiston = vars[3] || 0;
    const aPiston = vars[4] || 0;
    const volCC = vars[5] || 0;
    const TDC = L + a;
    const BDC = L - a;
    const stroke = 2 * a;

    // Positions in world coordinates
    const crankCenterY = 0;
    const crankCenterX = 0;

    // Crank pin position
    const cpx = a * sc * Math.sin(theta);
    const cpy = a * sc * Math.cos(theta);

    // Piston center (on vertical axis)
    const pistonY = H * sc;
    const pistonX = 0;

    // Bore in world units
    const boreW = B * sc;
    const pistonThickness = 0.25;

    // ── Cylinder walls ──
    const cylTop = (TDC + 15) * sc;
    const cylBot = (BDC - 20) * sc;
    const halfBore = boreW / 2;
    canvas.line(-halfBore, cylBot, -halfBore, cylTop, '#475569', 3);
    canvas.line(halfBore, cylBot, halfBore, cylTop, '#475569', 3);
    // Cylinder head (top)
    canvas.line(-halfBore, cylTop, halfBore, cylTop, '#475569', 3);

    // ── Combustion chamber shading ──
    const pistonTop = pistonY + pistonThickness / 2;
    const chamberVerts = [
      [-halfBore, pistonTop],
      [halfBore, pistonTop],
      [halfBore, cylTop],
      [-halfBore, cylTop],
    ];
    canvas.polygon(chamberVerts, 'rgba(239, 68, 68, 0.08)', null);

    // ── TDC / BDC markers ──
    const markerX = halfBore + 0.15;
    const tdcY = TDC * sc;
    const bdcY = BDC * sc;
    canvas.line(markerX, tdcY, markerX + 0.3, tdcY, '#22C55E', 1.5);
    canvas.text(markerX + 0.55, tdcY, 'TDC', '#22C55E', 8);
    canvas.line(markerX, bdcY, markerX + 0.3, bdcY, '#F59E0B', 1.5);
    canvas.text(markerX + 0.55, bdcY, 'BDC', '#F59E0B', 8);

    // Stroke bracket
    canvas.line(markerX + 0.15, tdcY, markerX + 0.15, bdcY, '#64748B', 1);
    canvas.text(markerX + 0.55, (tdcY + bdcY) / 2, 'S=' + stroke.toFixed(0) + 'mm', '#94A3B8', 7);

    // ── Piston ──
    canvas.rect(-halfBore + 0.02, pistonY - pistonThickness / 2, boreW - 0.04, pistonThickness, '#8B5CF6', '#A78BFA');

    // Piston pin
    canvas.circle(pistonX, pistonY, 0.06, '#CBD5E1', null);

    // ── Connecting rod ──
    canvas.rod(pistonX, pistonY, cpx, cpy, '#06B6D4', 3);

    // ── Crank arm ──
    canvas.rod(crankCenterX, crankCenterY, cpx, cpy, '#F59E0B', 3);

    // ── Crank pin ──
    canvas.circle(cpx, cpy, 0.08, '#F59E0B', '#FCD34D');

    // ── Crankshaft center ──
    canvas.circle(crankCenterX, crankCenterY, 0.1, '#64748B', '#94A3B8');
    canvas.line(-0.06, 0, 0.06, 0, '#CBD5E1', 1);
    canvas.line(0, -0.06, 0, 0.06, '#CBD5E1', 1);

    // ── Crank circle (dashed) ──
    const crankR = a * sc;
    const segments = 48;
    for (let i = 0; i < segments; i++) {
      if (i % 2 === 1) continue;
      const a1 = (2 * Math.PI * i) / segments;
      const a2 = (2 * Math.PI * (i + 1)) / segments;
      canvas.line(
        crankR * Math.sin(a1), crankR * Math.cos(a1),
        crankR * Math.sin(a2), crankR * Math.cos(a2),
        '#334155', 1
      );
    }

    // ── Inertial force arrow on piston (F = m·a) ──
    const F_inertial = mP * aPiston / 1000; // N (aPiston is mm/s², so /1000 for m/s²)
    const forceScale = 0.003; // world units per N
    const arrowLen = F_inertial * forceScale;
    if (Math.abs(arrowLen) > 0.03) {
      const arrowBase = pistonY + pistonThickness / 2;
      const arrowTip = arrowBase + arrowLen;
      canvas.line(-halfBore - 0.15, arrowBase, -halfBore - 0.15, arrowTip, '#EF4444', 2.5);
      // Arrowhead
      const dir = arrowLen > 0 ? 1 : -1;
      canvas.line(-halfBore - 0.15, arrowTip, -halfBore - 0.22, arrowTip - dir * 0.08, '#EF4444', 2);
      canvas.line(-halfBore - 0.15, arrowTip, -halfBore - 0.08, arrowTip - dir * 0.08, '#EF4444', 2);
      canvas.text(-halfBore - 0.5, (arrowBase + arrowTip) / 2, Math.abs(F_inertial).toFixed(0) + 'N', '#EF4444', 7);
    }

    // ── Readouts ──
    const angleDeg = ((theta * 180 / Math.PI) % 360 + 360) % 360;

    canvas.text(0, 4.1, 'θ = ' + angleDeg.toFixed(1) + '°     H = ' + H.toFixed(1) + ' mm', '#94A3B8', 10);
    canvas.text(0, 3.8, 'Vel = ' + vPiston.toFixed(0) + ' mm/s     Vol = ' + volCC.toFixed(1) + ' cm³', '#94A3B8', 9);
    canvas.text(0, 3.5, 'Accel = ' + (aPiston / 1000).toFixed(1) + ' m/s²     F = ' + Math.abs(mP * aPiston / 1e6).toFixed(1) + ' kN', '#94A3B8', 8);
    canvas.text(0, 3.2, rpm + ' RPM  (' + (rpm / 60).toFixed(2) + ' Hz)', '#64748B', 8);

    // ── Stroke info ──
    const displacement = Math.PI * (B / 2) * (B / 2) * stroke / 1000; // cm³
    canvas.text(-2.8, 4.1, 'L = ' + L + ' mm', '#06B6D4', 8);
    canvas.text(-2.8, 3.8, 'a = ' + a + ' mm', '#F59E0B', 8);
    canvas.text(-2.8, 3.5, 'B = ' + B + ' mm', '#8B5CF6', 8);
    canvas.text(-2.8, 3.2, 'L/a = ' + (L / a).toFixed(2), '#94A3B8', 8);
    canvas.text(-2.8, 2.9, 'Disp = ' + displacement.toFixed(0) + ' cm³', '#94A3B8', 7);

    // ── Label origin ──
    canvas.text(0.2, -0.2, 'O', '#64748B', 8);
  },

  info: `
    <h2>Automotive Piston — Slider-Crank Mechanism</h2>
    <p>A piston connected to a crankshaft via a connecting rod. The crankshaft rotates at constant angular speed, converting rotary motion into the reciprocating linear motion of the piston inside a cylinder.</p>

    <h3>Key Parameters</h3>
    <ul>
      <li><strong style="color:#F59E0B;">Crank radius (a):</strong> Half the stroke length. The crank arm from crankshaft center to the crank pin.</li>
      <li><strong style="color:#06B6D4;">Connecting rod length (L):</strong> Links the crank pin to the piston pin. Must be longer than the crank radius.</li>
      <li><strong style="color:#8B5CF6;">Bore diameter (B):</strong> The internal diameter of the cylinder. Determines the cross-sectional area.</li>
      <li><strong>Stroke (S = 2a):</strong> Total travel distance of the piston from BDC to TDC.</li>
      <li><strong>Piston Mass (m):</strong> Mass of the piston assembly. Determines inertial forces.</li>
    </ul>

    <h3>Dead Centers</h3>
    <ul>
      <li><strong style="color:#22C55E;">TDC (Top Dead Center):</strong> Piston at highest point. Height = L + a. Crank angle θ = 0°. Minimum combustion chamber volume.</li>
      <li><strong style="color:#F59E0B;">BDC (Bottom Dead Center):</strong> Piston at lowest point. Height = L − a. Crank angle θ = 180°. Maximum cylinder volume.</li>
    </ul>

    <h3>Piston Height</h3>
    <p><code>H(θ) = a·cos(θ) + √(L² − a²·sin²(θ))</code></p>
    <p>This is <strong>not</strong> a simple sinusoid — the connecting rod geometry introduces higher harmonics.
    The deviation from pure sinusoidal motion increases as the L/a ratio decreases. Compare the Phase tab
    (H vs Ḣ) for L/a = 3 vs L/a = 2 to see the asymmetry.</p>

    <h3>Cylinder Volume</h3>
    <p><code>V = π·(B/2)²·(L + a − H)</code></p>
    <p>The <strong>swept volume</strong> (displacement) is <code>π·(B/2)²·S = π·(B/2)²·2a</code>.
    This volume change drives the intake, compression, power, and exhaust strokes in a four-stroke engine.</p>

    <h3>Piston Velocity</h3>
    <p><code>Ḣ = −a·ω·sin(θ)·[1 + a·cos(θ)/√(L² − a²·sin²(θ))]</code></p>
    <p>Maximum piston speed occurs slightly <strong>before</strong> θ = 90° (not exactly at 90° due to the connecting rod geometry). This asymmetry is visible in the Time graph.</p>

    <h3>Piston Acceleration & Inertial Force</h3>
    <p>The exact acceleration involves the full second derivative of H(θ). A useful approximation is:</p>
    <p><code>Ḧ ≈ −a·ω²·[cos(θ) + (a/L)·cos(2θ)]</code></p>
    <p>The <strong style="color:#EF4444;">inertial force</strong> F = m·Ḧ is shown as a red arrow on the piston.
    At high RPM this force grows with ω² and can reach thousands of Newtons — this is why piston mass reduction
    is critical in high-performance engines.</p>

    <h3>Graph Tabs</h3>
    <ul>
      <li><strong>Phase (H vs Ḣ):</strong> Shows the asymmetric piston motion. A pure sinusoid would be a perfect ellipse. The connecting rod distorts it — more so at low L/a ratios.</li>
      <li><strong>Time:</strong> Height, velocity, and volume plotted vs time. Notice velocity is not symmetric about the horizontal axis.</li>
      <li><strong>Energy:</strong> Kinetic energy of the piston peaks twice per revolution at different magnitudes (due to the asymmetric velocity profile).</li>
    </ul>

    <h3>Try These</h3>
    <ol>
      <li><strong>L/a ratio:</strong> Compare L=150,a=50 (ratio 3:1) vs L=100,a=50 (ratio 2:1). Lower ratios produce more asymmetric piston motion — visible in the phase plot.</li>
      <li><strong>Drag the crank pin:</strong> Manually rotate the crank to see how piston height varies with angle.</li>
      <li><strong>High RPM:</strong> Increase to 300+ RPM and watch the inertial force arrow grow dramatically.</li>
      <li><strong>Phase plot:</strong> Switch to Phase tab. With L/a=3, the loop is nearly elliptical. With L/a=2, it's visibly egg-shaped.</li>
      <li><strong>Energy tab:</strong> Watch KE pulse twice per revolution. The two peaks have different heights due to the rod geometry.</li>
    </ol>
  `,
};
