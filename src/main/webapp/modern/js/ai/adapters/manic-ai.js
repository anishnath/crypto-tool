import { VibeCodingAssistant, applyExtractors } from '../assistant-core.js';

/*
 * AI assistant adapter for the manic playground (src/main/webapp/manic/).
 * Single-editor tool: chat that understands the manic animation DSL, reads the
 * current file as context, and applies generated code straight into the Monaco
 * editor via the page bridge `window.manicBridge` ({ getCode, setCode, fileName }).
 * Modeled on mermaid-adapter.js.
 */

const MANIC_LANGS = ['manic', ''];

// Concise fallback used only if the authoritative spec can't be fetched.
const FALLBACK_PROMPT = `You write **manic**, a small text DSL for 2D animations that renders to MP4.
Statements are calls: name(args); (one per line, // for comments). Every entity's first arg is a
unique id; put title(...) and canvas(...) first. Common calls: title, canvas, circle, rect, dot,
line, plot, axes, color(id, colorName), show(id, seconds), flash, draw, untraced; loops: for i in 0..N { … }.
For make/generate/update/fix requests, output ONLY valid manic source in a \`\`\`manic fence.`;

// The authoritative generation spec lives in manic/SYSTEM_PROMPT.md, copied to
// webapp/manic/system-prompt.md. Fetch it as text (it contains ``` fences, so a
// file avoids JS-string escaping). Top-level await: the module simply finishes
// loading once the prompt is ready (first AI open waits a beat).
let SYSTEM_PROMPT = FALLBACK_PROMPT;
try {
  const ctx = (window.MANIC && window.MANIC.ctx) || '';
  const res = await fetch(ctx + '/manic/system-prompt.md', { cache: 'no-cache' });
  if (res.ok) {
    const text = (await res.text()).trim();
    if (text) SYSTEM_PROMPT = text;
  }
} catch (e) { /* keep the fallback */ }

function cleanManicCode(raw) {
  return String(raw || '')
    .replace(/^```(?:manic)?\s*\n?/gim, '')
    .replace(/\n?```\s*$/g, '')
    .trim();
}

function extractManicPayload(text) {
  const raw = applyExtractors.fencedCode(MANIC_LANGS, {
    minLength: 6,
    fallbackTest: /^\s*(title|canvas|circle|rect|dot|line|plot|axes|color|show|flash|draw|untraced|for)\b/im,
  })(text);
  if (!raw) return null;
  const code = cleanManicCode(raw);
  return code.length >= 6 ? code : null;
}

function readCode() {
  try { return (window.manicBridge && window.manicBridge.getCode()) || ''; } catch (e) { return ''; }
}
function readFileName() {
  try { return (window.manicBridge && window.manicBridge.fileName()) || ''; } catch (e) { return ''; }
}

/** Floating AI assistant for the manic playground. */
export function createManicAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;

  return new VibeCodingAssistant({
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
        features: [
          'Much higher monthly AI limits',
          'Pro chat model tier',
          'No rate-limit waiting between requests',
        ],
      },
    },
    toolId: opts.toolId || 'developer-tools/manic',
    title: 'manic AI',
    subtitle: 'Describe an animation in English — get manic code, applied to your editor.',
    placeholder: 'e.g. a sine wave being drawn on labeled axes…',
    footerText: 'Ctrl+Shift+A · Apply to editor · then press Render',
    historyTurns: 4,
    systemPrompt: SYSTEM_PROMPT,
    seedContext: () => {
      const code = readCode();
      if (!code) return '';
      const name = readFileName();
      return `Current manic file${name ? ` (${name})` : ''}:\n${code}`;
    },
    getQuickActions: () => {
      const chip = (label, prompt) => ({ label, prompt, sendImmediately: true });
      return [
        chip('Bouncing ball', 'a ball that bounces down and settles, on a 1280x720 canvas'),
        chip('Sine wave', 'draw a sine wave on labeled x/y axes, animating the curve in'),
        chip('Title card', 'an intro title card that fades in a heading and subtitle'),
        chip('Grid of dots', 'a 5x5 grid of dots that appear one row at a time using a for loop'),
        { label: 'Explain', prompt: 'Explain what the current manic code animates, step by step.', sendImmediately: true },
        { label: 'Fix errors', prompt: 'Fix any errors in the current manic code. Return the corrected code only.', sendImmediately: true },
        { label: 'Add a fade-in', prompt: 'Add a smooth fade-in to the current animation. Return the full updated code.' },
      ];
    },
    applyActions: [
      {
        id: 'manic',
        order: 1,
        label: 'Apply to editor',
        extract: extractManicPayload,
        apply: async (code) => {
          if (!code) throw new Error('AI returned no manic code to apply.');
          if (!window.manicBridge || typeof window.manicBridge.setCode !== 'function') {
            throw new Error('manic editor not ready.');
          }
          window.manicBridge.setCode(code);
        },
      },
    ],
    getApplyLabel: () => 'Apply to editor',
  });
}
