/**
 * Generic Math AI — calculus shell (integral, derivative, limit).
 * Page tool UI is optional context; engines run in chat regardless of current page.
 */
import { CALCULUS_ACTIONS, formatMathActionLabel } from '../../math-action-extract.js';
import {
  solveDerivativeTask,
  solveIntegralTask,
  solveLimitTask,
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
      if (typeof window.icGetContext === 'function') return window.icGetContext();
      if (typeof window.dcGetContext === 'function') return window.dcGetContext();
      if (typeof window.lcGetContext === 'function') return window.lcGetContext();
      return null;
    },

    formatContext(snap) {
      const chat = Array.isArray(window.mathShell?.lastChatResults)
        ? window.mathShell.lastChatResults
        : [];
      const lines = [];

      if (pageHint) lines.push(`Page: ${pageHint}`);

      if (snap) {
        lines.push(
          `Mode: ${snap.mode || '(n/a)'}`,
          `Variable: ${snap.variable || 'x'}`,
          `Expression: ${snap.expr || snap.integrand || '(empty)'}`,
        );
        if (snap.mode === 'definite') {
          lines.push(`Bounds: [${snap.lower ?? '?'}, ${snap.upper ?? '?'}]`);
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
        return '(Paste calculus problems in chat — integral, derivative, or limit — then Solve / Steps / Graph.)';
      }
      return lines.join('\n');
    },

    getQuickActions() {
      return focusQuickActions(this.focus || focus);
    },

    promptExtra: `**Generic Math AI:** Route **integral**, **derivative**, and **limit** problems regardless of which calculator page the student is on. The chat engines are the same as the LaTeX editor **Σ Solve**.

**Do not** refuse a derivative because the page title says Integral Calculator — output \`\`\`derivative\`\`\` and let the engine compute.

**Textbook KaTeX in prose (required):** mirror every problem in \`$$\\displaystyle...$$\`:
- Integral: \`$$\\displaystyle\\int \\sin(3x)\\,\\mathrm{d}x$$\`
- Derivative: \`$$\\displaystyle\\frac{\\mathrm{d}}{\\mathrm{d}x}\\left[\\, x^{3}\\sin x \\,\\right]$$\`
- Limit: \`$$\\displaystyle\\lim\\limits_{x \\to 0} \\frac{\\sin x}{x}$$\`

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

Prefer \`raw:\` with full LaTeX when the user pasted \\int, \\frac{d}{dx}, or \\lim.

JSON batch: \`{"tasks":[{"action":"derivative",...},{"action":"limit",...}]}\`

Each block gets **Solve / Solve with steps / Show graph** chips in chat.`,
  };
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
