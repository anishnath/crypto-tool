/**
 * Generic Math AI — calculus shell (integral, derivative, limit).
 * Page tool UI is optional context; engines run in chat regardless of current page.
 */
import { CALCULUS_ACTIONS, formatMathActionLabel } from '../../math-action-extract.js';
import {
  solveDerivativeTask,
  solveIntegralTask,
  solveLimitTask,
  solveOdeTask,
  solvePdeTask,
  solveVectorCalculusTask,
} from '../../math-chat-compute.js';
import { icApplyIntegralTask } from './integral-calculator.js';

/** Page-focused quick-action example chips. `sendImmediately` runs the example on click. */
const FOCUS_CHIPS = {
  integral: [
    ['∫ x² dx', 'Integrate x^2 with respect to x.'],
    ['∫ sin(3x) dx', 'Integrate sin(3*x) with respect to x.'],
    ['∫₀¹ eˣ dx', 'Evaluate the definite integral of e^x from 0 to 1.'],
    ['∫ x·ln x dx', 'Integrate x*ln(x) with respect to x.'],
  ],
  derivative: [
    ['d/dx (x³ sin x)', 'Differentiate x^3 * sin(x) with respect to x.'],
    ['d/dx (eˣ/x)', 'Differentiate e^x / x with respect to x.'],
    ['d/dx √(x²+1)', 'Differentiate sqrt(x^2 + 1) with respect to x.'],
    ['d²/dx² (x⁴)', 'Find the second derivative of x^4 with respect to x.'],
  ],
  limit: [
    ['lim (sin x)/x', 'Find the limit of sin(x)/x as x approaches 0.'],
    ['lim (1+1/x)ˣ', 'Find the limit of (1 + 1/x)^x as x approaches infinity.'],
    ['lim (eˣ−1)/x', 'Find the limit of (e^x - 1)/x as x approaches 0.'],
    ['lim⁺ 1/x', 'Find the limit of 1/x as x approaches 0 from the right.'],
  ],
  ode: [
    ["y' = -2x·y", 'Solve the ODE y\' = -2*x*y.'],
    ["y' + 2y = x", 'Solve the linear ODE y\' + 2y = x.'],
    ["y'' + y = 0", 'Solve y\'\' + y = 0 with y(0)=1, y\'(0)=0.'],
    ["y'' + 2y' + y = 0", 'Solve y\'\' + 2y\' + y = 0.'],
  ],
  pde: [
    ['Heat u_t = k u_xx', 'Solve the heat equation with k=1, L=1, tmax=0.5, sin IC, Dirichlet BC.'],
    ['Wave u_tt = c² u_xx', 'Solve the wave equation with c=1, L=1, tmax=2, sin IC, fixed ends.'],
    ['1st-order linear PDE', 'Solve a u_x + b u_y + c u = 0 with a=1, b=1, c=1, g=0.'],
    ['Classify a PDE', 'Explain whether u_xx + 2 u_xy + u_yy = 0 is elliptic, parabolic, or hyperbolic. No solve block needed.'],
  ],
  series: [
    ['Maclaurin e^x', 'Find the Maclaurin series for e^x through degree 6 and explain each coefficient.'],
    ['Radius of convergence', 'What is the radius of convergence for ln(1+x)? Show the ratio or root test.'],
    ['Lagrange error bound', 'Bound |R_n(0.5)| for e^x using a 4-term Maclaurin polynomial centered at 0.'],
    ['lim via series', 'Evaluate lim x→0 (sin x)/x using a Taylor expansion — then verify with a limit block.'],
  ],
  vectorCalculus: [
    ['∇f for x²+y²+z²', 'Compute the gradient of f(x,y,z) = x^2 + y^2 + z^2. Emit a ```vectorCalculus``` block so Solve chips appear.'],
    ['∇·F', 'Compute the divergence of F = (x^2, y*z, x*z^2). Emit a ```vectorCalculus``` block.'],
    ['∇×F', 'Compute the curl of F = (-y, x, 0). Emit a ```vectorCalculus``` block.'],
    ['Generate 3 problems', 'Generate 3 vector calculus practice problems (one gradient, one divergence, one curl). Emit one ```vectorCalculus``` block per problem with expressions like x^2+y^2+z^2 or x^2*y^2*z^2. Do NOT solve in prose — chips run the engine.'],
  ],
};

function focusQuickActions(focus) {
  const set = FOCUS_CHIPS[focus] || FOCUS_CHIPS.integral;
  return set.map(([label, prompt]) => ({ label, prompt, sendImmediately: true }));
}

/**
 * @param {object} [opts]
 * @param {'integral'|'derivative'|'limit'} [opts.focus]
 */
export function configureGenericMathShell(opts = {}) {
  const pageLabel = opts.pageLabel || opts.toolName || '8gwifi.org Math';
  const pageHint = opts.pageHint || '';
  const focus = FOCUS_CHIPS[opts.focus] ? opts.focus : 'integral';

  window.mathShell = {
    toolName: pageLabel,
    focus,
    panelTitle: opts.panelTitle || 'Math AI',
    subtitle: opts.subtitle || 'Parse calculus · Σ Solve in chat',
    placeholder: opts.placeholder || 'Paste ∫, d/dx, or lim problems (LaTeX, ASCII, or English)…',
    footerText: opts.footerText || 'Ctrl+Shift+A · same engines as LaTeX editor Σ Solve',
    supportedActions: opts.supportedActions || CALCULUS_ACTIONS.slice(),
    batchDelayMs: 120,
    chatComputeEnabled: true,
    syncToCalculator: false,

    formatActionLabel: formatMathActionLabel,

    computeInChat(task, mode = 'simple') {
      if (!task?.action || !CALCULUS_ACTIONS.includes(task.action)) {
        return Promise.resolve({
          ok: false,
          error: `Unsupported action: ${task?.action || 'unknown'}`,
          mode,
        });
      }
      if (task.action === 'integral') return solveIntegralTask(task, mode);
      if (task.action === 'derivative') return solveDerivativeTask(task, mode);
      if (task.action === 'limit') return solveLimitTask(task, mode);
      if (task.action === 'ode') return solveOdeTask(task, mode);
      if (task.action === 'pde') return solvePdeTask(task, mode);
      if (task.action === 'vectorCalculus') return solveVectorCalculusTask(task, mode);
      return Promise.resolve({ ok: false, error: 'Unknown action.', mode });
    },

    async executeTask(task) {
      if (task?.action === 'integral' && typeof icApplyIntegralTask === 'function') {
        return icApplyIntegralTask(task);
      }
      const r = await this.computeInChat(task, 'simple');
      return r?.ok
        ? { applied: true, resultSummary: r.resultLatex || r.value || '' }
        : { applied: false, error: r?.error || 'Computation failed.' };
    },

    applyIntent(task) {
      if (task?.action === 'integral') return icApplyIntegralTask(task);
      return this.executeTask(task);
    },

    getContext() {
      if (typeof window.vcGetContext === 'function') return window.vcGetContext();
      if (typeof window.scGetContext === 'function') return window.scGetContext();
      if (typeof window.pdeGetContext === 'function') return window.pdeGetContext();
      if (typeof window.icGetContext === 'function') return window.icGetContext();
      if (typeof window.dcGetContext === 'function') return window.dcGetContext();
      if (typeof window.lcGetContext === 'function') return window.lcGetContext();
      if (typeof window.odeGetContext === 'function') return window.odeGetContext();
      return null;
    },

    formatContext(snap) {
      const chat = Array.isArray(window.mathShell?.lastChatResults)
        ? window.mathShell.lastChatResults
        : [];
      const lines = [];

      if (pageHint) lines.push(`Page: ${pageHint}`);

      if (snap) {
        if (snap.toolType === 'pde') {
          lines.push(`PDE type: ${snap.mode || '(n/a)'}`);
          if (snap.params && typeof snap.params === 'object') {
            Object.keys(snap.params).forEach((key) => {
              const val = snap.params[key];
              if (val != null && String(val).trim() !== '') {
                lines.push(`${key}: ${String(val).slice(0, 200)}`);
              }
            });
          }
        } else if (snap.toolType === 'series') {
          lines.push(
            `Page mode: ${snap.mode || 'expansion'}`,
            `Series type: ${snap.seriesType || 'maclaurin'}`,
            `Function: ${snap.expr || '(empty)'}`,
            `Center (a): ${snap.center ?? '0'}`,
            `Terms: ${snap.terms ?? '?'}`,
          );
        } else if (snap.toolType === 'vectorCalculus') {
          lines.push(`Page mode: ${snap.mode || 'gradient'}`);
          if (snap.mode === 'gradient') {
            lines.push(`Scalar field f: ${snap.scalar || '(empty)'}`);
          } else {
            lines.push(
              `F_x: ${snap.fx || '0'}`,
              `F_y: ${snap.fy || '0'}`,
              `F_z: ${snap.fz || '0'}`,
            );
          }
        } else {
          lines.push(
            `Mode: ${snap.mode || '(n/a)'}`,
            `Variable: ${snap.variable || 'x'}`,
            `Expression: ${snap.expr || snap.integrand || '(empty)'}`,
          );
          if (snap.mode === 'definite') {
            lines.push(`Bounds: [${snap.lower ?? '?'}, ${snap.upper ?? '?'}]`);
          }
        }
        if (snap.resultSummary) {
          lines.push('', 'Page calculator result:', snap.resultSummary.slice(0, 4000));
        }
      }

      if (chat.length) {
        lines.push('', 'Recent chat engine results:');
        chat.slice(-6).forEach((entry, i) => {
          const t = entry.task;
          const r = entry.result;
          const label = formatMathActionLabel(t || {}, i);
          if (r?.ok) {
            lines.push(`${i + 1}. ${label} → ${r.resultLatex || r.value || '(result)'} (${r.method || 'engine'})`);
          } else {
            lines.push(`${i + 1}. ${label} → failed: ${r?.error || 'unknown'}`);
          }
        });
      }

      if (!lines.length) {
        return '(Paste a math problem — integral, derivative, limit, ODE, PDE, or vector calculus — then Solve / Steps / Graph in chat.)';
      }
      return lines.join('\n');
    },

    getQuickActions() {
      return focusQuickActions(this.focus || focus);
    },

    promptExtra: `**Generic Math AI:** Route **integral**, **derivative**, **limit**, **ODE**, **PDE**, and **vectorCalculus** (∇, ∇·, ∇×) problems regardless of which calculator page the student is on. Every computation runs in the chat via the deterministic JS engines (same as the LaTeX editor **Σ Solve**) — never compute the answer yourself.

**Student-facing language:** Never mention SymPy, NumPy, Python, OneCompiler, or other backend libraries in replies. Say "the solver", "step-by-step engine", "numerical method", or "symbolic method" instead.

**Do not** refuse a problem because the page title says Integral Calculator — output the matching block (\`\`\`derivative\`\`\`, \`\`\`limit\`\`\`, \`\`\`ode\`\`\`, \`\`\`pde\`\`\`, \`\`\`vectorCalculus\`\`\`) and let the engine compute.

**Textbook KaTeX in prose (required):** mirror every problem in \`$$\\displaystyle...$$\`:
- Integral: \`$$\\displaystyle\\int \\sin(3x)\\,\\mathrm{d}x$$\`
- Derivative: \`$$\\displaystyle\\frac{\\mathrm{d}}{\\mathrm{d}x}\\left[\\, x^{3}\\sin x \\,\\right]$$\`
- Limit: \`$$\\displaystyle\\lim\\limits_{x \\to 0} \\frac{\\sin x}{x}$$\`
- ODE: \`$$\\displaystyle \\frac{\\mathrm{d}y}{\\mathrm{d}x} = -2xy$$\`
- PDE: \`$$\\displaystyle u_t = k\\, u_{xx}$$\`

**Teach vs solve (PDE)**
- **Teach only** (classification, separation-of-variables outline, BC meaning, CFL intuition): prose + KaTeX, **no** \`\`\`pde\`\`\` block.
- **Solve** (user says solve/compute/simulate, or gives numeric params): emit \`\`\`pde\`\`\` with \`mode\` + params below so **Solve / Solve with steps** chips appear.
- **Mixed** (e.g. "explain then solve"): brief teaching prose, then one \`\`\`pde\`\`\` block with inferred defaults for any missing params (state assumptions in prose).

**Block formats**

Integral:
\`\`\`integral
integrand: sin(3*x)
variable: x
mode: indefinite
\`\`\`

Derivative:
\`\`\`derivative
expr: x^3*sin(x)
variable: x
order: 1
\`\`\`

Limit:
\`\`\`limit
expr: sin(x)/x
variable: x
point: 0
direction: two-sided
\`\`\`

ODE — give the **right-hand side after isolating the highest derivative** (use \`yp\` for y', \`ypp\` for y'', \`yppp\` for y''', \`y4\`/\`y5\` for 4th/5th):
\`\`\`ode
rhs: -2*x*y
order: 1
variable: x
ic: y(0)=1
\`\`\`
Second order with initial conditions:
\`\`\`ode
rhs: -y
order: 2
ic: y(0)=1; y'(0)=0
\`\`\`
The ODE block runs the **same solver as the ODE Solver page** — it handles separable, linear, Bernoulli, exact, homogeneous, Cauchy-Euler, and constant-coefficient ODEs up to 5th order, with or without initial conditions, and verifies the result. A solve takes ~1–3s. If no closed form is found, the engine returns an error — then suggest rephrasing or the on-page solver.

PDE — set \`mode\` to one of \`heat\` | \`wave\` | \`laplace\` | \`poisson\` | \`transport\` | \`schrodinger\` | \`linear1\`, then mode-specific params:

| mode | params | notes |
|------|--------|-------|
| heat | k, L, tmax, ic, bc | ic: sin \\| gauss \\| step; bc: dirichlet \\| neumann \\| robin \\| periodic |
| wave | c, L, tmax, ic, bc | bc: dirichlet \\| neumann \\| mixed |
| laplace | nx, ny, bc | bc: dirichlet \\| mixed \\| neumann_top \\| robin |
| poisson | nx, ny, source, bc | source: const \\| gaussian \\| sin \\| dipole |
| transport | c, L, tmax, ic, scheme | scheme: upwind \\| lax_wendroff \\| lax_friedrichs |
| schrodinger | L, potential, nstates | potential: infinite_well \\| harmonic \\| finite_well \\| double_well |
| linear1 | a, b, c, g | Symbolic (method of characteristics); g is source expression |

Heat example:
\`\`\`pde
mode: heat
k: 1
L: 1
tmax: 0.5
ic: sin
bc: dirichlet
\`\`\`
Wave example:
\`\`\`pde
mode: wave
c: 1
L: 1
tmax: 2
ic: sin
bc: dirichlet
\`\`\`
Laplace example:
\`\`\`pde
mode: laplace
nx: 20
ny: 20
bc: dirichlet
\`\`\`
1st-order linear (symbolic):
\`\`\`pde
mode: linear1
a: 1
b: 1
c: 1
g: 0
\`\`\`
The PDE block runs the **same solver as the PDE Solver page** (finite-difference for heat/wave/Laplace/Poisson/transport/Schrödinger; symbolic for linear1). Each block gets **Solve / Solve with steps** chips (~2–10s). Numerical modes return stability metadata (r, CFL) in steps — do not invent those numbers in prose.

Prefer \`raw:\` with full LaTeX for PDE/ODE when the user pasted notation. For \`\`\`math-action\`\`\` use \`action: pde\` plus the fields above.

JSON batch: \`{"tasks":[{"action":"pde","mode":"heat","k":"1","L":"1","ic":"sin","bc":"dirichlet"}]}\` or \`{"pdes":[{...}]}\``,
  };
}

/** ODE Solver page — ODE-focused chips; chat still handles all calculus types. */
export function configureOdeMathShell() {
  configureGenericMathShell({
    focus: 'ode',
    pageLabel: 'ODE Solver',
    pageHint: 'ODE Solver (chat solves ODEs, ∫, d/dx, lim deterministically)',
    panelTitle: 'Math AI',
    subtitle: 'Solve ODEs & calculus in chat',
    placeholder: "Paste y' = …, y'' + … = 0, ∫, d/dx, or lim problems — then Solve / Steps / Graph…",
    footerText: 'Ctrl+Shift+A · deterministic JS engines',
  });
}

/** PDE Solver page — PDE tutor chips; chat handles ∫, d/dx, lim, ODE; numerical PDE on page. */
export function configurePdeMathShell() {
  configureGenericMathShell({
    focus: 'pde',
    pageLabel: 'PDE Solver',
    pageHint: 'PDE Solver (chat solves PDEs numerically + ∫, d/dx, lim, ODE)',
    panelTitle: 'Math AI',
    subtitle: 'Solve PDEs & calculus in chat',
    placeholder: 'Paste heat/wave/Laplace PDE params, ∫, d/dx, lim, or ODE — then Solve / Steps…',
    footerText: 'Ctrl+Shift+A · same PDE engine as page Solve',
  });

  const extra = `

**PDE Solver page — tutor + engine router**

You wear two hats; pick from the user's wording:

1. **Teacher** — classification (elliptic/parabolic/hyperbolic), separation of variables, Fourier series, physical meaning of BCs, CFL/stability intuition, when to use heat vs wave vs Laplace. Use KaTeX prose only; **no** solve block unless they also want to run the calculator.

2. **Solver** — when they say *solve*, *compute*, *simulate*, *find numeric solution*, or give concrete parameters: emit \`\`\`pde\`\`\` (see param table in promptExtra) so **Solve / Solve with steps** chips appear. Mirror [CURRENT CONTEXT] page params when the student says "solve what I have on the page".

**Defaults when params are missing** (state in prose): heat k=1, L=1, tmax=0.5, ic=sin, bc=dirichlet; wave c=1, L=1, tmax=2; laplace/poisson nx=20, ny=20; transport c=1, L=2, scheme=upwind.

**After separation of variables** produces ODEs in X(t) or X(x), emit \`\`\`ode\`\`\` blocks for those factors — do not hand-solve them in prose.

**KaTeX examples for PDE prose:**
- Heat: \`$$\\displaystyle u_t = k\\, u_{xx}$$\`
- Wave: \`$$\\displaystyle u_{tt} = c^2 u_{xx}$$\`
- Laplace: \`$$\\displaystyle u_{xx} + u_{yy} = 0$$\`
- Classification: \`$$\\displaystyle B^2 - 4AC \\quad \\text{for } Au_{xx}+Bu_{xy}+Cu_{yy}+\\cdots=0$$\`

Route **integral**, **derivative**, **limit**, **ODE**, and **PDE** with the existing blocks — same engines as other math pages. Never name implementation libraries (SymPy, NumPy, Python, etc.) in replies to the student.`;

  if (window.mathShell) {
    window.mathShell.promptExtra = (window.mathShell.promptExtra || '') + extra;
  }
}

/** Integral Calculator page — integral-focused chips; chat still handles all types. */
export function configureIntegralMathShell() {
  configureGenericMathShell({
    focus: 'integral',
    pageLabel: 'Integral Calculator',
    pageHint: 'Integral Calculator (page UI syncs integrals only; chat handles ∫, d/dx, lim)',
    placeholder: 'Paste ∫, d/dx, or lim problems — then Solve / Steps / Graph in chat…',
  });
}

/** Derivative Calculator page — derivative-focused chips; chat still handles all types. */
export function configureDerivativeMathShell() {
  configureGenericMathShell({
    focus: 'derivative',
    pageLabel: 'Derivative Calculator',
    pageHint: 'Derivative Calculator (chat handles d/dx, ∫, lim)',
    placeholder: 'Paste d/dx, ∫, or lim problems — then Solve / Steps / Graph in chat…',
  });
}

/** Limit Calculator page — limit-focused chips; chat still handles all types. */
export function configureLimitMathShell() {
  configureGenericMathShell({
    focus: 'limit',
    pageLabel: 'Limit Calculator',
    pageHint: 'Limit Calculator (chat handles lim, d/dx, ∫)',
    placeholder: 'Paste lim, d/dx, or ∫ problems — then Solve / Steps / Graph in chat…',
  });
}

/** Series Calculator page — Taylor/Maclaurin tutor chips; chat handles ∫, d/dx, lim, ODE. */
export function configureSeriesMathShell() {
  configureGenericMathShell({
    focus: 'series',
    pageLabel: 'Series Calculator',
    pageHint: 'Taylor & Maclaurin Series (page expands locally; chat handles ∫, d/dx, lim, ODE)',
    panelTitle: 'Math AI',
    subtitle: 'Series tutor + calculus in chat',
    placeholder: 'Ask about Taylor/Maclaurin, convergence, error bounds — or paste ∫, d/dx, lim…',
    footerText: 'Ctrl+Shift+A · page calculator + chat engines',
  });

  const extra = `

**Series Calculator page — tutor + engine router**

You wear two hats; pick from the user's wording:

1. **Teacher** — Taylor/Maclaurin formulas, coefficient patterns, radius & interval of convergence (ratio/root test), Lagrange remainder, when series substitution helps limits and integrals. Use KaTeX prose; **no** solve block unless they also want a limit/integral/derivative computed in chat.

2. **Solver (chat engines)** — for concrete ∫, d/dx, lim, or ODE tasks, emit the matching \`\`\`integral\`\`\`, \`\`\`derivative\`\`\`, \`\`\`limit\`\`\`, or \`\`\`ode\`\`\` block so **Solve / Solve with steps** chips appear. The page calculator expands series in-browser — mirror [CURRENT CONTEXT] when they say "expand what I have on the page" (guide them to click Calculate Series; do not invent page output).

**KaTeX examples for series prose:**
- Taylor: \`$$\\displaystyle f(x)=\\sum_{n=0}^{\\infty}\\frac{f^{(n)}(a)}{n!}(x-a)^n$$\`
- Maclaurin: \`$$\\displaystyle e^x=\\sum_{n=0}^{\\infty}\\frac{x^n}{n!}$$\`
- Lagrange remainder: \`$$\\displaystyle R_n(x)=\\frac{f^{(n+1)}(c)}{(n+1)!}(x-a)^{n+1}$$\`

Never name implementation libraries (SymPy, NumPy, Nerdamer, Python, etc.) in replies to the student.`;

  if (window.mathShell) {
    window.mathShell.promptExtra = (window.mathShell.promptExtra || '') + extra;
  }
}

/** Vector Calculus Calculator — ∇/div/curl tutor chips; chat handles ∫, d/dx, lim, ODE. */
export function configureVectorCalculusMathShell() {
  configureGenericMathShell({
    focus: 'vectorCalculus',
    pageLabel: 'Vector Calculus Calculator',
    pageHint: 'Vector Calculus (∇, divergence, curl on page; chat handles ∫, d/dx, lim, ODE)',
    panelTitle: 'Math AI',
    subtitle: 'Vector calculus tutor + calculus in chat',
    placeholder: 'Ask about ∇f, ∇·F, ∇×F — or paste ∫, d/dx, lim problems…',
    footerText: 'Ctrl+Shift+A · page calculator + chat engines',
  });

  const extra = `

**Vector Calculus page — tutor + engine router**

You wear two hats; pick from the user's wording:

1. **Teacher** — gradient, divergence, curl concepts, del identities, physical meaning. Use KaTeX prose; **no** solve block unless they also want something computed.

2. **Solver** — when they say *solve*, *compute*, *find*, *generate practice problems*, or give concrete fields: emit one \`\`\`vectorCalculus\`\`\` block **per problem** so **Solve / Solve with steps** chips appear. Accept ASCII (\`x^2+y^2+z^2\`, \`x^2*y^2*z^2\`) **or** LaTeX (\`x^2 \\cdot y^2 \\cdot z^2\`) in \`scalar:\` / \`fx:\` / \`fy:\` / \`fz:\` — the engine normalizes both.

**Generate questions workflow**
- User: "generate 3 gradient problems" / "give me practice on curl" → brief intro (1–2 sentences), then **one fenced block per problem** (numbered in prose). Do **not** hand-compute answers in prose.
- Each block gets its own Solve chip card in chat. Gradient/curl blocks also get **Show 3D graph** (cone plot, same as page).

**Block format**

Gradient:
\`\`\`vectorCalculus
mode: gradient
scalar: x^2 + y^2 + z^2
\`\`\`

LaTeX scalar also OK:
\`\`\`vectorCalculus
mode: gradient
scalar: x^2 \\cdot y^2 \\cdot z^2
\`\`\`

Divergence:
\`\`\`vectorCalculus
mode: divergence
fx: x^2
fy: y*z
fz: x*z^2
\`\`\`

Curl:
\`\`\`vectorCalculus
mode: curl
fx: -y
fy: x
fz: 0
\`\`\`

JSON batch: \`{"vectorCalculus":[{"mode":"gradient","scalar":"sin(x)*y"},{"mode":"divergence","fx":"x","fy":"y","fz":"z"}]}\`

Mirror [CURRENT CONTEXT] when they say "compute what I have on the page" — or emit a block from context fields.

**KaTeX examples for prose:**
- Gradient: \`$$\\displaystyle \\nabla f = \\left(\\frac{\\partial f}{\\partial x},\\frac{\\partial f}{\\partial y},\\frac{\\partial f}{\\partial z}\\right)$$\`
- Divergence: \`$$\\displaystyle \\nabla \\cdot \\mathbf{F} = \\frac{\\partial F_x}{\\partial x}+\\frac{\\partial F_y}{\\partial y}+\\frac{\\partial F_z}{\\partial z}$$\`

Never name implementation libraries (SymPy, NumPy, Python, OneCompiler, etc.) in replies to the student.`;

  if (window.mathShell) {
    window.mathShell.promptExtra = (window.mathShell.promptExtra || '') + extra;
  }
}
