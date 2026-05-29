import { VibeCodingAssistant, applyExtractors } from '../assistant-core.js';

const TIKZ_LANGS = ['latex', 'tex', 'tikz', ''];

const PROMPT_TEMPLATES = Object.freeze({
  newDiagram: [
    'Create a TikZ diagram for: <describe the diagram>.',
    'Style: clean, readable labels, sensible scale.',
    'Return \\usetikzlibrary{...} lines if needed, then a complete \\begin{tikzpicture}...\\end{tikzpicture} block.',
  ].join('\n'),
  explain: [
    'Explain the current TikZ diagram in plain English.',
    'Cover: shapes, coordinates, styling, and how the pieces relate.',
    'Use ONLY [CURRENT CONTEXT].',
  ].join('\n'),
  improve: [
    'Improve the current TikZ diagram for clarity and layout.',
    'Keep the same meaning; adjust spacing, labels, and styling.',
    'Return the full updated tikzpicture block.',
  ].join('\n'),
});

function formatTikzCode(code) {
  const fmt = typeof window.tikzFormatCode === 'function'
    ? window.tikzFormatCode
    : (c) => String(c || '').trim();
  return fmt(code);
}

function splitTikzPayload(raw) {
  let code = String(raw || '').trim();
  code = code.replace(/^```(?:latex|tex|tikz)?\s*\n?/gm, '').replace(/\n?```\s*$/gm, '').trim();

  let preamble = '';
  const libMatch = code.match(/\\usetikzlibrary\{[^}]+\}/g);
  if (libMatch) {
    preamble = libMatch.join('\n');
    code = code.replace(/\\usetikzlibrary\{[^}]+\}\s*/g, '').trim();
  }

  return { preamble, code: formatTikzCode(code) };
}

function extractTikzPayload(text) {
  let raw = applyExtractors.fencedCode(TIKZ_LANGS, {
    minLength: 10,
    fallbackTest: /\\begin\{tikzpicture\}/,
  })(text);

  if (!raw) {
    const m = /\\begin\{tikzpicture\}[\s\S]*\\end\{tikzpicture\}/.exec(String(text || ''));
    if (m) raw = m[0];
  }
  if (!raw) return null;
  return splitTikzPayload(raw);
}

function readRenderError() {
  const errEl = document.getElementById('errorMessage');
  if (!errEl || errEl.style.display === 'none') return '';
  return String(errEl.textContent || '').trim();
}

/**
 * Floating AI assistant for the TikZ viewer (generate / edit / explain).
 */
export function createTikzViewerAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;
  let lastUserPrompt = '';

  return new VibeCodingAssistant({
    ctx,
    aiUrl,
    useGateway,
    aiRouteMode,
    aiRouteByTier,
    userId,
    billing: {
      enabled: true,
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
    toolId: 'math/tikz-viewer',
    title: 'TikZ AI',
    subtitle: 'Generate, refine, and explain TikZ from your current editor code.',
    placeholder: 'Try: "binary search tree with 7 nodes and labeled edges"...',
    footerText: 'Tip: mention diagram type, labels, colors, and layout constraints',
    historyTurns: 3,
    systemPrompt: `You are an expert LaTeX TikZ author for an online TikZ viewer.
Use ONLY [CURRENT CONTEXT] as the source of truth for existing code and render errors.

Output rules:
- New or updated diagram: return \\usetikzlibrary{...} lines when needed, then ONE complete
  \\begin{tikzpicture}...\\end{tikzpicture} block in a \`\`\`latex fence.
- Do NOT include \\documentclass, \\usepackage{tikz}, \\begin{document}, or markdown commentary outside fences.
- Explain requests: plain text only unless the user explicitly asks for code.
- Prefer TikZJax-compatible constructs (avoid obscure packages).
- If context is incomplete, ask 1–3 targeted questions instead of guessing.`,
    seedContext: () => {
      const editor = window.tikzEditor;
      const ta = document.getElementById('tikzInput');
      const code = (editor?.getValue?.() || ta?.value || '').trim();
      const parts = [];
      if (code) parts.push(`Current TikZ:\n${code}`);
      const err = readRenderError();
      if (err) parts.push(`Last render error:\n${err}`);
      return parts.join('\n\n');
    },
    getQuickActions: () => {
      const actions = [
        { label: 'New diagram', prompt: PROMPT_TEMPLATES.newDiagram },
        { label: 'Explain', prompt: PROMPT_TEMPLATES.explain, sendImmediately: true },
        { label: 'Improve layout', prompt: PROMPT_TEMPLATES.improve },
        { label: 'Prompt tips', prompt: 'Use this structure:\n' + PROMPT_TEMPLATES.newDiagram },
      ];
      if (readRenderError()) {
        actions.unshift({
          label: 'Fix render error',
          prompt: 'Fix the TikZ so it renders without errors. Return the full corrected tikzpicture.',
          sendImmediately: true,
        });
      }
      return actions;
    },
    applyActions: [
      {
        id: 'tikz',
        order: 1,
        label: 'Apply TikZ to editor',
        extract: extractTikzPayload,
        apply: async (payload) => {
          if (!payload?.code) throw new Error('AI returned no TikZ code to apply.');
          const combined = (payload.preamble ? payload.preamble + '\n\n' : '') + payload.code;
          if (typeof opts.recordAppliedGeneration === 'function') {
            await opts.recordAppliedGeneration({
              userPrompt: lastUserPrompt,
              tikzCode: combined,
              source: 'ai_apply',
            });
          }
          if (typeof window.tikzLoadCode === 'function') {
            window.tikzLoadCode(payload.code, payload.preamble || '');
            return;
          }
          const ta = document.getElementById('tikzInput');
          if (ta) ta.value = combined;
          document.getElementById('btn-render')?.click();
        },
      },
    ],
    getApplyLabel: () => 'Apply TikZ to editor',
    onTurn: (userText, reply) => {
      lastUserPrompt = String(userText || '');
      opts.onTurn?.(userText, reply);
    },
    recordAppliedGeneration: opts.recordAppliedGeneration,
  });
}
