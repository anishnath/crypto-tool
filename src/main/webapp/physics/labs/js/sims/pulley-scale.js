/**
 * Pulley-Spring Scale System
 *
 * A ∩-shaped frame with two frictionless pulleys at the top corners.
 * A single continuous rope runs:
 *   down left → over left pulley → horizontally across → over right pulley → down right
 *
 * Weights hang from each end. A spring scale is in-line with the
 * horizontal rope segment between the pulleys.
 *
 * KEY PHYSICS INSIGHT:
 *   Tension in a continuous frictionless rope is CONSTANT throughout.
 *   The spring scale reads the TENSION, not the sum of the weights.
 *   With equal 100N weights on each side → scale reads 100N (not 200N).
 *
 *   With unequal weights: the system accelerates, and
 *   T = 2·m₁·m₂·g / (m₁ + m₂)  (Atwood machine formula)
 *
 * State: [s, v, time]
 *   s  = how far the left mass has moved down (right mass moves up by same amount)
 *   v  = velocity (positive = left mass descending)
 *
 * Coordinate system: y increases UPWARD for rendering.
 */

const G = 9.81;

// Frame geometry (world coords, y-up)
const FRAME_W = 3.0;      // half-width of frame
const FRAME_H = 4.5;      // height: ground to beam
const BEAM_Y = FRAME_H;   // beam at top
const PULLEY_R = 0.2;     // pulley wheel radius
const ROPE_LEN = 3.0;     // initial rope length from pulley down to weight
const SCALE_W = 0.6;      // spring scale width
const SCALE_H = 0.3;      // spring scale height

export const PulleyScaleSim = {
  name: 'Pulley–Spring Scale',
  slug: 'pulley-scale',
  category: 'Mechanics',

  vars: {
    position: { index: 0, label: 'Displacement (m)',  symbol: 's' },
    velocity: { index: 1, label: 'Velocity (m/s)',    symbol: 'v' },
    time:     { index: 2, label: 'Time (s)',           symbol: 't' },
  },
  varCount: 3,

  params: {
    m1:       { value: 10,  min: 1,  max: 50,  step: 0.5, label: 'Left Mass',   unit: 'kg' },
    m2:       { value: 10,  min: 1,  max: 50,  step: 0.5, label: 'Right Mass',  unit: 'kg' },
    gravity:  { value: 9.81, min: 0.1, max: 25, step: 0.1, label: 'Gravity g',  unit: 'm/s²' },
    damping:  { value: 0.5, min: 0,  max: 5,   step: 0.1, label: 'Damping',     unit: '' },
  },

  views: ['sim'],

  worldRect: { xMin: -5, xMax: 5, yMin: -1, yMax: 6 },

  presets: [
    { name: 'Equal Masses (100N each)',   params: { m1: 10, m2: 10 } },
    { name: 'Unequal (50N vs 100N)',      params: { m1: 5,  m2: 10 } },
    { name: 'Heavy Left (150N vs 50N)',   params: { m1: 15, m2: 5 } },
    { name: 'Light (10N each)',           params: { m1: 1,  m2: 1 } },
    { name: 'Very Unequal (200N vs 10N)', params: { m1: 20, m2: 1 } },
    { name: 'No Damping (Equal)',          params: { m1: 10, m2: 10, damping: 0 } },
    { name: 'Moon (g=1.62)',              params: { m1: 10, m2: 10, gravity: 1.62 } },
    { name: 'Mars (g=3.72)',              params: { m1: 10, m2: 5, gravity: 3.72 } },
    { name: 'Jupiter (g=24.79)',          params: { m1: 10, m2: 10, gravity: 24.79 } },
  ],

  // Internal state
  _scaleReading: 0,
  _tension: 0,
  _ropeSlack: false,     // true when a mass is on the ground and rope is slack
  _groundedSide: null,   // 'left' | 'right' | null

  init(p) {
    const g = p.gravity || G;
    const mTotal = p.m1 + p.m2;
    const a0 = (p.m1 - p.m2) * g / mTotal;
    this._tension = p.m1 * (g - a0);
    this._scaleReading = this._tension;
    this._ropeSlack = false;
    this._groundedSide = null;
    return [0, 0, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[2] = 1;
    if (isDragging) return;

    const [s, v] = vars;
    const { m1, m2, damping } = params;
    const g = params.gravity || G;
    const mTotal = m1 + m2;

    // Compute mass positions
    const leftMassY  = BEAM_Y - ROPE_LEN - s;
    const rightMassY = BEAM_Y - ROPE_LEN + s;
    const leftW  = 0.2 + Math.sqrt(m1) * 0.08;
    const rightW = 0.2 + Math.sqrt(m2) * 0.08;

    // Ground collision: mass bottom touches y=0
    const leftOnGround  = (leftMassY - leftW) <= 0.01;
    const rightOnGround = (rightMassY - rightW) <= 0.01;

    if (leftOnGround && v > 0) {
      // Left mass hit ground (was descending: v > 0)
      // Rope goes slack — right mass is free projectile going up then falling
      this._ropeSlack = true;
      this._groundedSide = 'left';
      // Right mass: free fall (only gravity, no tension)
      change[0] = 0;  // s doesn't change (left is stuck on ground)
      change[1] = -v * 0.3;  // partial bounce / stop
      this._tension = 0;
      this._scaleReading = 0;
      return;
    }

    if (rightOnGround && v < 0) {
      // Right mass hit ground (was descending: v < 0)
      this._ropeSlack = true;
      this._groundedSide = 'right';
      change[0] = 0;
      change[1] = -v * 0.3;
      this._tension = 0;
      this._scaleReading = 0;
      return;
    }

    // If rope was slack, check if it re-tensions
    if (this._ropeSlack) {
      // The grounded mass stays put. The other mass is in free fall.
      // For simplicity: apply gravity to move the free mass down
      // When the free mass descends enough that the rope becomes taut, resume Atwood
      if (this._groundedSide === 'left') {
        // Left on ground, right is free. Right mass at rightMassY.
        // Right mass free falls: a = -g (downward)
        change[0] = v;
        change[1] = -g - damping * v / m2;  // only right mass moves
        this._tension = 0;
        this._scaleReading = 0;
        // Check: has right mass descended to where rope is taut again?
        if (rightMassY <= BEAM_Y - ROPE_LEN + 0.1 && v < 0) {
          this._ropeSlack = false;
          this._groundedSide = null;
        }
      } else {
        // Right on ground, left is free
        change[0] = v;
        change[1] = g - damping * v / m1;  // only left mass moves (positive = left descends)
        this._tension = 0;
        this._scaleReading = 0;
        if (leftMassY <= BEAM_Y - ROPE_LEN + 0.1 && v > 0) {
          this._ropeSlack = false;
          this._groundedSide = null;
        }
      }
      return;
    }

    // Normal Atwood motion (rope taut, both masses connected)
    const accel = ((m1 - m2) * g - damping * v) / mTotal;
    change[0] = v;
    change[1] = accel;

    this._tension = m1 * (g - accel);
    this._scaleReading = Math.max(0, this._tension);
  },

  // Clamp masses to not go below ground
  postStep(vars, params) {
    const leftW  = 0.2 + Math.sqrt(params.m1) * 0.08;
    const rightW = 0.2 + Math.sqrt(params.m2) * 0.08;
    const leftMassY  = BEAM_Y - ROPE_LEN - vars[0];
    const rightMassY = BEAM_Y - ROPE_LEN + vars[0];

    // Left mass can't go below ground
    if (leftMassY - leftW < 0) {
      vars[0] = BEAM_Y - ROPE_LEN - leftW;  // clamp s
      if (vars[1] > 0) vars[1] = 0;         // stop downward velocity
    }
    // Right mass can't go below ground
    if (rightMassY - rightW < 0) {
      vars[0] = -(BEAM_Y - ROPE_LEN - rightW);
      if (vars[1] < 0) vars[1] = 0;
    }
    // Neither mass can go above the pulley
    if (leftMassY + leftW > BEAM_Y - PULLEY_R) {
      vars[0] = BEAM_Y - ROPE_LEN - (BEAM_Y - PULLEY_R - leftW);
    }
    if (rightMassY + rightW > BEAM_Y - PULLEY_R) {
      vars[0] = -(BEAM_Y - ROPE_LEN - (BEAM_Y - PULLEY_R - rightW));
    }
  },

  hitTest(wx, wy, vars, params) {
    // Drag left mass
    const leftY = BEAM_Y - ROPE_LEN - vars[0];
    if (Math.abs(wx - (-FRAME_W)) < 0.5 && Math.abs(wy - leftY) < 0.5) {
      return { id: 'leftMass', offsetY: wy - leftY };
    }
    // Drag right mass
    const rightY = BEAM_Y - ROPE_LEN + vars[0];
    if (Math.abs(wx - FRAME_W) < 0.5 && Math.abs(wy - rightY) < 0.5) {
      return { id: 'rightMass', offsetY: wy - rightY };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    if (id === 'leftMass') {
      const targetY = wy - offset.offsetY;
      vars[0] = BEAM_Y - ROPE_LEN - targetY;
      vars[1] = 0;
    } else if (id === 'rightMass') {
      const targetY = wy - offset.offsetY;
      vars[0] = -(BEAM_Y - ROPE_LEN - targetY);
      vars[1] = 0;
    }
  },

  render(canvas, vars, params) {
    const [s, v] = vars;
    const { m1, m2 } = params;
    const ctx = canvas.ctx;  // raw canvas context for advanced drawing

    const leftPulleyX = -FRAME_W, rightPulleyX = FRAME_W;
    const pulleyY = BEAM_Y;
    const leftMassY  = pulleyY - ROPE_LEN - s;
    const rightMassY = pulleyY - ROPE_LEN + s;
    const leftW  = 0.2 + Math.sqrt(m1) * 0.08;
    const rightW = 0.2 + Math.sqrt(m2) * 0.08;
    const reading = this._scaleReading;

    // ── Frame (∩ shape) ──
    canvas.line(-FRAME_W - 0.3, 0, -FRAME_W - 0.3, BEAM_Y, '#475569', 4);
    canvas.line(FRAME_W + 0.3, 0, FRAME_W + 0.3, BEAM_Y, '#475569', 4);
    canvas.line(-FRAME_W - 0.5, BEAM_Y, FRAME_W + 0.5, BEAM_Y, '#64748b', 6);
    for (let x = -FRAME_W; x <= FRAME_W; x += 0.4) {
      canvas.line(x, BEAM_Y, x + 0.15, BEAM_Y + 0.15, '#475569', 1);
    }

    // ── Ground ──
    canvas.line(-4.5, 0, 4.5, 0, '#334155', 2);
    for (let x = -4.2; x <= 4.2; x += 0.3) {
      canvas.line(x, 0, x - 0.12, -0.12, '#334155', 1);
    }
    // Gravity label
    const gVal = params.gravity || G;
    const gLabel = gVal === 9.81 ? 'Earth' : gVal === 1.62 ? 'Moon' : gVal === 3.72 ? 'Mars' : gVal === 24.79 ? 'Jupiter' : 'Custom';
    canvas.text(4.0, 0.25, 'g = ' + gVal.toFixed(2) + ' m/s²', '#64748b', 8);
    canvas.text(4.0, 0.45, gLabel, '#64748b', 7);

    // ── Pulleys (larger, with groove) ──
    canvas.circle(leftPulleyX, pulleyY, PULLEY_R, '#64748b', '#94a3b8');
    canvas.circle(leftPulleyX, pulleyY, PULLEY_R * 0.4, '#475569', null);
    canvas.circle(rightPulleyX, pulleyY, PULLEY_R, '#64748b', '#94a3b8');
    canvas.circle(rightPulleyX, pulleyY, PULLEY_R * 0.4, '#475569', null);

    // ── Rope (continuous, with arcs at pulleys) ──
    const ropeColor = reading > m1 * G * 0.95 ? '#f59e0b' : '#fbbf24';

    // Left vertical: mass top → pulley bottom
    canvas.line(leftPulleyX, leftMassY + leftW, leftPulleyX, pulleyY - PULLEY_R, ropeColor, 2.5);
    // Left pulley quarter arc (bottom to right)
    canvas.line(leftPulleyX, pulleyY - PULLEY_R, leftPulleyX + PULLEY_R, pulleyY, ropeColor, 2.5);
    // Horizontal: left pulley → scale left
    canvas.line(leftPulleyX + PULLEY_R, pulleyY, -SCALE_W - 0.3, pulleyY, ropeColor, 2.5);
    // Horizontal: scale right → right pulley
    canvas.line(SCALE_W + 0.3, pulleyY, rightPulleyX - PULLEY_R, pulleyY, ropeColor, 2.5);
    // Right pulley quarter arc (left to bottom)
    canvas.line(rightPulleyX - PULLEY_R, pulleyY, rightPulleyX, pulleyY - PULLEY_R, ropeColor, 2.5);
    // Right vertical: pulley bottom → mass top
    canvas.line(rightPulleyX, pulleyY - PULLEY_R, rightPulleyX, rightMassY + rightW, ropeColor, 2.5);

    // ── Spring Scale (prominent, larger) ──
    const scaleY = pulleyY;
    const SW = 0.9, SH = 0.45;
    canvas.rect(-SW, scaleY - SH, SW * 2, SH * 2, '#0f172a', '#06b6d4');
    // Reading — large and bold
    canvas.text(0, scaleY + 0.05, reading.toFixed(1) + ' N', '#22d3ee', 16);
    // Label
    canvas.text(0, scaleY - SH - 0.12, 'SPRING SCALE', '#64748b', 7);
    // Spring coils on each side
    for (let side = -1; side <= 1; side += 2) {
      for (let i = 0; i < 4; i++) {
        const x0 = side * (SW + 0.05 + i * 0.07);
        const dy = (i % 2 === 0 ? 1 : -1) * 0.06;
        canvas.line(x0, scaleY + dy, x0 + side * 0.07, scaleY - dy, '#06b6d4', 1.5);
      }
    }

    // ── Left Mass ──
    canvas.rect(leftPulleyX - leftW, leftMassY - leftW, leftW * 2, leftW * 2, '#8B5CF6', '#A78BFA');
    canvas.text(leftPulleyX, leftMassY + 0.05, m1.toFixed(1) + ' kg', '#FFF', 11);
    canvas.text(leftPulleyX, leftMassY - leftW - 0.15, (m1 * (params.gravity || G)).toFixed(0) + ' N', '#C4B5FD', 9);

    // ── Right Mass ──
    canvas.rect(rightPulleyX - rightW, rightMassY - rightW, rightW * 2, rightW * 2, '#22C55E', '#4ADE80');
    canvas.text(rightPulleyX, rightMassY + 0.05, m2.toFixed(1) + ' kg', '#FFF', 11);
    canvas.text(rightPulleyX, rightMassY - rightW - 0.15, (m2 * (params.gravity || G)).toFixed(0) + ' N', '#86EFAC', 9);

    // ── Force arrows WITH arrowheads ──
    const drawArrow = (x, y1, y2, color, label, labelSide) => {
      canvas.line(x, y1, x, y2, color, 2.5);
      // Arrowhead (triangle)
      const dir = y2 > y1 ? 1 : -1;
      const tipY = y2;
      canvas.line(x - 0.06, tipY - dir * 0.1, x, tipY, color, 2);
      canvas.line(x + 0.06, tipY - dir * 0.1, x, tipY, color, 2);
      if (label) {
        const lx = x + (labelSide === 'left' ? -0.25 : 0.25);
        canvas.text(lx, (y1 + y2) / 2, label, color, 9);
      }
    };

    // Gravity arrows (down from mass bottom)
    const gArrowLen = Math.min(0.8, Math.max(0.3, m1 * G / 200));
    drawArrow(leftPulleyX + leftW + 0.2, leftMassY - leftW, leftMassY - leftW - gArrowLen, '#EF4444', 'mg', 'right');
    drawArrow(rightPulleyX - rightW - 0.2, rightMassY - rightW, rightMassY - rightW - gArrowLen, '#EF4444', 'mg', 'left');

    // Tension arrows (up from mass top)
    const tArrowLen = Math.min(0.8, Math.max(0.3, reading / 200));
    drawArrow(leftPulleyX - leftW - 0.2, leftMassY + leftW, leftMassY + leftW + tArrowLen, '#06B6D4', 'T', 'left');
    drawArrow(rightPulleyX + rightW + 0.2, rightMassY + rightW, rightMassY + rightW + tArrowLen, '#06B6D4', 'T', 'right');

    // ── Info text (formula only near equilibrium) ──
    const g = params.gravity || G;
    const T_theory = 2 * m1 * m2 * g / (m1 + m2);
    if (Math.abs(v) < 0.1) {
      canvas.text(0, -0.3, 'T = 2m₁m₂g/(m₁+m₂) = ' + T_theory.toFixed(1) + ' N', '#94A3B8', 10);
    } else {
      canvas.text(0, -0.3, 'Accelerating... T = ' + reading.toFixed(1) + ' N', '#F59E0B', 10);
    }

    if (this._ropeSlack) {
      canvas.text(0, -0.6, '⚠ ROPE SLACK — Mass on ground! T = 0 N', '#EF4444', 12);
      canvas.text(0, -0.9, 'Other mass is in FREE FALL (no tension)', '#F59E0B', 10);
      // Draw slack rope indicator (dashed style on horizontal segment)
      canvas.text(0, pulleyY + 0.25, '~ slack ~', '#EF4444', 8);
    } else if (m1 === m2) {
      canvas.text(0, -0.6, '✓ Equal masses → Scale reads mg = ' + (m1 * (params.gravity || G)).toFixed(1) + ' N  (NOT ' + (2 * m1 * G).toFixed(0) + 'N!)', '#22C55E', 11);
    } else {
      const aNet = Math.abs(m1 - m2) * g / (m1 + m2);
      canvas.text(0, -0.6, 'Unequal → a = ' + aNet.toFixed(2) + ' m/s²  |  T < max weight', '#F59E0B', 10);
    }
  },

  info: `
    <h2>Pulley–Spring Scale System</h2>
    <p>A ∩-shaped frame with two frictionless pulleys. A single rope runs over both pulleys with weights on each end. A spring scale measures the tension in the horizontal rope segment.</p>

    <h3>The Common Misconception</h3>
    <p>Many students think: "100N pulling left + 100N pulling right = scale reads 200N." <strong>This is wrong.</strong></p>
    <p>The scale reads the <strong>tension in the rope</strong>, which is <strong>100N</strong> — the same throughout the entire continuous rope.</p>

    <h3>Why?</h3>
    <p>Think of it this way: the spring scale is like a bathroom scale. When you stand on a scale, the floor pushes up with the same force (your weight). The scale reads your weight — not your weight + the floor's reaction. Similarly, each side of the rope pulls with tension T. The scale measures T, not 2T.</p>

    <h3>The Math</h3>
    <p>For equal masses (m₁ = m₂ = m): <code>T = mg</code></p>
    <p>For unequal masses (Atwood machine):</p>
    <p><code>T = 2m₁m₂g / (m₁ + m₂)</code></p>
    <p><code>a = (m₁ − m₂)g / (m₁ + m₂)</code></p>

    <h3>Try These</h3>
    <ol>
      <li><strong>Equal masses (10 kg each):</strong> Scale reads 98.1N (= mg). System is in equilibrium.</li>
      <li><strong>Unequal (5 kg vs 10 kg):</strong> Scale reads 65.4N. System accelerates — heavier side descends.</li>
      <li><strong>Very unequal (20 kg vs 1 kg):</strong> Scale reads only 18.7N! The light mass barely resists.</li>
      <li><strong>Drag a mass:</strong> Pull one mass down. Release. Watch the Atwood oscillation with damping.</li>
      <li><strong>Ground collision:</strong> With unequal masses, the heavier one hits the ground. Watch: the rope goes slack, tension drops to 0, the lighter mass becomes a free projectile — then falls back and re-tensions the rope.</li>
    </ol>

    <h3>What Happens When a Mass Hits the Ground?</h3>
    <ol>
      <li>Heavy mass reaches the ground and <strong>stops</strong></li>
      <li>Rope goes <strong>slack</strong> — tension drops to <strong>0 N</strong> instantly</li>
      <li>The other mass continues upward as a <strong>free projectile</strong> (only gravity, no tension)</li>
      <li>It slows, stops, then <strong>falls back down</strong></li>
      <li>When it descends enough to pull the rope taut again, <strong>Atwood motion resumes</strong></li>
    </ol>

    <h3>Key Insight</h3>
    <p>The maximum the scale can ever read is <code>mg</code> (when masses are equal). With unequal masses, it reads <strong>less</strong> because the system accelerates — some of the gravitational force goes into acceleration, not tension.</p>
  `,
};
