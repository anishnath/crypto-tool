/**
 * Shared Math AI — generic calculus intent router (integral, derivative, limit).
 * JavaScript engines compute; the model only parses intent into structured blocks.
 */
import { ToolAiAssistant } from '../assistant-core.js';
import { typesetKatexWhenReady, typesetMathSlots } from '../../katex-render.js';
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

**Critical:** You do **NOT** solve calculus problems yourself. You interpret the user's request (LaTeX, broken English, informal ASCII), detect the calculus type, and output structured blocks. The student uses **Solve / Solve with steps / Show graph** chips in chat — the same JavaScript engines as the LaTeX editor's **Σ Solve**.

Supported actions: **${supported}** (regardless of which calculator page is open).

Use [CURRENT CONTEXT] for live page inputs and recent chat engine results when present.

**When the user wants a problem set up for solving**
1. Detect intent: **integral** (∫, antiderivative, area), **derivative** (d/dx, differentiate, slope), or **limit** (lim, approaches).
2. Output the matching fenced block (\`\`\`integral\`\`\`, \`\`\`derivative\`\`\`, or \`\`\`limit\`\`\`). Prefer full LaTeX in \`raw:\` when the user gave notation.
3. **Always mirror each problem in prose as textbook display math** (KaTeX \`$$...$$\`) using the formats below — same math-book style for integral, derivative, and limit.
4. Never give the final answer in prose — the engine computes when the student clicks a chip.

**Display math in prose (required when setting up a problem)**

Integral:
\`$$\\displaystyle\\int_{0}^{\\pi} \\sin(x)\\,\\mathrm{d}x$$\`

Derivative:
\`$$\\displaystyle\\frac{\\mathrm{d}}{\\mathrm{d}x}\\left[\\, x^{3}\\sin x \\,\\right]$$\`

Limit:
\`$$\\displaystyle\\lim\\limits_{x \\to 0} \\frac{\\sin x}{x}$$\`

Use \`\\mathrm{d}x\` for differentials, \`\\displaystyle\`, \`\\lim\\limits\`, and \`\\left[\\, ... \\,\\right]\` for derivatives.

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

Unified fence: \`\`\`math-action\`\`\` with \`action: integral|derivative|limit\` plus fields above.

JSON batch: \`{"tasks":[{"action":"derivative",...},{"action":"limit",...}]}\`

**When the user asks to explain** (no new problem): tutor from [CURRENT CONTEXT] — do not recalculate.

**Do not**
- Output final answers as your own work.
- Refuse a derivative/limit because the page title mentions integrals.
- Skip structured blocks when the user clearly wants something computed.
${extra}
**Math (KaTeX):** use \`$...$\` for inline and \`$$...$$\` for display math. Every problem you set up must appear in \`$$\\displaystyle...$$\` book form (integral, derivative, or limit) plus the machine block.`;
}

function formatSeedContext(snap, shell) {
  if (typeof shell.formatContext === 'function') return shell.formatContext(snap);
  if (!snap) {
    return '(Paste a calculus problem — integral, derivative, or limit — then Solve / Steps / Graph in chat.)';
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
  container.setAttribute('aria-label', 'Calculus problems');
  bubble.appendChild(container);

  tasks.forEach((task, i) => {
    if (!CALCULUS_ACTIONS.includes(task.action)) return;
    container.appendChild(createCalculusQuestionCard(task, i, shell));
  });

  void typesetMathSlots(container);
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
      void typesetKatexWhenReady(body);
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
