/**
 * Shared KaTeX rendering for AI chat, math calculators, and step-by-step UIs.
 * Uses global `katex` from katex-head.inc.jsp (CDN) or loadKatex().
 */

export const KATEX_VERSION = '0.16.9';
export const KATEX_CDN_BASE = `https://cdn.jsdelivr.net/npm/katex@${KATEX_VERSION}/dist`;

const HTML_ESCAPES = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' };

function escHtml(s) {
  return String(s ?? '').replace(/[&<>"']/g, (c) => HTML_ESCAPES[c]);
}

/** @returns {Promise<typeof katex>} */
export function loadKatex() {
  if (typeof window !== 'undefined' && window.katex) {
    return Promise.resolve(window.katex);
  }
  if (typeof window !== 'undefined' && window.__katexLoadPromise) {
    return window.__katexLoadPromise;
  }

  const promise = new Promise((resolve, reject) => {
    if (typeof document === 'undefined') {
      reject(new Error('KaTeX load requires a browser environment'));
      return;
    }

    if (!document.querySelector('link[data-katex-css]')) {
      const link = document.createElement('link');
      link.rel = 'stylesheet';
      link.href = `${KATEX_CDN_BASE}/katex.min.css`;
      link.dataset.katexCss = '1';
      document.head.appendChild(link);
    }

    const existing = document.querySelector('script[data-katex-js]');
    if (existing) {
      existing.addEventListener('load', () => resolve(window.katex));
      existing.addEventListener('error', () => reject(new Error('KaTeX script failed to load')));
      return;
    }

    const script = document.createElement('script');
    script.src = `${KATEX_CDN_BASE}/katex.min.js`;
    script.defer = true;
    script.dataset.katexJs = '1';
    script.onload = () => resolve(window.katex);
    script.onerror = () => reject(new Error('KaTeX script failed to load'));
    document.head.appendChild(script);
  });

  if (typeof window !== 'undefined') window.__katexLoadPromise = promise;
  return promise;
}

/**
 * Fix SymPy / JSON LaTeX quirks before KaTeX (backslash loss, empty \\mathrm, etc.).
 * @param {string} s
 */
function repairSympyLatex(s) {
  /** Protect matrix environments — row separators need \\\\; collapse breaks KaTeX. */
  const matrixSlots = [];
  let out = s.replace(
    /\\begin\{(pmatrix|bmatrix|matrix|vmatrix|Bmatrix|Vmatrix)\}[\s\S]*?\\end\{(?:pmatrix|bmatrix|matrix|vmatrix|Bmatrix|Vmatrix)\}/g,
    (block) => {
      matrixSlots.push(block);
      return `\x00MAT${matrixSlots.length - 1}\x00`;
    },
  );
  /* Collapse JSON double-backslashes outside matrices */
  out = out.replace(/\\\\/g, '\\');
  /* Erroneous \\text{mathrm} from partial command loss */
  out = out.replace(/\\text\{\s*mathrm\s*\}/gi, '');
  /* Restore \\mathrm when the backslash was dropped */
  out = out.replace(/(?<![\\a-zA-Z])mathrm\{/gi, '\\mathrm{');
  /* SymPy differentials: "mathrm d" or "mathrm{d}" without leading \\ */
  out = out.replace(/(?<![\\a-zA-Z])mathrm\s*d(?![a-zA-Z])/gi, '\\mathrm{d}');
  /* Stray empty \\mathrm or \\mathrm glued to numbers in fractions */
  out = out.replace(/\\mathrm\{\s*\}/g, '');
  out = out.replace(/\\frac\{(\d+)\\mathrm\}\{(\d+)\}/g, '\\frac{$1}{$2}');
  out = out.replace(/(\d)\\mathrm(?=[\s\}])/g, '$1');
  /* Restore common commands when \\ was lost (not already escaped) */
  out = out.replace(
    /(?<![\\a-zA-Z])(frac|left|right|sin|cos|tan|sec|csc|cot|log|ln|sqrt|int|sum|pi|infty|theta|cdot|quad|displaystyle)(?=[\s\{(\[])/g,
    '\\$1',
  );
  /* Thin-space differential. Handle the already-escaped "\, dx" first so the
     bare-comma rule below never sees it and prepends a second backslash
     (which would create "\\,\mathrm{d}x" — a KaTeX line break). */
  out = out.replace(/\\,\s*d([a-zA-Z])\b/g, '\\,\\mathrm{d}$1');
  /* Bare "<comma> d x" with no preceding backslash → \,\mathrm{d}x */
  out = out.replace(/(?<!\\),\s*d([a-zA-Z])\b/g, '\\,\\mathrm{d}$1');
  out = out.replace(/\x00MAT(\d+)\x00/g, (_, i) => matrixSlots[Number(i)] ?? '');
  return out;
}

/**
 * Normalize SymPy / JSON LaTeX for KaTeX (same rules as integral-calculator.js).
 * Collapses double-backslashes so \\mathrm → \mathrm, etc.
 * @param {string} latex
 * @returns {string}
 */
export function prepareLatexForKatex(latex) {
  if (!latex || typeof latex !== 'string') return latex;
  let s = repairSympyLatex(latex);
  const core = typeof window !== 'undefined' ? window.MatrixCalculatorCore : null;
  if (core?.repairMatrixLatex) {
    s = core.repairMatrixLatex(s);
  }
  /* Bare pi/inf tokens (not already \\pi) — e.g. bounds "pi/2" from AI */
  s = s.replace(/(?<![\\a-zA-Z])pi\s*\/\s*(\d+)(?![a-zA-Z])/gi, '\\frac{\\pi}{$1}');
  s = s.replace(/(?<![\\a-zA-Z])pi(?![a-zA-Z/])/gi, '\\pi');
  s = s.replace(/(?<![\\a-zA-Z])oo(?![a-zA-Z])/g, '\\infty');
  s = s.replace(/(?<![\\a-zA-Z])inf(ty)?(?![a-zA-Z])/gi, '\\infty');
  const hasLatex = /\\|[\^_]|\{[^}]*\}/.test(s);
  if (!hasLatex) {
    return `\\text{${s.replace(/\\/g, '\\\\').replace(/}/g, '\\}')}}`;
  }
  s = s.replace(/((?:[A-Za-z]{2,} ){2,}[A-Za-z]{2,})/g, '\\text{$1}');
  s = s.replace(/^([A-Z][a-z]+)\\ /g, '\\text{$1} ');
  return s;
}

/**
 * @param {string} bound
 * @returns {string}
 */
export function normalizeBoundLatex(bound) {
  let s = String(bound ?? '').trim();
  if (!s) return s;
  if (/\\/.test(s)) return s;
  s = s.replace(/\boo\b/g, '\\infty');
  s = s.replace(/\binf(ty)?\b/gi, '\\infty');
  s = s.replace(/\bpi\s*\/\s*(\d+)\b/gi, '\\frac{\\pi}{$1}');
  s = s.replace(/\bpi\b/gi, '\\pi');
  if (/^\d+\s*\/\s*\d+$/.test(s)) {
    const [a, b] = s.split('/').map((x) => x.trim());
    return `\\frac{${a}}{${b}}`;
  }
  return s;
}

export function createMathSlotEl(latex, display = true) {
  const el = document.createElement('div');
  el.className = 'vca-math-slot';
  el.dataset.latex = latex || '';
  el.dataset.display = display ? 'true' : 'false';
  return el;
}

/**
 * @param {HTMLElement} parent
 * @param {string} latex
 * @param {string} [extraClass]
 */
export function appendEqSlot(parent, latex, extraClass = '') {
  const wrap = document.createElement('div');
  wrap.className = `vca-math-eq ${extraClass}`.trim();
  wrap.appendChild(createMathSlotEl(latex, true));
  parent.appendChild(wrap);
  return wrap;
}

/**
 * @param {string} tex
 * @param {boolean} [displayMode]
 * @returns {string}
 */
export function renderTeX(tex, displayMode = false) {
  const katex = typeof window !== 'undefined' ? window.katex : null;
  if (!katex) return escHtml(tex);
  try {
    return katex.renderToString(prepareLatexForKatex(String(tex ?? '').trim()), {
      throwOnError: false,
      displayMode: !!displayMode,
      strict: 'ignore',
      trust: false,
    });
  } catch {
    return `<code>${escHtml(tex)}</code>`;
  }
}

/**
 * Render prepared LaTeX into a DOM element (engine steps / SymPy output).
 * @param {HTMLElement|null|undefined} el
 * @param {string} latex
 * @param {boolean} [displayMode]
 */
export function renderLatexIntoElement(el, latex, displayMode = true) {
  if (!el || !latex) return;
  const katex = typeof window !== 'undefined' ? window.katex : null;
  if (!katex) {
    el.textContent = latex;
    return;
  }
  try {
    let prepared = prepareLatexForKatex(latex);
    if (displayMode) prepared = prepared.replace(/^\\displaystyle\s+/, '');
    katex.render(prepared, el, {
      displayMode: !!displayMode,
      throwOnError: false,
      strict: 'ignore',
    });
  } catch {
    el.textContent = latex;
  }
}

/**
 * Typeset all `.vca-math-slot` placeholders under root (data-latex attribute).
 * @param {HTMLElement|null|undefined} root
 * @returns {Promise<void>}
 */
export async function typesetMathSlots(root) {
  if (!root) return;
  await loadKatex();
  root.querySelectorAll('.vca-math-slot').forEach((el) => {
    let latex = el.dataset.latex || el.getAttribute('data-latex') || '';
    if (latex.includes('%')) {
      try { latex = decodeURIComponent(latex); } catch (_) { /* keep raw */ }
    }
    const display = (el.dataset.display || el.getAttribute('data-display')) !== 'false';
    renderLatexIntoElement(/** @type {HTMLElement} */ (el), latex, display);
  });
}

/**
 * @param {string} text
 * @returns {{ type: 'prose'|'math', text: string, display?: boolean }[]}
 */
export function tokenizeMath(text) {
  const src = String(text ?? '');
  /** @type {{ type: 'prose'|'math', text: string, display?: boolean }[]} */
  const out = [];
  let i = 0;
  const n = src.length;

  const pushProse = (chunk) => {
    if (chunk) out.push({ type: 'prose', text: chunk });
  };
  const pushMath = (chunk, display) => {
    if (chunk.trim()) out.push({ type: 'math', text: chunk, display });
  };

  while (i < n) {
    if (src.startsWith('$$', i)) {
      const end = src.indexOf('$$', i + 2);
      if (end < 0) { pushProse(src.slice(i)); break; }
      pushMath(src.slice(i + 2, end), true);
      i = end + 2;
      continue;
    }
    if (src.startsWith('\\[', i)) {
      const end = src.indexOf('\\]', i + 2);
      if (end < 0) { pushProse(src.slice(i)); break; }
      pushMath(src.slice(i + 2, end), true);
      i = end + 2;
      continue;
    }
    if (src.startsWith('\\(', i)) {
      const end = src.indexOf('\\)', i + 2);
      if (end < 0) { pushProse(src.slice(i)); break; }
      pushMath(src.slice(i + 2, end), false);
      i = end + 2;
      continue;
    }
    if (src[i] === '$' && src[i + 1] !== '$') {
      const end = src.indexOf('$', i + 1);
      if (end < 0) { pushProse(src.slice(i)); break; }
      pushMath(src.slice(i + 1, end), false);
      i = end + 1;
      continue;
    }

    let next = n;
    for (let j = i; j < n; j += 1) {
      if (src.startsWith('$$', j) || src.startsWith('\\[', j) || src.startsWith('\\(', j) || src[j] === '$') {
        next = j;
        break;
      }
    }
    pushProse(src.slice(i, next));
    i = next;
  }

  return out;
}

/**
 * Render mixed prose + LaTeX to HTML (prose escaped, math via KaTeX).
 * @param {string} text
 * @returns {string}
 */
export function renderMixedLatex(text) {
  const tokens = tokenizeMath(text);
  if (!tokens.length) return '';
  return tokens.map((tok) => (
    tok.type === 'math'
      ? renderTeX(tok.text, tok.display)
      : escHtml(tok.text)
  )).join('');
}

/**
 * Replace math delimiters in text nodes under `root` (skips code/pre blocks).
 * @param {HTMLElement|null|undefined} root
 */
export function typesetKatexInElement(root) {
  if (!root || typeof window === 'undefined' || !window.katex) return;

  const walker = document.createTreeWalker(
    root,
    NodeFilter.SHOW_TEXT,
    {
      acceptNode(node) {
        const parent = node.parentElement;
        if (!parent) return NodeFilter.FILTER_REJECT;
        if (parent.closest('pre, code, .vca-code-wrap, .vca-code, .katex, script, style')) {
          return NodeFilter.FILTER_REJECT;
        }
        const t = node.textContent || '';
        if (!/[$]|\\[\[(]/.test(t)) return NodeFilter.FILTER_REJECT;
        return NodeFilter.FILTER_ACCEPT;
      },
    },
  );

  /** @type {Text[]} */
  const textNodes = [];
  while (walker.nextNode()) textNodes.push(/** @type {Text} */ (walker.currentNode));

  for (const node of textNodes) {
    const src = node.textContent || '';
    const html = renderMixedLatex(src);
    if (html === escHtml(src)) continue;
    const tpl = document.createElement('template');
    tpl.innerHTML = html;
    node.replaceWith(tpl.content);
  }
}

/**
 * Load KaTeX if needed, then typeset math in an element.
 * @param {HTMLElement|null|undefined} root
 * @returns {Promise<void>}
 */
export async function typesetKatexWhenReady(root) {
  if (!root) return;
  await loadKatex();
  typesetKatexInElement(root);
}
