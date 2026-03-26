/**
 * Car Suspension — Quarter-Car Model
 *
 * A car body (sprung mass) rides on a spring + damper connected to
 * a wheel that follows the road surface exactly (unsprung mass ≈ 0).
 *
 * The car drives over a repeating road with:
 *   - Speed bump (half-sine)
 *   - Washboard section (sinusoidal)
 *   - Pothole (negative half-sine)
 *
 * KEY INSIGHT: Damping ratio ζ = b / (2√(mk)) determines response:
 *   ζ < 1 → underdamped (oscillates after bump)
 *   ζ = 1 → critically damped (fastest settling, no overshoot)
 *   ζ > 1 → overdamped (slow, mushy return)
 *
 * Equation of motion:
 *   m·ÿ = -k·(y - y_road) - b·(ẏ - ẏ_road)
 *
 * State: [y, vy, x_road, time]
 *   y  = body vertical displacement from flat-road equilibrium
 *   vy = body vertical velocity
 *   x_road = horizontal position along road
 */

export const CarSuspensionSim = {
  name: 'Car Suspension',
  slug: 'car-suspension',
  category: 'Mechanics',

  vars: {
    bodyDisp: { index: 0, label: 'Body displacement (m)',  symbol: 'y' },
    bodyVel:  { index: 1, label: 'Body velocity (m/s)',    symbol: 'ẏ' },
    roadPos:  { index: 2, label: 'Road position (m)',      symbol: 'x' },
    time:     { index: 3, label: 'Time (s)',               symbol: 't' },
  },
  varCount: 4,

  params: {
    mass:       { value: 500,   min: 100,  max: 2000,  step: 10,   label: 'Body Mass m',    unit: 'kg' },
    stiffness:  { value: 20000, min: 2000, max: 80000, step: 500,  label: 'Spring Rate k',  unit: 'N/m' },
    damping:    { value: 4000,  min: 0,    max: 20000, step: 100,  label: 'Damper b',       unit: 'N·s/m' },
    carSpeed:   { value: 8,     min: 0.5,  max: 20,    step: 0.5,  label: 'Car Speed',      unit: 'm/s' },
    bumpHeight: { value: 0.08,  min: 0.02, max: 0.3,   step: 0.01, label: 'Bump Height',    unit: 'm' },
  },

  views: ['sim', 'phase', 'time', 'energy'],

  graphDefaults: {
    phase: { x: 'bodyDisp', y: 'bodyVel' },
    time: ['bodyDisp', 'bodyVel'],
  },

  worldRect: { xMin: -6, xMax: 6, yMin: -1.5, yMax: 3.5 },

  presets: [
    { name: 'Default (ζ≈0.63)',           params: {} },
    { name: 'Critically Damped (ζ=1)',    params: { damping: 6325 } },
    { name: 'Underdamped (ζ≈0.3)',        params: { damping: 1900 } },
    { name: 'Overdamped (ζ≈2)',           params: { damping: 12650 } },
    { name: 'No Damping (broken!)',       params: { damping: 0 } },
    { name: 'Washboard Resonance',        params: { damping: 1000, carSpeed: 5 } },
    { name: 'Stiff Racing (k=60k)',       params: { stiffness: 60000, damping: 8000 } },
    { name: 'Soft Comfort (k=10k)',       params: { stiffness: 10000, damping: 4000 } },
  ],

  // ── Road profile (repeating every 60 m) ──
  _PERIOD: 60,
  _WB_LAMBDA: 5,   // washboard wavelength (m)

  _roadHeight(x, h) {
    const xm = ((x % 60) + 60) % 60;
    // Speed bump: half-sine from 8 to 10 m
    if (xm >= 8 && xm <= 10) return h * Math.sin(Math.PI * (xm - 8) / 2);
    // Washboard: sine from 20 to 40 m, period 5 m
    if (xm >= 20 && xm <= 40) return 0.5 * h * Math.sin(2 * Math.PI * (xm - 20) / 5);
    // Pothole: negative half-sine from 48 to 50 m
    if (xm >= 48 && xm <= 50) return -h * Math.sin(Math.PI * (xm - 48) / 2);
    return 0;
  },

  _roadSlope(x, h) {
    const xm = ((x % 60) + 60) % 60;
    if (xm >= 8 && xm <= 10) return h * (Math.PI / 2) * Math.cos(Math.PI * (xm - 8) / 2);
    if (xm >= 20 && xm <= 40) return 0.5 * h * (2 * Math.PI / 5) * Math.cos(2 * Math.PI * (xm - 20) / 5);
    if (xm >= 48 && xm <= 50) return -h * (Math.PI / 2) * Math.cos(Math.PI * (xm - 48) / 2);
    return 0;
  },

  /** What road section is the car on? */
  _roadSection(x) {
    const xm = ((x % 60) + 60) % 60;
    if (xm >= 8 && xm <= 10) return 'bump';
    if (xm >= 20 && xm <= 40) return 'washboard';
    if (xm >= 48 && xm <= 50) return 'pothole';
    return 'flat';
  },

  /** Distance to next road feature (skips the one we're currently on) */
  _nextFeature(x) {
    const xm = ((x % 60) + 60) % 60;
    if (xm < 20) return { name: 'WASHBOARD', dist: 20 - xm };
    if (xm < 48) return { name: 'POTHOLE', dist: 48 - xm };
    return { name: 'BUMP', dist: 60 - xm + 8 };
  },

  init() {
    return [0, 0, 0, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[3] = 1;
    if (isDragging) return;

    const [y, vy, x] = vars;
    const { mass, stiffness, damping, carSpeed, bumpHeight } = params;

    const yr = this._roadHeight(x, bumpHeight);
    const yrDot = this._roadSlope(x, bumpHeight) * carSpeed;

    // Relative displacement & velocity (body minus road)
    const relDisp = y - yr;
    const relVel = vy - yrDot;

    // F = -k·(y - yr) - b·(ẏ - ẏr)
    const accel = (-stiffness * relDisp - damping * relVel) / mass;

    change[0] = vy;
    change[1] = accel;
    change[2] = carSpeed;
  },

  energy(vars, params) {
    const [y, vy, x] = vars;
    const { mass, stiffness, bumpHeight } = params;
    const yr = this._roadHeight(x, bumpHeight);
    const KE = 0.5 * mass * vy * vy;
    const PE = 0.5 * stiffness * (y - yr) * (y - yr);
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  theoreticalPeriod(params) {
    return 2 * Math.PI * Math.sqrt(params.mass / params.stiffness);
  },
  periodVar: 1,

  hitTest(wx, wy, vars, params) {
    const rideH = 1.3;
    const bodyY = vars[0] + rideH;
    if (Math.abs(wx) < 0.8 && Math.abs(wy - bodyY) < 0.4) {
      return { id: 'body', offsetY: wy - bodyY };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars) {
    if (id === 'body') {
      const rideH = 1.3;
      vars[0] = (wy - (offset.offsetY || 0)) - rideH;
      vars[1] = 0;
    }
  },

  onRelease() {},

  render(canvas, vars, params) {
    const [y, vy, xCar] = vars;
    const { mass, stiffness, damping, carSpeed, bumpHeight } = params;
    const rideH = 1.3;
    const bodyW = 1.4, bodyH = 0.55;
    const wheelR = 0.22;

    // ── Road surface ──
    for (let sx = -6; sx < 6; sx += 0.15) {
      const x1 = xCar + sx, x2 = xCar + sx + 0.15;
      const y1 = this._roadHeight(x1, bumpHeight);
      const y2 = this._roadHeight(x2, bumpHeight);
      const sec = this._roadSection(x1);
      const col = sec === 'bump' ? '#F59E0B' :
                  sec === 'washboard' ? '#06B6D4' :
                  sec === 'pothole' ? '#EF4444' : '#475569';
      canvas.line(sx, y1, sx + 0.15, y2, col, 2.5);
    }

    // ── Ground fill lines (hatching below road) ──
    for (let sx = -6; sx < 6; sx += 0.5) {
      const ry = this._roadHeight(xCar + sx, bumpHeight);
      canvas.line(sx, ry, sx - 0.15, ry - 0.2, '#334155', 1);
    }

    // ── Road section labels ──
    for (let sx = -6; sx < 6; sx += 0.5) {
      const sec = this._roadSection(xCar + sx);
      if (sec !== 'flat') {
        const ry = this._roadHeight(xCar + sx, bumpHeight);
        const secXm = ((xCar + sx) % 60 + 60) % 60;
        // Label at start of each section
        if (sec === 'bump' && secXm >= 8 && secXm < 8.5) {
          canvas.text(sx, ry + 0.35, 'BUMP', '#F59E0B', 8);
        } else if (sec === 'washboard' && secXm >= 20 && secXm < 20.5) {
          canvas.text(sx + 2, ry + 0.35, 'WASHBOARD', '#06B6D4', 8);
        } else if (sec === 'pothole' && secXm >= 48 && secXm < 48.5) {
          canvas.text(sx, ry - 0.35, 'POTHOLE', '#EF4444', 8);
        }
      }
    }

    // ── Upcoming feature indicator ──
    const nf = this._nextFeature(xCar);
    if (nf.dist < 12 && nf.dist > 2) {
      canvas.text(4.5, 2.8, nf.name + ' in ' + nf.dist.toFixed(0) + 'm', '#64748b', 8);
    }

    // ── Wheel ──
    const yr = this._roadHeight(xCar, bumpHeight);
    canvas.circle(0, yr + wheelR, wheelR, '#475569', '#64748b');
    // Wheel axle
    canvas.circle(0, yr + wheelR, 0.06, '#94A3B8', null);

    // ── Body position ──
    const bodyY = y + rideH;
    const bodyBot = bodyY - bodyH / 2;
    const wheelTop = yr + 2 * wheelR;

    // ── Spring (left side) ──
    canvas.spring(-0.35, wheelTop, -0.35, bodyBot, 8, 0.12, '#06B6D4');

    // ── Damper (right side) ──
    const dx = 0.35;
    const dBot = wheelTop;
    const dTop = bodyBot;
    const dMid = (dBot + dTop) / 2;
    const cylW = 0.07;
    // Cylinder (lower half)
    canvas.line(dx - cylW, dBot, dx - cylW, dMid + 0.02, '#F59E0B', 2);
    canvas.line(dx + cylW, dBot, dx + cylW, dMid + 0.02, '#F59E0B', 2);
    canvas.line(dx - cylW, dBot, dx + cylW, dBot, '#F59E0B', 1);
    // Piston rod (upper half)
    canvas.line(dx, dMid, dx, dTop, '#F59E0B', 2.5);
    // Piston head
    canvas.line(dx - cylW + 0.01, dMid, dx + cylW - 0.01, dMid, '#F59E0B', 2);

    // ── Car body ──
    canvas.rect(-bodyW / 2, bodyBot, bodyW, bodyH, '#8B5CF6', '#A78BFA');
    canvas.text(0, bodyY, mass + 'kg', '#FFF', 9);

    // ── Suspension deflection indicator ──
    const deflection = y - yr;
    const deflMM = (deflection * 1000).toFixed(0);
    canvas.text(1.8, bodyY, 'δ=' + deflMM + 'mm', '#94A3B8', 8);

    // ── Damping info ──
    const bc = 2 * Math.sqrt(mass * stiffness);
    const zeta = damping / bc;
    const fn = Math.sqrt(stiffness / mass) / (2 * Math.PI);
    canvas.text(0, 3.2, 'f₀ = ' + fn.toFixed(2) + ' Hz     ζ = ' + zeta.toFixed(2), '#94A3B8', 10);

    const dampLabel = zeta < 0.01 ? 'UNDAMPED' :
                      zeta < 0.95 ? 'UNDERDAMPED' :
                      zeta < 1.05 ? 'CRITICALLY DAMPED' :
                      'OVERDAMPED';
    const dampColor = zeta < 0.01 ? '#EF4444' :
                      zeta < 0.95 ? '#F59E0B' :
                      zeta < 1.05 ? '#22C55E' :
                      '#06B6D4';
    canvas.text(0, 2.9, dampLabel, dampColor, 11);

    // Speed
    const kmh = (carSpeed * 3.6).toFixed(0);
    canvas.text(-4, 2.9, kmh + ' km/h', '#94A3B8', 9);

    // ── Legend ──
    canvas.text(-4.5, -0.9, '● Bump', '#F59E0B', 7);
    canvas.text(-2.5, -0.9, '● Washboard', '#06B6D4', 7);
    canvas.text(-0.2, -0.9, '● Pothole', '#EF4444', 7);
  },

  info: `
    <h2>Car Suspension — Quarter-Car Model</h2>
    <p>A car body rides on a spring + damper suspension. The wheel follows the road surface exactly (simplified: zero unsprung mass). As the car drives over bumps, potholes, and washboard roads, the suspension determines how the body responds.</p>

    <h3>The Key Insight: Damping Ratio</h3>
    <p>The <strong>damping ratio</strong> <code>ζ = b / (2√(mk))</code> controls everything:</p>
    <ul>
      <li><strong style="color:#F59E0B;">ζ &lt; 1 (underdamped):</strong> Body oscillates after hitting a bump. Sporty but rough.</li>
      <li><strong style="color:#22C55E;">ζ = 1 (critically damped):</strong> Fastest settling with no overshoot. The engineering ideal.</li>
      <li><strong style="color:#06B6D4;">ζ &gt; 1 (overdamped):</strong> No oscillation but slow return. Feels mushy.</li>
      <li><strong style="color:#EF4444;">ζ = 0 (no damping):</strong> Bounces forever! Broken shock absorbers.</li>
    </ul>

    <h3>Equation of Motion</h3>
    <p><code>m·ÿ = −k·(y − y_road) − b·(ẏ − ẏ_road)</code></p>
    <p>The spring resists compression/extension from natural ride height. The damper resists relative velocity between body and wheel.</p>

    <h3>Road Features</h3>
    <ul>
      <li><strong style="color:#F59E0B;">Speed Bump:</strong> A single half-sine bump. Tests transient response — how quickly does the body settle?</li>
      <li><strong style="color:#06B6D4;">Washboard:</strong> Repeated sinusoidal bumps. Tests forced response. At the right speed, you can hit <strong>resonance</strong> where oscillations grow dramatically.</li>
      <li><strong style="color:#EF4444;">Pothole:</strong> A negative bump. Body drops into the hole then recovers.</li>
    </ul>

    <h3>Resonance</h3>
    <p>The washboard has wavelength 5m. Resonance occurs when forcing frequency = natural frequency:</p>
    <p><code>v / λ = f₀ = √(k/m) / (2π)</code></p>
    <p>With default params: f₀ ≈ 1.0 Hz, so resonant speed ≈ 5 m/s (18 km/h). Try the "Washboard Resonance" preset!</p>

    <h3>Try These</h3>
    <ol>
      <li><strong>Compare damping:</strong> Switch between underdamped / critically damped / overdamped and watch the body response after the speed bump.</li>
      <li><strong>No damping:</strong> The body bounces indefinitely. On the washboard, it's dangerously violent.</li>
      <li><strong>Washboard resonance:</strong> With low damping (ζ≈0.16) at 5 m/s, watch oscillations grow until the body hits the limits.</li>
      <li><strong>Phase plot:</strong> Underdamped spirals inward. Critically damped goes straight to origin. On washboard: limit cycle.</li>
      <li><strong>Drag the body:</strong> Pull the car body up or down, then release to see the free decay response.</li>
    </ol>
  `,
};
