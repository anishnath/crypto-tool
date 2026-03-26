/**
 * Series vs Parallel Springs — Side-by-Side Comparison
 *
 * Two independent spring-mass systems shown simultaneously:
 *   LEFT:  Two springs in SERIES → k_eff = k₁k₂/(k₁+k₂) — softer
 *   RIGHT: Two springs in PARALLEL → k_eff = k₁+k₂ — stiffer
 *
 * Both use the same k₁, k₂, m so students can directly compare:
 *   - Period (series is slower)
 *   - Amplitude (same if same initial displacement)
 *   - Equilibrium position (series stretches more under gravity)
 *
 * State: [y_series, vy_series, y_parallel, vy_parallel, time]
 *
 * Coordinate system: y increases UPWARD. Ceiling at ANCHOR_Y.
 */

const G = 9.81;
const ANCHOR_Y = 4.8;
const LEFT_X = -1.8;   // series side
const RIGHT_X = 1.8;   // parallel side

export const SeriesParallelSim = {
  name: 'Series vs Parallel Springs',
  slug: 'series-parallel-springs',
  category: 'Mechanics',

  vars: {
    ySeries:   { index: 0, label: 'Position (series)',   symbol: 'y_s' },
    vSeries:   { index: 1, label: 'Velocity (series)',   symbol: 'v_s' },
    yParallel: { index: 2, label: 'Position (parallel)', symbol: 'y_p' },
    vParallel: { index: 3, label: 'Velocity (parallel)', symbol: 'v_p' },
    time:      { index: 4, label: 'Time (s)',             symbol: 't' },
    eSeries:   { index: 5, label: 'Energy (series)',      symbol: 'E_s' },
    eParallel: { index: 6, label: 'Energy (parallel)',    symbol: 'E_p' },
  },
  varCount: 7,

  params: {
    mass:     { value: 1.0, min: 0.1, max: 10, step: 0.1, label: 'Mass',       unit: 'kg' },
    k1:       { value: 20,  min: 1,   max: 100, step: 1,  label: 'Spring k₁',  unit: 'N/m' },
    k2:       { value: 20,  min: 1,   max: 100, step: 1,  label: 'Spring k₂',  unit: 'N/m' },
    damping:  { value: 0.2, min: 0,   max: 5,  step: 0.05, label: 'Damping',   unit: '' },
    gravity:  { value: 9.81, min: 0.1, max: 25, step: 0.1, label: 'Gravity g', unit: 'm/s²' },
    startStretch: { value: 0.5, min: 0, max: 2, step: 0.1, label: 'Initial Stretch', unit: 'm' },
  },

  views: ['sim', 'time'],

  graphDefaults: {
    time: ['eSeries', 'eParallel'],
  },

  worldRect: { xMin: -4.5, xMax: 4.5, yMin: -1.5, yMax: 5.5 },

  presets: [
    { name: 'Equal Springs (k₁=k₂=20)',   params: { k1: 20, k2: 20 } },
    { name: 'Unequal (k₁=10, k₂=40)',     params: { k1: 10, k2: 40 } },
    { name: 'Very Stiff (k₁=k₂=80)',      params: { k1: 80, k2: 80 } },
    { name: 'Very Soft (k₁=k₂=5)',        params: { k1: 5,  k2: 5 } },
    { name: 'Heavy Mass',                  params: { mass: 5 } },
    { name: 'No Damping',                  params: { mass: 1, k1: 20, k2: 20, damping: 0 } },
    { name: 'One Weak Link (k₁=5, k₂=50)', params: { k1: 5, k2: 50 } },
  ],

  // Each individual spring has natural length L0_EACH = 0.8m
  // Series: total natural length = 2 × L0_EACH (two springs end-to-end)
  // Parallel: natural length = L0_EACH (both span the same gap)
  _L0_EACH: 0.8,
  _kSeries(p) { return p.k1 * p.k2 / (p.k1 + p.k2); },
  _kParallel(p) { return p.k1 + p.k2; },

  _eqSeries(p) {
    const g = p.gravity || G;
    return ANCHOR_Y - 2 * this._L0_EACH - p.mass * g / this._kSeries(p);
  },
  _eqParallel(p) {
    const g = p.gravity || G;
    return ANCHOR_Y - this._L0_EACH - p.mass * g / this._kParallel(p);
  },

  init(p) {
    const eqS = this._eqSeries(p);
    const eqP = this._eqParallel(p);
    return [eqS - p.startStretch, 0, eqP - p.startStretch, 0, 0, 0, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[4] = 1;
    if (isDragging) return;

    const { mass, damping } = params;
    const g = params.gravity || G;
    const kS = this._kSeries(params);
    const kP = this._kParallel(params);

    // Series system (natural length = 2 × L0_EACH)
    const [yS, vS] = [vars[0], vars[1]];
    const extS = (ANCHOR_Y - yS) - 2 * this._L0_EACH;
    change[0] = vS;
    change[1] = (kS * extS) / mass - g - (damping / mass) * vS;

    // Parallel system (natural length = L0_EACH)
    const [yP, vP] = [vars[2], vars[3]];
    const extP = (ANCHOR_Y - yP) - this._L0_EACH;
    change[2] = vP;
    change[3] = (kP * extP) / mass - g - (damping / mass) * vP;

    // Compute individual total energies (KE + spring PE + grav PE) for each system
    change[5] = 0; change[6] = 0;  // energy vars are set directly, not integrated
    vars[5] = 0.5 * mass * vS * vS + 0.5 * kS * extS * extS + mass * g * yS;
    vars[6] = 0.5 * mass * vP * vP + 0.5 * kP * extP * extP + mass * g * yP;
  },

  energy(vars, params) {
    const { mass } = params;
    const g = params.gravity || G;
    const kS = this._kSeries(params);
    const kP = this._kParallel(params);
    const extS = (ANCHOR_Y - vars[0]) - 2 * this._L0_EACH;
    const extP = (ANCHOR_Y - vars[2]) - this._L0_EACH;
    // Series energy
    const keS = 0.5 * mass * vars[1] * vars[1];
    const peS = 0.5 * kS * extS * extS + mass * g * vars[0];
    // Parallel energy
    const keP = 0.5 * mass * vars[3] * vars[3];
    const peP = 0.5 * kP * extP * extP + mass * g * vars[2];
    // Energy bar shows series energy (the more interesting one — softer spring)
    // Time graph shows both via vars[5] and vars[6]
    return { kinetic: keS + keP, potential: peS + peP, total: keS + peS + keP + peP };
  },

  theoreticalPeriod(params) {
    // Show series period (the slower one)
    return 2 * Math.PI * Math.sqrt(params.mass / this._kSeries(params));
  },
  periodVar: 1,

  hitTest(wx, wy, vars, params) {
    const blockW = 0.15 + Math.sqrt(params.mass) * 0.06;
    if (Math.abs(wx - LEFT_X) < blockW + 0.2 && Math.abs(wy - vars[0]) < blockW + 0.2) {
      return { id: 'series', offsetY: wy - vars[0] };
    }
    if (Math.abs(wx - RIGHT_X) < blockW + 0.2 && Math.abs(wy - vars[2]) < blockW + 0.2) {
      return { id: 'parallel', offsetY: wy - vars[2] };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars) {
    if (id === 'series') { vars[0] = wy - offset.offsetY; vars[1] = 0; }
    if (id === 'parallel') { vars[2] = wy - offset.offsetY; vars[3] = 0; }
  },

  onRelease() {},

  render(canvas, vars, params) {
    const { mass, k1, k2 } = params;
    const g = params.gravity || G;
    const kS = this._kSeries(params);
    const kP = this._kParallel(params);
    const blockW = 0.15 + Math.sqrt(mass) * 0.06;

    const yS = vars[0], yP = vars[2];
    const eqS = this._eqSeries(params);
    const eqP = this._eqParallel(params);

    // ── Ceiling ──
    canvas.line(-4, ANCHOR_Y, 4, ANCHOR_Y, '#64748B', 4);
    for (let i = -3.8; i <= 3.8; i += 0.2) {
      canvas.line(i, ANCHOR_Y, i + 0.1, ANCHOR_Y + 0.1, '#64748B', 1);
    }

    // ── Divider line ──
    canvas.line(0, ANCHOR_Y, 0, -1, '#334155', 1);

    // ── Labels ──
    canvas.text(LEFT_X, ANCHOR_Y + 0.35, 'SERIES', '#F59E0B', 11);
    canvas.text(RIGHT_X, ANCHOR_Y + 0.35, 'PARALLEL', '#22C55E', 11);

    // ═══ LEFT: SERIES (two springs end-to-end) ═══
    // Junction position: spring 1 stretches by F/k1, spring 2 by F/k2
    // Fraction of total span carried by spring 1 = (1/k1) / (1/k1 + 1/k2) = k2/(k1+k2)
    const totalSpan = ANCHOR_Y - (yS + blockW);
    const frac1 = k2 / (k1 + k2);  // fraction of span for spring 1 (softer spring stretches more)
    const midS = ANCHOR_Y - totalSpan * frac1;
    // Spring 1: ceiling to midpoint
    canvas.spring(LEFT_X, ANCHOR_Y, LEFT_X, midS, 8, 0.15, '#F59E0B');
    // Junction dot
    canvas.circle(LEFT_X, midS, 0.06, '#F59E0B', null);
    // Spring 2: midpoint to block
    canvas.spring(LEFT_X, midS, LEFT_X, yS + blockW, 8, 0.15, '#FB923C');
    // Block
    canvas.rect(LEFT_X - blockW, yS - blockW, blockW * 2, blockW * 2, '#8B5CF6', '#A78BFA');
    canvas.text(LEFT_X, yS, mass.toFixed(1) + 'kg', '#FFF', 9);
    // Spring labels
    canvas.text(LEFT_X - 0.6, (ANCHOR_Y + midS) / 2, 'k₁', '#F59E0B', 8);
    canvas.text(LEFT_X - 0.6, (midS + yS + blockW) / 2, 'k₂', '#FB923C', 8);
    // Equilibrium marker
    canvas.line(LEFT_X - 1.2, eqS, LEFT_X - 0.5, eqS, '#22C55E', 1);
    canvas.text(LEFT_X - 1.5, eqS, 'eq', '#22C55E', 7);

    // ═══ RIGHT: PARALLEL (two springs side by side) ═══
    const pSpacing = 0.3;
    // Spring 1 (left of pair)
    canvas.spring(RIGHT_X - pSpacing, ANCHOR_Y, RIGHT_X - pSpacing, yP + blockW, 12, 0.12, '#22C55E');
    // Spring 2 (right of pair)
    canvas.spring(RIGHT_X + pSpacing, ANCHOR_Y, RIGHT_X + pSpacing, yP + blockW, 12, 0.12, '#4ADE80');
    // Block (wider to connect both springs)
    canvas.rect(RIGHT_X - blockW - 0.15, yP - blockW, (blockW + 0.15) * 2, blockW * 2, '#8B5CF6', '#A78BFA');
    canvas.text(RIGHT_X, yP, mass.toFixed(1) + 'kg', '#FFF', 9);
    // Spring labels
    canvas.text(RIGHT_X - pSpacing - 0.4, (ANCHOR_Y + yP) / 2, 'k₁', '#22C55E', 8);
    canvas.text(RIGHT_X + pSpacing + 0.15, (ANCHOR_Y + yP) / 2, 'k₂', '#4ADE80', 8);
    // Equilibrium marker
    canvas.line(RIGHT_X + 0.5, eqP, RIGHT_X + 1.2, eqP, '#22C55E', 1);
    canvas.text(RIGHT_X + 1.4, eqP, 'eq', '#22C55E', 7);

    // ── Ground ──
    canvas.line(-4, 0, 4, 0, '#334155', 1);

    // ── Info panel ──
    const TS = 2 * Math.PI * Math.sqrt(mass / kS);
    const TP = 2 * Math.PI * Math.sqrt(mass / kP);

    canvas.text(LEFT_X, -0.4, 'k_eff = k₁k₂/(k₁+k₂)', '#F59E0B', 8);
    canvas.text(LEFT_X, -0.6, '= ' + kS.toFixed(1) + ' N/m', '#F59E0B', 9);
    canvas.text(LEFT_X, -0.85, 'T = ' + TS.toFixed(3) + 's', '#F59E0B', 9);

    canvas.text(RIGHT_X, -0.4, 'k_eff = k₁ + k₂', '#22C55E', 8);
    canvas.text(RIGHT_X, -0.6, '= ' + kP.toFixed(1) + ' N/m', '#22C55E', 9);
    canvas.text(RIGHT_X, -0.85, 'T = ' + TP.toFixed(3) + 's', '#22C55E', 9);

    // Ratio
    canvas.text(0, -1.15, 'Parallel is ' + (kP / kS).toFixed(1) + '× stiffer → ' + (TS / TP).toFixed(1) + '× faster', '#94A3B8', 9);
  },

  info: `
    <h2>Series vs Parallel Springs</h2>
    <p>Two spring configurations side by side. Same springs, same mass — different effective stiffness, different period.</p>

    <h3>Series (left, orange)</h3>
    <p>Springs connected end-to-end. The effective stiffness is:</p>
    <p><code>1/k_eff = 1/k₁ + 1/k₂</code> → <code>k_eff = k₁k₂/(k₁+k₂)</code></p>
    <p>Always <strong>softer</strong> than either spring alone. The weakest link dominates.</p>

    <h3>Parallel (right, green)</h3>
    <p>Springs side by side, both attached to the same mass. The effective stiffness is:</p>
    <p><code>k_eff = k₁ + k₂</code></p>
    <p>Always <strong>stiffer</strong> than either spring alone. Forces add up.</p>

    <h3>Key Comparisons</h3>
    <table style="border-collapse:collapse;font-size:14px;">
      <tr><th style="padding:4px 12px;border:1px solid #334;">Property</th><th style="padding:4px 12px;border:1px solid #334;">Series</th><th style="padding:4px 12px;border:1px solid #334;">Parallel</th></tr>
      <tr><td style="padding:4px 12px;border:1px solid #334;">k_eff</td><td style="padding:4px 12px;border:1px solid #334;">k₁k₂/(k₁+k₂) — softer</td><td style="padding:4px 12px;border:1px solid #334;">k₁+k₂ — stiffer</td></tr>
      <tr><td style="padding:4px 12px;border:1px solid #334;">Period T</td><td style="padding:4px 12px;border:1px solid #334;">Longer (slower)</td><td style="padding:4px 12px;border:1px solid #334;">Shorter (faster)</td></tr>
      <tr><td style="padding:4px 12px;border:1px solid #334;">Eq stretch</td><td style="padding:4px 12px;border:1px solid #334;">More (hangs lower)</td><td style="padding:4px 12px;border:1px solid #334;">Less (hangs higher)</td></tr>
      <tr><td style="padding:4px 12px;border:1px solid #334;">Equal springs</td><td style="padding:4px 12px;border:1px solid #334;">k/2</td><td style="padding:4px 12px;border:1px solid #334;">2k</td></tr>
    </table>

    <h3>Try These</h3>
    <ol>
      <li><strong>Equal springs (k₁=k₂=20):</strong> Series gives k_eff=10, parallel gives 40. Period ratio = 2:1.</li>
      <li><strong>One weak link (k₁=5, k₂=50):</strong> Series k_eff ≈ 4.5 — dominated by the weak spring! Parallel k_eff = 55.</li>
      <li><strong>Drag both masses:</strong> Pull both down by the same amount, release simultaneously. Watch the parallel system bounce faster.</li>
      <li><strong>Time graph:</strong> Switch to Time tab to see both positions plotted together. The frequency difference is immediately visible.</li>
      <li><strong>No damping:</strong> Both oscillate forever. Count cycles — parallel completes more in the same time.</li>
    </ol>

    <h3>Analogy</h3>
    <p><strong>Series = chain:</strong> A chain is only as strong as its weakest link. Two soft springs in series are even softer.</p>
    <p><strong>Parallel = team:</strong> Two people pushing together are stronger than either alone. Two springs in parallel are stiffer.</p>
  `,
};
