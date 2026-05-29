/**
 * ToolAiAssistant — generic multi-turn AI chat surface for any tool page.
 *
 * Features:
 *   • Streaming chat over /ai or /ai-gateway with abort (Stop) support.
 *   • Pluggable per-tool apply pipeline (`applyActions`) with reusable extractors.
 *   • Smart history management: sliding window, intent-aware reset, fenced-code
 *     compression of older assistant turns, empty-context elision.
 *   • Lightweight Markdown rendering (headings, lists, bold/italic, inline code,
 *     fenced code blocks with per-block copy buttons). No external dependency.
 *   • Accessibility: focus trap, escape-to-close, aria-busy on streaming bubbles.
 *
 * @example
 * import {
 *   ToolAiAssistant,
 *   applyExtractors,
 *   extractLastFencedBlock,
 * } from '/modern/js/vibe-coding-assistant.js';
 *
 * const ai = new ToolAiAssistant({
 *   ctx: '/myapp',
 *   toolId: 'tools/my-editor',
 *   systemPrompt: '...',
 *   seedContext: () => editor.getValue(),
 *   applyActions: [{
 *     id: 'source',
 *     label: 'Apply to editor',
 *     extract: applyExtractors.fencedCode(['python', 'py']),
 *     apply: (code) => editor.setValue(code),
 *   }],
 * });
 * ai.mount();
 */

import { streamChat } from './llm-client.js';
import { fetchBillingStatus, fetchPlans, startCheckout, loginUrl } from './billing-client.js';

// ─── Constants ───────────────────────────────────────────────────────────────

const STORAGE_PREFIX = 'tool_ai_v1_';
const LEGACY_STORAGE_PREFIXES = ['tool_ai_', 'vibe_chat_'];
const LAYOUT_SUFFIX = '_layout';
const PREFS_SUFFIX = '_prefs';
const DEFAULT_LAYOUT = Object.freeze({ x: null, y: null, w: null, h: null, collapsed: false });
const PANEL_MIN_W = 360;
const PANEL_MIN_H = 300;
const DEFAULT_POLICY_PREFS = Object.freeze({ mode: 'fast', freshContext: true });

/** Default tier → servlet when aiRouteMode is `tier` (e.g. USE_AI_GATEWAY=true on server). */
function defaultAiRouteByTier(sitePrefersGateway) {
  return {
    guest: 'legacy',
    free: 'gateway',
    pro: 'gateway',
    unknown: sitePrefersGateway ? 'gateway' : 'legacy',
  };
}
const MODE_PROMPT_SUFFIX = Object.freeze({
  fast: '',
  explain: 'Explain briefly with rationale and trade-offs tied to the current code/circuit.',
  strict: 'Prioritize correctness and risks. Call out uncertainty explicitly; do not guess.',
});

const DEFAULT_CODE_LANGS = Object.freeze([
  'cpp', 'c++', 'arduino', 'ino',
  'javascript', 'js', 'typescript', 'ts',
  'python', 'py', 'java', 'kotlin', 'go', 'rust', 'rs',
  'ruby', 'rb', 'php', 'swift', 'c', 'h', 'html', 'css', 'scss',
  'sql', 'bash', 'sh', 'shell', 'yaml', 'yml', 'xml', 'lua', 'verilog', 'vhdl',
]);

/** Phrases that signal a fresh start (drop conversation history). */
const DEFAULT_RESET_PATTERNS = Object.freeze([
  /\bnew (?:project|chat|conversation|session|file|sketch|example|task)\b/i,
  /\b(?:start|begin)\s+(?:over|fresh|again|a\s+new)\b/i,
  /\b(?:reset|clear|forget)\s+(?:chat|history|context|everything)\b/i,
  /^\s*\/(?:new|reset|clear)\b/i,
  /\bcreate\s+(?:a\s+)?(?:new|another|different)\s+\w+/i,
  /\b(?:scrap|throw\s+away)\s+(?:that|this|everything)\b/i,
]);

const JSON_FENCE_RE = /```(?:json)?\s*\n([\s\S]*?)```/gi;
const ANY_FENCE_RE = /```[\w#+.-]*\s*\n[\s\S]*?```/g;
/** Matches `[CURRENT CONTEXT]\n…\n\n[USER]\n` prefix used by `_buildMessages`. */
const CONTEXT_USER_PREFIX_RE = /^\[CURRENT CONTEXT\][\s\S]*?\n\[USER\]\n/;

/**
 * Phrases assistants emit when the seedContext was empty ("no code/sketch/
 * circuit yet"). If a fresh non-empty context arrives after one of these
 * replies, the conversation is stale and should be reset before sending —
 * otherwise the model anchors to the prior disclaimers.
 */
const STALE_DISCLAIMER_RE = new RegExp([
  /\bno\s+(?:current\s+)?(?:code|sketch|circuit|project|content)\b/.source,
  /\b(?:is|are)n'?t\s+(?:any\s+)?(?:current\s+)?(?:code|sketch|circuit|project|content)\b/.source,
  /\bsketch\s+is\s+(?:empty|blank|not\s+set)\b/.source,
  /\b(?:current\s+)?context\s+(?:is\s+)?(?:empty|blank|not\s+(?:set|provided))\b/.source,
  /\bnothing\s+(?:to\s+explain|here|in\s+(?:the\s+)?(?:project|context))\b/.source,
  /\bproject\s+(?:hasn'?t\s+been\s+(?:built|configured)|is\s+empty)\b/.source,
  /\bboard(?:\s+fqbn)?\s+is\s+(?:empty|not\s+set|missing|blank)\b/.source,
].join('|'), 'i');

/**
 * Strip a `[CURRENT CONTEXT] … [USER]` prefix from a user-turn payload so older
 * snapshots don't compete with the freshest one. Exported for tests/tools.
 * @param {string} content
 */
export function stripContextPrefix(content) {
  const s = String(content ?? '');
  if (!CONTEXT_USER_PREFIX_RE.test(s)) return s;
  return s.replace(CONTEXT_USER_PREFIX_RE, '').trim();
}

function contextWarningsFromState(state) {
  const text = String(state ?? '');
  const warns = [];
  if (!text.trim()) warns.push('Context snapshot is empty.');
  if (/Board\s+FQBN:\s*\(\s*\)/i.test(text) || /Board\s+FQBN:\s*$/im.test(text)) {
    warns.push('Board FQBN is missing in context.');
  }
  if (/Sketch\s*\(\s*false\s*\):/i.test(text)) {
    warns.push('Sketch name is invalid (`false`) in context.');
  }
  if (/Sketch\s*\([^)]*\):\s*$/im.test(text) && !/Sketch\s*\([^)]*\):\s*[\s\S]*\S/im.test(text)) {
    warns.push('Sketch content appears empty.');
  }
  return warns;
}
const FOCUSABLE_SELECTOR = [
  'button:not([disabled])',
  'textarea:not([disabled])',
  'input:not([disabled])',
  '[tabindex]:not([tabindex="-1"])',
].join(',');

let instanceCounter = 0;

// ─── Pure helpers ────────────────────────────────────────────────────────────

function escapeRegex(s) {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

const HTML_ESCAPES = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' };
function escapeHtml(s) {
  return String(s ?? '').replace(/[&<>"']/g, (c) => HTML_ESCAPES[c]);
}

/**
 * Default compression for older assistant turns. Replaces fenced code/diagram
 * blocks with a short marker (current state is already in `seedContext`).
 * The newest assistant turn is preserved intact.
 *
 * @param {string} text
 * @param {number} recencyIndex - 0 = newest assistant turn, 1 = previous, …
 */
export function compressOldAssistant(text, recencyIndex) {
  if (recencyIndex === 0) return text;
  let replaced = 0;
  const stripped = text.replace(ANY_FENCE_RE, () => {
    replaced += 1;
    return '[code/diagram applied — see current state]';
  });
  if (!replaced) return text;
  if (stripped.length > 600) {
    return stripped.slice(0, 600).trimEnd() + '…\n[older assistant message trimmed]';
  }
  return stripped;
}

/** Returns true when a `seedContext()` block contains only labels/whitespace. */
function isEffectivelyEmptyContext(state) {
  if (!state) return true;
  const stripped = state
    .replace(/^\s*[\w][\w\s/.()]*:\s*$/gm, '')
    .replace(/\(\s*\)/g, '')
    .replace(/[\s\n]/g, '');
  return stripped.length === 0;
}

// ─── Extractors (public) ─────────────────────────────────────────────────────

/**
 * All fenced code blocks in a response.
 * @param {string} text
 * @param {{ langs?: string[], minLength?: number }} [options]
 * @returns {{ lang: string, content: string }[]}
 */
export function extractFencedBlocks(text, options = {}) {
  const langs = options.langs;
  const minLength = options.minLength ?? 1;
  const langPart = langs?.length ? langs.map(escapeRegex).join('|') : '[\\w#+.-]+';
  const re = new RegExp('```(' + langPart + ')?\\s*\\n([\\s\\S]*?)```', 'gi');
  const blocks = [];
  let m;
  while ((m = re.exec(text)) !== null) {
    const content = m[2].trim();
    if (content.length >= minLength) {
      blocks.push({ lang: (m[1] || '').toLowerCase(), content });
    }
  }
  return blocks;
}

/**
 * Last matching fenced block (typical for "full updated file" replies).
 * @param {string} text
 * @param {{ langs?: string[], minLength?: number, fallbackTest?: RegExp }} [options]
 * @returns {string|null}
 */
export function extractLastFencedBlock(text, options = {}) {
  const blocks = extractFencedBlocks(text, options);
  if (blocks.length) return blocks[blocks.length - 1].content;
  if (options.fallbackTest?.test(text)) return text.trim();
  return null;
}

/** Best-effort parse: tolerates trailing commas often produced by LLMs. */
function tryParseJsonLenient(raw) {
  const s = String(raw ?? '').trim();
  if (!s) return undefined;
  try { return JSON.parse(s); } catch { /* try lenient */ }
  try { return JSON.parse(s.replace(/,(\s*[}\]])/g, '$1')); } catch { return undefined; }
}

/**
 * Parsed JSON objects from fenced code blocks (```json or ``` unlabelled).
 * Falls back to any `{ ... }` block in the response that lexically contains
 * the required shape — useful when the LLM forgets the json language tag.
 *
 * @param {string} text
 * @param {(obj: any) => boolean} [validate]
 * @returns {any[]}
 */
export function extractJsonFences(text, validate) {
  const out = [];
  let m;
  JSON_FENCE_RE.lastIndex = 0;
  while ((m = JSON_FENCE_RE.exec(text)) !== null) {
    const parsed = tryParseJsonLenient(m[1]);
    if (parsed !== undefined && (!validate || validate(parsed))) out.push(parsed);
  }
  if (!out.length && validate) {
    // Fallback: scan for any balanced { … } object that passes validation.
    const candidates = scanBalancedObjects(text);
    for (const obj of candidates) {
      if (validate(obj)) out.push(obj);
    }
  }
  return out;
}

/** Iterate top-level `{ … }` candidates without parsing the whole document. */
function scanBalancedObjects(text) {
  const results = [];
  const src = String(text ?? '');
  for (let i = 0; i < src.length; i += 1) {
    if (src[i] !== '{') continue;
    let depth = 0;
    let inStr = false;
    let escape = false;
    for (let j = i; j < src.length; j += 1) {
      const ch = src[j];
      if (escape) { escape = false; continue; }
      if (ch === '\\') { escape = true; continue; }
      if (ch === '"') { inStr = !inStr; continue; }
      if (inStr) continue;
      if (ch === '{') depth += 1;
      else if (ch === '}') {
        depth -= 1;
        if (depth === 0) {
          const slice = src.slice(i, j + 1);
          const parsed = tryParseJsonLenient(slice);
          if (parsed && typeof parsed === 'object') results.push(parsed);
          i = j; // skip past this object
          break;
        }
      }
    }
  }
  return results;
}

/** Reusable extractors for common tool patterns. */
export const applyExtractors = Object.freeze({
  fencedCode(langs = DEFAULT_CODE_LANGS, opts = {}) {
    const { minLength = 20, fallbackTest } = opts;
    return (text) => extractLastFencedBlock(text, { langs, minLength, fallbackTest });
  },
  fencedJson(validate = (o) => o !== null && typeof o === 'object') {
    return (text) => {
      const items = extractJsonFences(text, validate);
      return items.length ? items[items.length - 1] : null;
    };
  },
  wokwiDiagram() {
    return applyExtractors.fencedJson((o) => Array.isArray(o?.parts));
  },
  fencedLang(lang, minLength = 1) {
    return (text) => {
      const blocks = extractFencedBlocks(text, { langs: [lang], minLength });
      return blocks.length ? blocks[blocks.length - 1].content : null;
    };
  },
});

// ─── Markdown rendering (minimal, safe) ──────────────────────────────────────

/**
 * Render a small subset of Markdown into a DocumentFragment.
 * Returns a fragment so callers can attach copy handlers to code blocks.
 *
 * Supported: ATX headings (#-###), unordered (`- `, `* `) and ordered (`1. `)
 * lists, **bold**, *italic*, `inline code`, fenced code blocks with language
 * class, blank-line paragraph breaks, automatic link wrapping for raw URLs.
 *
 * All input is HTML-escaped before any Markdown transform runs.
 *
 * @param {string} markdown
 * @returns {DocumentFragment}
 */
export function renderMarkdown(markdown) {
  const frag = document.createDocumentFragment();
  const text = String(markdown ?? '');

  const fenceRe = /```([\w#+.-]*)\s*\n([\s\S]*?)```/g;
  let lastIndex = 0;
  let m;

  const appendProse = (chunk) => {
    if (!chunk.trim()) return;
    const wrapper = document.createElement('div');
    wrapper.className = 'vca-md';
    wrapper.innerHTML = renderProse(chunk);
    frag.appendChild(wrapper);
  };

  while ((m = fenceRe.exec(text)) !== null) {
    if (m.index > lastIndex) appendProse(text.slice(lastIndex, m.index));

    const lang = (m[1] || '').toLowerCase();
    const code = m[2].replace(/\n$/, '');
    frag.appendChild(buildCodeBlock(lang, code));

    lastIndex = fenceRe.lastIndex;
  }
  if (lastIndex < text.length) appendProse(text.slice(lastIndex));
  return frag;
}

function buildCodeBlock(lang, code) {
  const wrap = document.createElement('div');
  wrap.className = 'vca-code-wrap';

  const header = document.createElement('div');
  header.className = 'vca-code-header';

  const langLabel = document.createElement('span');
  langLabel.className = 'vca-code-lang';
  langLabel.textContent = lang || 'text';

  const copyBtn = document.createElement('button');
  copyBtn.type = 'button';
  copyBtn.className = 'vca-code-copy';
  copyBtn.textContent = 'Copy';
  copyBtn.addEventListener('click', async () => {
    try {
      await navigator.clipboard.writeText(code);
      copyBtn.textContent = 'Copied';
      setTimeout(() => { copyBtn.textContent = 'Copy'; }, 1500);
    } catch {
      copyBtn.textContent = 'Failed';
      setTimeout(() => { copyBtn.textContent = 'Copy'; }, 1500);
    }
  });

  header.appendChild(langLabel);
  header.appendChild(copyBtn);

  const pre = document.createElement('pre');
  pre.className = 'vca-code';
  const codeEl = document.createElement('code');
  if (lang) codeEl.className = 'language-' + lang;
  codeEl.textContent = code;
  pre.appendChild(codeEl);

  wrap.appendChild(header);
  wrap.appendChild(pre);
  return wrap;
}

function renderProse(raw) {
  const escaped = escapeHtml(raw);
  const lines = escaped.split('\n');
  const out = [];
  let listType = null; // 'ul' | 'ol' | null
  let paragraphBuf = [];

  const flushParagraph = () => {
    if (!paragraphBuf.length) return;
    out.push('<p>' + applyInline(paragraphBuf.join(' ')) + '</p>');
    paragraphBuf = [];
  };
  const closeList = () => {
    if (listType) { out.push(`</${listType}>`); listType = null; }
  };

  for (const line of lines) {
    if (!line.trim()) {
      flushParagraph();
      closeList();
      continue;
    }

    const heading = /^(#{1,3})\s+(.+)$/.exec(line);
    if (heading) {
      flushParagraph();
      closeList();
      const level = heading[1].length;
      out.push(`<h${level + 2}>${applyInline(heading[2])}</h${level + 2}>`);
      continue;
    }

    const ul = /^\s*[-*]\s+(.+)$/.exec(line);
    const ol = /^\s*\d+\.\s+(.+)$/.exec(line);
    if (ul || ol) {
      flushParagraph();
      const wantType = ul ? 'ul' : 'ol';
      if (listType !== wantType) {
        closeList();
        out.push(`<${wantType}>`);
        listType = wantType;
      }
      out.push('<li>' + applyInline((ul || ol)[1]) + '</li>');
      continue;
    }

    paragraphBuf.push(line.trim());
  }
  flushParagraph();
  closeList();
  return out.join('');
}

function applyInline(text) {
  return text
    .replace(/`([^`]+)`/g, '<code>$1</code>')
    .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
    .replace(/(^|[^*])\*([^*\n]+)\*/g, '$1<em>$2</em>')
    .replace(/\bhttps?:\/\/[^\s<]+/g, (url) => `<a href="${url}" target="_blank" rel="noopener noreferrer">${url}</a>`);
}

// ─── Apply-action plumbing ───────────────────────────────────────────────────

/**
 * @typedef {object} ApplyAction
 * @property {string} id
 * @property {string} label
 * @property {number} [order]
 * @property {(responseText: string) => any} extract
 * @property {(payload: any) => void|Promise<void>} apply
 */

function buildLegacyApplyActions(opts) {
  /** @type {ApplyAction[]} */
  const actions = [];
  const labels = opts.applyLabels || {};

  if (typeof opts.onApplyCode === 'function') {
    actions.push({
      id: 'code',
      order: 1,
      label: labels.code || 'Apply code',
      extract: typeof opts.extractCode === 'function'
        ? opts.extractCode
        : applyExtractors.fencedCode(opts.codeLangs || DEFAULT_CODE_LANGS, {
          minLength: opts.codeMinLength ?? 20,
          fallbackTest: opts.codeFallbackTest,
        }),
      apply: opts.onApplyCode,
    });
  }
  if (typeof opts.onApplyDiagram === 'function') {
    actions.push({
      id: 'diagram',
      order: 2,
      label: labels.diagram || 'Apply diagram',
      extract: typeof opts.extractDiagram === 'function'
        ? opts.extractDiagram
        : applyExtractors.wokwiDiagram(),
      apply: opts.onApplyDiagram,
    });
  }
  return actions;
}

// ─── ToolAiAssistant ─────────────────────────────────────────────────────────

export class ToolAiAssistant {
  /**
   * @param {object} opts
   * @param {string} opts.ctx
   * @param {string} [opts.aiUrl]
   * @param {boolean} [opts.useGateway]
   * @param {'auto'|'gateway'|'legacy'|'tier'} [opts.aiRouteMode] - per-tool route override.
   *   auto (default): infer from aiUrl/useGateway (static for the session).
   *   gateway: force /ai-gateway with gateway headers.
   *   legacy: force /ai (AIProxyServlet / Ollama) with no gateway headers.
   *   tier: pick route from aiRouteByTier after billing tier is known (guest → legacy, logged-in → gateway by default).
   * @param {Partial<Record<'guest'|'free'|'pro'|'unknown', 'gateway'|'legacy'>>} [opts.aiRouteByTier]
   *   Per-tier route when aiRouteMode is tier. Tools may override individual tiers.
   * @param {string} [opts.userId]
   * @param {string} [opts.toolId]
   * @param {string} opts.systemPrompt
   * @param {string} [opts.title]
   * @param {string} [opts.subtitle]
   * @param {string} [opts.placeholder]
   * @param {string} [opts.footerText]
   * @param {number} [opts.historyTurns] - user+assistant pairs sent to the model (default 3)
   * @param {boolean} [opts.persistHistory]
   * @param {RegExp[]} [opts.resetPatterns]
   * @param {(userText: string, history: object[]) => 'reset'|'continue'|void} [opts.detectIntent]
   * @param {(text: string, recencyIndex: number, role: string) => string} [opts.compressTurn]
   * @param {boolean} [opts.skipEmptyContext]
   * @param {Function} opts.seedContext
   * @param {ApplyAction[]} [opts.applyActions]
   * @param {'combined'|'separate'} [opts.applyUi]
   * @param {(matched: {action: ApplyAction, payload: any}[]) => string} [opts.getApplyLabel]
   * @param {string} [opts.appliedLabel]
   * @param {Function} [opts.onApplyCode] - legacy alias for applyActions
   * @param {Function} [opts.onApplyDiagram] - legacy alias for applyActions
   * @param {{ code?: string, diagram?: string }} [opts.applyLabels]
   * @param {string[]} [opts.codeLangs]
   * @param {Function} [opts.getQuickActions]
   * @param {Function} [opts.onTurn]
   * @param {Function} [opts.onError]
   * @param {boolean} [opts.markdown] - render Markdown in assistant bubbles (default true)
   * @param {number} [opts.maxInputLength] - clamp textarea input (default 8000)
   * @param {boolean} [opts.floating] - render as a non-blocking, draggable, collapsible
   *   floating panel that lets the user keep interacting with the parent page (default true)
   * @param {boolean} [opts.persistLayout] - persist drag position + collapsed state in
   *   localStorage per toolId (default true)
   */
  constructor(opts) {
    this.ctx = opts.ctx || '';
    this.userId = opts.userId || '';
    const mode = (opts.aiRouteMode || 'auto').toLowerCase();
    this.aiRouteMode = ['auto', 'gateway', 'legacy', 'tier'].includes(mode) ? mode : 'auto';
    const requestedUrl = opts.aiUrl || (this.ctx + (opts.useGateway ? '/ai-gateway' : '/ai'));
    this._sitePrefersGateway = opts.useGateway === true || String(requestedUrl).includes('/ai-gateway');
    this.aiRouteByTier = { ...defaultAiRouteByTier(this._sitePrefersGateway), ...(opts.aiRouteByTier || {}) };
    if (this.aiRouteMode === 'gateway') {
      this.aiUrl = this.ctx + '/ai-gateway';
      this.useGateway = true;
    } else if (this.aiRouteMode === 'legacy') {
      this.aiUrl = this.ctx + '/ai';
      this.useGateway = false;
    } else if (this.aiRouteMode === 'tier') {
      this.aiUrl = this.ctx + (this._sitePrefersGateway ? '/ai-gateway' : '/ai');
      this.useGateway = this._sitePrefersGateway;
      this._applyAiRouteForTier(this.userId ? 'free' : 'guest');
    } else {
      this.aiUrl = requestedUrl;
      this.useGateway = opts.useGateway === true || this.aiUrl.includes('/ai-gateway');
    }
    this.billing = opts.billing && opts.billing !== false
      ? {
        ctx: opts.billing.ctx || opts.ctx || '',
        userId: opts.billing.userId ?? opts.userId ?? '',
        enabled: opts.billing.enabled !== false,
      }
      : null;
    this._billingStatus = null;
    this._billingBusy = false;
    this.toolId = opts.toolId || '';
    this.systemPrompt = (opts.systemPrompt || 'You are a helpful assistant.').trim();
    this.title = opts.title || 'AI Assistant';
    this.subtitle = opts.subtitle || 'Follow-up questions remember this conversation.';
    this.placeholder = opts.placeholder || 'Ask a follow-up…';
    this.footerText = opts.footerText
      ?? 'Enter to send · Shift+Enter for newline · Esc to close';
    this.historyTurns = Math.max(1, opts.historyTurns ?? 3);
    this.persistHistory = opts.persistHistory !== false;
    this.resetPatterns = Array.isArray(opts.resetPatterns) ? opts.resetPatterns : DEFAULT_RESET_PATTERNS;
    this.detectIntent = typeof opts.detectIntent === 'function' ? opts.detectIntent : null;
    this.compressTurn = typeof opts.compressTurn === 'function' ? opts.compressTurn : compressOldAssistant;
    this.skipEmptyContext = opts.skipEmptyContext !== false;
    this.seedContext = opts.seedContext || (() => '');
    this.applyUi = opts.applyUi === 'separate' ? 'separate' : 'combined';
    this.getApplyLabel = opts.getApplyLabel;
    this.appliedLabel = opts.appliedLabel ?? 'Applied';
    this.getQuickActions = opts.getQuickActions;
    this.onTurn = opts.onTurn;
    this.onError = opts.onError;
    this.useMarkdown = opts.markdown !== false;
    this.maxInputLength = Math.max(1, opts.maxInputLength ?? 8000);

    const fromLegacy = buildLegacyApplyActions(opts);
    /** @type {ApplyAction[]} */
    this.applyActions = (opts.applyActions?.length ? opts.applyActions : fromLegacy)
      .slice()
      .sort((a, b) => (a.order ?? 0) - (b.order ?? 0));

    this.floating = opts.floating !== false;
    this.persistLayout = opts.persistLayout !== false;
    this.policyControls = opts.policyControls !== false;
    this.policyModeEnabled = opts.modeSelector !== false;
    this.policyFreshContextEnabled = opts.freshContextToggle !== false;
    this.policyContextValidator = opts.contextValidator !== false;
    this.policyConfidenceLabels = opts.confidenceLabels !== false;
    this.policyResetOnContextChange = opts.resetOnContextChange !== false;

    this.instanceId = ++instanceCounter;
    this.storageKey = STORAGE_PREFIX + (this.toolId || 'default').replace(/\//g, '_');
    this.layoutKey = this.storageKey + LAYOUT_SUFFIX;
    this.prefsKey = this.storageKey + PREFS_SUFFIX;
    this.history = this._loadHistory();
    this.layout = this._loadLayout();
    this.prefs = this._loadPrefs();
    this.busy = false;
    this.abortCtrl = null;
    this._previouslyFocused = null;
    this._onWindowResize = null;
    this._lastContextFingerprint = '';
    /** @type {?{ backdrop: HTMLDivElement, modal: HTMLDivElement, header: HTMLElement, messages: HTMLDivElement, quick: HTMLDivElement, input: HTMLTextAreaElement, sendBtn: HTMLButtonElement, collapseBtn: HTMLButtonElement, modeSelect: HTMLSelectElement|null, freshToggle: HTMLInputElement|null }} */
    this._els = null;
  }

  // ─── Lifecycle ─────────────────────────────────────────────────────────────

  mount() {
    if (this._els) return this;

    const titleId = `vca-title-${this.instanceId}`;
    const backdrop = document.createElement('div');
    backdrop.className = 'vca-backdrop';
    if (this.floating) backdrop.dataset.floating = 'true';
    backdrop.setAttribute('role', 'presentation');
    backdrop.innerHTML = `
      <div class="vca-modal" role="dialog" aria-modal="${this.floating ? 'false' : 'true'}" aria-labelledby="${titleId}">
        <header class="vca-header" title="${this.floating ? 'Drag to move' : ''}">
          <div class="vca-header-text">
            <div class="vca-title-row">
              <h3 class="vca-title" id="${titleId}"></h3>
              <span class="vca-tier" data-tier="" hidden></span>
              <button type="button" class="vca-expand-hint" hidden aria-label="Expand assistant">
                <span class="vca-expand-hint-icon" aria-hidden="true">▴</span> Expand
              </button>
            </div>
            <p class="vca-subtitle"></p>
          </div>
          <div class="vca-policy" ${this.policyControls ? '' : 'hidden'}>
            <label class="vca-policy-item" ${this.policyModeEnabled ? '' : 'hidden'}>
              <span>Mode</span>
              <select class="vca-mode" aria-label="Assistant mode">
                <option value="fast">Fast</option>
                <option value="explain">Explain</option>
                <option value="strict">Strict</option>
              </select>
            </label>
            <label class="vca-policy-item" ${this.policyFreshContextEnabled ? '' : 'hidden'}>
              <input type="checkbox" class="vca-fresh-toggle" />
              <span>Fresh context</span>
            </label>
          </div>
          <div class="vca-header-actions">
            <button type="button" class="vca-icon-btn vca-reset" title="New conversation">New</button>
            <button type="button" class="vca-icon-btn vca-collapse" aria-expanded="true" title="Minimize" aria-label="Minimize">−</button>
            <button type="button" class="vca-icon-btn vca-close" aria-label="Close" title="Close">&times;</button>
          </div>
        </header>
        <div class="vca-body">
          <div class="vca-messages" role="log" aria-live="polite" aria-atomic="false"></div>
          <div class="vca-quick" role="toolbar" hidden></div>
          <form class="vca-input-row" autocomplete="off">
            <textarea class="vca-input" rows="2" aria-label="Message"></textarea>
            <button type="submit" class="vca-send" data-mode="send">Send</button>
          </form>
          <footer class="vca-footer"></footer>
        </div>
        <div class="vca-resize-handles" aria-hidden="true">
          <div class="vca-resize vca-resize-n" data-dir="n" title="Resize height"></div>
          <div class="vca-resize vca-resize-e" data-dir="e" title="Resize width"></div>
          <div class="vca-resize vca-resize-s" data-dir="s" title="Resize height"></div>
          <div class="vca-resize vca-resize-w" data-dir="w" title="Resize width"></div>
          <div class="vca-resize vca-resize-se" data-dir="se" title="Resize"></div>
        </div>
      </div>`;
    document.body.appendChild(backdrop);

    const $ = (sel) => backdrop.querySelector(sel);
    const modal = $('.vca-modal');
    const header = $('.vca-header');
    const collapseBtn = $('.vca-collapse');
    const modeSelect = $('.vca-mode');
    const freshToggle = $('.vca-fresh-toggle');

    $('.vca-title').textContent = this.title;
    $('.vca-subtitle').textContent = this.subtitle;
    $('.vca-input').placeholder = this.placeholder;
    $('.vca-input').maxLength = this.maxInputLength;
    $('.vca-footer').textContent = this.floating
      ? (this.footerText + ' · Drag header to move · drag edges/corner to resize')
      : this.footerText;

    $('.vca-close').addEventListener('click', () => this.close());
    $('.vca-reset').addEventListener('click', () => this.reset({ notify: true }));
    collapseBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      this.toggleCollapse();
    });
    if (modeSelect) {
      modeSelect.value = this.prefs.mode;
      modeSelect.addEventListener('change', () => {
        this.prefs.mode = modeSelect.value;
        this._savePrefs();
      });
    }
    if (freshToggle) {
      freshToggle.checked = !!this.prefs.freshContext;
      freshToggle.addEventListener('change', () => {
        this.prefs.freshContext = !!freshToggle.checked;
        this._savePrefs();
      });
    }

    if (!this.floating) {
      backdrop.addEventListener('mousedown', (e) => { if (e.target === backdrop) this.close(); });
    }
    $('.vca-input-row').addEventListener('submit', (e) => {
      e.preventDefault();
      if (this.busy) this.stop();
      else this._send();
    });

    const input = $('.vca-input');
    input.addEventListener('keydown', (e) => this._onInputKey(e));
    input.addEventListener('input', () => this._autoResize(input));
    backdrop.addEventListener('keydown', (e) => this._trapFocus(e));

    const bodyEl = $('.vca-body');
    const messages = $('.vca-messages');
    let billingBar = null;
    if (this.billing?.enabled) {
      billingBar = document.createElement('div');
      billingBar.className = 'vca-billing-bar';
      billingBar.hidden = true;
      billingBar.setAttribute('role', 'region');
      billingBar.setAttribute('aria-label', 'Subscription');
      bodyEl.insertBefore(billingBar, messages);
      billingBar.addEventListener('click', (e) => this._onBillingClick(e));
    }

    this._els = {
      backdrop,
      modal,
      header,
      tier: $('.vca-tier'),
      expandHint: $('.vca-expand-hint'),
      billingBar,
      messages,
      quick: $('.vca-quick'),
      input,
      sendBtn: $('.vca-send'),
      collapseBtn,
      modeSelect,
      freshToggle,
    };
    if (this.billing?.enabled) this._setTier('unknown');

    if (this.floating) {
      this._setupDrag();
      this._setupResize();
      this._setupCollapsedExpand();
      this._onWindowResize = () => this._reclampPosition();
      window.addEventListener('resize', this._onWindowResize, { passive: true });
    }
    this._applyLayout();

    this._renderHistory();
    if (this.billing?.enabled) this._refreshBilling();
    return this;
  }

  open(prefill = '', autoSend = false) {
    if (!this._els) this.mount();
    this._previouslyFocused = document.activeElement;
    this._renderQuickActions();
    if (this.billing?.enabled) this._refreshBilling();
    this._els.backdrop.classList.add('open');
    // Reopening always expands the panel for visibility; user can collapse again.
    if (this.layout.collapsed) this.toggleCollapse(false);
    this._reclampPosition();
    if (prefill) {
      this._els.input.value = prefill.slice(0, this.maxInputLength);
      this._autoResize(this._els.input);
    }
    this._els.input.focus();
    if (autoSend && prefill) this._send();
    return this;
  }

  close() {
    if (this.busy && this.abortCtrl) {
      this.abortCtrl.abort();
      this.abortCtrl = null;
    }
    this._els?.backdrop.classList.remove('open');
    if (this._previouslyFocused && typeof this._previouslyFocused.focus === 'function') {
      try { this._previouslyFocused.focus(); } catch { /* noop */ }
    }
  }

  /** Cancel an in-flight stream without closing the modal. */
  stop() {
    if (this.busy && this.abortCtrl) this.abortCtrl.abort();
  }

  /** Clear conversation history. */
  reset({ notify = false } = {}) {
    this.stop();
    this.history = [];
    this._saveHistory();
    if (this._els) {
      this._els.messages.innerHTML = '';
      if (notify) {
        this._renderSystemBubble('Conversation cleared.', { kind: 'info' });
      }
      this._els.input.value = '';
      this._autoResize(this._els.input);
    }
    return this;
  }

  // ─── Storage ───────────────────────────────────────────────────────────────

  _loadHistory() {
    if (!this.persistHistory) return [];
    const candidates = [this.storageKey, ...LEGACY_STORAGE_PREFIXES.map(
      (p) => p + (this.toolId || 'default').replace(/\//g, '_'),
    )];
    for (const key of candidates) {
      try {
        const raw = sessionStorage.getItem(key);
        if (!raw) continue;
        const parsed = JSON.parse(raw);
        if (!Array.isArray(parsed)) continue;
        const filtered = parsed.filter(
          (t) => (t.role === 'user' || t.role === 'assistant')
            && String(t.content ?? '').trim().length > 0,
        );
        if (key !== this.storageKey) {
          try { sessionStorage.removeItem(key); } catch { /* ignore */ }
        }
        return filtered;
      } catch { /* try next */ }
    }
    return [];
  }

  _saveHistory() {
    if (!this.persistHistory) return;
    try {
      sessionStorage.setItem(this.storageKey, JSON.stringify(this.history));
    } catch { /* quota */ }
  }

  _loadPrefs() {
    try {
      const raw = localStorage.getItem(this.prefsKey);
      if (!raw) return { ...DEFAULT_POLICY_PREFS };
      const parsed = JSON.parse(raw);
      return {
        mode: ['fast', 'explain', 'strict'].includes(parsed?.mode) ? parsed.mode : 'fast',
        freshContext: parsed?.freshContext !== false,
      };
    } catch {
      return { ...DEFAULT_POLICY_PREFS };
    }
  }

  _savePrefs() {
    try { localStorage.setItem(this.prefsKey, JSON.stringify(this.prefs)); } catch { /* quota */ }
  }

  // ─── Rendering ─────────────────────────────────────────────────────────────

  _renderQuickActions() {
    const el = this._els?.quick;
    if (!el) return;
    const actions = typeof this.getQuickActions === 'function' ? this.getQuickActions() : [];
    el.innerHTML = '';
    if (!actions.length) { el.hidden = true; return; }
    el.hidden = false;
    for (const a of actions) {
      const btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'vca-quick-btn';
      btn.textContent = a.label;
      btn.addEventListener('click', () => {
        this._els.input.value = (a.prompt || '').slice(0, this.maxInputLength);
        this._autoResize(this._els.input);
        this._els.input.focus();
        if (a.sendImmediately) this._send();
      });
      el.appendChild(btn);
    }
  }

  _renderHistory() {
    if (!this._els) return;
    this._els.messages.innerHTML = '';
    for (const turn of this.history) {
      if (turn.role !== 'user' && turn.role !== 'assistant') continue;
      this._appendBubble(turn.role, turn.content, { streaming: false });
    }
    this._scroll();
  }

  _appendBubble(role, text, { streaming = false } = {}) {
    const bubble = document.createElement('div');
    bubble.className = 'vca-msg ' + role + (streaming ? ' streaming' : '');
    if (streaming) bubble.setAttribute('aria-busy', 'true');

    const body = document.createElement('div');
    body.className = 'vca-msg-body';
    body.textContent = text || '';
    bubble.appendChild(body);

    this._els.messages.appendChild(bubble);
    if (role === 'assistant' && !streaming && text) {
      this._finalizeAssistantBubble(bubble, body, text);
    }
    this._scroll();
    return { bubble, body };
  }

  _renderSystemBubble(text, { kind = 'info', confidence } = {}) {
    const bubble = document.createElement('div');
    const klass = kind === 'error' ? 'is-error' : (kind === 'warn' ? 'is-warn' : 'is-info');
    bubble.className = 'vca-msg system ' + klass;
    bubble.setAttribute('role', kind === 'error' ? 'alert' : 'status');
    bubble.textContent = this.policyConfidenceLabels && confidence
      ? `[${confidence}] ${text}`
      : text;
    this._els.messages.appendChild(bubble);
    this._scroll();
    return bubble;
  }

  _finalizeAssistantBubble(bubble, body, text) {
    bubble.removeAttribute('aria-busy');
    if (this.useMarkdown) {
      body.innerHTML = '';
      body.appendChild(renderMarkdown(text));
    } else {
      body.textContent = text;
    }
    this._maybeApplyButtons(bubble, text);
  }

  // ─── Apply-action UI ───────────────────────────────────────────────────────

  /** @returns {{ action: ApplyAction, payload: any }[]} */
  _collectMatchedActions(text) {
    const matched = [];
    for (const action of this.applyActions) {
      if (typeof action.extract !== 'function' || typeof action.apply !== 'function') continue;
      try {
        const payload = action.extract(text);
        if (payload != null && payload !== '') matched.push({ action, payload });
      } catch (err) {
        // Loud for developers, silent for users.
        console.warn('[ToolAiAssistant] extractor failed:', action.id, err);
      }
    }
    return matched.sort((a, b) => (a.action.order ?? 0) - (b.action.order ?? 0));
  }

  _defaultCombinedLabel(matched) {
    if (matched.length === 1) return matched[0].action.label;
    return matched.map((m) => m.action.label).join(' & ');
  }

  _maybeApplyButtons(msgEl, text) {
    const matched = this._collectMatchedActions(text);
    console.log('[ToolAiAssistant] matched apply actions:',
      matched.map((m) => m.action.id), { available: this.applyActions.map((a) => a.id) });
    if (!matched.length) return;

    if (this.applyUi === 'separate') {
      for (const item of matched) {
        this._renderApplyButton(msgEl, [item], item.action.label);
      }
      return;
    }
    const label = this.getApplyLabel
      ? this.getApplyLabel(matched)
      : this._defaultCombinedLabel(matched);
    this._renderApplyButton(msgEl, matched, label);
  }

  _setApplyButtonLabel(btn, text) {
    const labelEl = btn.querySelector('.vca-apply-label');
    if (labelEl) labelEl.textContent = text;
    else btn.textContent = text;
  }

  _renderApplyButton(msgEl, matched, label) {
    const row = document.createElement('div');
    row.className = 'vca-apply-row';
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'vca-apply-btn';
    btn.innerHTML = '<span class="vca-apply-icon" aria-hidden="true">↓</span><span class="vca-apply-label"></span>';
    btn.querySelector('.vca-apply-label').textContent = label;
    btn.addEventListener('click', async () => {
      const original = label;
      btn.disabled = true;
      this._setApplyButtonLabel(btn, 'Applying…');
      let failedAction = null;
      try {
        for (const { action, payload } of matched) {
          failedAction = action;
          await action.apply(payload);
        }
        failedAction = null;
        this._setApplyButtonLabel(btn, this.appliedLabel);
        const icon = btn.querySelector('.vca-apply-icon');
        if (icon) icon.textContent = '✓';
      } catch (err) {
        console.error('[ToolAiAssistant] apply failed:',
          { actionId: failedAction?.id, err });
        const detail = err?.message || String(err);
        this._renderSystemBubble(
          `Apply failed${failedAction ? ` (${failedAction.id})` : ''}: ${detail}`,
          { kind: 'error', confidence: 'High' },
        );
        this._setApplyButtonLabel(btn, 'Failed — retry');
        btn.disabled = false;
        btn.dataset.failed = '1';
        btn.title = detail;
        setTimeout(() => {
          if (btn.dataset.failed === '1') this._setApplyButtonLabel(btn, original);
        }, 4000);
        return;
      }
      btn.disabled = true;
      btn.classList.add('is-applied');
    });
    row.appendChild(btn);
    msgEl.appendChild(row);
  }

  // ─── Conversation building ─────────────────────────────────────────────────

  /** @returns {'reset'|'continue'} */
  _classifyIntent(userText, history, state) {
    if (this.detectIntent) {
      try {
        const result = this.detectIntent(userText, history, state);
        if (result === 'reset' || result === 'continue') return result;
      } catch { /* fall through */ }
    }
    if (this.resetPatterns.some((re) => re.test(userText))) return 'reset';
    // Implicit reset: prior assistant turn disclaimed an empty context but
    // we now have real context — those replies are stale and bias the model.
    if (state && !isEffectivelyEmptyContext(state)) {
      for (let i = history.length - 1; i >= 0; i -= 1) {
        const turn = history[i];
        if (turn.role !== 'assistant') continue;
        if (STALE_DISCLAIMER_RE.test(String(turn.content ?? ''))) return 'reset';
        break; // only inspect the most recent assistant turn
      }
    }
    return 'continue';
  }

  /** Snapshot the host's seedContext once and reuse across send/build. */
  _readState() {
    try { return (this.seedContext() || '').trim(); } catch { return ''; }
  }

  _buildMessages(userText, state, forceReset = false) {
    const trimmedUser = String(userText ?? '').trim();
    const msgs = [{ role: 'system', content: this._effectiveSystemPrompt() }];

    const priorHistory = this.history.slice(0, -1);
    const snapshot = state != null ? state : this._readState();
    const intent = forceReset ? 'reset' : this._classifyIntent(trimmedUser, priorHistory, snapshot);
    const freshOnly = this.policyFreshContextEnabled && this.prefs.freshContext;

    if (intent === 'continue' && !freshOnly) {
      msgs.push(...this._packHistory(priorHistory));
    }

    const haveContext = snapshot && !(this.skipEmptyContext && isEffectivelyEmptyContext(snapshot));
    msgs.push({
      role: 'user',
      content: haveContext
        ? `[CURRENT CONTEXT]\n${snapshot}\n\n[USER]\n${trimmedUser}`
        : trimmedUser,
    });
    return msgs;
  }

  _effectiveSystemPrompt() {
    const suffix = MODE_PROMPT_SUFFIX[this.prefs.mode] || '';
    return suffix ? `${this.systemPrompt}\n\n[MODE]\n${suffix}` : this.systemPrompt;
  }

  _contextFingerprint(state) {
    const s = String(state ?? '').trim();
    if (!s) return '';
    const board = (s.match(/Board FQBN:\s*(.+)$/m)?.[1] || '').trim();
    const sketchHead = (s.match(/Sketch \([^)]+\):\n([\s\S]{0,180})/)?.[1] || '').trim();
    return `${board}|${sketchHead.slice(0, 120)}`.toLowerCase();
  }

  /** Window → strip orphans → dedupe → compress old assistant turns. */
  _packHistory(priorHistory) {
    const maxMsgs = this.historyTurns * 2;
    let recent = priorHistory.slice(-maxMsgs);
    while (recent.length && recent[0].role === 'assistant') recent = recent.slice(1);

    const compact = [];
    for (const turn of recent) {
      const prev = compact[compact.length - 1];
      if (prev && prev.role === turn.role && prev.content === turn.content) continue;
      compact.push(turn);
    }

    const ageFromEnd = new Map();
    let seenAssistants = 0;
    for (let i = compact.length - 1; i >= 0; i -= 1) {
      if (compact[i].role === 'assistant') {
        ageFromEnd.set(i, seenAssistants++);
      }
    }

    const out = [];
    for (let i = 0; i < compact.length; i += 1) {
      const turn = compact[i];
      let content = String(turn.content ?? '').trim();
      if (!content) continue;
      if (turn.role !== 'user' && turn.role !== 'assistant') continue;
      if (turn.role === 'assistant') {
        try {
          content = this.compressTurn(content, ageFromEnd.get(i) ?? 0, 'assistant') || content;
        } catch (err) {
          console.warn('[ToolAiAssistant] compressTurn failed:', err);
        }
      } else {
        // Prior user turns may carry their own `[CURRENT CONTEXT]` snapshot
        // (board/sketch/errors at the time the question was asked). Strip
        // those so the freshest context — appended below — is the only one
        // the model sees. Without this, "Explain the current code" after a
        // board switch could anchor to a stale snapshot earlier in history.
        content = stripContextPrefix(content) || content;
      }
      out.push({ role: turn.role, content });
    }
    return out;
  }

  // ─── Sending ───────────────────────────────────────────────────────────────

  async _send() {
    if (!this._els || this.busy) return;
    const text = this._els.input.value.trim();
    if (!text) return;

    this._setBusy(true);
    this._els.input.value = '';
    this._autoResize(this._els.input);

    this.history.push({ role: 'user', content: text });
    this._appendBubble('user', text, { streaming: false });

    const snapshot = this._readState();
    if (!this._lastContextFingerprint) this._lastContextFingerprint = this._contextFingerprint(snapshot);
    const warnings = this.policyContextValidator ? contextWarningsFromState(snapshot) : [];
    if (warnings.length) {
      this._renderSystemBubble(`Context warning: ${warnings[0]}`, { kind: 'info', confidence: 'High' });
    }
    const priorHistory = this.history.slice(0, -1);
    const intent = this._classifyIntent(text, priorHistory, snapshot);
    const fp = this._contextFingerprint(snapshot);
    const forceReset = this.policyResetOnContextChange
      && this._lastContextFingerprint
      && fp
      && fp !== this._lastContextFingerprint;
    if (intent === 'reset' && this.history.length > 1) {
      // Disambiguate the two reasons for clarity.
      const explicit = this.resetPatterns.some((re) => re.test(text));
      this._renderSystemBubble(
        explicit
          ? 'Starting a fresh conversation for this request.'
          : 'Refreshing — using the latest code/circuit for this turn.',
        { kind: 'info', confidence: 'High' },
      );
    } else if (forceReset && this.history.length > 1) {
      this._renderSystemBubble(
        'Context changed (board/file). Sending a fresh turn with latest state.',
        { kind: 'info', confidence: 'High' },
      );
    }

    const { bubble, body } = this._appendBubble('assistant', '', { streaming: true });
    this.abortCtrl = new AbortController();

    try {
      const full = await streamChat(
        this.aiUrl,
        { messages: this._buildMessages(text, snapshot, forceReset) },
        {
          useGateway: this.useGateway,
          userId: this.userId,
          toolId: this.toolId,
          signal: this.abortCtrl.signal,
          onDelta: (_d, accumulated) => {
            body.textContent = accumulated;
            this._scroll();
          },
        },
      );

      const reply = String(full ?? '').trim();
      bubble.classList.remove('streaming');
      if (!reply) {
        throw new Error('AI returned an empty response. Try again or start a new conversation.');
      }
      this._finalizeAssistantBubble(bubble, body, reply);
      this.history.push({ role: 'assistant', content: reply });
      this._saveHistory();
      this.onTurn?.(text, reply);
    } catch (err) {
      bubble.classList.remove('streaming');
      bubble.removeAttribute('aria-busy');
      if (err?.name === 'AbortError') {
        bubble.remove();
        this.history.pop();
        this._renderSystemBubble('Stopped.', { kind: 'info', confidence: 'High' });
      } else {
        bubble.remove();
        this.history.pop();
        const upsell = this._isQuotaExceeded(err) || this._isRateLimited(err);
        if (upsell) {
          this._renderSystemBubble(this._formatError(err), { kind: 'warn', confidence: 'High' });
          this._showUpgradePrompt(err);
        } else {
          this._renderSystemBubble(this._formatError(err), { kind: 'error', confidence: 'High' });
        }
        this.onError?.(err);
      }
    } finally {
      this._lastContextFingerprint = fp || this._lastContextFingerprint;
      this.abortCtrl = null;
      this._setBusy(false);
      this._els.input.focus();
    }
  }

  _formatError(err) {
    if (!err) return 'Unknown error.';
    if (this._isRateLimited(err)) {
      const wait = Number(err.retryAfter);
      const when = Number.isFinite(wait) && wait > 0
        ? ` Try again in ${wait}s, or upgrade for instant access.`
        : '';
      return (err.message || 'Rate limit reached.') + when;
    }
    if (this._isQuotaExceeded(err)) {
      return err.message || 'Monthly AI limit reached.';
    }
    const parts = [err.message || String(err)];
    if (err.status) parts.push(`(HTTP ${err.status})`);
    if (err.code) parts.push(`[${err.code}]`);
    return parts.join(' ');
  }

  _isQuotaExceeded(err) {
    return err?.status === 402 || err?.code === 'ai_quota_exceeded';
  }

  _isRateLimited(err) {
    return err?.status === 429 || err?.code === 'rate_limited';
  }

  /** Surface the upgrade card after a quota/rate-limit hit. */
  _showUpgradePrompt(err) {
    if (!this.billing?.enabled || !this._els?.billingBar) return;
    const bar = this._els.billingBar;
    const loggedIn = err?.loggedIn != null
      ? !!err.loggedIn
      : !!(this.billing.userId || this.userId);
    bar.dataset.reason = this._isRateLimited(err) ? 'rate' : 'quota';
    bar.dataset.dismissed = '';
    bar.dataset.state = loggedIn ? 'free' : 'guest';
    bar.hidden = false;
    this._renderBillingBar();
    bar.scrollIntoView?.({ block: 'nearest', behavior: 'smooth' });
  }

  /**
   * Update the Free/Pro/Guest badge in the header.
   * @param {'pro'|'free'|'guest'|'unknown'} tier
   */
  _setTier(tier) {
    const el = this._els?.tier;
    if (el) {
      const labels = { pro: 'Pro', free: 'Free', guest: 'Guest', unknown: '' };
      const titles = {
        pro: 'You are on the Pro plan',
        free: 'Free plan — upgrade for higher AI limits',
        guest: 'Not signed in — sign in or upgrade for more AI',
        unknown: '',
      };
      const label = labels[tier] ?? '';
      el.dataset.tier = tier;
      el.textContent = label;
      el.title = titles[tier] || '';
      el.hidden = !label;
    }
    this._applyAiRouteForTier(tier);
  }

  /**
   * When aiRouteMode is tier, map billing tier → /ai vs /ai-gateway.
   * @param {'pro'|'free'|'guest'|'unknown'} tier
   */
  _applyAiRouteForTier(tier) {
    if (this.aiRouteMode !== 'tier') return;
    const pick = this.aiRouteByTier[tier] || this.aiRouteByTier.unknown || 'legacy';
    const useGateway = pick === 'gateway';
    this.useGateway = useGateway;
    this.aiUrl = this.ctx + (useGateway ? '/ai-gateway' : '/ai');
  }

  async _refreshBilling() {
    if (!this.billing?.enabled || !this._els?.billingBar) return;
    const bar = this._els.billingBar;
    const ctx = this.billing.ctx || this.ctx;
    const loggedIn = !!(this.billing.userId || this.userId);
    const stickyReason = bar.dataset.reason && bar.dataset.reason !== 'idle';
    if (!loggedIn) {
      this._billingStatus = null;
      this._setTier('guest');
      bar.dataset.state = 'guest';
      if (!stickyReason) bar.dataset.reason = 'idle';
      bar.hidden = !stickyReason;
      this._renderBillingBar();
      this._loadPlans();
      return;
    }
    try {
      const status = await fetchBillingStatus(ctx);
      this._billingStatus = status;
      if (status?.is_premium) {
        this._setTier('pro');
        bar.dataset.state = 'pro';
        bar.hidden = true;
      } else {
        this._setTier('free');
        bar.dataset.state = 'free';
        if (!stickyReason) bar.dataset.reason = 'idle';
        bar.hidden = false;
        this._loadPlans();
        // Resume a checkout the user started before signing in.
        const pending = this._consumePendingPlan();
        if (pending) {
          this._renderBillingBar();
          this._startBillingCheckout(pending);
          return;
        }
      }
      this._renderBillingBar();
    } catch {
      // Keep last known tier on transient errors; default to nothing if never set.
      this._setTier('unknown');
      bar.dataset.state = 'unknown';
      if (!stickyReason) bar.dataset.reason = 'idle';
      bar.hidden = false;
      this._renderBillingBar();
    }
  }

  _billingCopy(state, reason) {
    if (state === 'guest') {
      if (reason === 'rate') {
        return { title: 'You hit the free AI limit', sub: 'Sign in for more free requests, or go Pro for the highest limits and no waiting.' };
      }
      if (reason === 'quota') {
        return { title: 'Monthly AI limit reached', sub: 'Sign in for a higher free limit, or upgrade to Pro.' };
      }
      return { title: 'Sign in for more AI', sub: 'A free account unlocks a higher AI limit on Arduino tools.' };
    }
    if (reason === 'rate') {
      return { title: 'You hit the free AI limit', sub: 'Upgrade to Pro for higher limits and no waiting between requests.' };
    }
    if (reason === 'quota') {
      return { title: 'Monthly AI limit reached', sub: 'Upgrade to Pro to keep generating, explaining, and fixing.' };
    }
    return { title: 'Go Pro', sub: 'Higher monthly AI limits and priority access on Arduino tools.' };
  }

  _renderBillingBar() {
    const bar = this._els?.billingBar;
    if (!bar) return;
    const ctx = this.billing.ctx || this.ctx;
    const state = bar.dataset.state || 'unknown';
    const reason = bar.dataset.reason || 'idle';
    const login = loginUrl(ctx);
    const busy = this._billingBusy;

    if (state === 'pro') {
      bar.innerHTML = '';
      bar.hidden = true;
      return;
    }

    const sub = this._billingStatus?.subscription;
    const pending = sub && sub.status && sub.status !== 'active' && sub.status !== 'cancelled';
    const { title, sub: subText } = this._billingCopy(state, reason);
    const dismissBtn = '<button type="button" class="vca-billing-dismiss" data-billing-dismiss aria-label="Dismiss">&times;</button>';

    let actions;
    if (state === 'guest') {
      actions = `
        <a class="vca-billing-btn vca-billing-btn-primary" href="${login}">Sign in with Google</a>
        <button type="button" class="vca-billing-btn vca-billing-btn-ghost" data-billing-action="plans">See Pro plans</button>`;
    } else {
      actions = `
        <button type="button" class="vca-billing-btn vca-billing-btn-primary" data-billing-action="plans" ${busy ? 'disabled' : ''}>
          ${busy ? 'Starting…' : 'View Pro plans'}
        </button>`;
    }

    bar.innerHTML = `
      ${dismissBtn}
      <div class="vca-billing-main">
        <span class="vca-billing-badge">PRO</span>
        <div class="vca-billing-copy">
          <p class="vca-billing-title">${title}</p>
          <p class="vca-billing-sub">${subText}${pending ? ' <em>Payment received — activating shortly.</em>' : ''}</p>
        </div>
      </div>
      <div class="vca-billing-actions">${actions}</div>`;
  }

  async _onBillingClick(e) {
    if (e.target.closest('[data-billing-dismiss]')) {
      e.preventDefault();
      const bar = this._els?.billingBar;
      if (bar) {
        bar.dataset.dismissed = 'true';
        bar.dataset.reason = 'idle';
        bar.hidden = true;
      }
      return;
    }
    if (e.target.closest('[data-billing-action="plans"]')) {
      e.preventDefault();
      await this._openPlanPicker();
      return;
    }
    const btn = e.target.closest('[data-billing-plan]');
    if (!btn || this._billingBusy) return;
    e.preventDefault();
    const plan = btn.getAttribute('data-billing-plan') === 'yearly' ? 'yearly' : 'monthly';
    await this._startBillingCheckout(plan);
  }

  /**
   * Plan metadata for the picker. Source of truth is Go /api/billing/plans
   * (price, tokens, features); opts.billing.plans is fallback only.
   */
  _plansConfig() {
    const cfg = this.billing?.plans || {};
    const fallbackFeatures = Array.isArray(cfg.features) && cfg.features.length
      ? cfg.features
      : [
        'Much higher monthly AI limits',
        'No rate-limit waiting between requests',
        'Priority access on Arduino & other tools',
      ];
    const monthly = {
      name: 'Monthly',
      priceLabel: '',
      cadence: 'Billed monthly · cancel anytime',
      badge: '',
      tokenLabel: '',
      features: fallbackFeatures,
      ...(cfg.monthly || {}),
      ...(this._goPlan('monthly')),
    };
    const yearly = {
      name: 'Yearly',
      priceLabel: '',
      cadence: 'Billed yearly',
      badge: 'Best value',
      tokenLabel: '',
      features: fallbackFeatures,
      ...(cfg.yearly || {}),
      ...(this._goPlan('yearly')),
    };
    if (!monthly.features?.length) monthly.features = fallbackFeatures;
    if (!yearly.features?.length) yearly.features = fallbackFeatures;
    return { monthly, yearly };
  }

  /** Map a Go plan record into picker fields. */
  _goPlan(key) {
    const list = Array.isArray(this._plansCatalog?.plans) ? this._plansCatalog.plans : null;
    if (!list) return {};
    const p = list.find((x) => x && x.key === key);
    if (!p) return {};
    const out = {};
    if (p.name) {
      out.name = String(p.name).replace(/^\s*pro\s+/i, '').trim()
        || (key === 'yearly' ? 'Yearly' : 'Monthly');
    }
    if (p.price_label) out.priceLabel = p.price_label;
    if (p.badge) out.badge = p.badge;
    if (p.cadence) out.cadence = p.cadence;
    if (p.monthly_token_label) out.tokenLabel = p.monthly_token_label;
    if (p.model_id) out.modelId = p.model_id;
    if (Array.isArray(p.features) && p.features.length) out.features = p.features;
    if (p.description) out.description = p.description;
    return out;
  }

  /**
   * Lazily fetch plans from Go once. Stores { plans, ai_tiers } on failure as empty.
   */
  async _loadPlans() {
    const toolId = this.toolId || this.billing?.toolId || '';
    if (this._plansCatalog && this._plansCatalogTool === toolId && this._plansCatalog.plans?.length) {
      return;
    }
    if (this._plansLoading) return;
    this._plansLoading = true;
    try {
      this._plansCatalog = await fetchPlans(this.billing?.ctx || this.ctx, { toolId })
        || { plans: [], ai_tiers: [] };
      this._plansCatalogTool = toolId;
    } catch {
      this._plansCatalog = { plans: [], ai_tiers: [] };
      this._plansCatalogTool = toolId;
    } finally {
      this._plansLoading = false;
    }
  }

  _tierCompareHTML() {
    const tiers = Array.isArray(this._plansCatalog?.ai_tiers)
      ? this._plansCatalog.ai_tiers
      : [];
    if (!tiers.length) return '';
    const rows = tiers.map((t) => {
      const id = String(t.plan_id || '').toLowerCase();
      const isPro = id === 'pro';
      const label = t.token_label
        || (t.monthly_token_limit ? `${Number(t.monthly_token_limit).toLocaleString()} / month` : '');
      const model = t.model_id
        ? `<span class="vca-plans-tier-model">${t.model_id}</span>`
        : '';
      return `
        <div class="vca-plans-tier${isPro ? ' is-pro' : ''}" data-tier="${id}">
          <span class="vca-plans-tier-name">${t.display_name || t.plan_id || ''}</span>
          <span class="vca-plans-tier-tokens">${label}</span>
          ${model}
        </div>`;
    }).join('');
    return `
      <div class="vca-plans-compare" aria-label="AI limits and models by tier">
        <h4 class="vca-plans-compare-title">AI limits &amp; models</h4>
        <div class="vca-plans-tier-grid">${rows}</div>
      </div>`;
  }

  _planCardHTML(plan, info, busy) {
    const price = info.priceLabel
      ? `<span class="vca-plan-price">${info.priceLabel}</span>`
      : '<span class="vca-plan-price vca-plan-price-pending">See checkout</span>';
    const badge = info.badge
      ? `<span class="vca-plan-ribbon">${info.badge}</span>`
      : '';
    const token = info.tokenLabel
      ? `<span class="vca-plan-tokens">${info.tokenLabel}</span>`
      : '';
    const model = info.modelId
      ? `<span class="vca-plan-model">${info.modelId} chat model</span>`
      : '';
    const desc = info.description
      ? `<p class="vca-plan-desc">${info.description}</p>`
      : '';
    const feats = (info.features || []).map((f) => `<li>${f}</li>`).join('');
    return `
      <div class="vca-plan-card" data-plan="${plan}">
        ${badge}
        <div class="vca-plan-head">
          <span class="vca-plan-name">Pro ${info.name}</span>
          ${price}
          ${token}
          ${model}
          <span class="vca-plan-cadence">${info.cadence}</span>
        </div>
        ${desc}
        <ul class="vca-plan-feats">${feats}</ul>
        <button type="button" class="vca-billing-btn vca-billing-btn-primary vca-plan-choose"
                data-billing-plan="${plan}" ${busy ? 'disabled' : ''}>
          ${busy ? 'Starting…' : `Choose ${info.name}`}
        </button>
      </div>`;
  }

  async _openPlanPicker() {
    if (!this._els?.modal) return;
    await this._loadPlans();
    const { monthly, yearly } = this._plansConfig();
    let overlay = this._els.plans;
    if (!overlay) {
      overlay = document.createElement('div');
      overlay.className = 'vca-plans';
      overlay.addEventListener('click', (e) => this._onPlansClick(e));
      overlay.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') { e.stopPropagation(); this._closePlanPicker(); }
      });
      this._els.modal.appendChild(overlay);
      this._els.plans = overlay;
    }
    const loggedIn = !!(this.billing?.userId || this.userId);
    const note = loggedIn
      ? 'Secure checkout via Dodo Payments. Cancel anytime.'
      : 'Pick a plan — you’ll sign in, then go straight to secure checkout.';
    overlay.innerHTML = `
      <div class="vca-plans-sheet" role="dialog" aria-label="Choose a Pro plan">
        <button type="button" class="vca-plans-close" data-plans-close aria-label="Close">&times;</button>
        <h3 class="vca-plans-title">Upgrade to Pro</h3>
        <p class="vca-plans-sub">Higher Pro chat model, more monthly AI tokens, no rate-limit waits.</p>
        <div class="vca-plans-grid">
          ${this._planCardHTML('monthly', monthly, this._billingBusy)}
          ${this._planCardHTML('yearly', yearly, this._billingBusy)}
        </div>
        ${this._tierCompareHTML()}
        <p class="vca-plans-note">${note}</p>
      </div>`;
    overlay.hidden = false;
    overlay.dataset.open = 'true';
    overlay.querySelector('.vca-plans-close')?.focus();
  }

  _closePlanPicker() {
    const overlay = this._els?.plans;
    if (overlay) {
      overlay.hidden = true;
      overlay.dataset.open = '';
    }
  }

  async _onPlansClick(e) {
    if (e.target.closest('[data-plans-close]') || e.target === this._els.plans) {
      e.preventDefault();
      this._closePlanPicker();
      return;
    }
    const choose = e.target.closest('[data-billing-plan]');
    if (!choose || this._billingBusy) return;
    e.preventDefault();
    const plan = choose.getAttribute('data-billing-plan') === 'yearly' ? 'yearly' : 'monthly';
    await this._startBillingCheckout(plan);
  }

  _pendingPlanKey() {
    return 'vca_pending_plan_' + (this.toolId || 'default').replace(/\//g, '_');
  }

  /** Remember the chosen plan so we can resume checkout right after login. */
  _rememberPendingPlan(plan) {
    try {
      localStorage.setItem(this._pendingPlanKey(), JSON.stringify({ plan, ts: Date.now() }));
    } catch { /* ignore */ }
  }

  /** Consume a pending plan saved before a login redirect (valid for 15 min). */
  _consumePendingPlan() {
    try {
      const raw = localStorage.getItem(this._pendingPlanKey());
      if (!raw) return null;
      localStorage.removeItem(this._pendingPlanKey());
      const { plan, ts } = JSON.parse(raw);
      if (!plan || (Date.now() - ts) > 15 * 60 * 1000) return null;
      return plan === 'yearly' ? 'yearly' : 'monthly';
    } catch { return null; }
  }

  async _startBillingCheckout(plan) {
    const ctx = this.billing?.ctx || this.ctx;
    const loggedIn = !!(this.billing?.userId || this.userId);
    if (!loggedIn) {
      // Save selection, sign in, then resume checkout automatically on return.
      this._rememberPendingPlan(plan);
      window.location.href = loginUrl(ctx);
      return;
    }
    this._billingBusy = true;
    this._renderBillingBar();
    if (this._els?.plans && this._els.plans.dataset.open === 'true') this._openPlanPicker();
    try {
      const { checkout_url: url } = await startCheckout(ctx, {
        plan,
        toolId: this.toolId || this.billing?.toolId || '',
      });
      window.location.href = url;
    } catch (err) {
      this._billingBusy = false;
      this._renderBillingBar();
      this._closePlanPicker();
      const msg = err.status === 401
        ? 'Please sign in to upgrade.'
        : (err.message || 'Checkout failed.');
      this._renderSystemBubble(msg, { kind: 'error', confidence: 'High' });
      if (err.status === 401) {
        this._rememberPendingPlan(plan);
        window.location.href = loginUrl(ctx);
      }
    }
  }

  _setBusy(busy) {
    this.busy = busy;
    if (!this._els) return;
    const btn = this._els.sendBtn;
    if (busy) {
      btn.dataset.mode = 'stop';
      btn.textContent = 'Stop';
      btn.setAttribute('aria-label', 'Stop generation');
    } else {
      btn.dataset.mode = 'send';
      btn.textContent = 'Send';
      btn.setAttribute('aria-label', 'Send message');
      btn.disabled = false;
    }
    this._els.input.disabled = false;
  }

  // ─── Input helpers ─────────────────────────────────────────────────────────

  _onInputKey(e) {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      if (this.busy) this.stop();
      else this._send();
      return;
    }
    if (e.key === 'Escape') {
      e.preventDefault();
      this.close();
    }
  }

  _autoResize(el) {
    el.style.height = 'auto';
    el.style.height = Math.min(el.scrollHeight, 160) + 'px';
  }

  _trapFocus(e) {
    if (this.floating) return; // non-blocking panel: let users Tab back to the parent page
    if (e.key !== 'Tab' || !this._els) return;
    const root = this._els.backdrop.querySelector('.vca-modal');
    const focusable = Array.from(root.querySelectorAll(FOCUSABLE_SELECTOR))
      .filter((el) => el.offsetParent !== null);
    if (!focusable.length) return;
    const first = focusable[0];
    const last = focusable[focusable.length - 1];
    if (e.shiftKey && document.activeElement === first) {
      e.preventDefault();
      last.focus();
    } else if (!e.shiftKey && document.activeElement === last) {
      e.preventDefault();
      first.focus();
    }
  }

  // ─── Floating layout (drag + collapse) ─────────────────────────────────────

  /** Toggle the collapsed (minimized) state; persisted. */
  toggleCollapse(force) {
    if (!this._els) return this;
    const next = typeof force === 'boolean' ? force : !this.layout.collapsed;
    this.layout.collapsed = next;
    this._applyLayout();
    this._saveLayout();
    if (!next) {
      // Just expanded — focus input.
      setTimeout(() => this._els?.input.focus(), 0);
    }
    return this;
  }

  _loadLayout() {
    if (!this.persistLayout) return { ...DEFAULT_LAYOUT };
    try {
      const raw = localStorage.getItem(this.layoutKey);
      if (!raw) return { ...DEFAULT_LAYOUT };
      const obj = JSON.parse(raw);
      if (!obj || typeof obj !== 'object') return { ...DEFAULT_LAYOUT };
      return {
        x: Number.isFinite(obj.x) ? obj.x : null,
        y: Number.isFinite(obj.y) ? obj.y : null,
        w: Number.isFinite(obj.w) ? obj.w : null,
        h: Number.isFinite(obj.h) ? obj.h : null,
        collapsed: !!obj.collapsed,
      };
    } catch { return { ...DEFAULT_LAYOUT }; }
  }

  _saveLayout() {
    if (!this.persistLayout) return;
    try { localStorage.setItem(this.layoutKey, JSON.stringify(this.layout)); } catch { /* quota */ }
  }

  _applyLayout() {
    if (!this._els) return;
    const { modal, collapseBtn, header, expandHint } = this._els;
    const collapsed = !!this.layout.collapsed;
    if (this.floating) {
      if (this.layout.x != null && this.layout.y != null) {
        modal.style.left = this.layout.x + 'px';
        modal.style.top = this.layout.y + 'px';
        modal.style.right = 'auto';
        modal.style.bottom = 'auto';
      }
      modal.dataset.collapsed = collapsed ? 'true' : 'false';
      const userSized = !collapsed && (this.layout.w != null || this.layout.h != null);
      modal.dataset.userSized = userSized ? 'true' : 'false';
      if (userSized) {
        if (this.layout.w != null) modal.style.width = this.layout.w + 'px';
        if (this.layout.h != null) modal.style.height = this.layout.h + 'px';
      } else if (!collapsed) {
        modal.style.width = '';
        modal.style.height = '';
      } else {
        modal.style.width = '';
        modal.style.height = '';
      }
    }
    if (header) {
      if (this.floating && collapsed) {
        header.title = 'Click or hover to expand · drag header to move';
      } else {
        header.title = this.floating ? 'Drag to move · drag edges/corner to resize' : '';
      }
    }
    if (expandHint) {
      expandHint.hidden = !(this.floating && this.layout.collapsed);
    }
    if (collapseBtn) {
      const collapsed = !!this.layout.collapsed;
      collapseBtn.setAttribute('aria-expanded', String(!collapsed));
      collapseBtn.textContent = collapsed ? '+' : '−';
      collapseBtn.title = collapsed ? 'Expand' : 'Minimize';
      collapseBtn.setAttribute('aria-label', collapseBtn.title);
    }
  }

  _reclampPosition() {
    if (!this._els || !this.floating) return;
    const { modal } = this._els;
    const collapsed = !!this.layout.collapsed;
    const maxW = Math.max(PANEL_MIN_W, window.innerWidth - 8);
    const maxH = Math.max(PANEL_MIN_H, window.innerHeight - 8);

    if (!collapsed && (this.layout.w != null || this.layout.h != null)) {
      let w = this.layout.w ?? modal.offsetWidth;
      let h = this.layout.h ?? modal.offsetHeight;
      w = Math.min(maxW, Math.max(PANEL_MIN_W, w));
      h = Math.min(maxH, Math.max(PANEL_MIN_H, h));
      this.layout.w = w;
      this.layout.h = h;
      modal.style.width = w + 'px';
      modal.style.height = h + 'px';
    }

    if (this.layout.x == null || this.layout.y == null) return;
    const width = modal.offsetWidth;
    const height = modal.offsetHeight;
    const maxLeft = Math.max(0, window.innerWidth - width);
    const maxTop = Math.max(0, window.innerHeight - Math.min(height, 80));
    const nx = Math.min(maxLeft, Math.max(0, this.layout.x));
    const ny = Math.min(maxTop, Math.max(0, this.layout.y));
    if (nx !== this.layout.x || ny !== this.layout.y) {
      this.layout.x = nx;
      this.layout.y = ny;
      modal.style.left = nx + 'px';
      modal.style.top = ny + 'px';
      this._saveLayout();
    }
  }

  /** Pin modal to left/top before drag or resize (from default bottom/right anchor). */
  _ensureLayoutPosition() {
    if (!this._els || !this.floating) return;
    const { modal } = this._els;
    if (this.layout.x != null && this.layout.y != null) return;
    const rect = modal.getBoundingClientRect();
    this.layout.x = Math.round(rect.left);
    this.layout.y = Math.round(rect.top);
    modal.style.left = this.layout.x + 'px';
    modal.style.top = this.layout.y + 'px';
    modal.style.right = 'auto';
    modal.style.bottom = 'auto';
  }

  _panelSizeLimits() {
    return {
      minW: PANEL_MIN_W,
      minH: PANEL_MIN_H,
      maxW: Math.max(PANEL_MIN_W, window.innerWidth - 8),
      maxH: Math.max(PANEL_MIN_H, window.innerHeight - 8),
    };
  }

  _setupResize() {
    if (!this._els || !this.floating) return;
    const { modal } = this._els;
    modal.querySelectorAll('.vca-resize').forEach((handle) => {
      handle.addEventListener('pointerdown', (e) => {
        if (this.layout.collapsed) return;
        e.preventDefault();
        e.stopPropagation();
        const dir = handle.dataset.dir || 'se';
        this._ensureLayoutPosition();
        const startX = e.clientX;
        const startY = e.clientY;
        const startW = modal.offsetWidth;
        const startH = modal.offsetHeight;
        const startLeft = this.layout.x ?? modal.getBoundingClientRect().left;
        const startTop = this.layout.y ?? modal.getBoundingClientRect().top;
        const pointerId = e.pointerId;
        modal.classList.add('vca-resizing');
        document.body.classList.add('vca-no-select');
        try { handle.setPointerCapture(pointerId); } catch { /* ignore */ }

        const onMove = (ev) => {
          const dx = ev.clientX - startX;
          const dy = ev.clientY - startY;
          const { minW, minH, maxW, maxH } = this._panelSizeLimits();
          let w = startW;
          let h = startH;
          let x = startLeft;
          let y = startTop;

          if (dir === 'e' || dir === 'se') w = startW + dx;
          if (dir === 'w') { w = startW - dx; x = startLeft + dx; }
          if (dir === 's' || dir === 'se') h = startH + dy;
          if (dir === 'n') { h = startH - dy; y = startTop + dy; }

          w = Math.min(maxW, Math.max(minW, w));
          h = Math.min(maxH, Math.max(minH, h));

          if (dir === 'w') x = startLeft + startW - w;
          if (dir === 'n') y = startTop + startH - h;

          x = Math.max(0, Math.min(window.innerWidth - w, x));
          y = Math.max(0, Math.min(window.innerHeight - h, y));

          this.layout.w = Math.round(w);
          this.layout.h = Math.round(h);
          this.layout.x = Math.round(x);
          this.layout.y = Math.round(y);
          this._applyLayout();
        };

        const onUp = () => {
          modal.classList.remove('vca-resizing');
          document.body.classList.remove('vca-no-select');
          try { handle.releasePointerCapture(pointerId); } catch { /* ignore */ }
          handle.removeEventListener('pointermove', onMove);
          handle.removeEventListener('pointerup', onUp);
          handle.removeEventListener('pointercancel', onUp);
          this._saveLayout();
        };

        handle.addEventListener('pointermove', onMove);
        handle.addEventListener('pointerup', onUp);
        handle.addEventListener('pointercancel', onUp);
      });
    });
  }

  _isHeaderInteractiveTarget(target) {
    return !!target?.closest?.(
      'button, .vca-icon-btn, input, textarea, select, option, label, a, .vca-policy',
    );
  }

  /** Reliable click/tap expand when minimized (hover peek alone is CSS-only and temporary). */
  _setupCollapsedExpand() {
    if (!this._els) return;
    const { header, expandHint } = this._els;
    header.addEventListener('click', (e) => {
      if (!this.floating || !this.layout.collapsed) return;
      if (e.target.closest(
        '.vca-expand-hint, button, .vca-icon-btn, input, textarea, select, option, label, a, .vca-policy',
      )) return;
      this.toggleCollapse(false);
    });
    if (expandHint) {
      expandHint.addEventListener('click', (e) => {
        e.stopPropagation();
        if (this.floating && this.layout.collapsed) this.toggleCollapse(false);
      });
    }
  }

  _setupDrag() {
    if (!this._els) return;
    const { header, modal } = this._els;
    let dragging = false;
    let moved = false;
    let startX = 0, startY = 0, startLeft = 0, startTop = 0, pointerId = -1;

    const onDown = (e) => {
      if (e.button !== undefined && e.button !== 0) return;
      if (e.target.closest('.vca-resize')) return;
      // Interactive controls inside header should not initiate drag.
      if (e.target.closest('button, .vca-icon-btn, input, textarea, select, option, label, a, .vca-policy')) return;
      this._ensureLayoutPosition();
      const rect = modal.getBoundingClientRect();
      startX = e.clientX; startY = e.clientY;
      startLeft = rect.left; startTop = rect.top;
      dragging = true;
      moved = false;
      pointerId = e.pointerId;
      try { header.setPointerCapture(pointerId); } catch { /* ignore */ }
      header.classList.add('vca-dragging');
      modal.classList.add('vca-dragging');
      document.body.classList.add('vca-no-select');
      e.preventDefault();
    };
    const onMove = (e) => {
      if (!dragging) return;
      const dx = e.clientX - startX;
      const dy = e.clientY - startY;
      if (Math.abs(dx) > 4 || Math.abs(dy) > 4) moved = true;
      const maxLeft = Math.max(0, window.innerWidth - modal.offsetWidth);
      const maxTop = Math.max(0, window.innerHeight - 60);
      const nx = Math.min(maxLeft, Math.max(0, startLeft + dx));
      const ny = Math.min(maxTop, Math.max(0, startTop + dy));
      modal.style.left = nx + 'px';
      modal.style.top = ny + 'px';
      modal.style.right = 'auto';
      modal.style.bottom = 'auto';
      this.layout.x = nx;
      this.layout.y = ny;
    };
    const onUp = (e) => {
      if (!dragging) return;
      const wasCollapsed = !!this.layout.collapsed;
      dragging = false;
      try { header.releasePointerCapture(pointerId); } catch { /* ignore */ }
      header.classList.remove('vca-dragging');
      modal.classList.remove('vca-dragging');
      document.body.classList.remove('vca-no-select');
      this._saveLayout();
      // Tap/click on minimized bar (not a drag) → persist expand.
      if (!moved && wasCollapsed && e?.target
          && !this._isHeaderInteractiveTarget(e.target)) {
        this.toggleCollapse(false);
      }
    };

    header.addEventListener('pointerdown', onDown);
    header.addEventListener('pointermove', onMove);
    header.addEventListener('pointerup', onUp);
    header.addEventListener('pointercancel', onUp);
  }

  _scroll() {
    const el = this._els?.messages;
    if (!el) return;
    el.scrollTop = el.scrollHeight;
  }
}

/** @deprecated Use ToolAiAssistant. */
export class VibeCodingAssistant extends ToolAiAssistant {}

if (typeof window !== 'undefined') {
  window.ToolAiAssistant = ToolAiAssistant;
  window.VibeCodingAssistant = VibeCodingAssistant;
  window.applyExtractors = applyExtractors;
  window.extractLastFencedBlock = extractLastFencedBlock;
  window.compressOldAssistant = compressOldAssistant;
  window.stripContextPrefix = stripContextPrefix;
  window.renderMarkdown = renderMarkdown;
}
