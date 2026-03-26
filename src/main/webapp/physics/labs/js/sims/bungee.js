/**
 * Bungee Jump Simulator
 *
 * A mass falls from a platform. After falling a distance equal to the
 * bungee cord's natural length, the cord engages and acts as a spring.
 * Before that — pure free fall (no spring force).
 *
 * THREE PHASES:
 *   1. Free fall: y > (platform - cordLength) → a = -g (no tension)
 *   2. Bungee engaged: y < (platform - cordLength) → a = -g + k·stretch/m
 *   3. Bouncing: oscillates around equilibrium, cord may go slack on upswing
 *
 * KEY INSIGHT: The cord can only PULL, never PUSH.
 *   If stretch < 0 (cord would be compressed), tension = 0 → free fall again.
 *
 * Coordinate system: y increases UPWARD.
 *   Platform at y = PLATFORM_Y. Jumper falls downward (y decreases).
 *
 * State: [y, vy, time]
 */

const G = 9.81;
const PLATFORM_Y = 8.0;

export const BungeeSim = {
  name: 'Bungee Jump',
  slug: 'bungee',
  category: 'Mechanics',

  vars: {
    position: { index: 0, label: 'Height (m)',     symbol: 'y' },
    velocity: { index: 1, label: 'Velocity (m/s)', symbol: 'v' },
    time:     { index: 2, label: 'Time (s)',        symbol: 't' },
  },
  varCount: 3,

  params: {
    mass:       { value: 70,  min: 30, max: 150, step: 1,   label: 'Jumper Mass',    unit: 'kg' },
    cordLength: { value: 4.0, min: 1,  max: 7,   step: 0.1, label: 'Cord Length L₀', unit: 'm' },
    stiffness:  { value: 800, min: 50, max: 2000, step: 10,  label: 'Cord Stiffness', unit: 'N/m' },
    damping:    { value: 50, min: 0,  max: 200,  step: 1, label: 'Damping',        unit: 'N·s/m' },
    gravity:    { value: 9.81, min: 0.1, max: 25, step: 0.1, label: 'Gravity g',     unit: 'm/s²' },
  },

  views: ['sim', 'time', 'energy'],

  graphDefaults: {
    time: ['position', 'velocity'],
  },

  worldRect: { xMin: -3, xMax: 3, yMin: -4, yMax: 10 },

  presets: [
    // k_min for survival = 2mg·H / (H-L₀)² where H=platform height=8m
    // Critical damping b_c = 2√(mk). For m=70,k=800: b_c≈473. Default b=50 → ζ≈10% → settles in ~10 bounces.
    { name: 'Standard Jump',          params: { mass: 70, cordLength: 4, stiffness: 800, damping: 50 } },
    { name: 'Heavy Jumper (120kg)',    params: { mass: 120, cordLength: 4, stiffness: 1200, damping: 80 } },
    { name: 'Light Jumper (40kg)',     params: { mass: 40, cordLength: 4, stiffness: 500, damping: 30 } },
    { name: 'Short Cord (2m)',         params: { cordLength: 2, stiffness: 400, damping: 40 } },
    { name: 'Long Cord (dangerous!)',  params: { cordLength: 6.5, stiffness: 500, damping: 30 } },
    { name: 'Very Elastic (bouncy)',   params: { stiffness: 300, damping: 10 } },
    { name: 'Stiff Cord (harsh stop)', params: { stiffness: 2000, damping: 100 } },
    { name: 'No Damping (forever)',    params: { mass: 70, cordLength: 4, stiffness: 800, damping: 0 } },
  ],

  // Internal state
  _phase: 'free-fall',  // 'free-fall' | 'bungee' | 'slack'
  _maxStretch: 0,
  _minY: Infinity,

  init(p) {
    this._phase = 'free-fall';
    this._maxStretch = 0;
    this._minY = PLATFORM_Y;
    return [PLATFORM_Y, 0, 0];  // start at platform, at rest
  },

  evaluate(vars, change, params, isDragging) {
    change[2] = 1;
    if (isDragging) return;

    const [y, vy] = vars;
    const { mass, cordLength, stiffness, damping } = params;
    const g = params.gravity || G;

    // Cord attachment point
    const attachY = PLATFORM_Y;
    // How far below the cord's natural length end
    const cordEnd = attachY - cordLength;
    const stretch = cordEnd - y;  // positive when cord is stretched (y below cordEnd)

    let accel;
    if (stretch > 0) {
      // Cord engaged: spring force pulls UP + gravity pulls DOWN
      const tension = stiffness * stretch;
      accel = tension / mass - g - (damping / mass) * vy;
    } else {
      // Cord slack: pure free fall (cord can't push)
      accel = -g - (damping / mass) * vy;
    }

    change[0] = vy;
    change[1] = accel;
    // NOTE: Do NOT mutate _phase/_maxStretch/_minY here — RK4 calls evaluate
    // multiple times per step with intermediate values. Use postStep instead.
  },

  // Called once per committed timestep — safe to mutate tracking state
  postStep(vars, params) {
    const y = vars[0];
    const cordEnd = PLATFORM_Y - params.cordLength;
    const stretch = cordEnd - y;

    // Update phase from committed position
    this._phase = stretch > 0 ? 'bungee' : (y < PLATFORM_Y ? 'slack' : 'free-fall');

    // Track extremes
    if (stretch > this._maxStretch) this._maxStretch = stretch;
    if (y < this._minY) this._minY = y;

    // Ground clamp — stop at y=0 (don't fall through)
    if (vars[0] < 0) {
      vars[0] = 0;
      vars[1] = 0;
    }
  },

  energy(vars, params) {
    const [y, vy] = vars;
    const { mass, cordLength, stiffness } = params;
    const g = params.gravity || G;
    const cordEnd = PLATFORM_Y - cordLength;
    const stretch = Math.max(0, cordEnd - y);  // only when cord is stretched

    const KE = 0.5 * mass * vy * vy;
    const gravPE = mass * g * y;
    const elasticPE = 0.5 * stiffness * stretch * stretch;
    return { kinetic: KE, potential: gravPE + elasticPE, total: KE + gravPE + elasticPE };
  },

  potentialEnergy(y, params) {
    const { mass, cordLength, stiffness } = params;
    const g = params.gravity || G;
    const stretch = Math.max(0, (PLATFORM_Y - cordLength) - y);
    return mass * g * y + 0.5 * stiffness * stretch * stretch;
  },
  peWellConfig: { posVar: 0, posLabel: 'y (m)', range: { min: -4, max: 9 } },

  theoreticalPeriod(params) {
    // Half-period of the spring phase only (cord engaged).
    // The full bungee cycle is longer (includes free-fall + slack phases).
    return Math.PI * Math.sqrt(params.mass / params.stiffness);
  },
  periodVar: 1,

  hitTest(wx, wy, vars) {
    const jumperY = vars[0];
    if (Math.abs(wx) < 0.5 && Math.abs(wy - jumperY) < 0.5) {
      return { id: 'jumper', offsetY: wy - jumperY };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars) {
    if (id === 'jumper') {
      vars[0] = Math.max(0, Math.min(PLATFORM_Y, wy - offset.offsetY));
      vars[1] = 0;
    }
  },

  onRelease() {},

  render(canvas, vars, params) {
    const [y, vy] = vars;
    const { mass, cordLength, stiffness } = params;
    const g = params.gravity || G;
    const cordEnd = PLATFORM_Y - cordLength;
    const stretch = Math.max(0, cordEnd - y);
    const jumperR = 0.2 + Math.sqrt(mass) * 0.02;

    // ── Platform ──
    canvas.rect(-1.5, PLATFORM_Y, 3, 0.3, '#475569', '#64748b');
    // Railing
    canvas.line(-1.5, PLATFORM_Y + 0.3, -1.5, PLATFORM_Y + 1.2, '#64748b', 2);
    canvas.line(1.5, PLATFORM_Y + 0.3, 1.5, PLATFORM_Y + 1.2, '#64748b', 2);
    canvas.line(-1.5, PLATFORM_Y + 1.2, 1.5, PLATFORM_Y + 1.2, '#64748b', 2);

    // ── Cord natural length marker ──
    canvas.line(-2.5, cordEnd, -1.8, cordEnd, '#F59E0B', 1);
    canvas.text(-2.8, cordEnd, 'L₀', '#F59E0B', 8);

    // ── Ground / danger zone ──
    canvas.line(-3, 0, 3, 0, '#EF4444', 2);
    canvas.text(0, -0.3, '⚠ GROUND', '#EF4444', 9);
    for (let x = -2.8; x <= 2.8; x += 0.3) {
      canvas.line(x, 0, x - 0.12, -0.12, '#EF4444', 1);
    }

    // ── Bungee Cord ──
    if (stretch > 0) {
      // Cord is taut — draw as spring (zigzag)
      canvas.spring(0, PLATFORM_Y, 0, y + jumperR, 16, 0.25, '#22C55E');
    } else if (y < PLATFORM_Y) {
      // Cord is slack — draw as loose hanging curve
      // Slack cord: draw hanging straight from platform to cord natural end
      canvas.line(0, PLATFORM_Y, 0, Math.max(y + jumperR, PLATFORM_Y - cordLength), '#64748b', 1.5);
      // Slack indicator
      if (this._phase === 'slack') {
        canvas.text(0.8, (PLATFORM_Y + y) / 2, '~ slack ~', '#64748b', 8);
      }
    }

    // ── Jumper (circle + body) ──
    const phaseColor = this._phase === 'free-fall' ? '#EF4444' :
                       this._phase === 'bungee' ? '#22C55E' : '#F59E0B';
    // Head
    canvas.circle(0, y + jumperR + 0.15, 0.15, phaseColor, '#FFF');
    // Body
    canvas.line(0, y + jumperR, 0, y - jumperR, phaseColor, 3);
    // Arms
    canvas.line(-0.3, y + jumperR * 0.3, 0.3, y + jumperR * 0.3, phaseColor, 2);
    // Legs
    canvas.line(0, y - jumperR, -0.2, y - jumperR - 0.3, phaseColor, 2);
    canvas.line(0, y - jumperR, 0.2, y - jumperR - 0.3, phaseColor, 2);

    // ── Equilibrium marker (when cord is engaged) ──
    const eqY = cordEnd - mass * g / stiffness;
    canvas.line(1.8, eqY, 2.5, eqY, '#22C55E', 1);
    canvas.text(2.7, eqY, 'eq', '#22C55E', 7);

    // ── Phase indicator ──
    const phaseLabel = this._phase === 'free-fall' ? '🟥 FREE FALL' :
                       this._phase === 'bungee' ? '🟩 BUNGEE' : '🟨 SLACK';
    canvas.text(0, PLATFORM_Y + 1.6, phaseLabel, phaseColor, 12);

    // ── Stats ──
    const speed = Math.abs(vy);
    canvas.text(-2.2, PLATFORM_Y + 1.6, 'v = ' + speed.toFixed(1) + ' m/s', '#94A3B8', 9);

    const tension = stretch > 0 ? stiffness * stretch : 0;
    canvas.text(2.2, PLATFORM_Y + 1.6, 'T = ' + tension.toFixed(0) + ' N', '#06B6D4', 9);

    // Height and stretch info
    const fallDist = PLATFORM_Y - y;
    canvas.text(-2.2, -0.7, 'Fall: ' + fallDist.toFixed(1) + 'm', '#94A3B8', 9);
    if (this._minY < PLATFORM_Y - 0.1) {
      canvas.text(0, -0.7, 'Lowest: ' + this._minY.toFixed(1) + 'm', this._minY < 0 ? '#EF4444' : '#22C55E', 9);
    }
    canvas.text(2.2, -0.7, 'Max stretch: ' + this._maxStretch.toFixed(1) + 'm', '#F59E0B', 9);

    // Danger warning if lowest point is below ground
    if (this._minY < 0) {
      canvas.text(0, -1.2, '💀 FATAL — Jumper hit the ground!', '#EF4444', 12);
    }

    // ── Height scale on right side ──
    for (let h = 0; h <= 8; h += 2) {
      canvas.line(2.8, h, 3.0, h, '#334155', 1);
      canvas.text(2.6, h, h + 'm', '#334155', 7);
    }
  },

  info: `
    <h2>Bungee Jump Simulator</h2>
    <p>Jump off a platform with a bungee cord attached. The cord has a natural length — during free fall above that length, there's no tension. Once the cord stretches past its natural length, it pulls back like a spring.</p>

    <h3>Three Phases</h3>
    <ol>
      <li><strong style="color:#EF4444;">Free Fall</strong> — Jumper falls, cord is slack. a = g downward. Speed increases.</li>
      <li><strong style="color:#22C55E;">Bungee Engaged</strong> — Cord stretches, tension = k × stretch. Deceleration begins.</li>
      <li><strong style="color:#F59E0B;">Slack / Bounce</strong> — On the upswing, if jumper rises above cord length, tension drops to zero. Free fall again briefly, then cord re-engages.</li>
    </ol>

    <h3>The Physics</h3>
    <p><strong>Before cord engages:</strong> <code>a = −g</code> (pure free fall)</p>
    <p><strong>After cord engages:</strong> <code>a = k·stretch/m − g</code></p>
    <p>The cord can only <strong>pull</strong> (tension ≥ 0), never push. This makes it a <strong>piecewise</strong> system — different ODE above and below the cord's natural length.</p>

    <h3>Key Equations</h3>
    <p>Speed at cord engagement: <code>v = √(2gL₀)</code> (from free fall over distance L₀)</p>
    <p>Maximum stretch (energy conservation): <code>½mv² + mg·x_max = ½k·x_max²</code></p>
    <p>Lowest point: <code>y_min = platform − L₀ − x_max</code></p>

    <h3>Try These</h3>
    <ol>
      <li><strong>Standard Jump:</strong> Watch the three phases: red (free fall) → green (bungee) → yellow (slack on bounce).</li>
      <li><strong>Heavy Jumper:</strong> Falls further, higher max stretch. More dangerous — check if y_min > 0!</li>
      <li><strong>Long Cord (dangerous!):</strong> The jumper hits the ground! 💀 Change stiffness to save them.</li>
      <li><strong>No Damping:</strong> Bounces forever. The cord goes slack on each upswing.</li>
      <li><strong>Energy tab:</strong> Watch KE convert to elastic PE at the bottom. Gravitational PE decreases continuously during fall.</li>
      <li><strong>PE Well tab:</strong> The potential is a hockey-stick shape — flat above L₀ (just gravity), parabolic below (gravity + spring).</li>
      <li><strong>Drag the jumper:</strong> Pull them to any height and release. Try starting from below the platform.</li>
    </ol>

    <h3>Safety Design</h3>
    <p>Real bungee cords are designed so that <code>y_min > 0</code> (jumper never hits the ground). This requires:</p>
    <p><code>k > 2mg(L₀ + h) / h²</code> where <code>h = platform height</code></p>
    <p>The "Long Cord" preset violates this — increase stiffness to fix it!</p>
  `,
};
