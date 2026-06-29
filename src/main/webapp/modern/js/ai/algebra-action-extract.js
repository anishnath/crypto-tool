/**
 * Extract structured algebra actions from Algebra AI replies.
 * Fences: ```quadratic```, ```system```, ```inequality```, ```polynomial```, ```algebra-action```
 */
import { prepareLatexForKatex } from '../katex-render.js';

export const ALGEBRA_ACTIONS = ['quadratic', 'system', 'inequality', 'polynomial'];

const ACTION_FENCE_LANGS = new Set([
  'quadratic', 'quad', 'quadratic-equation',
  'system', 'systems', 'system-of-equations', 'linear-system',
  'inequality', 'inequalities',
  'polynomial', 'poly',
  'algebra-action', 'algebra', 'algebraintent',
]);

function nerdamerTeX(expr) {
  try {
    const nd = typeof nerdamer !== 'undefined' ? nerdamer : window.nerdamer;
    if (!nd) return String(expr || '');
    return nd(String(expr || '')).toTeX();
  } catch (_) {
    return String(expr || '');
  }
}

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

function parseBlockContent(content, fenceLang) {
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
    const m = line.match(/^([a-z_0-9]+)\s*:\s*(.+)$/i);
    if (m) {
      kv[m[1].toLowerCase()] = m[2].trim();
      continue;
    }
    if (!bareLine && !line.includes(':')) bareLine = line;
  }

  let action = String(kv.action || kv.kind || kv.type || fenceLang || '').toLowerCase();
  if (action === 'quad') action = 'quadratic';
  if (action === 'systems' || action === 'linear-system' || action === 'system-of-equations') action = 'system';
  if (action === 'poly') action = 'polynomial';
  if (action === 'inequalities') action = 'inequality';
  if (!ALGEBRA_ACTIONS.includes(action)) {
    if (['quadratic', 'quad', 'quadratic-equation'].includes(fenceLang)) action = 'quadratic';
    else if (['system', 'systems', 'linear-system', 'system-of-equations'].includes(fenceLang)) action = 'system';
    else if (['inequality', 'inequalities'].includes(fenceLang)) action = 'inequality';
    else if (['polynomial', 'poly'].includes(fenceLang)) action = 'polynomial';
  }
  if (!ALGEBRA_ACTIONS.includes(action)) return null;

  /** @type {Record<string, unknown>} */
  const task = { action };
  if (kv.raw) task.raw = kv.raw;
  if (kv.expr || kv.equation) task.expr = kv.expr || kv.equation;
  if (kv.variable || kv.var) task.variable = kv.variable || kv.var;
  if (kv.method) task.method = kv.method;
  if (kv.op || kv.operation) task.op = kv.op || kv.operation;
  if (kv.p || kv.p1 || kv.poly) task.p = kv.p || kv.p1 || kv.poly;
  if (kv.q || kv.p2) task.q = kv.q || kv.p2;
  if (kv.x != null || kv.evalx != null) task.x = kv.x ?? kv.evalx;
  if (kv.inequality) task.inequality = kv.inequality;

  for (let i = 1; i <= 8; i++) {
    const eq = kv[`eq${i}`] || kv[`equation${i}`];
    if (eq) task[`eq${i}`] = eq;
  }
  if (kv.equations) {
    task.equations = String(kv.equations).split(/\n|;|\|/).map((s) => s.trim()).filter(Boolean);
  }

  if (bareLine && !task.raw && !task.expr && !task.p) {
    if (action === 'system') task.raw = bareLine;
    else if (action === 'quadratic' || action === 'inequality') task.raw = bareLine;
    else if (action === 'polynomial') task.p = bareLine;
  }

  if (action === 'quadratic' && !task.raw && !task.expr) return null;
  if (action === 'inequality' && !task.raw && !task.expr && !task.inequality) return null;
  if (action === 'system') {
    const hasEq = task.raw || task.equations?.length || task.eq1;
    if (!hasEq) return null;
  }
  if (action === 'polynomial' && !task.p && !task.expr) return null;

  if (task.label || kv.label) task.label = task.label || kv.label;
  return task;
}

function tasksFromJson(data) {
  if (!data || typeof data !== 'object') return [];
  /** @type {object[]} */
  const out = [];

  const normalize = (t) => {
    if (!t || typeof t !== 'object') return;
    let action = String(t.action || '').toLowerCase();
    if (action === 'systems') action = 'system';
    if (action === 'quadratics') action = 'quadratic';
    if (action === 'inequalities') action = 'inequality';
    if (action === 'polynomials') action = 'polynomial';
    if (!ALGEBRA_ACTIONS.includes(action)) return;
    out.push({ ...t, action });
  };

  for (const key of ['tasks', 'quadratic', 'quadratics', 'system', 'systems', 'inequality', 'inequalities', 'polynomial', 'polynomials']) {
    if (Array.isArray(data[key])) {
      data[key].forEach((t) => normalize({ ...t, action: t.action || key.replace(/s$/, '') }));
      return out;
    }
  }
  if (Array.isArray(data)) {
    data.forEach(normalize);
    return out;
  }
  normalize(data);
  return out;
}

/**
 * @param {string} text
 * @returns {object[]}
 */
export function extractAlgebraActions(text) {
  const src = String(text ?? '');
  /** @type {object[]} */
  const found = [];
  const seen = new Set();

  const add = (task) => {
    if (!task || !ALGEBRA_ACTIONS.includes(task.action)) return;
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
      const parsed = parseBlockContent(body, lang);
      if (parsed) add(parsed);
    }
  }
  return found;
}

/**
 * @param {object} task
 */
export function taskToDisplayLatex(task) {
  const action = task?.action || 'quadratic';
  if (task.raw) return ensureDisplayStyle(prepareLatexForKatex(String(task.raw).trim()));

  if (action === 'quadratic' || action === 'inequality') {
    const raw = task.expr || task.equation || task.inequality || '';
    return ensureDisplayStyle(exprToBodyLatex(raw));
  }

  if (action === 'system') {
    const eqs = [];
    if (Array.isArray(task.equations)) eqs.push(...task.equations);
    else {
      for (let i = 1; i <= 8; i++) {
        if (task[`eq${i}`]) eqs.push(String(task[`eq${i}`]));
      }
    }
    if (eqs.length) {
      const rows = eqs.map((e) => exprToBodyLatex(e)).join(' \\\\ ');
      return ensureDisplayStyle(`\\begin{cases}${rows}\\end{cases}`);
    }
    return ensureDisplayStyle(exprToBodyLatex(task.raw || ''));
  }

  if (action === 'polynomial') {
    const op = String(task.op || task.operation || 'factor').toLowerCase();
    const p = exprToBodyLatex(task.p || task.p1 || task.expr || '');
    const q = task.q || task.p2 ? exprToBodyLatex(task.q || task.p2) : '';
    if (op === 'add' && q) return ensureDisplayStyle(`${p} + ${q}`);
    if (op === 'subtract' && q) return ensureDisplayStyle(`${p} - ${q}`);
    if (op === 'multiply' && q) return ensureDisplayStyle(`(${p})(${q})`);
    if (op === 'divide' && q) return ensureDisplayStyle(`\\frac{${p}}{${q}}`);
    if (op === 'factor') return ensureDisplayStyle(`\\text{factor}\\left(${p}\\right)`);
    if (op === 'roots' || op === 'root') return ensureDisplayStyle(`\\text{roots of }${p}`);
    if (op === 'evaluate' || op === 'eval') {
      const x = task.x ?? task.evalX ?? '0';
      return ensureDisplayStyle(`${p}\\big|_{x=${x}}`);
    }
    return ensureDisplayStyle(p);
  }

  return '';
}

/**
 * @param {object} task
 * @param {number} [index]
 */
export function formatAlgebraActionLabel(task, index) {
  const n = typeof index === 'number' ? `#${index + 1} ` : '';
  if (task.label) return task.label;

  const names = {
    quadratic: 'Quadratic equation',
    system: 'System of equations',
    inequality: 'Inequality',
    polynomial: 'Polynomial',
  };
  const base = names[task.action] || 'Algebra problem';
  if (task.action === 'polynomial' && task.op) {
    return `${n}${base} · ${String(task.op).toLowerCase()}`;
  }
  return `${n}${base}`;
}
