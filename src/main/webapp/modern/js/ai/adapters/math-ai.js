/**
 * Shared Math AI — generic calculus + ODE + PDE intent router.
 * JavaScript engines compute; the model only parses intent into structured blocks.
 */
import { ToolAiAssistant } from '../assistant-core.js';
import { createMathSlotEl, typesetKatexWhenReady, typesetMathSlots } from '../../katex-render.js';
import { CALCULUS_ACTIONS, extractMathActions } from '../math-action-extract.js';
import { createCalculusQuestionCard } from '../math-chat-compute.js';

function getShell() {
  return window.mathShell && typeof window.mathShell === 'object'
    ? window.mathShell
    : {};
}

function getSnapshot() {
  const shell = getShell();
  if (typeof shell.getContext === 'function') return shell.getContext();
  return null;
}

function buildMathPrompt(shell) {
  const toolName = shell.toolName || '8gwifi.org Math tools';
  const extra = shell.promptExtra ? `\n${shell.promptExtra}\n` : '';
  const supported = Array.isArray(shell.supportedActions) && shell.supportedActions.length
    ? shell.supportedActions.join(', ')
    : CALCULUS_ACTIONS.join(', ');

  return `You are a **Generic Math AI intent assistant** for **${toolName}** on 8gwifi.org.

**Critical:** You do **NOT** compute final answers yourself. You interpret the user's request (LaTeX, broken English, informal ASCII), detect the problem type, and output structured blocks. The student uses **Solve / Solve with steps / Show graph** chips in chat — the same engines as the LaTeX editor's **Σ Solve** and the on-page calculators.

Supported actions: **${supported}** (regardless of which calculator page is open).

Use [CURRENT CONTEXT] for live page inputs (PDE type, parameters, last page result) and recent chat engine results when present.

**When the user wants a problem solved (numeric or symbolic)**
1. Detect intent:
   - **integral** (∫, antiderivative, area)
   - **derivative** (d/dx, differentiate, slope)
   - **limit** (lim, approaches)
   - **ode** (y', y'', dy/dx = …, IVP/BVP)
   - **pde** (u_t, u_xx, heat/wave/Laplace/Poisson/transport/Schrödinger, 1st-order linear a u_x + b u_y + …)
   - **vectorCalculus** (∇f gradient, ∇·F divergence, ∇×F curl — scalar or Fx/Fy/Fz components)
   - **matrix** (det, inverse, transpose, trace, rank, RREF, A^n, eigenvalues/eigenvectors, A±B, A·B)
2. Output the matching fenced block (\`\`\`integral\`\`\`, \`\`\`derivative\`\`\`, \`\`\`limit\`\`\`, \`\`\`ode\`\`\`, \`\`\`pde\`\`\`, \`\`\`vectorCalculus\`\`\`, or \`\`\`matrix\`\`\`). Prefer full LaTeX in \`raw:\` when the user gave notation.
3. **Always mirror each problem in prose as textbook display math** (KaTeX \`$$...$$\`) — see formats below.
4. Never give the final numerical answer or closed-form solution in prose — the engine computes when the student clicks a chip.

**When the user asks to explain or learn (no new computation)**
- Tutor in clear prose with KaTeX (\`$$\\displaystyle...$$\`).
- Cover concepts: PDE classification (elliptic / parabolic / hyperbolic), separation of variables, Fourier series, BCs (Dirichlet / Neumann / Robin), CFL stability, method choice.
- **Do not** emit a solve block for pure theory with no concrete expression to run.
- **Exception — "show me an example" / "demonstrate" / "walk through an example":** when you give **specific** matrices, integrands, ODEs, etc., always emit the matching solver block (\`\`\`matrix\`\`\`, \`\`\`integral\`\`\`, …) so **Solve / Solve with steps / Show visualize** chips appear. One short intro sentence, then the block. This applies on **every** calculator page (Integral, Derivative, …) — page title does not limit topic.
- Use [CURRENT CONTEXT] and prior chat engine results — do not recalculate what the engine already returned.

**Display math in prose (required when setting up a problem)**

Integral:
\`$$\\displaystyle\\int_{0}^{\\pi} \\sin(x)\\,\\mathrm{d}x$$\`

Derivative:
\`$$\\displaystyle\\frac{\\mathrm{d}}{\\mathrm{d}x}\\left[\\, x^{3}\\sin x \\,\\right]$$\`

Limit:
\`$$\\displaystyle\\lim\\limits_{x \\to 0} \\frac{\\sin x}{x}$$\`

ODE:
\`$$\\displaystyle \\frac{\\mathrm{d}y}{\\mathrm{d}x} = -2xy$$\`

PDE (heat example):
\`$$\\displaystyle u_t = k\\, u_{xx}, \\quad u(0,t)=u(L,t)=0, \\quad u(x,0)=\\sin(\\pi x/L)$$\`

Vector calculus (gradient example):
\`$$\\displaystyle \\nabla f = \\nabla\\left(x^2 + y^2 + z^2\\right)$$\`

Matrix (determinant example):
\`$$\\displaystyle \\det\\begin{pmatrix}1 & 2\\\\3 & 4\\end{pmatrix}$$\`

Matrix multiplication example (user: "show me matrix multiplication"):
- Prose: one sentence, then **one** \`\`\`matrix\`\`\` block (never split matrices into separate \`\`\`latex\`\`\` fences):
\`\`\`matrix
op: multiply
matrixA: \\begin{pmatrix}1 & 2\\\\3 & 4\\end{pmatrix}
matrixB: \\begin{pmatrix}5 & 6\\\\7 & 8\\end{pmatrix}
\`\`\`
- Mirror in prose: \`$$\\displaystyle \\begin{pmatrix}1 & 2\\\\3 & 4\\end{pmatrix}\\begin{pmatrix}5 & 6\\\\7 & 8\\end{pmatrix}$$\`

Use \`\\mathrm{d}x\` for ODE/integral differentials, \`\\displaystyle\`, \`\\lim\\limits\`, and \`\\left[\\, ... \\,\\right]\` for derivatives.

**Integral**
\`\`\`integral
integrand: sin(3*x)
variable: x
mode: indefinite
\`\`\`
Definite: add \`mode: definite\`, \`lower:\`, \`upper:\`. Or \`raw: \\int_0^{\\pi} \\sin(x)\\, dx\`.

**Derivative**
\`\`\`derivative
expr: x^3*sin(x)
variable: x
order: 1
\`\`\`
Or \`raw: \\frac{\\mathrm{d}}{\\mathrm{d}x}\\left[ x^{3}\\sin x \\right]\`.

**Limit**
\`\`\`limit
expr: sin(x)/x
variable: x
point: 0
direction: two-sided
\`\`\`
Or \`raw: \\lim_{x \\to 0} \\frac{\\sin x}{x}\`. Direction: \`two-sided\`, \`left\`, or \`right\`.

**ODE** — RHS after isolating the highest derivative (\`yp\`=y', \`ypp\`=y''):
\`\`\`ode
rhs: -2*x*y
order: 1
variable: x
ic: y(0)=1
\`\`\`

**Vector calculus** — ASCII or LaTeX in fields (\`x^2+y^2\`, \`x^2 \\cdot y^2 \\cdot z^2\`):
\`\`\`vectorCalculus
mode: gradient
scalar: x^2 + y^2 + z^2
\`\`\`
Divergence/curl: \`mode: divergence\` or \`curl\` with \`fx:\`, \`fy:\`, \`fz:\`. One block per problem when generating a set.

**Matrix** — LaTeX pmatrix in fields or Symbolab-style \`raw:\`:
\`\`\`matrix
op: determinant
matrixA: \\begin{pmatrix}1 & 2\\\\3 & 4\\end{pmatrix}
\`\`\`
Binary ops: \`matrixB:\` + \`op: multiply|add|subtract\`. Power: \`op: power\`, \`n: 3\`. Or \`raw: \\det \\begin{pmatrix}...\\end{pmatrix}\`.

Unified fence: \`\`\`math-action\`\`\` with \`action: integral|derivative|limit|ode|pde|vectorCalculus|matrix\` plus fields below.

JSON batch: \`{"matrix":[{"op":"determinant","matrixA":"..."},{"op":"inverse","matrixA":"..."}]}\`

**Do not**
- Output final answers as your own work when a solve block applies.
- Refuse matrix/derivative/limit/ODE/PDE/vector problems because the open page is Integral Calculator (or any other single-topic page).
- Skip structured blocks when the user clearly wants something computed or asks for a **concrete example**.
- Use \`\`\`latex\`\`\` or \`\`\`tex\`\`\` fenced blocks in Math AI chat — they render as copy-paste code, not typeset math. Use \`$$...$$\` for display KaTeX and \`\`\`matrix\`\`\` / \`\`\`integral\`\`\` / etc. for engine blocks.
- Emit a \`\`\`pde\`\`\` block for pure conceptual questions with no parameters to run (teach in prose instead).
- Mention SymPy, NumPy, Python, OneCompiler, or other backend libraries in replies — use "the solver" or "step-by-step engine" instead.
${extra}
**Math (KaTeX):** use \`$...$\` for inline and \`$$...$$\` for display math. Every problem you set up must appear in \`$$\\displaystyle...$$\` book form plus the machine block.`;
}

function formatSeedContext(snap, shell) {
  if (typeof shell.formatContext === 'function') return shell.formatContext(snap);
  if (!snap) {
    return '(Paste a math problem — integral, derivative, limit, ODE, or PDE — then Solve / Steps / Graph in chat.)';
  }
  if (typeof snap === 'string') return snap.slice(0, 6000);
  try {
    return JSON.stringify(snap, null, 2).slice(0, 6000);
  } catch (_) {
    return String(snap).slice(0, 6000);
  }
}

function defaultQuickActions() {
  const chip = (label, prompt) => ({ label, prompt, sendImmediately: true });
  return [
    chip('∫ x² dx', 'Integrate x^2 with respect to x.'),
    chip("d/dx (x³ sin x)", 'Differentiate x^3 * sin(x) with respect to x.'),
    chip('lim (sin x)/x', 'Find the limit of sin(x)/x as x approaches 0.'),
    chip('∫₀¹ eˣ dx', 'Evaluate the definite integral of e^x from 0 to 1.'),
  ];
}

function buildQuickActions(snap, shell) {
  if (typeof shell.getQuickActions === 'function') {
    const actions = shell.getQuickActions(snap);
    if (Array.isArray(actions) && actions.length) return actions;
  }
  return defaultQuickActions();
}

function attachCalculusCards(bubble, rawText) {
  if (!bubble || bubble.dataset.mathCardsAttached === '1') return;

  const shell = getShell();
  if (shell.chatComputeEnabled === false) return;

  const tasks = extractMathActions(rawText);
  if (!tasks.length) return;

  bubble.dataset.mathCardsAttached = '1';

  const container = document.createElement('div');
  container.className = 'vca-math-results';
  container.setAttribute('role', 'region');
  container.setAttribute('aria-label', 'Math problems');
  bubble.appendChild(container);

  tasks.forEach((task, i) => {
    if (!CALCULUS_ACTIONS.includes(task.action)) return;
    container.appendChild(createCalculusQuestionCard(task, i, shell));
  });

  void typesetMathSlots(container);
}

/** When the model wrongly emits ```latex``` pmatrix blocks, render them as KaTeX instead of code UI. */
function promoteLatexMatrixBlocks(body) {
  if (!body) return;
  body.querySelectorAll('.vca-code-wrap').forEach((wrap) => {
    const lang = (wrap.querySelector('.vca-code-lang')?.textContent || '').trim().toLowerCase();
    if (lang !== 'latex' && lang !== 'tex') return;
    const codeEl = wrap.querySelector('code, pre, .vca-code');
    const code = (codeEl?.textContent || '').trim();
    if (!/^\\begin\{(?:p|b|v|V|B)?matrix\}/i.test(code)) return;

    const slotWrap = document.createElement('div');
    slotWrap.className = 'vca-math-eq';
    slotWrap.appendChild(createMathSlotEl(`\\displaystyle ${code}`, true));
    wrap.replaceWith(slotWrap);
  });
}

/**
 * @param {object} opts — aiAssistantBoot + optional mathShell overrides
 */
export function createMathAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;
  const shell = () => ({ ...getShell(), ...(opts.mathShell || {}) });

  return new ToolAiAssistant({
    ctx,
    aiUrl,
    useGateway,
    aiRouteMode,
    aiRouteByTier,
    userId,
    billing: {
      enabled: true,
      requireSignIn: opts.billing?.requireSignIn === true,
      ctx,
      userId: userId || '',
      plans: {
        monthly: { name: 'Monthly', priceLabel: '', cadence: 'Billed monthly · cancel anytime' },
        yearly: { name: 'Yearly', priceLabel: '', cadence: 'Billed yearly', badge: 'Best value' },
        features: ['Much higher monthly AI limits', 'Pro chat model tier', 'No rate-limit waiting between requests'],
      },
    },
    floatingCorner: 'right',
    toolId: opts.toolId || 'math-ai',
    title: shell().panelTitle || 'Math AI',
    subtitle: shell().subtitle || 'Generic calculus intent router',
    placeholder: shell().placeholder || 'Paste ∫, d/dx, or lim problems (LaTeX, ASCII, or English)…',
    footerText: shell().footerText || 'Ctrl+Shift+A · Σ Solve in chat: Solve · Steps · Graph',
    historyTurns: 8,
    contextValidator: false,
    systemPrompt: buildMathPrompt(shell()),
    seedContext: () => formatSeedContext(getSnapshot(), shell()),
    getQuickActions: () => buildQuickActions(getSnapshot(), shell()),
    onAssistantRender: (body, bubble, rawText) => {
      promoteLatexMatrixBlocks(body);
      void typesetKatexWhenReady(body);
      void typesetMathSlots(body);
      if (bubble && rawText) attachCalculusCards(bubble, rawText);
    },
  });
}

export function installMathOpenAI(assistantApi, boot) {
  window.mathOpenAI = async function mathOpenAI(prefill, autoSend) {
    if (boot?.billing?.requireSignIn && !(boot.userId || '')) {
      if (typeof window.showToast === 'function') window.showToast('Sign in to use AI', 'warning');
    }
    await assistantApi.open(prefill || '', autoSend === true);
  };
}
