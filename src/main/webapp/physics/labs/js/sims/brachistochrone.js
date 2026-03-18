/**
 * Brachistochrone — Race on Different Curves
 *
 * Four balls race from A to B on different curves under gravity.
 * The cycloid (brachistochrone) is always fastest — the famous result
 * first solved by Johann Bernoulli in 1696.
 *
 * Physics: bead on wire y = f(x), using Lagrangian constraint:
 *   ẍ = (g·f' - ẋ²·f'·f'') / (1 + f'²)
 *
 * Convention: y-down positive (gravity in +y direction).
 *
 * State: [x₁,v₁, x₂,v₂, x₃,v₃, x₄,v₄, time]
 *
 * Reference: myphysicslab/src/sims/roller/BrachistoSim.ts
 */

// ═══════════════════════════════════════════
// CURVE DEFINITIONS
// ═══════════════════════════════════════════

const D = 3;    // horizontal distance
const H = 2;    // vertical drop (y-down)

/** Straight line: y = (H/D)·x */
const LINE = {
  name: 'Line',
  color: '#EF4444',
  y:  (x) => (H / D) * x,
  dy: (x) => H / D,
  d2y:(x) => 0,
};

/** Steep parabola: y = H·(1 - (1-x/D)²) — drops fast then flattens */
const PARABOLA = {
  name: 'Parabola',
  color: '#F59E0B',
  y:  (x) => H * (1 - (1 - x / D) ** 2),
  dy: (x) => 2 * H * (1 - x / D) / D,
  d2y:(x) => -2 * H / (D * D),
};

/** Circle arc through (0,0) and (D,H) */
const CIRCLE = (() => {
  // Circle passing through origin and (D,H) with center on perpendicular bisector
  // Center: (D/2 + t·(-H/L), H/2 + t·(D/L)) where L = sqrt(D²+H²), t chosen for curvature
  const R = (D * D + H * H) / (2 * H); // radius for circle tangent at origin going through (D,H)
  const cx = 0, cy = R; // center directly above origin
  return {
    name: 'Circle',
    color: '#10B981',
    y:  (x) => { const val = cy - Math.sqrt(Math.max(0, R * R - (x - cx) ** 2)); return Math.max(0, val); },
    dy: (x) => { const sq = Math.max(0.01, R * R - (x - cx) ** 2); return (x - cx) / Math.sqrt(sq); },
    d2y:(x) => { const sq = Math.max(0.01, R * R - (x - cx) ** 2); return R * R / (sq * Math.sqrt(sq)); },
  };
})();

/** Cycloid (brachistochrone) — the optimal curve, computed numerically */
const CYCLOID = (() => {
  // Cycloid: x(θ) = r(θ - sinθ), y(θ) = r(1 - cosθ)
  // Find r so that (x(θ_end), y(θ_end)) = (D, H)
  // Use Newton's method to find θ_end, then r = H / (1 - cos(θ_end))
  let thetaEnd = Math.PI; // initial guess
  for (let iter = 0; iter < 20; iter++) {
    const r = H / (1 - Math.cos(thetaEnd));
    const xEnd = r * (thetaEnd - Math.sin(thetaEnd));
    const dxdtheta = r * (1 - Math.cos(thetaEnd)); // = H (at θ_end)
    // Newton step: x(θ) - D = 0
    thetaEnd -= (xEnd - D) / dxdtheta;
    if (thetaEnd < 0.1) thetaEnd = 0.1;
    if (thetaEnd > 2 * Math.PI) thetaEnd = 2 * Math.PI;
  }
  const r = H / (1 - Math.cos(thetaEnd));

  // Build lookup table: θ → (x, y) then interpolate x → θ → y, dy, d2y
  const N = 200;
  const table = [];
  for (let i = 0; i <= N; i++) {
    const th = (i / N) * thetaEnd;
    table.push({
      x: r * (th - Math.sin(th)),
      y: r * (1 - Math.cos(th)),
      th,
    });
  }

  function thetaFromX(x) {
    // Binary search in table
    if (x <= 0) return 0;
    if (x >= D) return thetaEnd;
    let lo = 0, hi = N;
    while (hi - lo > 1) {
      const mid = (lo + hi) >> 1;
      if (table[mid].x < x) lo = mid; else hi = mid;
    }
    const frac = (x - table[lo].x) / (table[hi].x - table[lo].x + 1e-12);
    return table[lo].th + frac * (table[hi].th - table[lo].th);
  }

  return {
    name: 'Cycloid',
    color: '#8B5CF6',
    y: (x) => {
      const th = thetaFromX(x);
      return r * (1 - Math.cos(th));
    },
    dy: (x) => {
      const th = thetaFromX(x);
      // dy/dx = sin(θ) / (1 - cos(θ)). At θ→0: limit is ∞ (vertical cusp). Use ≈ 2/θ.
      if (th < 0.001) return 2000; // large but finite, avoids NaN
      const denom = 1 - Math.cos(th);
      return denom < 1e-10 ? 2000 : Math.sin(th) / denom;
    },
    d2y: (x) => {
      const th = thetaFromX(x);
      const denom = 1 - Math.cos(th);
      if (th < 0.001 || denom < 1e-10) return -1e6; // steep concavity at cusp
      // d²y/dx² = -1 / (r·(1 - cosθ)²)
      return -1 / (r * denom * denom);
    },
  };
})();

const CURVES = [CYCLOID, LINE, PARABOLA, CIRCLE];

// ═══════════════════════════════════════════
// SIM DEFINITION
// ═══════════════════════════════════════════

export const BrachistochroneSim = {
  name: 'Brachistochrone',
  slug: 'brachistochrone',
  category: 'Mechanics',

  vars: {
    x1: { index: 0, label: 'Cycloid x',  symbol: 'x_cyc' },
    v1: { index: 1, label: 'Cycloid v',  symbol: 'v_cyc' },
    x2: { index: 2, label: 'Line x',     symbol: 'x_line' },
    v2: { index: 3, label: 'Line v',     symbol: 'v_line' },
    x3: { index: 4, label: 'Parabola x', symbol: 'x_par' },
    v3: { index: 5, label: 'Parabola v', symbol: 'v_par' },
    x4: { index: 6, label: 'Circle x',   symbol: 'x_circ' },
    v4: { index: 7, label: 'Circle v',   symbol: 'v_circ' },
    time: { index: 8, label: 'Time (s)',  symbol: 't' },
  },
  varCount: 9,

  params: {
    gravity: { value: 9.81, min: 1, max: 25, step: 0.1, label: 'Gravity', unit: 'm/s²' },
    damping: { value: 0,    min: 0, max: 2,  step: 0.01, label: 'Friction' },
  },

  views: ['sim', 'time', 'energy'],

  graphDefaults: {
    phase: { x: 'x1', y: 'v1' },
    time: ['x1', 'x2', 'x3', 'x4'],
  },

  worldRect: { xMin: -0.5, xMax: 4, yMin: -2.8, yMax: 0.8 },

  presets: [
    { name: 'Default Race', params: {} },
    { name: 'Low Gravity',  params: { gravity: 2 } },
    { name: 'Moon',          params: { gravity: 1.62 } },
    { name: 'With Friction', params: { damping: 0.5 } },
  ],

  init() {
    // Start slightly past x=0 to avoid zero/undefined slopes at the origin
    // (cycloid has dy/dx = 0/0 at θ=0, circle has dy/dx = 0 at x=0)
    const x0 = 0.02;
    return [x0, 0, x0, 0, x0, 0, x0, 0, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[8] = 1;
    if (isDragging) return;

    const { gravity: g, damping: b } = params;

    for (let i = 0; i < 4; i++) {
      const x = vars[i * 2];
      const v = vars[i * 2 + 1];
      const curve = CURVES[i];

      // Ball reached the end — stop
      if (x >= D) {
        change[i * 2] = 0;
        change[i * 2 + 1] = 0;
        continue;
      }

      const fp = curve.dy(x);   // f'(x) = dy/dx
      const fpp = curve.d2y(x); // f''(x) = d²y/dx²
      const denom = 1 + fp * fp;

      // Bead on wire: ẍ = (g·f' - 2ẋ²·f'·f'') / (1 + f'²) - damping
      change[i * 2] = v;
      change[i * 2 + 1] = (g * fp - 2 * v * v * fp * fpp) / denom - b * v;
    }
  },

  /** Clamp balls to valid range */
  postStep(vars) {
    for (let i = 0; i < 4; i++) {
      if (vars[i * 2] < 0) { vars[i * 2] = 0; vars[i * 2 + 1] = Math.max(0, vars[i * 2 + 1]); }
      if (vars[i * 2] >= D) { vars[i * 2] = D; vars[i * 2 + 1] = 0; }
    }
  },

  energy(vars, params) {
    const g = params.gravity;
    let KE = 0, PE = 0;
    for (let i = 0; i < 4; i++) {
      const x = vars[i * 2], v = vars[i * 2 + 1];
      const curve = CURVES[i];
      const fp = curve.dy(x);
      const speed2 = v * v * (1 + fp * fp);
      KE += 0.5 * speed2;
      PE += g * (H - curve.y(x)); // PE = g(H - y), always non-negative. Zero when ball reaches bottom.
    }
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  // Click on canvas → find nearest curve, drop ball from that x position
  _selectedCurve: -1,

  hitTest(wx, wy, vars, params) {
    // Find which curve is closest to the click point
    let bestCurve = -1, bestDist = Infinity;
    for (let c = 0; c < 4; c++) {
      const curveY = -CURVES[c].y(Math.max(0, Math.min(D, wx))); // canvas y (negated)
      const dist = Math.abs(wy - curveY);
      if (dist < bestDist) { bestDist = dist; bestCurve = c; }
    }
    if (bestDist < 0.5 && wx >= 0 && wx <= D) {
      return { id: 'curve', curveIdx: bestCurve, dropX: Math.max(0.01, Math.min(D - 0.1, wx)) };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    if (id === 'curve') {
      // Drop all balls from this x position on their respective curves
      const dropX = Math.max(0.01, Math.min(D - 0.1, wx));
      for (let i = 0; i < 4; i++) {
        vars[i * 2] = dropX;
        vars[i * 2 + 1] = 0;
      }
      this._selectedCurve = offset.curveIdx;
    }
  },

  onRelease(id, vars, params) {
    // On release, balls race from current position
    // Already in correct state from onDrag
  },

  // --- Rendering ---

  render(canvas, vars, params) {
    // Draw curves — selected curve is brighter
    for (let c = 0; c < 4; c++) {
      const curve = CURVES[c];
      const isSelected = c === this._selectedCurve;
      const alpha = isSelected ? 'CC' : '50';
      const width = isSelected ? 3 : 1.5;
      const steps = 80;
      for (let i = 0; i < steps; i++) {
        const x0 = (i / steps) * D;
        const x1 = ((i + 1) / steps) * D;
        canvas.line(x0, -curve.y(x0), x1, -curve.y(x1), curve.color + alpha, width);
      }
      // Curve label at midpoint
      const mx = D * 0.5;
      const my = -curve.y(mx);
      canvas.text(mx + 0.15, my + 0.12, curve.name, curve.color + '90', 8);
    }

    // Start and end markers
    canvas.circle(0, 0, 0.07, '#ffffff', '#ffffff40');
    canvas.text(-0.35, 0.05, 'START', '#ffffff60', 8);
    canvas.circle(D, -H, 0.07, '#ffffff', '#ffffff40');
    canvas.text(D - 0.3, -H - 0.2, 'END', '#ffffff60', 8);

    // Click hint
    canvas.text(canvas.world.xMax - 1.5, canvas.world.yMax - 0.1, 'Click a curve to drop balls', '#64748b60', 8);

    // Balls on curves
    const finished = [];
    for (let c = 0; c < 4; c++) {
      const curve = CURVES[c];
      const x = Math.min(vars[c * 2], D);
      const y = -curve.y(x);
      canvas.circle(x, y, 0.08, curve.color, '#ffffff60');

      // Finish detection
      if (x >= D - 0.01) finished.push({ name: curve.name, color: curve.color });
    }

    // Legend + finish order
    for (let c = 0; c < 4; c++) {
      const curve = CURVES[c];
      const lx = canvas.world.xMin + 0.15;
      const ly = canvas.world.yMax - 0.15 - c * 0.2;
      canvas.circle(lx, ly, 0.04, curve.color, null);
      canvas.text(lx + 0.1, ly, curve.name, curve.color, 9);
    }

    // Winner announcement
    if (finished.length > 0) {
      canvas.text(D / 2 - 0.5, -H - 0.3, finished[0].name + ' wins!', finished[0].color, 12);
    }
  },

  info: `
    <h2>The Brachistochrone — Curve of Fastest Descent</h2>
    <p>Four balls race from point A to point B under gravity, each on a different curve. Which path is fastest? This is the <strong>brachistochrone problem</strong>, first posed by Johann Bernoulli in 1696 and solved using calculus of variations.</p>

    <h3>The Curves</h3>
    <ul>
      <li><strong style="color:#8B5CF6">Cycloid (violet):</strong> The optimal curve — always wins! A cycloid is the path traced by a point on a rolling circle</li>
      <li><strong style="color:#EF4444">Straight line (red):</strong> Shortest distance but NOT fastest time</li>
      <li><strong style="color:#F59E0B">Parabola (yellow):</strong> Drops quickly then flattens — fast start but slow finish</li>
      <li><strong style="color:#10B981">Circle arc (green):</strong> Smooth curve, but not optimal</li>
    </ul>

    <h3>Physics</h3>
    <p>Each ball is a bead constrained to its wire. The equation of motion for a bead on curve y = f(x):</p>
    <p><code>ẍ = (g·f' - ẋ²·f'·f'') / (1 + f'²)</code></p>
    <p>This is derived from the Lagrangian with the constraint that the ball stays on the curve.</p>

    <h3>Why the Cycloid Wins</h3>
    <p>The cycloid dips steeply at the start, converting potential energy to kinetic energy early. The ball reaches high speed quickly, then takes a longer but faster path. The straight line is shorter in distance but the ball accelerates slowly because the slope is constant and moderate.</p>
    <p>Mathematically, the cycloid minimizes the <strong>time functional</strong>:</p>
    <p><code>T = ∫ ds/v = ∫ √(1+f'²) / √(2gy) dx</code></p>
    <p>The Euler-Lagrange equation for this integral gives the cycloid as the unique solution.</p>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Watch the race:</strong> Default settings — the cycloid wins every time, even though it's a longer path</li>
      <li><strong>Low gravity:</strong> Slower race, but relative order stays the same — the cycloid is optimal for any gravity</li>
      <li><strong>Add friction:</strong> With friction, the advantage of the cycloid is reduced (but it usually still wins)</li>
      <li><strong>Watch the Time tab:</strong> See each ball's x-position over time — the cycloid reaches x=3 first</li>
    </ol>

    <h3>Historical Significance</h3>
    <p>The brachistochrone problem launched the field of <strong>calculus of variations</strong> — the mathematics of optimizing functions of functions. Solutions were contributed by Newton, Leibniz, L'Hôpital, and the Bernoulli brothers. It remains a cornerstone problem in physics and mathematics education.</p>

    <h3>Real-World Applications</h3>
    <ul>
      <li><strong>Roller coaster design:</strong> Initial drops use cycloid-like curves for maximum thrill</li>
      <li><strong>Optimal trajectories:</strong> Spacecraft reentry paths use similar variational principles</li>
      <li><strong>Fermat's principle:</strong> Light follows the brachistochrone through media with varying refractive index (Snell's law)</li>
    </ul>
  `,
};
