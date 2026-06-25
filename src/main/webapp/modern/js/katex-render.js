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
 * @param {string} tex
 * @param {boolean} [displayMode]
 * @returns {string}
 */
export function renderTeX(tex, displayMode = false) {
  const katex = typeof window !== 'undefined' ? window.katex : null;
  if (!katex) return escHtml(tex);
  try {
    return katex.renderToString(String(tex ?? '').trim(), {
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
