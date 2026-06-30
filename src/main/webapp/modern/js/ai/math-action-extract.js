/**
 * Extract structured calculus actions from Generic Math AI replies.
 *
 * Fences: ```integral```, ```derivative```, ```limit```, ```math-action```, ```json```
 */
import { normalizeBoundLatex, prepareLatexForKatex } from '../katex-render.js';
import {
  ALGEBRA_ACTIONS,
  extractAlgebraActions,
  formatAlgebraActionLabel,
  taskToDisplayLatex as algebraTaskToDisplayLatex,
} from './algebra-action-extract.js';

export const CALCULUS_ACTIONS = ['integral', 'derivative', 'limit', 'ode', 'pde', 'vectorCalculus', 'matrix', 'bode', 'laplace'];
export { ALGEBRA_ACTIONS };
/** All Math AI intents — calculus, linear algebra, algebra (standalone Math AI page uses full set). */
export const MATH_ACTIONS = [...CALCULUS_ACTIONS, ...ALGEBRA_ACTIONS];

const VC_MODES = new Set(['gradient', 'divergence', 'curl', 'grad', 'div', 'nabla']);

const MATRIX_OPS = new Set([
  'determinant', 'det', 'inverse', 'transpose', 'trace', 'tr', 'rank', 'rref',
  'power', 'eigenvalues', 'eigenvectors', 'charpoly', 'characteristic',
  'add', 'subtract', 'sub', 'multiply', 'mul',
]);

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
  'vectorcalculus', 'vector-calculus', 'vc', 'vector_calculus',
  'gradient', 'divergence', 'curl',
  'matrix', 'matrices', 'linearalgebra', 'linear-algebra',
  'bode', 'bodeplot', 'transferfunction', 'transfer-function',
  'laplace-transform', 'laplacetransform', 'inverse-laplace', 'inverse-laplace-transform', 'ilaplace', 'laplace',
  'math-action', 'math', 'mathintent',
]);

/** @typedef {'integral'|'derivative'|'limit'|'ode'|'pde'|'vectorCalculus'|'matrix'|'bode'|'laplace'} CalculusAction */

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

function inferVcModeFromRaw(raw) {
  const s = String(raw || '');
  if (/\\nabla\s*\\cdot|\\nabla\s*\.\s*\\mathbf|\\bdivergence\b/i.test(s)) return 'divergence';
  if (/\\nabla\s*\\times|\\nabla\s*×|\\bcurl\b/i.test(s)) return 'curl';
  if (/\\nabla\s*f|\\nabla\s*\(|\\bgradient\b/i.test(s)) return 'gradient';
  return null;
}

function inferMatrixOpFromRaw(raw) {
  const s = String(raw || '');
  if (/\\det\b/i.test(s)) return 'determinant';
  if (/\^\s*\{?\s*-\s*1\s*\}?/i.test(s)) return 'inverse';
  if (/\^\s*\{?\s*T\s*\}?/i.test(s)) return 'transpose';
  if (/\\tr\b|\btrace\b/i.test(s)) return 'trace';
  if (/\brank\b/i.test(s)) return 'rank';
  if (/\brref\b|gauss[\s-]*jordan/i.test(s)) return 'rref';
  if (/eigen\s*values?/i.test(s)) return 'eigenvalues';
  if (/eigen\s*vectors?|diagonali[sz]e/i.test(s)) return 'eigenvectors';
  if (/char(?:acteristic)?\s*poly/i.test(s)) return 'charpoly';
  if (/\\begin\{(?:pmatrix|bmatrix|matrix)/.test(s)) return 'determinant';
  return null;
}

function isLaplaceTransformIntent(obj, fenceLang) {
  const fence = String(fenceLang || '').toLowerCase();
  if (['laplace-transform', 'laplacetransform', 'inverse-laplace', 'inverse-laplace-transform', 'ilaplace'].includes(fence)) {
    return true;
  }
  if (fence !== 'laplace') return false;
  const m = String(obj?.mode || obj?.laplaceMode || obj?.transformMode || '').toLowerCase();
  if (['forward', 'inverse', 'ilaplace', 'inverse-laplace'].includes(m)) return true;
  if (obj?.forwardExpr != null || obj?.inverseExpr != null || obj?.ft != null || obj?.Fs != null || obj?.fs != null) {
    return true;
  }
  if (obj?.nx != null || obj?.ny != null || obj?.k != null || obj?.tmax != null || obj?.ic != null) return false;
  if (obj?.expr || obj?.raw) return true;
  return false;
}

function detectAction(obj, fenceLang) {
  let action = String(obj?.action || obj?.kind || obj?.type || fenceLang || '').toLowerCase();
  if (action === 'integrate') action = 'integral';
  if (action === 'differentiate' || action === 'diff') action = 'derivative';
  if (action === 'lim') action = 'limit';
  if (action === 'dsolve' || action === 'differential' || action === 'differentialequation') action = 'ode';
  if (action === 'pdesolve' || action === 'partial') action = 'pde';
  if (action === 'vectorcalculus' || action === 'vector-calculus' || action === 'vc' || action === 'vector_calculus') {
    action = 'vectorCalculus';
  }
  if (action === 'matrices' || action === 'linearalgebra' || action === 'linear-algebra') action = 'matrix';
  if (action === 'bodeplot' || action === 'bode-diagram' || action === 'transferfunction' || action === 'transfer-function') {
    action = 'bode';
  }
  if (action === 'laplacetransform' || action === 'laplace-transform' || action === 'inverse-laplace' || action === 'inverse-laplace-transform' || action === 'ilaplace') {
    action = 'laplace';
  }
  if (action === 'grad' || action === 'nabla') action = 'gradient';
  if (action === 'div') action = 'divergence';
  if (action === 'gradient' || action === 'divergence' || action === 'curl') {
    action = 'vectorCalculus';
  }
  if (action === 'laplace' && !isLaplaceTransformIntent(obj, fenceLang)) {
    const modeHintEarly = String(obj?.mode || obj?.pdeType || obj?.pde || '').toLowerCase();
    if (PDE_MODES.has(modeHintEarly) || obj?.nx != null || obj?.ny != null) action = 'pde';
  }
  if (CALCULUS_ACTIONS.includes(action)) return /** @type {CalculusAction} */ (action);
  const matrixOpHint = String(obj.op || obj.operation || '').toLowerCase();
  if (MATRIX_OPS.has(matrixOpHint)) return 'matrix';
  const fence = String(fenceLang || '').toLowerCase();
  if (fence === 'bode' || fence === 'bodeplot' || fence === 'transferfunction' || fence === 'transfer-function') {
    return 'bode';
  }
  if (obj.transferFunction != null || obj.transfer_function != null || obj.hs != null || obj.Hs != null) {
    return 'bode';
  }
  if ((obj.zeros != null || obj.poles != null) && (fence === 'bode' || obj.gain != null)) return 'bode';
  if (isLaplaceTransformIntent(obj, fence)) return 'laplace';
  if (fence === 'matrix' || fence === 'matrices') return 'matrix';
  if (obj.matrixA != null || obj.matrix_a != null || obj.matrixB != null || obj.matrix_b != null) {
    return 'matrix';
  }
  const modeHint = String(obj?.mode || obj?.pdeType || obj?.pde || '').toLowerCase();
  if (PDE_MODES.has(modeHint)) return 'pde';
  if (VC_MODES.has(modeHint) || obj?.scalar != null || obj?.fx != null || obj?.fy != null || obj?.fz != null) {
    if (obj?.scalar != null || obj?.fx != null || obj?.fy != null || obj?.fz != null || VC_MODES.has(modeHint)) {
      return 'vectorCalculus';
    }
  }
  const raw = String(obj?.raw || obj?.latex || '');
  if (/H\s*\(\s*s\s*\)|transfer function|bode plot/i.test(raw) && /[=\/\^]|\\frac/.test(raw)) return 'bode';
  if (/\\mathcal\{L\}|laplace transform|inverse laplace|L\^{-1}|L\\\{/i.test(raw) && !inferPdeModeFromRaw(raw)) return 'laplace';
  if (inferVcModeFromRaw(raw)) return 'vectorCalculus';
  if (inferMatrixOpFromRaw(raw)) return 'matrix';
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

  if (action === 'vectorCalculus') {
    let vcMode = String(obj.mode || '').toLowerCase();
    const fence = String(fenceLang || '').toLowerCase();
    if (['gradient', 'divergence', 'curl'].includes(fence)) vcMode = fence;
    if (!vcMode && raw) {
      const inferred = inferVcModeFromRaw(raw);
      if (inferred) vcMode = inferred;
    }
    if (vcMode === 'grad' || vcMode === 'nabla') vcMode = 'gradient';
    if (vcMode === 'div') vcMode = 'divergence';
    task.mode = ['gradient', 'divergence', 'curl'].includes(vcMode) ? vcMode : 'gradient';
    task.scalar = String(obj.scalar ?? obj.f ?? (task.mode === 'gradient' ? (obj.expr || obj.body || obj.function) : '') ?? '').trim();
    task.fx = String(obj.fx ?? obj.Fx ?? '').trim();
    task.fy = String(obj.fy ?? obj.Fy ?? '').trim();
    task.fz = String(obj.fz ?? obj.Fz ?? '').trim();
    return task;
  }

  if (action === 'matrix') {
    let op = String(obj.op || obj.operation || '').toLowerCase();
    if (!op && raw) {
      const inferred = inferMatrixOpFromRaw(raw);
      if (inferred) op = inferred;
    }
    if (op === 'det') op = 'determinant';
    if (op === 'tr') op = 'trace';
    if (op === 'sub') op = 'subtract';
    if (op === 'mul') op = 'multiply';
    if (op === 'characteristic') op = 'charpoly';
    task.op = MATRIX_OPS.has(op) ? op : 'determinant';
    const matrixA = String(obj.matrixA ?? obj.matrix_a ?? obj.latexA ?? '').trim();
    const matrixB = String(obj.matrixB ?? obj.matrix_b ?? obj.latexB ?? '').trim();
    if (matrixA) task.matrixA = matrixA;
    if (matrixB) task.matrixB = matrixB;
    if (obj.n != null && obj.n !== '') task.n = parseInt(String(obj.n), 10);
    const core = typeof window !== 'undefined' ? window.MatrixCalculatorCore : null;
    if (core?.normalizeMatrixTask) {
      const norm = core.normalizeMatrixTask(task);
      if (norm.matrixA) task.matrixA = norm.matrixA;
      if (norm.matrixB) task.matrixB = norm.matrixB;
      if (norm.raw) task.raw = norm.raw;
    }
    if (!raw && !matrixA) return null;
    return task;
  }

  if (action === 'bode') {
    let inputMode = String(obj.inputMode || obj.input_mode || obj.bodeMode || '').toLowerCase();
    if (!inputMode) {
      const modeHint = String(obj.mode || '').toLowerCase();
      if (modeHint === 'zpk' || modeHint === 'zeros-poles-gain') inputMode = 'zpk';
      else if (modeHint === 'transfer' || modeHint === 'transfer-function') inputMode = 'transfer';
      else if (obj.zeros != null || obj.poles != null) inputMode = 'zpk';
      else inputMode = 'transfer';
    }
    task.inputMode = inputMode === 'zpk' ? 'zpk' : 'transfer';
    const tf = String(
      obj.transferFunction || obj.transfer_function || obj.hs || obj.Hs || obj.expr || obj.function || '',
    ).trim();
    if (tf) task.transferFunction = tf;
    if (obj.zeros != null) task.zeros = String(obj.zeros).trim();
    if (obj.poles != null) task.poles = String(obj.poles).trim();
    if (obj.gain != null && String(obj.gain).trim() !== '') task.gain = String(obj.gain).trim();
    if (!raw && task.inputMode === 'transfer' && !task.transferFunction) return null;
    if (!raw && task.inputMode === 'zpk' && !task.zeros && !task.poles && !task.transferFunction) return null;
    return task;
  }

  if (action === 'laplace') {
    let mode = String(obj.laplaceMode || obj.transformMode || obj.mode || 'forward').toLowerCase();
    if (/inverse|ilaplace|inv/.test(mode)) mode = 'inverse';
    else mode = 'forward';
    task.mode = mode;
    const fwd = String(obj.forwardExpr || obj.ft || obj.f_t || '').trim();
    const inv = String(obj.inverseExpr || obj.Fs || obj.fs || obj.f_s || '').trim();
    const expr = String(obj.expr || obj.body || obj.function || '').trim();
    if (mode === 'forward') {
      if (fwd) task.forwardExpr = fwd;
      else if (expr) task.forwardExpr = expr;
    } else {
      if (inv) task.inverseExpr = inv;
      else if (expr) task.inverseExpr = expr;
    }
    if (!raw && mode === 'forward' && !task.forwardExpr) return null;
    if (!raw && mode === 'inverse' && !task.inverseExpr) return null;
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
    scalar: kv.scalar || kv.f,
    fx: kv.fx,
    fy: kv.fy,
    fz: kv.fz,
    op: kv.op || kv.operation,
    matrixA: kv.matrixa || kv.matrix_a || kv.latexa,
    matrixB: kv.matrixb || kv.matrix_b || kv.latexb,
    n: kv.n || kv.exponent,
    transferFunction: kv.transferfunction || kv.transfer_function || kv.hs,
    zeros: kv.zeros,
    poles: kv.poles,
    gain: kv.gain || kv.k,
    inputMode: kv.inputmode || kv.input_mode || kv.bodemode,
    forwardExpr: kv.forwardexpr || kv.ft || kv.f_t,
    inverseExpr: kv.inverseexpr || kv.fs || kv.f_s,
    laplaceMode: kv.lapacemode || kv.transformmode || kv.laplacemode,
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
  if (Array.isArray(data.vectorCalculus)) {
    data.vectorCalculus.forEach((t) => push({ ...t, action: 'vectorCalculus' }));
    return out;
  }
  if (Array.isArray(data.vc)) {
    data.vc.forEach((t) => push({ ...t, action: 'vectorCalculus' }));
    return out;
  }
  if (Array.isArray(data.matrix)) {
    data.matrix.forEach((t) => push({ ...t, action: 'matrix' }));
    return out;
  }
  if (Array.isArray(data.bode)) {
    data.bode.forEach((t) => push({ ...t, action: 'bode' }));
    return out;
  }
  if (Array.isArray(data.laplace)) {
    data.laplace.forEach((t) => push({ ...t, action: 'laplace' }));
    return out;
  }
  if (Array.isArray(data.laplaceTransform)) {
    data.laplaceTransform.forEach((t) => push({ ...t, action: 'laplace' }));
    return out;
  }
  if (Array.isArray(data.matrices)) {
    data.matrices.forEach((t) => push({ ...t, action: 'matrix' }));
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
 * Fallback when the model emits ```latex``` pmatrix blocks instead of ```matrix``` solver blocks.
 * @param {string} src
 * @returns {MathActionTask[]}
 */
function extractMatrixTasksFromLatexFences(src) {
  const text = String(src ?? '');
  /** @type {string[]} */
  const matrices = [];
  const fenceRe = /```(?:latex|tex)\s*\n([\s\S]*?)```/gi;
  let m;
  while ((m = fenceRe.exec(text)) !== null) {
    const body = m[1].trim();
    if (/\\begin\{(?:p|b|v|V|B)?matrix\}/i.test(body)) matrices.push(body);
  }
  if (!matrices.length) return [];

  const lower = text.toLowerCase();
  /** @type {Record<string, string>|null} */
  let raw = null;

  if (matrices.length >= 2) {
    let op = 'multiply';
    if (/subtract|minus\b|difference/.test(lower)) op = 'subtract';
    else if (/add|plus\b|sum of two matrices/.test(lower)) op = 'add';
    else if (!/multip|matrix product|dot product|·|times\b/.test(lower) && /matrix/.test(lower)) {
      op = 'multiply';
    }
    raw = { action: 'matrix', op, matrixA: matrices[0], matrixB: matrices[1] };
  } else {
    let op = 'determinant';
    if (/inverse|invert|\^{-1}/.test(lower)) op = 'inverse';
    else if (/transpose|\^t\b|\^\{?t\}?/i.test(lower)) op = 'transpose';
    else if (/eigenvector/.test(lower)) op = 'eigenvectors';
    else if (/eigenvalue|characteristic|char\s*poly/.test(lower)) op = 'eigenvalues';
    else if (/trace|\btr\b/.test(lower)) op = 'trace';
    else if (/rank/.test(lower)) op = 'rank';
    else if (/rref|row reduce/.test(lower)) op = 'rref';
    else if (/power|\^n|\^k/.test(lower)) op = 'power';
    raw = { action: 'matrix', op, matrixA: matrices[0] };
  }

  const task = normalizeCalculusTask(raw, 'matrix');
  return task ? [task] : [];
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

  if (!found.some((t) => t.action === 'matrix')) {
    extractMatrixTasksFromLatexFences(src).forEach(add);
  }

  extractAlgebraActions(src).forEach((task) => {
    if (!task || !ALGEBRA_ACTIONS.includes(task.action)) return;
    const key = JSON.stringify(task);
    if (seen.has(key)) return;
    seen.add(key);
    found.push(task);
  });

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

function bodeProblemLatex(task) {
  if (task.raw) return prepareLatexForKatex(String(task.raw).trim());
  const inputMode = task.inputMode || (task.mode === 'zpk' ? 'zpk' : 'transfer');
  if (inputMode === 'zpk') {
    const k = task.gain || '1';
    const z = task.zeros ? `z=\\{${String(task.zeros).replace(/,/g, ',\\,')}\\}` : 'z=\\varnothing';
    const p = task.poles ? `p=\\{${String(task.poles).replace(/,/g, ',\\,')}\\}` : 'p=\\varnothing';
    return `H(s)\\ \\text{from ZPK:}\\ K=${k},\\ ${z},\\ ${p}`;
  }
  const tf = String(task.transferFunction || task.expr || '').trim();
  const body = exprToBodyLatex(tf);
  return `H(s) = ${body}`;
}

function laplaceProblemLatex(task) {
  if (task.raw) return prepareLatexForKatex(String(task.raw).trim());
  const mode = String(task.mode || task.laplaceMode || 'forward').toLowerCase();
  const isInverse = /inverse|ilaplace|inv/.test(mode);
  const expr = isInverse
    ? String(task.inverseExpr || task.expr || '').trim()
    : String(task.forwardExpr || task.expr || '').trim();
  const body = exprToBodyLatex(expr);
  if (isInverse) return `\\mathcal{L}^{-1}\\{F(s)\\} = \\mathcal{L}^{-1}\\left\\{${wrapCalculusBody(body)}\\right\\}`;
  return `\\mathcal{L}\\{f(t)\\} = \\mathcal{L}\\left\\{${wrapCalculusBody(body)}\\right\\}`;
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

/** Textbook LaTeX for a vector calculus task card. */
function vectorCalculusProblemLatex(task) {
  const mode = String(task.mode || 'gradient').toLowerCase();
  if (task.raw) return prepareLatexForKatex(task.raw.trim());
  if (mode === 'gradient') {
    const f = wrapCalculusBody(exprToBodyLatex(task.scalar || task.expr || ''));
    return `\\nabla f = \\nabla\\left(${f}\\right)`;
  }
  const fx = exprToBodyLatex(task.fx || '0');
  const fy = exprToBodyLatex(task.fy || '0');
  const fz = exprToBodyLatex(task.fz || '0');
  const field = `\\mathbf{F} = ${fx}\\,\\hat{\\mathbf{i}} + ${fy}\\,\\hat{\\mathbf{j}} + ${fz}\\,\\hat{\\mathbf{k}}`;
  if (mode === 'divergence') return `\\nabla \\cdot \\mathbf{F}, \\quad ${field}`;
  return `\\nabla \\times \\mathbf{F}, \\quad ${field}`;
}

/** Textbook LaTeX for a matrix task card. */
function matrixProblemLatex(task) {
  const core = typeof window !== 'undefined' ? window.MatrixCalculatorCore : null;
  const t = core?.normalizeMatrixTask ? core.normalizeMatrixTask(task) : task;
  if (t.raw) {
    const raw = core?.normalizeMatrixExpression
      ? core.normalizeMatrixExpression(t.raw.trim())
      : t.raw.trim();
    return prepareLatexForKatex(raw);
  }
  if (core?.buildLatexFromTask) {
    return prepareLatexForKatex(core.buildLatexFromTask(t));
  }
  const op = String(t.op || 'determinant').toLowerCase();
  const A = String(t.matrixA || t.latexA || '').trim();
  const B = String(t.matrixB || t.latexB || '').trim();
  if (!A) return '';
  const Apx = core?.normalizeMatrixLatex ? core.normalizeMatrixLatex(A) : A;
  const Bpx = B && core?.normalizeMatrixLatex ? core.normalizeMatrixLatex(B) : B;
  if (op === 'determinant' || op === 'det') return `\\det ${Apx}`;
  if (op === 'inverse') return `${Apx}^{-1}`;
  if (op === 'transpose') return `${Apx}^{T}`;
  if (op === 'trace' || op === 'tr') return `\\operatorname{tr}${Apx}`;
  if (op === 'multiply' || op === 'mul') return Bpx ? `${Apx}${Bpx}` : Apx;
  if (op === 'add') return Bpx ? `${Apx} + ${Bpx}` : Apx;
  if (op === 'subtract' || op === 'sub') return Bpx ? `${Apx} - ${Bpx}` : Apx;
  if (op === 'power') return `${Apx}^{${t.n != null ? t.n : 2}}`;
  if (op === 'eigenvalues') return `\\operatorname{eigenvalues}${Apx}`;
  if (op === 'eigenvectors') return `\\operatorname{eigenvectors}${Apx}`;
  return Apx;
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

  if (task.action === 'vectorCalculus') {
    return task.raw ? task.raw.trim() : vectorCalculusProblemLatex(task);
  }

  if (task.action === 'matrix') {
    return task.raw ? task.raw.trim() : matrixProblemLatex(task);
  }

  // ODE is solved via the SymPy backbone
  if (task.action === 'ode') return task.raw ? task.raw.trim() : odeEquationLatex(task);

  if (task.action === 'bode') return task.raw ? task.raw.trim() : bodeProblemLatex(task);

  if (task.action === 'laplace') return task.raw ? task.raw.trim() : laplaceProblemLatex(task);

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
  if (ALGEBRA_ACTIONS.includes(task?.action)) {
    return algebraTaskToDisplayLatex(task);
  }

  if (task.action === 'pde') {
    return ensureDisplayStyle(pdeProblemLatex(task));
  }

  if (task.action === 'vectorCalculus') {
    return ensureDisplayStyle(vectorCalculusProblemLatex(task));
  }

  if (task.action === 'matrix') {
    return ensureDisplayStyle(matrixProblemLatex(task));
  }

  if (task.action === 'ode') {
    const eq = task.raw ? prepareLatexForKatex(task.raw.trim()) : odeEquationLatex(task);
    return ensureDisplayStyle(eq);
  }

  if (task.action === 'bode') {
    return ensureDisplayStyle(bodeProblemLatex(task));
  }

  if (task.action === 'laplace') {
    return ensureDisplayStyle(laplaceProblemLatex(task));
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

  if (ALGEBRA_ACTIONS.includes(task.action)) {
    return formatAlgebraActionLabel(task, index);
  }

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
  if (task.action === 'vectorCalculus') {
    const names = { gradient: 'Gradient', divergence: 'Divergence', curl: 'Curl' };
    const mode = String(task.mode || 'gradient').toLowerCase();
    return `${n}${names[mode] || 'Vector calculus'}`;
  }
  if (task.action === 'matrix') {
    const names = {
      determinant: 'Determinant', inverse: 'Inverse', transpose: 'Transpose', trace: 'Trace',
      rank: 'Rank', rref: 'RREF', power: 'Matrix power', eigenvalues: 'Eigenvalues',
      eigenvectors: 'Eigenvectors', charpoly: 'Characteristic polynomial',
      add: 'Matrix addition', subtract: 'Matrix subtraction', multiply: 'Matrix multiplication',
    };
    const op = String(task.op || 'determinant').toLowerCase();
    return `${n}${names[op] || 'Matrix'}`;
  }
  if (task.action === 'bode') {
    return `${n}Bode plot`;
  }
  if (task.action === 'laplace') {
    const mode = String(task.mode || 'forward').toLowerCase();
    return `${n}${/inverse|ilaplace|inv/.test(mode) ? 'Inverse Laplace' : 'Laplace transform'}`;
  }
  return `${n}${task.mode === 'definite' ? 'Definite integral' : 'Integral'}`;
}
