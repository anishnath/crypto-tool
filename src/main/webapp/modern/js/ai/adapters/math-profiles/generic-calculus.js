/**
 * Generic Math AI — calculus shell (integral, derivative, limit).
 * Page tool UI is optional context; engines run in chat regardless of current page.
 */
import { MATH_ACTIONS, CALCULUS_ACTIONS, formatMathActionLabel } from '../../math-action-extract.js';
import {
  solveDerivativeTask,
  solveIntegralTask,
  solveLimitTask,
  solveOdeTask,
  solvePdeTask,
  solveVectorCalculusTask,
  solveVectorTask,
  solveMatrixTask,
  solveBodeTask,
  solveLaplaceTask,
  solveZTransformTask,
  solveTrigTask,
  solveStatisticsTask,
} from '../../math-chat-compute.js';
import { solveAlgebraTask } from '../../algebra-chat-compute.js';
import { icApplyIntegralTask } from './integral-calculator.js';

/** Tutor-first quick-action chips. One "Show example" may emit a solver block; others are prose/teaching. */
const chip = (label, prompt) => ({ label, prompt, sendImmediately: true });

function ctxSnippet(snap, keys) {
  if (!snap || typeof snap !== 'object') return '';
  for (const k of keys) {
    const v = snap[k];
    if (v == null) continue;
    if (Array.isArray(v) && v.length) return String(v.join('; ')).slice(0, 140);
    if (String(v).trim()) return String(v).slice(0, 140);
  }
  return '';
}

function buildFocusQuickActions(focus, snap) {
  const s = snap || {};
  const integralExpr = ctxSnippet(s, ['integrand', 'expr']);
  const derivExpr = ctxSnippet(s, ['expr', 'integrand']);
  const limitExpr = ctxSnippet(s, ['expr']);
  const odeExpr = ctxSnippet(s, ['equation', 'expr', 'rhs']);
  const quadExpr = ctxSnippet(s, ['expr', 'raw']);
  const ineqExpr = ctxSnippet(s, ['expr', 'raw']);
  const polyP = ctxSnippet(s, ['p1', 'p', 'expr']);
  const tfExpr = ctxSnippet(s, ['transferFunction', 'expr']);
  const ltExpr = ctxSnippet(s, ['forwardExpr', 'inverseExpr', 'expr']);
  const ztExpr = ctxSnippet(s, ['forwardExpr', 'inverseExpr', 'expr']);
  const pnExpr = ctxSnippet(s, ['checkExpr', 'expr']);
  const trigExpr = ctxSnippet(s, ['expr', 'lhs']);
  const eqs = ctxSnippet(s, ['equations']);
  const ctx = (line) => (line ? ` Current page input: ${line}.` : '');

  const sets = {
    integral: [
      chip("Don't get it", `Explain integrals in plain language — indefinite vs definite, notation, and what the answer means.${ctx(integralExpr)} Prose + KaTeX only; no solve block unless I ask.`),
      chip('Which technique?', `Which integration technique should I try first for this type of integrand (substitution, parts, partial fractions, trig)? Strategy and reasoning only — no full worked solution.${ctx(integralExpr)}`),
      chip('Exam tip', 'Exam tips for integration: common mistakes, when to simplify first, and how to write +C and bounds for partial credit.'),
      chip('Show example', 'Give one classic integral example with a ```integral``` block so I can click Solve. One short intro sentence, then the block.'),
    ],
    derivative: [
      chip("Don't get it", `Explain derivatives in plain language — rate of change, Leibniz notation, and how to read d/dx.${ctx(derivExpr)} Prose + KaTeX only.`),
      chip('Which rule?', `Which differentiation rules apply here (power, product, quotient, chain)? Strategy only — do not give the final derivative.${ctx(derivExpr)}`),
      chip('Exam tip', 'Exam tips for derivatives: product vs chain rule pitfalls, implicit differentiation checks, and notation graders expect.'),
      chip('Show example', 'Give one clear derivative example with a ```derivative``` block so I can click Solve. One intro sentence, then the block.'),
    ],
    limit: [
      chip("Don't get it", `Explain limits in plain language — what "x approaches a" means and one-sided vs two-sided limits.${ctx(limitExpr)} Prose + KaTeX only.`),
      chip('Which approach?', `For a limit like mine, should I try direct substitution, factoring, L'Hôpital, or a series? Outline the strategy without computing the final value.${ctx(limitExpr)}`),
      chip('Exam tip', 'Exam tips for limits: indeterminate forms, when L\'Hôpital applies, and how to justify each step for partial credit.'),
      chip('Show example', 'Give one standard limit example with a ```limit``` block so I can click Solve. One intro sentence, then the block.'),
    ],
    ode: [
      chip("Don't get it", `Explain ODEs in plain language — order, initial conditions, and what a general vs particular solution means.${ctx(odeExpr)} Prose + KaTeX only.`),
      chip('Which method?', `For an ODE like mine, is it separable, linear, exact, or need an integrating factor? Name the method and first step only — no full solution.${ctx(odeExpr)}`),
      chip('Exam tip', 'Exam tips for ODEs: checking ICs, writing the general solution before applying conditions, and common sign errors.'),
      chip('Show example', 'Give one ODE example with a ```ode``` block so I can click Solve. One intro sentence, then the block.'),
    ],
    pde: [
      chip("Don't get it", 'Explain PDEs in plain language — classification (elliptic/parabolic/hyperbolic), boundary vs initial conditions, and what the heat/wave/Laplace models represent. Prose + KaTeX only.'),
      chip('Which method?', 'For a PDE like heat or wave, outline separation of variables or finite-difference intuition — teaching only, no ```pde``` solve block unless I ask to compute.'),
      chip('Exam tip', 'Exam tips for PDEs: naming BC types, stability/CFL intuition, and how to set up a well-posed problem statement.'),
      chip('Show example', 'Give one concrete PDE setup with a ```pde``` block (heat or wave with numeric params) so I can click Solve. Brief intro, then the block.'),
    ],
    series: [
      chip("Don't get it", 'Explain Taylor/Maclaurin series in plain language — coefficients, radius of convergence, and when a series approximation is useful. Prose + KaTeX only.'),
      chip('Which test?', 'How do I pick between ratio test, root test, or known series for convergence? Strategy for a series problem like mine — no full expansion unless I ask.'),
      chip('Exam tip', 'Exam tips for series: Lagrange error bound wording, center vs Maclaurin, and common radius-of-convergence mistakes.'),
      chip('Show example', 'Give one Taylor/Maclaurin walkthrough for e^x or sin(x) through degree 4. Prose + KaTeX; add a ```limit``` block only if you want me to verify a related limit.'),
    ],
    vectorCalculus: [
      chip("Don't get it", 'Explain gradient, divergence, and curl in plain language — what each operator measures geometrically. Prose + KaTeX only.'),
      chip('Which operator?', 'When should I use ∇, ∇·, or ∇× for a vector field problem? Decision guide with one tiny example — no full computation unless I ask.'),
      chip('Exam tip', 'Exam tips for vector calculus: notation for div/curl, conservative fields, and common component-sign errors.'),
      chip('Show example', 'Give one vector calculus example (gradient, div, or curl) with a ```vectorCalculus``` block so I can click Solve. One intro sentence, then the block.'),
    ],
    vector: [
      chip("Don't get it", 'Explain dot product, cross product, and vector projection in plain language — geometric meaning and when each returns a scalar vs vector. Prose + KaTeX only.'),
      chip('Which operation?', 'For vectors like mine on the page, which operation fits (dot, cross, magnitude, projection)? Strategy only — no final numbers unless I ask.'),
      chip('Exam tip', 'Exam tips for vector arithmetic: 3D-only cross product, zero-vector edge cases, and angle formula domain.'),
      chip('Show example', 'Give one vector example (dot or cross product) with a ```vector``` block so I can click Solve. One intro sentence, then the block.'),
    ],
    matrix: [
      chip("Don't get it", 'Explain matrix operations in plain language — determinant, inverse, eigenvalues, and when each is used. Prose + KaTeX only.'),
      chip('Which operation?', 'For a matrix task like mine, which operation or method fits (row reduction, cofactor expansion, eigen decomposition)? Strategy only — no final numbers unless I ask.'),
      chip('Exam tip', 'Exam tips for linear algebra: row-echelon vs inverse method, dimension checks for multiply, and how to state "no inverse" correctly.'),
      chip('Show example', 'Give one matrix example (det, inverse, or multiply) with a ```matrix``` block so I can click Solve. One intro sentence, then the block.'),
    ],
    quadratic: [
      chip("Don't get it", `Explain quadratic equations in plain language — roots, discriminant, vertex, and what the calculator shows.${ctx(quadExpr)} Prose + KaTeX only.`),
      chip('Which method?', `When should I factor vs use the quadratic formula vs complete the square? Strategy for my type of equation — no full worked answer.${ctx(quadExpr)}`),
      chip('Exam tip', 'Exam tips for quadratics: discriminant cases, exact vs decimal roots, and writing quadratic inequalities in interval notation.'),
      chip('Show example', 'Give one quadratic example with a ```quadratic``` block so I can click Solve. One intro sentence, then the block.'),
    ],
    system: [
      chip("Don't get it", `Explain systems of equations in plain language — substitution vs elimination, linear vs nonlinear, and what "no solution" means.${ctx(eqs)} Prose + KaTeX only.`),
      chip('Which method?', `For a system like mine, should I use substitution, elimination/Cramer, or graphing? Pick a method and outline the first step only.${ctx(eqs)}`),
      chip('Exam tip', 'Exam tips for systems: checking solutions, dependent vs inconsistent systems, and how to write ordered-pair answers.'),
      chip('Show example', 'Give one 2×2 linear system with a ```system``` block (eq1/eq2 lines) so I can click Solve. One intro sentence, then the block.'),
    ],
    inequality: [
      chip("Don't get it", `Explain solving inequalities in plain language — sign charts, open vs closed endpoints, and interval notation.${ctx(ineqExpr)} Prose + KaTeX only.`),
      chip('Which approach?', `For an inequality like mine, should I use a sign chart, test points, or algebraic isolation? Outline the strategy without the final solution set.${ctx(ineqExpr)}`),
      chip('Exam tip', 'Exam tips for inequalities: flipping the sign when multiplying by negatives, rational inequalities, and writing ∪ interval notation.'),
      chip('Show example', 'Give one inequality example with an ```inequality``` block so I can click Solve. One intro sentence, then the block.'),
    ],
    polynomial: [
      chip("Don't get it", `Explain polynomial operations in plain language — factoring patterns, long division, and the Rational Root Theorem.${ctx(polyP)} Prose + KaTeX only.`),
      chip('Which technique?', `For a polynomial like mine, should I factor, use synthetic division, or apply RRT? Strategy only — no full factorization unless I ask.${ctx(polyP)}`),
      chip('Exam tip', 'Exam tips for polynomials: factoring order, remainder theorem checks, and stating roots with multiplicity.'),
      chip('Show example', 'Give one polynomial example (factor or divide) with a ```polynomial``` block so I can click Solve. One intro sentence, then the block.'),
    ],
    bode: [
      chip("Don't get it", `Explain Bode plots in plain language — magnitude vs phase, dB scale, and what H(jω) means.${ctx(tfExpr)} Prose + KaTeX only.`),
      chip('Gain & phase margin', 'How do I read gain margin and phase margin from a Bode plot? Explain crossover frequencies and stability — no numbers unless from my transfer function.'),
      chip('Poles & zeros', 'How do pole and zero locations shape the magnitude and phase curves? Outline corner frequencies and ±20 dB/decade slopes for my type of H(s).'),
      chip('Show example', 'Give one transfer-function Bode example with a ```bode``` block so I can click Solve / Show Bode plot. One intro sentence, then the block.'),
    ],
    laplace: [
      chip("Don't get it", `Explain Laplace transforms in plain language — L{f(t)}, s-domain vs t-domain, and why engineers use them.${ctx(ltExpr)} Prose + KaTeX only.`),
      chip('Partial fractions', 'When do I need partial fractions for inverse Laplace? Outline the decomposition strategy for rational F(s) — no full worked inverse unless I ask.'),
      chip('ROC & pairs', 'How do I read the region of convergence and use the Laplace pairs table? Explain Re(s) constraints for common entries.'),
      chip('Show example', 'Give one Laplace transform example with a ```laplace-transform``` block so I can click Solve / Show graph. One intro sentence, then the block.'),
    ],
    ztransform: [
      chip("Don't get it", `Explain Z-transforms in plain language — Z{x[n]}, z-domain vs n-domain, and digital signal processing.${ctx(ztExpr)} Prose + KaTeX only.`),
      chip('Residue method', 'When do I use partial fractions vs the residue method for inverse Z-transform? Outline the strategy for rational X(z) — no full worked inverse unless I ask.'),
      chip('ROC & pairs', 'How do I read the region of convergence |z| > r and use Z-transform pairs? Explain causal sequences and the unit circle.'),
      chip('Show example', 'Give one Z-transform example with a ```z-transform``` block so I can click Solve / Show graph. One intro sentence, then the block.'),
    ],
    statistics: [
      chip("Don't get it", 'Explain this statistics concept in plain language — mean vs median, variance, hypothesis tests, or distributions. Use [CURRENT CONTEXT] data when present. Prose + KaTeX only.'),
      chip('Which test?', 'For my type of problem, should I use a t-test, z-test, chi-square, or ANOVA? Outline the decision tree — no computed p-values unless I run the page calculator.'),
      chip('Interpret results', 'How do I read p-values, confidence intervals, and effect sizes? Explain α, β, and practical vs statistical significance without inventing numbers for my dataset.'),
      chip('Show example', 'Give one related math example with a matching solver block (```statistics```, ```integral```, ```matrix```, ```quadratic```) so I can click Solve in chat. One intro sentence, then the block.'),
    ],
    'prime-number': [
      chip("Don't get it", `Explain prime numbers in plain language — divisibility, why 1 is not prime, and how factorization works.${ctx(pnExpr)} Prose + KaTeX only.`),
      chip('Miller-Rabin?', 'When is Miller-Rabin deterministic vs probabilistic? Explain what a witness tells us — no claiming primality of my number unless I ran Check on the page.'),
      chip('Goldbach & twins', 'Explain Goldbach\'s conjecture and twin primes intuitively. Relate to my even N or a list I generated — teaching only unless I ask for a ```integral``` or ```matrix``` example.'),
      chip('Show example', 'Give one related math example with a matching solver block (```integral```, ```quadratic```, ```matrix```, etc.) so I can click Solve in chat. One intro sentence, then the block.'),
    ],
    collatz: [
      chip("Don't get it", 'Explain the Collatz conjecture (3n+1) in plain language — the even/odd rule, hailstone analogy, and why it is unsolved. Prose + KaTeX only.'),
      chip('Why is 27 famous?', 'Why is starting number 27 a classic Collatz example? Explain stopping time and peak value intuitively — point me to **Start sequence** on the page to see the animation.'),
      chip('Stopping time?', 'What is total stopping time vs peak value in a Collatz orbit? How do they differ? Strategy for exploring patterns — no inventing orbit data for my N unless I ran the page.'),
      chip('Show example', 'Give one related math example with a matching solver block (```integral```, ```quadratic```, ```matrix```, etc.) so I can click Solve in chat. One intro sentence, then the block.'),
    ],
    trig: [
      chip("Don't get it", `Explain trig functions in plain language — unit circle, radians vs degrees, and special angles.${ctx(trigExpr)} Prose + KaTeX only.`),
      chip('Which identity?', 'When should I use Pythagorean, double-angle, or sum formulas? Strategy for simplifying or proving — no full derivation unless I ask.'),
      chip('Exam tip', 'Exam tips for trig: ASTC signs, reference angles, general solutions with +2πn, and exact values at 30°/45°/60°.'),
      chip('Show example', 'Give one trig example with a ```trig``` block (mode, expr, unit) so I can click Solve / Show graph. One intro sentence, then the block.'),
    ],
    hub: [
      // Concrete starter problems — clicking sends a real problem so the solver
      // block + Solve/Steps/Graph chips appear immediately, and students learn
      // by example that they can paste their own problem the same way.
      chip('Solve x² − 5x + 6 = 0', 'Solve x^2 - 5x + 6 = 0'),
      chip('∫ x·eˣ dx', 'Integrate x*e^x dx'),
      chip('d/dx sin(x²)', 'Differentiate sin(x^2)'),
      chip('Mean & standard deviation', 'Find the mean and standard deviation of 4, 8, 15, 16, 23, 42'),
      chip('Determinant of a 2×2', 'Find the determinant of [[1, 2], [3, 4]]'),
      chip('Which method should I use?', 'I have a math problem but I am not sure which method or formula to use. Explain how to choose the right approach across algebra, calculus, statistics, and linear algebra, with tiny examples. Prose + KaTeX only — no solve block.'),
    ],
  };

  return sets[focus] || sets.integral;
}

const FOCUS_KEYS = new Set([
  'integral', 'derivative', 'limit', 'ode', 'pde', 'series',
  'vectorCalculus', 'matrix', 'quadratic', 'system', 'inequality', 'polynomial', 'bode', 'laplace', 'ztransform', 'statistics', 'prime-number', 'collatz', 'trig', 'hub',
]);

/**
 * @param {object} [opts]
 * @param {'integral'|'derivative'|'limit'} [opts.focus]
 */
export function configureGenericMathShell(opts = {}) {
  const pageLabel = opts.pageLabel || opts.toolName || '8gwifi.org Math';
  const pageHint = opts.pageHint || '';
  const focus = FOCUS_KEYS.has(opts.focus) ? opts.focus : 'integral';

  window.mathShell = {
    toolName: pageLabel,
    focus,
    panelTitle: opts.panelTitle || 'Math AI',
    subtitle: opts.subtitle || 'Parse calculus · Σ Solve in chat',
    placeholder: opts.placeholder || 'Paste ∫, d/dx, or lim problems (LaTeX, ASCII, or English)…',
    footerText: opts.footerText || 'Ctrl+Shift+A · same engines as LaTeX editor Σ Solve',
    emptyState: opts.emptyState || null,
    supportedActions: opts.supportedActions || MATH_ACTIONS.slice(),
    batchDelayMs: 120,
    chatComputeEnabled: true,
    syncToCalculator: false,

    formatActionLabel: formatMathActionLabel,

    computeInChat(task, mode = 'simple') {
      if (!task?.action || !MATH_ACTIONS.includes(task.action)) {
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
      if (task.action === 'vector') return solveVectorTask(task, mode);
      if (task.action === 'matrix') return solveMatrixTask(task, mode);
      if (task.action === 'bode') return solveBodeTask(task, mode);
      if (task.action === 'laplace') return solveLaplaceTask(task, mode);
      if (task.action === 'ztransform') return solveZTransformTask(task, mode);
      if (task.action === 'trig') return solveTrigTask(task, mode);
      if (task.action === 'statistics') return solveStatisticsTask(task, mode);
      return solveAlgebraTask(task, mode);
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
      if (typeof window.statGetContext === 'function') return window.statGetContext();
      if (typeof window.ztGetContext === 'function') return window.ztGetContext();
      if (typeof window.ltGetContext === 'function') return window.ltGetContext();
      if (typeof window.tfnGetContext === 'function') return window.tfnGetContext();
      if (typeof window.teqGetContext === 'function') return window.teqGetContext();
      if (typeof window.tidGetContext === 'function') return window.tidGetContext();
      if (typeof window.pnGetContext === 'function') return window.pnGetContext();
      if (typeof window.ccGetContext === 'function') return window.ccGetContext();
      if (typeof window.bpGetContext === 'function') return window.bpGetContext();
      if (typeof window.qsGetContext === 'function') return window.qsGetContext();
      if (typeof window.syGetContext === 'function') return window.syGetContext();
      if (typeof window.iqGetContext === 'function') return window.iqGetContext();
      if (typeof window.polyGetContext === 'function') return window.polyGetContext();
      if (typeof window.mcGetContext === 'function') return window.mcGetContext();
      if (typeof window.vcalcGetContext === 'function') return window.vcalcGetContext();
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
        } else if (snap.toolType === 'matrix') {
          lines.push(`Page operation: ${snap.op || 'determinant'}`);
          if (snap.matrixA) lines.push(`Matrix A: ${String(snap.matrixA).slice(0, 400)}`);
          if (snap.matrixB) lines.push(`Matrix B: ${String(snap.matrixB).slice(0, 400)}`);
          if (snap.n != null) lines.push(`Exponent n: ${snap.n}`);
        } else if (snap.toolType === 'vector') {
          lines.push(`Page operation: ${snap.op || 'add'}`);
          lines.push(`Dimension: ${snap.dim || 3}D`);
          if (snap.a) lines.push(`Vector a: (${snap.a.join(', ')})`);
          if (snap.b) lines.push(`Vector b: (${snap.b.join(', ')})`);
          if (snap.c) lines.push(`Vector c: (${snap.c.join(', ')})`);
          if (snap.scalar != null) lines.push(`Scalar k: ${snap.scalar}`);
        } else if (snap.toolType === 'quadratic' || snap.toolType === 'inequality') {
          lines.push(`Expression: ${snap.expr || '(empty)'}`);
          if (snap.method) lines.push(`Method: ${snap.method}`);
          if (snap.variable) lines.push(`Variable: ${snap.variable}`);
        } else if (snap.toolType === 'system') {
          lines.push(`Method: ${snap.method || 'gaussian'}`);
          if (Array.isArray(snap.equations)) {
            snap.equations.forEach((eq, i) => lines.push(`  eq${i + 1}: ${eq}`));
          }
        } else if (snap.toolType === 'polynomial') {
          lines.push(`Operation: ${snap.op || 'factor'}`);
          if (snap.p1) lines.push(`P(x): ${String(snap.p1).slice(0, 200)}`);
          if (snap.p2) lines.push(`Q(x): ${String(snap.p2).slice(0, 200)}`);
        } else if (snap.toolType === 'bode') {
          lines.push(`Input mode: ${snap.mode || 'transfer'}`);
          if (snap.mode === 'zpk') {
            if (snap.zeros) lines.push(`Zeros: ${snap.zeros}`);
            if (snap.poles) lines.push(`Poles: ${snap.poles}`);
            if (snap.gain) lines.push(`Gain K: ${snap.gain}`);
          } else if (snap.transferFunction) {
            lines.push(`H(s): ${String(snap.transferFunction).slice(0, 400)}`);
          }
        } else if (snap.toolType === 'laplace') {
          lines.push(`Mode: ${snap.mode || 'forward'}`);
          if (snap.mode === 'inverse') {
            if (snap.inverseExpr) lines.push(`F(s): ${String(snap.inverseExpr).slice(0, 400)}`);
          } else if (snap.forwardExpr) {
            lines.push(`f(t): ${String(snap.forwardExpr).slice(0, 400)}`);
          }
        } else if (snap.toolType === 'ztransform') {
          lines.push(`Mode: ${snap.mode || 'forward'}`);
          if (snap.mode === 'inverse') {
            if (snap.inverseExpr) lines.push(`X(z): ${String(snap.inverseExpr).slice(0, 400)}`);
          } else if (snap.forwardExpr) {
            lines.push(`x[n]: ${String(snap.forwardExpr).slice(0, 400)}`);
          }
        } else if (snap.toolType === 'statistics') {
          if (snap.pageKey) lines.push(`Page: ${snap.pageKey}`);
          if (snap.data) lines.push(`Data/context: ${String(snap.data).slice(0, 400)}`);
        } else if (snap.toolType === 'prime-number') {
          if (snap.checkExpr) lines.push(`Check/factorize: ${String(snap.checkExpr).slice(0, 400)}`);
          if (snap.limitN) lines.push(`Generate ≤ N: ${snap.limitN}`);
          if (snap.rangeA != null && snap.rangeB != null) {
            lines.push(`Range: [${snap.rangeA}, ${snap.rangeB}]`);
          }
          if (snap.lastResult) lines.push(`Last result: ${String(snap.lastResult).slice(0, 200)}`);
        } else if (snap.toolType === 'collatz') {
          if (snap.startNumber != null) lines.push(`Starting number: ${snap.startNumber}`);
          if (snap.speedMs != null) lines.push(`Animation speed: ${snap.speedMs}ms`);
          if (snap.stoppingTime != null) lines.push(`Stopping time (last run): ${snap.stoppingTime} steps`);
          if (snap.peakValue != null) lines.push(`Peak value (last run): ${snap.peakValue}`);
          if (snap.statusText) lines.push(`Status: ${String(snap.statusText).slice(0, 200)}`);
        } else if (snap.toolType === 'trig-fn' || snap.toolType === 'trig-eq' || snap.toolType === 'trig-id') {
          lines.push(`Page mode: ${snap.mode || '(n/a)'}`);
          if (snap.unit) lines.push(`Angle unit: ${snap.unit}`);
          if (snap.expr) lines.push(`Expression: ${String(snap.expr).slice(0, 400)}`);
          if (snap.lhs) lines.push(`LHS: ${String(snap.lhs).slice(0, 300)}`);
          if (snap.rhs) lines.push(`RHS: ${String(snap.rhs).slice(0, 300)}`);
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
        return '(Paste any math problem — ∫, lim, ODE, matrix, Bode H(s), Laplace/Z-transform, trig, statistics, quadratic, system, inequality, polynomial — then Solve / Steps / Graph in chat.)';
      }
      return lines.join('\n');
    },

    getQuickActions(snap) {
      return buildFocusQuickActions(this.focus || focus, snap);
    },

    promptExtra: `**Generic Math AI:** Route **integral**, **derivative**, **limit**, **ODE**, **PDE**, **vectorCalculus** (∇, ∇·, ∇×), **matrix** (det, inverse, eigenvalues, A·B, …), **bode** (H(s) Bode magnitude/phase), **laplace** (forward/inverse Laplace transform — not the PDE Laplace equation), **ztransform** (forward/inverse Z-transform for discrete signals), **trig** (evaluate, solve equations/inequalities, simplify, prove identities, quadrant/coterminal), **statistics** (descriptive stats, z-score, normal CDF, percentile), **quadratic**, **system**, **inequality**, and **polynomial** problems regardless of which calculator page the student is on. Every computation runs in chat via the same JS engines as the on-page calculators — never compute the answer yourself.

**Student-facing language:** Never mention SymPy, NumPy, Python, OneCompiler, or other backend libraries in replies. Say "the solver", "step-by-step engine", "numerical method", or "symbolic method" instead.

**Do not** refuse a problem because the page title says Integral Calculator — output the matching block (\`\`\`derivative\`\`\`, \`\`\`limit\`\`\`, \`\`\`ode\`\`\`, \`\`\`pde\`\`\`, \`\`\`vectorCalculus\`\`\`, \`\`\`matrix\`\`\`) and let the engine compute.

**Cross-topic examples:** On the Integral page (or any page), "show me matrix multiplication" → \`\`\`matrix\`\`\` block with \`op: multiply\`, \`matrixA:\`, \`matrixB:\` (pmatrix LaTeX). "Find det of …" → \`\`\`matrix\`\`\` with \`op: determinant\`. Never answer with only \`\`\`latex\`\`\` copy-paste blocks.

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
    pageHint: 'Integral Calculator (page UI syncs integrals only; chat handles ∫, d/dx, lim, matrix, ODE, PDE, ∇)',
    placeholder: 'Paste ∫, d/dx, lim, matrix, ODE… — Solve / Steps / Graph in chat…',
  });

  const extra = `

**Integral Calculator page — cross-topic routing (CRITICAL)**
The on-page calculator only integrates, but **Math AI engines are generic**. When the user asks about **matrices** (det, inverse, A·B, eigenvalues, …), **derivatives**, **limits**, **ODEs**, **PDEs**, or **vector calculus** — emit the correct \`\`\`matrix\`\`\`, \`\`\`derivative\`\`\`, \`\`\`limit\`\`\`, \`\`\`ode\`\`\`, \`\`\`pde\`\`\`, or \`\`\`vectorCalculus\`\`\` block. **Never** refuse or reply "this page is for integrals only."

**"Show me an example"** (matrix multiplication, det, inverse, …): one intro sentence + **one** \`\`\`matrix\`\`\` block with concrete pmatrix values so **Solve / Solve with steps / Show visualize** chips appear. Do **not** use \`\`\`latex\`\`\` code fences for matrices.`;

  if (window.mathShell) {
    window.mathShell.promptExtra = (window.mathShell.promptExtra || '') + extra;
  }
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

/** Matrix Calculator — linear algebra tutor + matrix solver in chat. */
export function configureMatrixMathShell() {
  configureGenericMathShell({
    focus: 'matrix',
    pageLabel: 'Matrix Calculator',
    pageHint: 'Matrix Calculator (13 ops on page; chat handles matrix + ∫, d/dx, lim, ODE)',
    panelTitle: 'Math AI',
    subtitle: 'Matrix tutor + linear algebra solver in chat',
    placeholder: 'Ask about det, inverse, eigenvalues — or paste ∫, d/dx, lim…',
    footerText: 'Ctrl+Shift+A · page calculator + chat engines',
  });

  const extra = `

**Matrix Calculator page — tutor + engine router**

You wear two hats; pick from the user's wording:

1. **Teacher** — matrix concepts (determinant as area/volume scaling, inverse meaning, eigenvalues/eigenvectors, rank, RREF, multiplication rules). Use KaTeX prose; **no** solve block unless they also want something computed.

2. **Solver** — when they say *solve*, *compute*, *find*, *generate practice problems*, or give concrete matrices: emit one \`\`\`matrix\`\`\` block **per problem** so **Solve / Solve with steps** chips appear (and **Show visualize** when matrices are numeric 2×2 or 3×3 on det, inverse, transpose, eigenvectors, power, multiply, add, subtract). Use LaTeX \`\\begin{pmatrix}...\\end{pmatrix}\` in \`matrixA:\` / \`matrixB:\` fields.

**Supported ops (op: field)**
determinant, inverse, transpose, trace, rank, rref, power (needs \`n:\`), eigenvalues, eigenvectors, charpoly, add, subtract, multiply

**Block format**

Determinant:
\`\`\`matrix
op: determinant
matrixA: \\begin{pmatrix}1 & 2\\\\3 & 4\\end{pmatrix}
\`\`\`

Inverse:
\`\`\`matrix
op: inverse
matrixA: \\begin{pmatrix}4 & 7\\\\2 & 6\\end{pmatrix}
\`\`\`

Multiply:
\`\`\`matrix
op: multiply
matrixA: \\begin{pmatrix}1 & 2\\\\3 & 4\\end{pmatrix}
matrixB: \\begin{pmatrix}5 & 6\\\\7 & 8\\end{pmatrix}
\`\`\`

Symbolab-style raw also OK:
\`\`\`matrix
raw: \\det \\begin{pmatrix}1 & 2 & 3\\\\4 & 5 & 6\\\\7 & 8 & 10\\end{pmatrix}
\`\`\`

JSON batch: \`{"matrix":[{"op":"determinant","matrixA":"\\\\begin{pmatrix}1&2\\\\3&4\\\\end{pmatrix}"},{"op":"inverse","matrixA":"..."}]}\`

Mirror [CURRENT CONTEXT] when they say "compute what I have on the page" — or emit a block from context fields.

Never name implementation libraries (SymPy, Python, OneCompiler, etc.) in replies to the student.`;

  if (window.mathShell) {
    window.mathShell.promptExtra = (window.mathShell.promptExtra || '') + extra;
  }
}

/** Vector Calculator — discrete vector ops tutor + chat solver. */
export function configureVectorMathShell() {
  configureGenericMathShell({
    focus: 'vector',
    pageLabel: 'Vector Calculator',
    pageHint: 'Vectors — dot, cross, magnitude, projection, angle (2D/3D)',
    panelTitle: 'Math AI',
    subtitle: 'Vector tutor + discrete ops solver in chat',
    placeholder: 'Ask about dot/cross product, projection — or paste ∫, matrix, ODE…',
    footerText: 'Ctrl+Shift+A · page calculator + chat engines',
  });

  const extra = `

**Vector Calculator page — tutor + engine router**

1. **Teacher** — dot/cross product geometry, magnitude, unit vectors, projection/rejection, triple scalar product, linear independence. Use KaTeX prose; mirror [CURRENT CONTEXT] when the student has vectors on the page.

2. **Solver** — when they say *compute*, *find*, *calculate*, or give concrete vectors: emit one \`\`\`vector\`\`\` block **per problem** so **Solve / Solve with steps** chips appear.

**Supported ops (op: field)**
add, subtract, scalar_multiply, dot_product, cross_product, magnitude, unit_vector, angle, projection, rejection, area, triple_scalar, linear_independence

**Block format**

Dot product:
\`\`\`vector
op: dot_product
dim: 3
vectorA: [1, 2, 3]
vectorB: [4, -1, 2]
\`\`\`

Cross product:
\`\`\`vector
op: cross_product
vectorA: 1,2,3
vectorB: 4,-1,2
\`\`\`

Magnitude:
\`\`\`vector
op: magnitude
dim: 2
vectorA: [3, 4]
\`\`\`

JSON batch: \`{"vector":[{"op":"dot_product","vectorA":[1,2,3],"vectorB":[4,-1,2]}]}\`

For **∇ / div / curl** on fields use \`\`\`vectorCalculus\`\`\` — not this block.

Never name implementation libraries in replies to the student.`;

  if (window.mathShell) {
    window.mathShell.promptExtra = (window.mathShell.promptExtra || '') + extra;
  }

  registerContextGetter('vcalcGetContext', () => {
    const parse = (prefix) => {
      const x = parseFloat(document.getElementById(`vc-${prefix}x`)?.value);
      const y = parseFloat(document.getElementById(`vc-${prefix}y`)?.value);
      const z = parseFloat(document.getElementById(`vc-${prefix}z`)?.value);
      const dimBtn = document.querySelector('.vc-dim-btn.active');
      const dim = dimBtn ? parseInt(dimBtn.getAttribute('data-dim'), 10) : 3;
      if (!Number.isFinite(x) || !Number.isFinite(y)) return null;
      return dim === 2 ? [x, y] : [x, y, Number.isFinite(z) ? z : 0];
    };
    const modeBtn = document.querySelector('.vc-mode-btn.active');
    const dimBtn = document.querySelector('.vc-dim-btn.active');
    return {
      toolType: 'vector',
      op: modeBtn?.getAttribute('data-mode') || 'add',
      dim: dimBtn ? parseInt(dimBtn.getAttribute('data-dim'), 10) : 3,
      a: parse('a'),
      b: parse('b'),
      c: parse('c'),
      scalar: document.getElementById('vc-scalar')?.value?.trim() || '',
    };
  });
}

function registerContextGetter(name, fn) {
  if (typeof window !== 'undefined') window[name] = fn;
}

/** Bode Plot Generator — control-systems tutor chips; chat handles ∫, ODE, matrix, etc. */
export function configureBodeMathShell() {
  configureGenericMathShell({
    focus: 'bode',
    pageLabel: 'Bode Plot Generator',
    pageHint: 'Bode Plot — H(s) magnitude & phase, gain/phase margin',
    panelTitle: 'Math AI',
    subtitle: 'Bode tutor + full math router in chat',
    placeholder: 'Ask about Bode plots, H(s), stability — or paste ∫, ODE, matrix problems…',
    footerText: 'Ctrl+Shift+A · page Bode engine + chat solvers',
  });

  const extra = `

**Bode Plot page — tutor + engine router**

1. **Teacher** — Bode magnitude/phase, corner frequencies, asymptotic slopes (±20 dB/decade per pole/zero), gain & phase margin, PID/lead-lag intuition. Use KaTeX prose; mirror [CURRENT CONTEXT] H(s) when present.

2. **Solver** — for concrete H(s) or ZPK problems emit a \`\`\`bode\`\`\` block so **Solve / Solve with steps / Show Bode plot** chips appear. Same SymPy engine as the page — never invent plot data in prose.

Example:
\`\`\`bode
transferFunction: 1/(s^2 + 2*s + 1)
\`\`\`
Or ZPK:
\`\`\`bode
inputMode: zpk
zeros: -1
poles: 0, -10
gain: 10
\`\`\`

For other math ( ∫, ODE, matrix, … ) use the matching block type on any page.`;

  if (window.mathShell) {
    window.mathShell.promptExtra = (window.mathShell.promptExtra || '') + extra;
  }

  registerContextGetter('bpGetContext', () => {
    const modeEl = document.querySelector('.bp-mode-btn.active');
    const mode = modeEl?.getAttribute('data-mode') || 'transfer';
    return {
      toolType: 'bode',
      mode,
      transferFunction: document.getElementById('bp-tf-expr')?.value?.trim() || '',
      zeros: document.getElementById('bp-zpk-zeros')?.value?.trim() || '',
      poles: document.getElementById('bp-zpk-poles')?.value?.trim() || '',
      gain: document.getElementById('bp-zpk-gain')?.value?.trim() || '1',
    };
  });
}

/** Laplace Transform Calculator — signals tutor + generic math router. */
export function configureLaplaceMathShell() {
  configureGenericMathShell({
    focus: 'laplace',
    pageLabel: 'Laplace Transform Calculator',
    pageHint: 'Laplace — forward L{f(t)} & inverse L⁻¹{F(s)}, ROC, partial fractions',
    panelTitle: 'Math AI',
    subtitle: 'Laplace tutor + full math router in chat',
    placeholder: 'Ask about Laplace transforms, ROC, partial fractions — or paste ∫, ODE, matrix problems…',
    footerText: 'Ctrl+Shift+A · page Laplace engine + chat solvers',
  });

  const extra = `

**Laplace Transform page — tutor + engine router**

1. **Teacher** — forward/inverse Laplace, ROC, partial fractions, shifting theorems, Heaviside, solving ODEs via L{f(t)}. Use KaTeX prose; mirror [CURRENT CONTEXT] f(t) or F(s) when present.

2. **Solver** — for concrete forward/inverse Laplace problems emit a \`\`\`laplace-transform\`\`\` block so **Solve / Solve with steps / Show graph** chips appear. Same SymPy engine as the page — never invent transform results in prose.

Forward example:
\`\`\`laplace-transform
mode: forward
forwardExpr: t*exp(-2*t)
\`\`\`

Inverse example:
\`\`\`laplace-transform
mode: inverse
inverseExpr: 1/(s+1)^2
\`\`\`

For related problems in chat, also use \`\`\`ode\`\`\`, \`\`\`integral\`\`\`, \`\`\`bode\`\`\`, etc. **Do not** confuse \`laplace\` PDE mode (\`u_xx + u_yy = 0\`) with Laplace **transform** — transforms use action \`laplace\` / fence \`laplace-transform\`; elliptic PDE uses \`\`\`pde\`\`\` with \`mode: laplace\`.`;

  if (window.mathShell) {
    window.mathShell.promptExtra = (window.mathShell.promptExtra || '') + extra;
  }

  registerContextGetter('ltGetContext', () => {
    const modeEl = document.querySelector('.lt-mode-btn.active');
    const mode = modeEl?.getAttribute('data-mode') || 'forward';
    return {
      toolType: 'laplace',
      mode,
      forwardExpr: document.getElementById('lt-forward-expr')?.value?.trim() || '',
      inverseExpr: document.getElementById('lt-inverse-expr')?.value?.trim() || '',
    };
  });
}

/** Z-Transform Calculator — DSP tutor + generic math router. */
export function configureZTransformMathShell() {
  configureGenericMathShell({
    focus: 'ztransform',
    pageLabel: 'Z-Transform Calculator',
    pageHint: 'Z-transform — forward Z{x[n]} & inverse Z⁻¹{X(z)}, ROC, partial fractions',
    panelTitle: 'Math AI',
    subtitle: 'Z-transform tutor + full math router in chat',
    placeholder: 'Ask about Z-transforms, ROC, residue method — or paste ∫, ODE, matrix problems…',
    footerText: 'Ctrl+Shift+A · page Z-transform engine + chat solvers',
  });

  const extra = `

**Z-Transform page — tutor + engine router**

1. **Teacher** — forward/inverse Z-transform, ROC, partial fractions, shifting properties, digital filters H(z), difference equations. Use KaTeX prose; mirror [CURRENT CONTEXT] x[n] or X(z) when present.

2. **Solver** — for concrete forward/inverse Z-transform problems emit a \`\`\`z-transform\`\`\` block so **Solve / Solve with steps / Show graph** chips appear. Same SymPy engine as the page — never invent transform results in prose.

Forward example:
\`\`\`z-transform
mode: forward
forwardExpr: (1/2)^n
\`\`\`

Inverse example:
\`\`\`z-transform
mode: inverse
inverseExpr: z/(z-1/2)
\`\`\`

For related problems in chat, also use \`\`\`laplace-transform\`\`\`, \`\`\`bode\`\`\`, \`\`\`integral\`\`\`, etc.`;

  if (window.mathShell) {
    window.mathShell.promptExtra = (window.mathShell.promptExtra || '') + extra;
  }

  registerContextGetter('ztGetContext', () => {
    const modeEl = document.querySelector('.zt-mode-btn.active');
    const mode = modeEl?.getAttribute('data-mode') || 'forward';
    return {
      toolType: 'ztransform',
      mode,
      forwardExpr: document.getElementById('zt-forward-expr')?.value?.trim() || '',
      inverseExpr: document.getElementById('zt-inverse-expr')?.value?.trim() || '',
    };
  });
}

/** Statistics calculators — tutor + generic math router (page engine stays on-page). */
export function configureStatisticsMathShell() {
  const meta = (typeof window !== 'undefined' && window.__MS_STAT_PAGE__) || {};
  const pageLabel = meta.label || 'Statistics Calculator';
  const pageKey = meta.key || 'statistics';

  configureGenericMathShell({
    focus: 'statistics',
    pageLabel,
    pageHint: 'Descriptive & inferential statistics — use on-page Calculate; related math via chat blocks',
    panelTitle: 'Math AI',
    subtitle: 'Statistics tutor + full math router in chat',
    placeholder: 'Ask about mean, variance, hypothesis tests, distributions — or paste ∫, matrix, algebra…',
    footerText: 'Ctrl+Shift+A · page stats engine + chat solvers',
  });

  const extra = `

**Statistics page — tutor + engine router**

1. **Teacher** — descriptive stats (mean, median, SD, percentiles), probability, distributions (normal, binomial), confidence intervals, hypothesis tests (z, t, χ², ANOVA), correlation/regression, sample size, effect size. Use KaTeX prose; mirror [CURRENT CONTEXT] when the student has data in the input fields.

2. **Page engine** — for concrete calculations on this page (ANOVA, χ², regression, hypothesis beyond one/two-sample t, binomial, sample size, etc.), tell the student to click **Calculate** / **Compute** on the page. For chat-computable stats, emit \`\`\`statistics\`\`\` with mode: descriptive | zscore | normal | percentile | ttest | correlation.

3. **Related topics** — \`\`\`integral\`\`\`, \`\`\`matrix\`\`\`, \`\`\`quadratic\`\`\`, \`\`\`ode\`\`\`, etc. as needed.

Never invent p-values, test statistics, or regression coefficients in prose when the page calculator can run — point to Calculate or emit a \`\`\`statistics\`\`\` / solver block for follow-ups.`;

  if (window.mathShell) {
    window.mathShell.promptExtra = (window.mathShell.promptExtra || '') + extra;
  }

  registerContextGetter('statGetContext', () => {
    const dataEl = document.querySelector('.stat-input-text, textarea[id$="-data-input"], input[id$="-data-input"]');
    const data = dataEl && ('value' in dataEl) ? String(dataEl.value || '').trim() : '';
    const activeMode = document.querySelector('.stat-mode-btn.active');
    return {
      toolType: 'statistics',
      pageKey,
      mode: activeMode ? (activeMode.id || activeMode.textContent || '').trim() : '',
      data: data.slice(0, 500),
    };
  });
}

/** Prime Number Calculator — number theory tutor + generic math router. */
export function configurePrimeMathShell() {
  configureGenericMathShell({
    focus: 'prime-number',
    pageLabel: 'Prime Number Calculator',
    pageHint: 'Primes — check, factorize, sieve, Goldbach, GCD, twin primes',
    panelTitle: 'Math AI',
    subtitle: 'Number theory tutor + full math router in chat',
    placeholder: 'Ask about primes, factorization, Goldbach — or paste ∫, matrix, algebra…',
    footerText: 'Ctrl+Shift+A · page prime engine + chat solvers',
  });

  const extra = `

**Prime Number page — tutor + engine router**

1. **Teacher** — primality, sieve of Eratosthenes, unique factorization, Goldbach conjecture, twin primes, GCD/coprimality, prime number theorem. Use KaTeX prose; mirror [CURRENT CONTEXT] when the student has a number in the Check field or last page result.

2. **Page engine** — for concrete check/factorize/sieve on this page, tell the student to use **Check**, **Factorize**, or **Go** (same in-browser engine). For related problems in chat, emit matching blocks:
   - Integrals / sums: \`\`\`integral\`\`\`
   - Algebra: \`\`\`quadratic\`\`\`, \`\`\`polynomial\`\`\`, \`\`\`system\`\`\`
   - Linear algebra: \`\`\`matrix\`\`\`

Never invent primality or factorization results in prose when the page calculator can run — point to Check/Factorize or emit a solver block for symbolic/numeric follow-ups.`;

  if (window.mathShell) {
    window.mathShell.promptExtra = (window.mathShell.promptExtra || '') + extra;
  }

  registerContextGetter('pnGetContext', () => {
    const hero = document.getElementById('pn-hero');
    return {
      toolType: 'prime-number',
      checkExpr: document.getElementById('pn-check-input')?.value?.trim() || '',
      limitN: document.getElementById('pn-limit-input')?.value?.trim() || '',
      rangeA: document.getElementById('pn-range-a')?.value?.trim() || '',
      rangeB: document.getElementById('pn-range-b')?.value?.trim() || '',
      nth: document.getElementById('pn-nth-input')?.value?.trim() || '',
      nearest: document.getElementById('pn-nearest-input')?.value?.trim() || '',
      goldbach: document.getElementById('pn-goldbach-input')?.value?.trim() || '',
      lastResult: hero?.textContent?.trim() && hero.textContent.trim() !== '—' ? hero.textContent.trim() : '',
    };
  });
}

/** Collatz Conjecture Explorer — number-theory tutor + generic math router. */
export function configureCollatzMathShell() {
  configureGenericMathShell({
    focus: 'collatz',
    pageLabel: 'Collatz Conjecture Explorer',
    pageHint: 'Collatz 3n+1 — animated hailstone sequences, stopping time, peak value',
    panelTitle: 'Math AI',
    subtitle: 'Collatz tutor + full math router in chat',
    placeholder: 'Ask about 3n+1, stopping time, hailstone — or paste ∫, matrix, algebra…',
    footerText: 'Ctrl+Shift+A · page explorer + chat solvers',
  });

  const extra = `

**Collatz Conjecture page — tutor + engine router**

1. **Teacher** — the 3n+1 rule, hailstone analogy, stopping time, peak value, famous starts (27, 871, 6171), partial results (Tao), why the conjecture is open. Use KaTeX prose; mirror [CURRENT CONTEXT] when the student has a starting number or last run stats on the page.

2. **Page explorer** — for a concrete animated orbit, tell the student to enter N and click **Start sequence** (same in-browser engine with live graph). Do not invent stopping times or peak values for their N in prose — point to Start or describe known famous examples only.

3. **Chat solvers** — for related problems emit matching blocks:
   - Integrals / sums: \`\`\`integral\`\`\`
   - Algebra: \`\`\`quadratic\`\`\`, \`\`\`polynomial\`\`\`, \`\`\`system\`\`\`
   - Linear algebra: \`\`\`matrix\`\`\`

Never name implementation libraries in replies to the student.`;

  if (window.mathShell) {
    window.mathShell.promptExtra = (window.mathShell.promptExtra || '') + extra;
  }

  registerContextGetter('ccGetContext', () => {
    const startEl = document.getElementById('cc-start-number');
    const speedEl = document.getElementById('cc-speed-slider');
    const statsEl = document.getElementById('cc-stats-area');
    const statusEl = document.getElementById('cc-status-area');
    const statsText = statsEl?.textContent?.replace(/\s+/g, ' ').trim() || '';
    let stoppingTime = null;
    let peakValue = null;
    const stepsMatch = statsText.match(/(\d[\d,]*)\s*steps/i);
    if (stepsMatch) stoppingTime = stepsMatch[1].replace(/,/g, '');
    const peakMatch = statsText.match(/peak[:\s]+(\d[\d,]*)/i);
    if (peakMatch) peakValue = peakMatch[1].replace(/,/g, '');
    return {
      toolType: 'collatz',
      startNumber: startEl?.value?.trim() || '',
      speedMs: speedEl?.value || '',
      stoppingTime,
      peakValue,
      statusText: statusEl?.textContent?.trim() || '',
      statsSummary: statsText.slice(0, 400),
    };
  });
}

/** Quadratic Solver — algebra focus on unified Math AI. */
export function configureQuadraticMathShell() {
  configureGenericMathShell({
    focus: 'quadratic',
    pageLabel: 'Quadratic Formula Calculator',
    pageHint: 'Quadratic Solver — equations & quadratic inequalities',
    panelTitle: 'Math AI',
    subtitle: 'Quadratic + full math router in chat',
    placeholder: 'Ask about quadratics — or paste ∫, matrix, systems, inequalities…',
  });
  registerContextGetter('qsGetContext', () => {
    const exprEl = document.getElementById('ic-expr');
    const methodEl = document.getElementById('qs-method');
    return {
      toolType: 'quadratic',
      expr: exprEl?.value?.trim() || '',
      method: methodEl?.value || 'all',
    };
  });
}

/** System of Equations — unified Math AI. */
export function configureSystemMathShell() {
  configureGenericMathShell({
    focus: 'system',
    pageLabel: 'System of Equations Solver',
    pageHint: 'Systems — linear & nonlinear',
    panelTitle: 'Math AI',
    subtitle: 'Systems + full math router in chat',
    placeholder: 'Paste a system — or ask about ∫, matrix, quadratics…',
  });
  registerContextGetter('syGetContext', () => {
    const inputs = document.querySelectorAll('.sy-eq-input');
    const eqs = [];
    inputs.forEach((el) => { const v = el.value?.trim(); if (v) eqs.push(v); });
    const activeMethod = document.querySelector('.sy-method-btn.active');
    return {
      toolType: 'system',
      equations: eqs,
      method: activeMethod?.getAttribute('data-method') || 'cramer',
    };
  });
}

/** Inequality Solver — unified Math AI. */
export function configureInequalityMathShell() {
  configureGenericMathShell({
    focus: 'inequality',
    pageLabel: 'Inequality Solver',
    pageHint: 'Inequalities — sign chart, interval notation',
    panelTitle: 'Math AI',
    subtitle: 'Inequalities + full math router in chat',
    placeholder: 'Paste an inequality — or ask about ∫, matrix, quadratics…',
  });
  registerContextGetter('iqGetContext', () => {
    const exprEl = document.getElementById('ic-expr') || document.getElementById('iq-expr');
    const varEl = document.getElementById('iq-var');
    return {
      toolType: 'inequality',
      expr: exprEl?.value?.trim() || '',
      variable: varEl?.value || 'x',
    };
  });
}

/** Polynomial Calculator — unified Math AI. */
export function configurePolynomialMathShell() {
  configureGenericMathShell({
    focus: 'polynomial',
    pageLabel: 'Polynomial Calculator',
    pageHint: 'Polynomials — factor, divide, roots',
    panelTitle: 'Math AI',
    subtitle: 'Polynomials + full math router in chat',
    placeholder: 'Factor or multiply polynomials — or paste ∫, matrix…',
  });
  registerContextGetter('polyGetContext', () => {
    const p1 = document.getElementById('ic-expr') || document.getElementById('poly-p1');
    const p2 = document.getElementById('poly-p2');
    const modeBtn = document.querySelector('.poly-bridge-op.active, .poly-mode-btn.active');
    return {
      toolType: 'polynomial',
      op: modeBtn?.getAttribute('data-mode') || 'add',
      p1: p1?.value?.trim() || '',
      p2: p2?.value?.trim() || '',
    };
  });
}

function readTrigPageContext(toolType) {
  const modeBtn = document.querySelector('.trig-mode-btn.active');
  const unitBtn = document.querySelector('.trig-unit-btn.active');
  const ctx = {
    toolType,
    mode: modeBtn?.getAttribute('data-mode') || '',
    unit: unitBtn?.getAttribute('data-unit') || '',
    expr: document.getElementById('trig-expr')?.value?.trim() || '',
  };
  const lhsEl = document.getElementById('trig-lhs');
  const rhsEl = document.getElementById('trig-rhs');
  if (lhsEl) ctx.lhs = lhsEl.value?.trim() || '';
  if (rhsEl) ctx.rhs = rhsEl.value?.trim() || '';
  return ctx;
}

function configureTrigMathShell(opts) {
  configureGenericMathShell({
    focus: 'trig',
    pageLabel: opts.pageLabel,
    pageHint: opts.pageHint,
    panelTitle: 'Math AI',
    subtitle: opts.subtitle || 'Trig tutor + full math router in chat',
    placeholder: opts.placeholder || 'Ask about sin/cos/tan — or paste ∫, matrix, algebra…',
    footerText: opts.footerText || 'Ctrl+Shift+A · page calculator + chat solvers',
  });

  const extra = `

**Trigonometry page — tutor + engine router**

1. **Teacher** — unit circle, radians/degrees, ASTC, reference/coterminal angles, identities, general solutions (+2πn). Use KaTeX; mirror [CURRENT CONTEXT] when the student has input on the page.

2. **Page calculator** — for step-by-step with the live graph tab, tell the student to click **Calculate** / **Solve** on the page (same SymPy engine). Do not invent exact values in prose when they can run the page.

3. **Chat solvers** — for concrete trig work emit a \`\`\`trig\`\`\` block so **Solve / Solve with steps / Show graph** chips appear:
   - Evaluate: \`mode: evaluate\`, \`expr: sin(45)\`, \`unit: deg\`
   - Equation: \`mode: solve_equation\`, \`expr: sin(x) = 1/2\`
   - Inequality: \`mode: solve_inequality\`, \`expr: cos(x) > 0\`
   - Simplify: \`mode: simplify\`, \`expr: sin(x)^2 + cos(x)^2\`
   - Identity: \`mode: prove\`, \`lhs: ...\`, \`rhs: ...\`
   - Quadrant / coterminal: \`mode: quadrant\` or \`coterminal\`, \`expr: 210\`, \`unit: deg\`

4. **Related topics** — \`\`\`integral\`\`\`, \`\`\`matrix\`\`\`, \`\`\`quadratic\`\`\`, etc. as needed.

Never name implementation libraries in replies to the student.`;

  if (window.mathShell) {
    window.mathShell.promptExtra = (window.mathShell.promptExtra || '') + extra;
  }

  registerContextGetter(opts.contextKey, () => readTrigPageContext(opts.toolType));
}

/** Trig Function Calculator — evaluate / quadrant / coterminal + Math AI. */
export function configureTrigFunctionMathShell() {
  configureTrigMathShell({
    pageLabel: 'Trigonometric Function Calculator',
    pageHint: 'Trig functions — evaluate, quadrant, coterminal, unit circle graph',
    subtitle: 'Trig tutor + Solve / graph in chat',
    placeholder: 'Ask about sin/cos/tan, special angles — or paste ```trig``` / ∫ / matrix…',
    contextKey: 'tfnGetContext',
    toolType: 'trig-fn',
  });
}

/** Trig Equation Solver — equations, inequalities, simplify + Math AI. */
export function configureTrigEquationMathShell() {
  configureTrigMathShell({
    pageLabel: 'Trigonometric Equation Solver',
    pageHint: 'Trig equations & inequalities — general solutions with graph markers',
    subtitle: 'Equation solver + full math router in chat',
    placeholder: 'Paste sin(x)=… — or ask about identities, ∫, matrix…',
    contextKey: 'teqGetContext',
    toolType: 'trig-eq',
  });
}

/** Trig Identity Calculator — prove / simplify identities + Math AI. */
export function configureTrigIdentityMathShell() {
  configureTrigMathShell({
    pageLabel: 'Trigonometric Identity Calculator',
    pageHint: 'Prove or simplify trig identities — LHS vs RHS graph',
    subtitle: 'Identity prover + full math router in chat',
    placeholder: 'Ask about identities — or paste ```trig``` prove blocks, ∫, matrix…',
    contextKey: 'tidGetContext',
    toolType: 'trig-id',
  });
}

/**
 * Standalone Math AI page profile — neutral focus, all MATH_ACTIONS.
 * Use on a dedicated math-ai.jsp that loads all engine script bundles.
 */
export function configureStandaloneMathShell() {
  configureGenericMathShell({
    focus: 'integral',
    pageLabel: '8gwifi.org Math AI',
    pageHint: 'Standalone Math AI — all topics',
    panelTitle: 'Math AI',
    subtitle: '∫ · lim · ODE · PDE · matrix · algebra — solve in chat',
    placeholder: 'Paste any math problem: calculus, linear algebra, quadratics, systems…',
    footerText: 'Ctrl+Shift+A · unified Math AI · Solve · Steps · Graph',
  });
}

/**
 * Math Studio hub (math/index.jsp) — embedded VCA clone with hub profile.
 * Same chat UI + billing as calculator ✨ AI; only the page shell differs.
 */
export function configureMathHubShell() {
  configureGenericMathShell({
    focus: 'hub',
    pageLabel: '8gwifi.org Math Studio',
    pageHint: 'Math Studio hub — browse calculators, exam prep, and solve any topic in chat',
    panelTitle: 'Math AI',
    subtitle: 'Algebra · calculus · statistics · matrices — step by step',
    placeholder: 'Type any math problem — plain English is fine (e.g. solve x²−5x+6=0, or ∫ x·eˣ dx)',
    footerText: 'Answers appear as cards — click Solve, Steps, or Graph',
    emptyState: {
      title: 'Ask Math AI anything',
      text: 'Type a problem in plain English, LaTeX, or ordinary typing — algebra, calculus, statistics, matrices — and get a worked, step-by-step answer you can trust. New here? Tap a starter below to see it work.',
    },
  });
}
