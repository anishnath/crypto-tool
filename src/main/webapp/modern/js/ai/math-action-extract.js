/**
 * Extract structured calculus actions from Generic Math AI replies.
 *
 * Fences: ```integral```, ```derivative```, ```limit```, ```math-action```, ```json```
 */
import { normalizeBoundLatex, prepareLatexForKatex } from '../katex-render.js';

export const CALCULUS_ACTIONS = ['integral', 'derivative', 'limit'];

const ACTION_FENCE_LANGS = new Set([
  'integral', 'derivative', 'limit', 'math-action', 'math', 'mathintent',
]);

/** @typedef {'integral'|'derivative'|'limit'} CalculusAction */

/**
 * @typedef {Object} MathActionTask
 * @property {CalculusAction} action
 * @property {string} [raw]
 * @property {string} [integrand]
 * @property {string} [expr]
 * @property {string} [variable]
 * @property {'indefinite'|'definite'} [mode]
 * @property {string} [lower]
 * @property {string} [upper]
 * @property {number|string} [order]
 * @property {string} [point]
 * @property {'two-sided'|'left'|'right'|'both'} [direction]
 * @property {string} [label]
 */

function detectAction(obj, fenceLang) {
  let action = String(obj?.action || obj?.kind || obj?.type || fenceLang || '').toLowerCase();
  if (action === 'integrate') action = 'integral';
  if (action === 'differentiate' || action === 'diff') action = 'derivative';
  if (action === 'lim') action = 'limit';
  if (CALCULUS_ACTIONS.includes(action)) return /** @type {CalculusAction} */ (action);
  if (obj?.integrand || (obj?.raw && /\\int\b/.test(String(obj.raw)))) return 'integral';
  if (obj?.order != null || (obj?.raw && /\\frac\s*\{\s*d/.test(String(obj.raw)))) return 'derivative';
  if (obj?.point != null || obj?.limitPoint != null || (obj?.raw && /\\lim\b/.test(String(obj.raw)))) return 'limit';
  if (obj?.expr && obj?.point != null) return 'limit';
  if (obj?.expr && !obj?.integrand) return 'derivative';
  return null;
}

/**
 * @param {Record<string, unknown>} obj
 * @param {string} [fenceLang]
 * @returns {MathActionTask | null}
 */
export function normalizeCalculusTask(obj, fenceLang) {
  if (!obj || typeof obj !== 'object') return null;

  const action = detectAction(obj, fenceLang);
  if (!action) return null;

  const raw = String(obj.raw || obj.latex || obj.display || '').trim();
  const label = String(obj.label || obj.name || '').trim();
  const variable = String(obj.variable || obj.var || 'x').trim() || 'x';

  /** @type {MathActionTask} */
  const task = { action, variable };
  if (raw) task.raw = raw;
  if (label) task.label = label;

  if (action === 'integral') {
    const integrand = String(obj.integrand || obj.body || obj.function || obj.expr || '').trim();
    if (!raw && !integrand) return null;

    let mode = String(obj.mode || obj.integralType || '').toLowerCase();
    const typeHint = String(obj.type || '').toLowerCase();
    if (!mode && (typeHint === 'definite' || typeHint === 'indefinite')) mode = typeHint;
    if (mode !== 'definite' && mode !== 'indefinite') {
      mode = (obj.lower != null || obj.upper != null || obj.a != null || obj.b != null)
        ? 'definite' : 'indefinite';
    }
    task.mode = mode === 'definite' ? 'definite' : 'indefinite';
    if (integrand) task.integrand = integrand;
    if (task.mode === 'definite') {
      if (obj.lower != null || obj.a != null) task.lower = String(obj.lower ?? obj.a ?? '').trim();
      if (obj.upper != null || obj.b != null) task.upper = String(obj.upper ?? obj.b ?? '').trim();
    }
    return task;
  }

  if (action === 'derivative') {
    const expr = String(obj.expr || obj.body || obj.function || obj.integrand || '').trim();
    if (!raw && !expr) return null;
    if (expr) task.expr = expr;
    const order = obj.order != null && obj.order !== '' ? parseInt(String(obj.order), 10) : 1;
    task.order = Number.isFinite(order) && order > 0 ? order : 1;
    return task;
  }

  // limit
  const expr = String(obj.expr || obj.body || obj.function || '').trim();
  if (!raw && !expr) return null;
  if (expr) task.expr = expr;
  task.point = String(obj.point ?? obj.limitPoint ?? obj.a ?? '0').trim();
  let dir = String(obj.direction || obj.dir || 'two-sided').toLowerCase();
  if (dir === 'both') dir = 'two-sided';
  if (dir === '+' || dir === 'right' || dir === 'from the right') task.direction = 'right';
  else if (dir === '-' || dir === 'left' || dir === 'from the left') task.direction = 'left';
  else task.direction = 'two-sided';
  return task;
}

/**
 * @param {string} content
 * @param {string} [fenceLang]
 */
export function parseCalculusBlockContent(content, fenceLang) {
  const lines = String(content || '')
    .trim()
    .split(/\r?\n/)
    .map((l) => l.trim())
    .filter(Boolean);

  if (!lines.length) return null;

  /** @type {Record<string, string>} */
  const kv = {};
  let bareLine = '';

  for (const line of lines) {
    const m = line.match(/^([a-z_]+)\s*:\s*(.+)$/i);
    if (m) {
      kv[m[1].toLowerCase()] = m[2].trim();
      continue;
    }
    if (!bareLine && !line.includes(':')) bareLine = line;
  }

  return normalizeCalculusTask({
    action: kv.action || kv.kind || fenceLang,
    raw: kv.raw || kv.latex || kv.display,
    integrand: kv.integrand || kv.body || kv.function,
    expr: kv.expr || kv.expression || kv.body || kv.function || bareLine,
    variable: kv.variable || kv.var || 'x',
    mode: kv.mode || kv.type,
    lower: kv.lower || kv.a,
    upper: kv.upper || kv.b,
    order: kv.order,
    point: kv.point || kv.limitpoint || kv.to,
    direction: kv.direction || kv.dir,
    label: kv.label || kv.name,
  }, fenceLang);
}

function tasksFromJson(data) {
  if (!data || typeof data !== 'object') return [];

  /** @type {MathActionTask[]} */
  const out = [];

  const push = (t) => {
    const n = normalizeCalculusTask(t, String(t?.action || ''));
    if (n) out.push(n);
  };

  if (Array.isArray(data.tasks)) {
    data.tasks.forEach(push);
    return out;
  }
  if (Array.isArray(data.integrals)) {
    data.integrals.forEach((t) => push({ ...t, action: 'integral' }));
    return out;
  }
  if (Array.isArray(data)) {
    data.forEach(push);
    return out;
  }

  const single = normalizeCalculusTask(data, String(data.action || ''));
  return single ? [single] : [];
}

/**
 * @param {string} text
 * @returns {MathActionTask[]}
 */
export function extractMathActions(text) {
  const src = String(text ?? '');
  /** @type {MathActionTask[]} */
  const found = [];
  const seen = new Set();

  const add = (task) => {
    if (!task || !CALCULUS_ACTIONS.includes(task.action)) return;
    const key = JSON.stringify(task);
    if (seen.has(key)) return;
    seen.add(key);
    found.push(task);
  };

  const fenceRe = /```([\w#+.-]*)\s*\n([\s\S]*?)```/g;
  let m;
  while ((m = fenceRe.exec(src)) !== null) {
    const lang = (m[1] || '').toLowerCase();
    const body = m[2];

    if (lang === 'json') {
      try {
        tasksFromJson(JSON.parse(body.trim())).forEach(add);
      } catch { /* ignore */ }
      continue;
    }

    if (ACTION_FENCE_LANGS.has(lang)) {
      const parsed = parseCalculusBlockContent(body, lang);
      if (parsed) add(parsed);
    }
  }

  return found;
}

function nerdamerTeX(expr) {
  try {
    const nd = typeof nerdamer !== 'undefined' ? nerdamer : window.nerdamer;
    if (!nd) return String(expr || '');
    return nd(String(expr || '')).toTeX();
  } catch (_) {
    return String(expr || '');
  }
}

/** ASCII expr → TeX; pass through strings that already look like LaTeX. */
function exprToBodyLatex(expr) {
  const s = String(expr || '').trim();
  if (!s) return '';
  if (/\\|[\^_]|\{[^}]*\}/.test(s)) return prepareLatexForKatex(s);
  return nerdamerTeX(s);
}

function ensureDisplayStyle(latex) {
  const s = String(latex || '').trim();
  if (!s) return s;
  if (/\\displaystyle\b/.test(s)) return s;
  return `\\displaystyle ${s}`;
}

/** Wrap multi-term bodies for textbook layout (does not affect engine parse strings). */
function wrapCalculusBody(body) {
  const b = String(body || '').trim();
  if (!b) return b;
  if (/^\\left[\[(]/.test(b)) return b;
  if (/[+*/^]|\\frac|\\sin|\\cos|\\tan|\\log|\\ln/.test(b)) {
    return `\\left(${b}\\right)`;
  }
  return b;
}

function differentialLatex(v) {
  return `\\,\\mathrm{d}${v}`;
}

/**
 * Normalize textbook LaTeX into the plain form the *CalculatorCore parsers expect.
 * The cores understand `\, dx` / `\frac{d}{dx}` / `\lim_{...}` but NOT `\mathrm{d}x`,
 * `\lim\limits`, `\displaystyle`, or `\left[ \,` book-style spacing.
 * @param {string} latex
 */
export function sanitizeLatexForEngine(latex) {
  let out = String(latex || '');

  /* Drop layout-only macros */
  out = out.replace(/\\displaystyle\b/g, ' ');
  out = out.replace(/\\limits\b/g, ' ');

  /* \mathrm{d} / \operatorname{...} → plain text (handles \mathrm{d}x differentials) */
  out = out.replace(/\\mathrm\s*\{([^}]*)\}/g, '$1');
  out = out.replace(/\\operatorname\*?\s*\{([^}]*)\}/g, '$1');

  /* Bracket delimiters used in derivative display → parens the core can strip */
  out = out.replace(/\\left\s*\[/g, '\\left(').replace(/\\right\s*\]/g, '\\right)');

  /* Spacing macros (\, \; \: \! \quad \qquad) → single space */
  out = out.replace(/\\[,;:!]/g, ' ');
  out = out.replace(/\\q?quad\b/g, ' ');

  /* Collapse whitespace */
  out = out.replace(/\s+/g, ' ').trim();

  return out;
}

/**
 * Build LaTeX for *Core.solveFromLatex (same entry as latex/editor Σ Solve).
 * @param {MathActionTask} task
 */
export function taskToSolveLatex(task) {
  if (task.raw) return sanitizeLatexForEngine(task.raw.trim());

  const v = task.variable || 'x';

  if (task.action === 'integral') {
    const body = exprToBodyLatex(task.integrand || task.expr || '');
    if (task.mode === 'definite' && task.lower != null && task.upper != null) {
      const lo = normalizeBoundLatex(task.lower);
      const hi = normalizeBoundLatex(task.upper);
      return sanitizeLatexForEngine(`\\int_{${lo}}^{${hi}} ${body}${differentialLatex(v)}`);
    }
    return sanitizeLatexForEngine(`\\int ${body}${differentialLatex(v)}`);
  }

  if (task.action === 'derivative') {
    const order = Number(task.order) || 1;
    const body = exprToBodyLatex(task.expr || '');
    const ordPart = order === 1 ? '' : `^{${order}}`;
    return sanitizeLatexForEngine(`\\frac{d${ordPart}}{d${v}${ordPart}} ${wrapCalculusBody(body)}`);
  }

  // limit
  const body = exprToBodyLatex(task.expr || '');
  const pt = normalizeBoundLatex(task.point || '0');
  let arrow = `${v} \\to ${pt}`;
  if (task.direction === 'right') arrow += '^{+}';
  else if (task.direction === 'left') arrow += '^{-}';
  return sanitizeLatexForEngine(`\\lim_{${arrow}} ${wrapCalculusBody(body)}`);
}

/**
 * Textbook-style display LaTeX for KaTeX cards and AI prose mirroring.
 * @param {MathActionTask} task
 */
export function taskToDisplayLatex(task) {
  if (task.raw) return ensureDisplayStyle(prepareLatexForKatex(task.raw.trim()));

  const v = task.variable || 'x';

  if (task.action === 'integral') {
    const body = exprToBodyLatex(task.integrand || task.expr || '');
    const diff = differentialLatex(v);
    if (task.mode === 'definite' && task.lower != null && task.upper != null) {
      const lo = normalizeBoundLatex(task.lower);
      const hi = normalizeBoundLatex(task.upper);
      return `\\displaystyle\\int_{${lo}}^{${hi}} ${body}${diff}`;
    }
    return `\\displaystyle\\int ${body}${diff}`;
  }

  if (task.action === 'derivative') {
    const order = Number(task.order) || 1;
    const body = wrapCalculusBody(exprToBodyLatex(task.expr || ''));
    if (order === 1) {
      return `\\displaystyle\\frac{\\mathrm{d}}{\\mathrm{d}${v}}\\left[\\, ${body} \\,\\right]`;
    }
    return `\\displaystyle\\frac{\\mathrm{d}^{${order}}}{\\mathrm{d}${v}^{${order}}}\\left[\\, ${body} \\,\\right]`;
  }

  const body = wrapCalculusBody(exprToBodyLatex(task.expr || ''));
  const pt = normalizeBoundLatex(task.point || '0');
  let arrow = `${v} \\to ${pt}`;
  if (task.direction === 'right') arrow += '^{+}';
  else if (task.direction === 'left') arrow += '^{-}';
  return `\\displaystyle\\lim\\limits_{${arrow}} ${body}`;
}

/**
 * Short card header label (prose); problem math uses taskToDisplayLatex.
 * @param {MathActionTask} task
 * @param {number} [index]
 */
export function formatMathActionLabel(task, index) {
  const n = typeof index === 'number' ? `#${index + 1} ` : '';
  if (task.label) return task.label;

  if (task.action === 'derivative') {
    const o = Number(task.order) > 1 ? ` · order ${task.order}` : '';
    return `${n}Derivative${o}`;
  }
  if (task.action === 'limit') {
    return `${n}Limit`;
  }
  return `${n}${task.mode === 'definite' ? 'Definite integral' : 'Integral'}`;
}
