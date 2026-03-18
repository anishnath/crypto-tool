/**
 * Cart + Pendulum — Coupled Dynamics
 *
 * A cart on a spring-connected track with a pendulum hanging from it.
 * The cart and pendulum are coupled: the swinging pendulum pushes the cart,
 * and the cart's motion affects the pendulum.
 *
 * Physics (Lagrangian-derived):
 *   v' = [m·ω²·L·sin(θ) + m·g·sin(θ)·cos(θ) - k·x - d·v + b·ω·cos(θ)/L] / (M + m·sin²θ)
 *   ω' = [-m·ω²·L·sin(θ)·cos(θ) + k·x·cos(θ) - (M+m)·g·sin(θ) + d·v·cos(θ) - (M+m)·b·ω/(m·L)] / [L·(M + m·sin²θ)]
 *
 *
 * State: [x, θ, v, ω, time]
 */

export const CartPendulumSim = {
  name: 'Cart + Pendulum',
  slug: 'cart-pendulum',
  category: 'Mechanics',

  vars: {
    cartX:     { index: 0, label: 'Cart Position (m)',  symbol: 'x' },
    angle:     { index: 1, label: 'Angle (rad)',         symbol: 'θ' },
    cartVel:   { index: 2, label: 'Cart Velocity',       symbol: 'v' },
    angularVel:{ index: 3, label: 'Angular Velocity',    symbol: 'ω' },
    time:      { index: 4, label: 'Time (s)',             symbol: 't' },
  },
  varCount: 5,

  params: {
    cartMass:   { value: 1.0,  min: 0.1, max: 10, step: 0.1, label: 'Cart Mass (M)',    unit: 'kg' },
    bobMass:    { value: 1.0,  min: 0.1, max: 10, step: 0.1, label: 'Bob Mass (m)',     unit: 'kg' },
    length:     { value: 1.0,  min: 0.2, max: 3,  step: 0.1, label: 'Rod Length',       unit: 'm' },
    stiffness:  { value: 6.0,  min: 0, max: 30,   step: 0.5, label: 'Spring k',         unit: 'N/m' },
    gravity:    { value: 9.8,  min: 0, max: 25,    step: 0.1, label: 'Gravity',          unit: 'm/s²' },
    cartDamp:   { value: 0,    min: 0, max: 5,     step: 0.01,label: 'Cart Damping (d)' },
    bobDamp:    { value: 0,    min: 0, max: 5,     step: 0.01,label: 'Pendulum Damping (b)' },
    startAngle: { value: Math.PI / 4, min: -Math.PI, max: Math.PI, step: 0.05, label: 'Start Angle', unit: 'rad' },
  },

  views: ['sim', 'phase', 'time', 'energy'],

  graphDefaults: {
    phase: { x: 'cartX', y: 'angle' },
    time: ['cartX', 'angle'],
  },

  worldRect: { xMin: -5, xMax: 5, yMin: -2.5, yMax: 1.5 },

  presets: [
    { name: 'Default',       params: {} },
    { name: 'Heavy Cart',    params: { cartMass: 5 } },
    { name: 'Heavy Bob',     params: { bobMass: 5 } },
    { name: 'Stiff Spring',  params: { stiffness: 20 } },
    { name: 'No Spring',     params: { stiffness: 0 } },
    { name: 'Large Angle',   params: { startAngle: Math.PI * 0.8 } },
    { name: 'Damped',        params: { cartDamp: 0.3, bobDamp: 0.3 } },
  ],

  init(p) {
    return [0, p.startAngle, 0, 0, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[4] = 1;
    if (isDragging) return;

    const [x, h, v, w] = vars;
    const { cartMass: M, bobMass: m, length: L, stiffness: k, gravity: g, cartDamp: d, bobDamp: b } = params;

    const sinH = Math.sin(h), cosH = Math.cos(h);
    const denom = M + m * sinH * sinH;

    change[0] = v; // dx/dt
    change[1] = w; // dθ/dt

    // Cart acceleration
    change[2] = (m * w * w * L * sinH + m * g * sinH * cosH - k * x - d * v + b * w * cosH / L) / denom;

    // Pendulum angular acceleration
    change[3] = (-m * w * w * L * sinH * cosH + k * x * cosH - (M + m) * g * sinH + d * v * cosH - (M + m) * b * w / (m * L)) / (L * denom);
  },

  energy(vars, params) {
    const [x, h, v, w] = vars;
    const { cartMass: M, bobMass: m, length: L, stiffness: k, gravity: g } = params;

    // Bob velocity in lab frame
    const vxBob = v + L * w * Math.cos(h);
    const vyBob = L * w * Math.sin(h);

    const KE = 0.5 * M * v * v + 0.5 * m * (vxBob * vxBob + vyBob * vyBob);
    const PE = 0.5 * k * x * x + m * g * (-L * Math.cos(h) + L); // PE ref: bob hanging straight down
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  // --- Drag ---

  hitTest(wx, wy, vars, params) {
    const [x, h] = vars;
    const L = params.length;
    const bobX = x + L * Math.sin(h);
    const bobY = -L * Math.cos(h);
    if (Math.hypot(wx - bobX, wy - bobY) < 0.3) return { id: 'bob' };
    const cartW = 0.35 * Math.sqrt(params.cartMass);
    if (Math.abs(wx - x) < cartW + 0.1 && Math.abs(wy) < cartW * 0.6 + 0.1) return { id: 'cart', offsetX: wx - x };
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    if (id === 'cart') {
      vars[0] = wx - offset.offsetX;
      vars[2] = 0; vars[3] = 0;
    } else if (id === 'bob') {
      const cartX = vars[0];
      vars[1] = Math.atan2(wx - cartX, -wy);
      vars[2] = 0; vars[3] = 0;
    }
  },
  onRelease() {},

  trailPoint(vars, params) {
    const L = params.length;
    return { wx: vars[0] + L * Math.sin(vars[1]), wy: -L * Math.cos(vars[1]) };
  },

  vectors(vars, params) {
    const [x, h, v, w] = vars;
    const L = params.length;
    const bobX = x + L * Math.sin(h);
    const bobY = -L * Math.cos(h);
    const vxBob = v + L * w * Math.cos(h);
    const vyBob = L * w * Math.sin(h);
    return {
      pos: { x: bobX, y: bobY },
      velocity: { x: vxBob, y: vyBob, mag: Math.hypot(vxBob, vyBob) },
      accel: { x: 0, y: 0, mag: 0 },
    };
  },

  // --- Rendering ---

  render(canvas, vars, params) {
    const [x, h] = vars;
    const { length: L, cartMass: M, bobMass: m, stiffness: k } = params;
    const cartW = 0.35 * Math.sqrt(M);
    const cartY = 0;
    const bobX = x + L * Math.sin(h);
    const bobY = cartY - L * Math.cos(h);

    // Track
    canvas.line(-4.5, cartY + cartW + 0.05, 4.5, cartY + cartW + 0.05, '#334155', 1);

    // Spring (wall to cart)
    if (k > 0) {
      canvas.spring(-4.5, cartY, x - cartW, cartY, 10, 0.12, '#10B981');
      // Wall
      canvas.rect(-4.65, -0.8, 0.15, 1.6, '#475569', null);
    }

    // Cart (rectangle)
    canvas.rect(x - cartW, cartY - cartW * 0.6, cartW * 2, cartW * 1.2, '#64748B', '#94A3B8');
    // Wheels
    canvas.circle(x - cartW * 0.5, cartY + cartW * 0.6, 0.06, '#475569', null);
    canvas.circle(x + cartW * 0.5, cartY + cartW * 0.6, 0.06, '#475569', null);

    // Rod
    canvas.line(x, cartY, bobX, bobY, '#94a3b8', 2);

    // Bob
    canvas.circle(bobX, bobY, 0.08 * Math.sqrt(m), '#8B5CF6', '#A78BFA');
  },

  info: `
    <h2>Cart + Pendulum — Coupled Dynamics</h2>
    <p>A cart on a track (connected to a wall by a spring) with a pendulum hanging from it. The cart and pendulum are <strong>coupled</strong>: the swinging pendulum pushes the cart, and the cart's motion affects the pendulum. This is one of the most important systems in control theory.</p>

    <h3>Equations of Motion</h3>
    <p>Derived from the Lagrangian with constraints:</p>
    <p><code>v' = [mω²L·sinθ + mg·sinθ·cosθ - kx - dv + bω·cosθ/L] / (M + m·sin²θ)</code></p>
    <p><code>ω' = [-mω²L·sinθ·cosθ + kx·cosθ - (M+m)g·sinθ + dv·cosθ - (M+m)bω/(mL)] / [L(M + m·sin²θ)]</code></p>

    <h3>The Coupling</h3>
    <ul>
      <li><strong>Pendulum → Cart:</strong> The swinging bob exerts a centrifugal force <code>mω²L·sinθ</code> on the cart, pushing it sideways</li>
      <li><strong>Cart → Pendulum:</strong> The spring force <code>kx·cosθ</code> accelerates the cart, which changes the effective gravity for the pendulum</li>
      <li><strong>Effective mass:</strong> The denominator <code>M + m·sin²θ</code> shows the cart feels heavier when the pendulum is horizontal (sin²θ = 1)</li>
    </ul>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Watch energy transfer:</strong> Default preset — the pendulum swings and makes the cart oscillate. Energy flows between pendulum and cart-spring</li>
      <li><strong>Heavy cart:</strong> Cart barely moves. Pendulum behaves almost like it's on a fixed pivot</li>
      <li><strong>Heavy bob:</strong> Pendulum dominates — drags the cart along with each swing</li>
      <li><strong>No spring:</strong> Cart slides freely. Total momentum is conserved (cart + bob). Watch cart drift</li>
      <li><strong>Drag the cart:</strong> Pull the cart sideways and release — both the cart and pendulum oscillate in a complex coupled pattern</li>
    </ol>

    <h3>Phase Space</h3>
    <p>The <strong>Phase tab</strong> defaults to cart position (x) vs pendulum angle (θ) — this shows the coupled configuration space. The pattern reveals how the two degrees of freedom exchange energy.</p>

    <h3>Real-World Applications</h3>
    <ul>
      <li><strong>Crane control:</strong> A crane payload is a pendulum on a moveable cart — operators must account for swing</li>
      <li><strong>Segway / self-balancing robots:</strong> Inverted cart-pendulum — the control problem is to keep the pendulum upright by moving the cart</li>
      <li><strong>Earthquake engineering:</strong> Buildings sway like pendulums on moving ground (the "cart" is the earth)</li>
      <li><strong>Rocket landing:</strong> SpaceX booster landing is essentially a 3D inverted pendulum on a moving cart</li>
    </ul>
  `,
};
