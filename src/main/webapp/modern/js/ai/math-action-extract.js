/**
 * Extract structured calculus actions from Generic Math AI replies.
 *
 * Fences: ```integral```, ```derivative```, ```limit```, ```math-action```, ```json```
 */
import { normalizeBoundLatex, prepareLatexForKatex } from '../katex-render.js';

export const CALCULUS_ACTIONS = ['integral', 'derivative', 'limit', 'ode', 'pde'];

const PDE_MODES = new Set(['heat', 'wave', 'laplace', 'poisson', 'transport', 'schrodinger', 'linear1']);

/** Map lowercase fence keys → canonical PDE param names (kv parser lowercases keys). */
const PDE_KV_TO_PARAM = {
  k: 'k',
  l: 'L',
  tmax: 'tmax',
  ic: 'ic',
  bc: 'bc',
  c: 'c',
  nx: 'nx',
  ny: 'ny',
  source: 'source',
  scheme: 'scheme',
  potential: 'potential',
  nstates: 'nstates',
  a: 'a',
  b: 'b',
  g: 'g',
};

function copyPdeParamsFromKv(target, kv) {
  Object.entries(PDE_KV_TO_PARAM).forEach(([kvKey, paramKey]) => {
    if (kv[kvKey] != null && String(kv[kvKey]).trim() !== '') {
      target[paramKey] = String(kv[kvKey]).trim();
    }
  });
}

/** Canonical PDE param names (JSON / task objects). */
export const PDE_PARAM_KEYS = [...new Set(Object.values(PDE_KV_TO_PARAM))];

function inferPdeModeFromRaw(raw) {
  const s = String(raw || '').toLowerCase();
  if (/u_\s*\{?\s*tt\s*\}?|u_tt|d\^2u\s*\/\s*dt\^2/.test(s)) return 'wave';
  if (/u_\s*\{?\s*t\s*\}?|u_t|du\s*\/\s*dt/.test(s) && /u_\s*\{?\s*xx\s*\}?|u_xx/.test(s)) return 'heat';
  if (/u_\s*\{?\s*t\s*\}?|u_t/.test(s) && /u_\s*\{?\s*x\s*\}?|u_x/.test(s) && !/u_\s*\{?\s*xx/.test(s)) return 'transport';
  if (/\\nabla\^2|\\Delta\s*u|u_\s*\{?\s*xx\s*\}?.*u_\s*\{?\s*yy/.test(s) && /f\s*\(|=\s*f/.test(s)) return 'poisson';
  if (/\\nabla\^2|\\Delta\s*u|u_\s*\{?\s*xx\s*\}?.*u_\s*\{?\s*yy/.test(s)) return 'laplace';
  if (/\\psi|schrodinger|schroedinger|hamiltonian/.test(s)) return 'schrodinger';
  if (/u_\s*\{?\s*x\s*\}?.*u_\s*\{?\s*y\s*\}?|a\s*u_\s*x/.test(s)) return 'linear1';
  return null;
}

const ACTION_FENCE_LANGS = new Set([
  'integral', 'derivative', 'limit', 'ode', 'pde', 'dsolve', 'differential',
  'math-action', 'math', 'mathintent',
]);

/** @typedef {'integral'|'derivative'|'limit'|'ode'|'pde'} CalculusAction */

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
 * @property {string} [rhs]
 * @property {string} [func]
 * @property {{x0?:string,y0?:string,dy0?:string}} [ics]
 * @property {string} [label]
 * @property {string} [mode]
 * @property {Record<string, string>} [params]
 */

function detectAction(obj, fenceLang) {
  let action = String(obj?.action || obj?.kind || obj?.type || fenceLang || '').toLowerCase();
  if (action === 'integrate') action = 'integral';
  if (action === 'differentiate' || action === 'diff') action = 'derivative';
  if (action === 'lim') action = 'limit';
  if (action === 'dsolve' || action === 'differential' || action === 'differentialequation') action = 'ode';
  if (action === 'pdesolve' || action === 'partial') action = 'pde';
  if (CALCULUS_ACTIONS.includes(action)) return /** @type {CalculusAction} */ (action);
  const modeHint = String(obj?.mode || obj?.pdeType || obj?.pde || '').toLowerCase();
  if (PDE_MODES.has(modeHint)) return 'pde';
  // ODE markers: y'/y'' notation, dy/dx with an "=", or an rhs+order pairing.
  const raw = String(obj?.raw || obj?.latex || '');
  if (obj?.rhs != null || (raw && /=/.test(raw) && /(y''|y'|\\frac\s*\{\s*d\s*y\s*\}|dy\s*\/\s*dx)/.test(raw))) return 'ode';
  if (raw && inferPdeModeFromRaw(raw)) return 'pde';
  if (PDE_PARAM_KEYS.some((k) => obj?.[k] != null && String(obj[k]).trim() !== '')) {
    if (obj?.k != null || obj?.tmax != null || obj?.ic != null || obj?.bc != null
      || obj?.nx != null || obj?.potential != null || obj?.scheme != null) return 'pde';
  }
  if (obj?.integrand || (raw && /\\int\b/.test(raw))) return 'integral';
  if (obj?.order != null || (raw && /\\frac\s*\{\s*d/.test(raw))) return 'derivative';
  if (obj?.point != null || obj?.limitPoint != null || (raw && /\\lim\b/.test(raw))) return 'limit';
  if (obj?.expr && obj?.point != null) return 'limit';
  if (obj?.expr && !obj?.integrand) return 'derivative';
  return null;
}

/**
 * Parse initial conditions like "y(0)=1", "y'(0)=0", "y(0)=1; y'(0)=0"
 * into { x0, y0, dy0 }. Also honours explicit x0/y0/dy0 fields.
 */
function parseIcs(obj) {
  const ics = {};
  if (obj.x0 != null) ics.x0 = String(obj.x0).trim();
  if (obj.y0 != null) ics.y0 = String(obj.y0).trim();
  if (obj.dy0 != null) ics.dy0 = String(obj.dy0).trim();

  const raw = String(obj.ic || obj.ics || obj.initial || obj.conditions || '').trim();
  if (raw) {
    const parts = raw.split(/[;,\n]+/).map((p) => p.trim()).filter(Boolean);
    for (const p of parts) {
      // y'(x0) = v  → derivative condition
      let m = p.match(/y\s*'\s*\(\s*([^)]*)\)\s*=\s*(.+)/i);
      if (m) { ics.x0 = ics.x0 ?? m[1].trim(); ics.dy0 = m[2].trim(); continue; }
      // y(x0) = v   → value condition
      m = p.match(/y\s*\(\s*([^)]*)\)\s*=\s*(.+)/i);
      if (m) { ics.x0 = ics.x0 ?? m[1].trim(); ics.y0 = m[2].trim(); continue; }
    }
  }
  return (ics.x0 != null && (ics.y0 != null || ics.dy0 != null)) ? ics : null;
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

  if (action === 'ode') {
    const rhs = String(obj.rhs || obj.expr || obj.body || obj.equation || '').trim();
    if (!raw && !rhs) return null;
    if (rhs) task.rhs = rhs;
    task.func = String(obj.func || obj.y || 'y').trim() || 'y';
    const order = obj.order != null && obj.order !== '' ? parseInt(String(obj.order), 10) : null;
    if (Number.isFinite(order) && order > 0) {
      task.order = order;
    } else {
      // Fallback when the model omits `order:` — infer the highest derivative
      // from the raw equation / rhs markers (prefer the explicit order field).
      const probe = `${raw} ${rhs}`;
      if (/y''''|y'{4}|d\^?4y|\by4\b/.test(probe)) task.order = 4;
      else if (/y'''|y'{3}|d\^?3y|\byppp\b/.test(probe)) task.order = 3;
      else if (/y''|\bypp\b|d\^?2y/.test(probe)) task.order = 2;
      else task.order = 1;
    }
    const ics = parseIcs(obj);
    if (ics) task.ics = ics;
    return task;
  }

  if (action === 'pde') {
    let mode = String(obj.mode || obj.pdeType || obj.pde || '').toLowerCase();
    if (!PDE_MODES.has(mode) && raw) {
      const inferred = inferPdeModeFromRaw(raw);
      if (inferred) mode = inferred;
    }
    task.mode = PDE_MODES.has(mode) ? mode : 'heat';
    /** @type {Record<string, string>} */
    const params = {};
    PDE_PARAM_KEYS.forEach((key) => {
      if (obj[key] != null && String(obj[key]).trim() !== '') {
        params[key] = String(obj[key]).trim();
      }
    });
    if (obj.params && typeof obj.params === 'object') {
      Object.keys(obj.params).forEach((key) => {
        if (obj.params[key] != null && String(obj.params[key]).trim() !== '') {
          params[key] = String(obj.params[key]).trim();
        }
      });
    }
    task.params = params;
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

  const fence = String(fenceLang || '').toLowerCase();
  const pdeModeHint = String(kv.mode || kv.pdetype || kv.pde || '').toLowerCase();
  const isPdeFence = fence === 'pde' || PDE_MODES.has(pdeModeHint);

  /** @type {Record<string, unknown>} */
  const payload = {
    action: kv.action || kv.kind || fenceLang,
    raw: kv.raw || kv.latex || kv.display,
    integrand: kv.integrand || kv.body || kv.function,
    expr: kv.expr || kv.expression || kv.body || kv.function || bareLine,
    rhs: kv.rhs || kv.equation,
    func: kv.func || kv.y,
    variable: kv.variable || kv.var || 'x',
    mode: kv.mode || kv.pdetype || kv.pde || kv.type,
    lower: isPdeFence ? kv.lower : (kv.lower || kv.a),
    upper: isPdeFence ? kv.upper : (kv.upper || kv.b),
    order: kv.order,
    point: kv.point || kv.limitpoint || kv.to,
    direction: kv.direction || kv.dir,
    ic: kv.ic || kv.ics || kv.initial || kv.conditions,
    x0: kv.x0,
    y0: kv.y0,
    dy0: kv.dy0,
    label: kv.label || kv.name,
  };
  copyPdeParamsFromKv(payload, kv);
  return normalizeCalculusTask(payload, fenceLang);
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
  if (Array.isArray(data.pdes)) {
    data.pdes.forEach((t) => push({ ...t, action: 'pde' }));
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

/** Textbook LaTeX for an ODE: LHS derivative = RHS (with y'/y'' rendered). */
function odeEquationLatex(task) {
  const v = task.variable || 'x';
  const order = Number(task.order) || 1;
  let rhs = String(task.rhs || task.expr || '').trim();

  // Render RHS via nerdamer with yp/ypp protected as placeholder symbols.
  const tmp = rhs.replace(/ypp/g, 'ODEdd').replace(/yp/g, 'ODEd');
  let rhsTeX = exprToBodyLatex(tmp)
    .replace(/ODEdd/g, "y''")
    .replace(/ODEd/g, "y'");

  const lhs = order === 1
    ? `\\frac{\\mathrm{d}y}{\\mathrm{d}${v}}`
    : `\\frac{\\mathrm{d}^{${order}}y}{\\mathrm{d}${v}^{${order}}}`;
  return `${lhs} = ${rhsTeX}`;
}

const PDE_MODE_LATEX = {
  heat: 'u_t = k\\, u_{xx}',
  wave: 'u_{tt} = c^2\\, u_{xx}',
  laplace: 'u_{xx} + u_{yy} = 0',
  poisson: '\\nabla^2 u = f(x,y)',
  transport: 'u_t + c\\, u_x = 0',
  schrodinger: '-\\frac{\\hbar^2}{2m}\\psi\'\'(x) + V(x)\\psi = E\\psi',
  linear1: 'a\\, u_x + b\\, u_y + c\\, u = G(x,y)',
};

/** Textbook LaTeX for a PDE task card. */
function pdeProblemLatex(task) {
  const mode = String(task.mode || 'heat').toLowerCase();
  if (task.raw) return prepareLatexForKatex(task.raw.trim());
  const base = PDE_MODE_LATEX[mode] || 'u_t = k u_{xx}';
  const p = task.params || {};
  const bits = [];
  if (mode === 'heat' || mode === 'wave' || mode === 'transport') {
    if (p.k != null && mode === 'heat') bits.push(`k=${p.k}`);
    if (p.c != null && (mode === 'wave' || mode === 'transport')) bits.push(`c=${p.c}`);
    if (p.L != null) bits.push(`L=${p.L}`);
    if (p.ic) bits.push(`\\text{IC: ${p.ic}}`);
    if (p.bc) bits.push(`\\text{BC: ${p.bc}}`);
  } else if (mode === 'laplace' || mode === 'poisson') {
    if (p.nx != null) bits.push(`${p.nx}\\times${p.ny || p.nx}`);
    if (p.bc) bits.push(`\\text{BC: ${p.bc}}`);
    if (p.source && mode === 'poisson') bits.push(`\\text{source: ${p.source}}`);
  } else if (mode === 'schrodinger') {
    if (p.L != null) bits.push(`L=${p.L}`);
    if (p.potential) bits.push(`V=${p.potential.replace(/_/g, '\\_')}`);
    if (p.nstates) bits.push(`${p.nstates}\\text{ states}`);
  } else if (mode === 'linear1') {
    if (p.a != null) bits.push(`a=${p.a}`);
    if (p.b != null) bits.push(`b=${p.b}`);
    if (p.c != null) bits.push(`c=${p.c}`);
    if (p.g != null) bits.push(`G=${p.g}`);
  }
  return bits.length ? `${base}, \\quad ${bits.join(',\\; ')}` : base;
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
  if (task.action === 'pde') return task.raw ? task.raw.trim() : pdeProblemLatex(task);

  // ODE is solved via the SymPy backbone (ODECalculatorCore.solveTask), not a
  // single-latex engine call; return the equation form for callers/logging.
  if (task.action === 'ode') return task.raw ? task.raw.trim() : odeEquationLatex(task);

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
  if (task.action === 'pde') {
    return ensureDisplayStyle(pdeProblemLatex(task));
  }

  if (task.action === 'ode') {
    const eq = task.raw ? prepareLatexForKatex(task.raw.trim()) : odeEquationLatex(task);
    return ensureDisplayStyle(eq);
  }

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
  if (task.action === 'ode') {
    const o = Number(task.order) > 1 ? ` · order ${task.order}` : '';
    const ivp = task.ics ? ' · IVP' : '';
    return `${n}Differential equation${o}${ivp}`;
  }
  if (task.action === 'pde') {
    const names = {
      heat: 'Heat equation',
      wave: 'Wave equation',
      laplace: 'Laplace equation',
      poisson: 'Poisson equation',
      transport: 'Transport equation',
      schrodinger: 'Schrödinger equation',
      linear1: '1st-order linear PDE',
    };
    const mode = String(task.mode || 'heat').toLowerCase();
    return `${n}${names[mode] || 'PDE'}`;
  }
  return `${n}${task.mode === 'definite' ? 'Definite integral' : 'Integral'}`;
}
