/**
 * AI assistant for latex/editor.jsp.
 * Requires window.latexShell (CodeMirror snapshot + applyLatex).
 * Inline selection popup / diff / per-error fix remain in latex/static/js/ai.js.
 */
import { VibeCodingAssistant, applyExtractors, extractFencedBlocks } from '../assistant-core.js';
import { LATEX_EDITOR_CHAT_PROMPT } from '../latex-editor-ai-prompt.js';

const LATEX_LANGS = ['latex', 'tex'];

function extractLatexBlock(text) {
  const blocks = extractFencedBlocks(text, { langs: LATEX_LANGS, minLength: 4 });
  if (blocks.length) return blocks[blocks.length - 1].content.trim();
  const fallback = applyExtractors.fencedCode(LATEX_LANGS, { minLength: 4 })(text);
  return fallback?.trim() || null;
}

function formatSeedContext(snap) {
  if (!snap) return '(editor not ready)';
  const lines = [
    `Active file: ${snap.activeFile || 'main.tex'}`,
    `Engine: ${snap.engine || 'pdfLaTeX'}`,
  ];
  if (snap.selection) {
    lines.push('', 'Selected text:', snap.selection.slice(0, 4000));
  }
  const code = String(snap.code || '').trim();
  const cap = 14000;
  lines.push('', 'Document source:', code.length > cap ? `${code.slice(0, cap)}\n… [truncated]` : code || '(empty)');
  if (snap.hasCompileErrors && snap.compileLog) {
    lines.push('', 'Compiler log (errors):', snap.compileLog.slice(0, 8000));
  } else if (snap.compileLog) {
    lines.push('', 'Recent compiler output:', snap.compileLog.slice(0, 2000));
  }
  return lines.join('\n');
}

function buildQuickActions(snap) {
  const actions = [
    {
      label: 'Explain doc',
      prompt: 'Explain the structure and purpose of my LaTeX document. No code changes.',
      sendImmediately: true,
    },
    {
      label: 'Article skeleton',
      prompt: 'Generate a minimal \\documentclass{article} skeleton with title, author, abstract, and one section. Return one latex fenced block.',
      sendImmediately: true,
    },
    {
      label: 'Table template',
      prompt: 'Add a clean 3-column table template suitable for my document. Return one latex fenced block.',
      sendImmediately: true,
    },
    {
      label: 'Math equation',
      prompt: 'Write a well-formatted displayed equation with brief surrounding context. Return one latex fenced block.',
      sendImmediately: true,
    },
  ];
  if (snap?.hasCompileErrors) {
    actions.unshift({
      label: 'Fix compile errors',
      prompt: 'Fix the LaTeX compilation errors shown in context. Return a minimal corrected fragment (or the full selection if selected) in one latex fenced block — remember Apply inserts at cursor when nothing is selected.',
      sendImmediately: true,
    });
  }
  if (snap?.selection) {
    actions.unshift({
      label: 'Improve selection',
      prompt: 'Improve the selected LaTeX (clarity and formatting). Return one latex fenced block with the improved selection only.',
      sendImmediately: true,
    });
  }
  return actions;
}

/**
 * @param {object} opts — aiAssistantBoot fields; uses window.latexShell
 */
export function createLatexEditorAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;
  const shell = () => window.latexShell;

  const assistant = new VibeCodingAssistant({
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
    floatingCorner: 'left',
    toolId: opts.toolId || 'latex/editor',
    title: 'LaTeX AI',
    subtitle: 'Generate, fix, explain — or attach a screenshot to convert it to LaTeX.',
    placeholder: 'e.g. "Fix my compile error", "Add a 3×3 matrix" — or paste an image',
    imageUpload: true,
    footerText: 'Apply inserts at cursor or replaces selection · Ctrl+Shift+A',
    historyTurns: 8,
    contextValidator: false,
    systemPrompt: LATEX_EDITOR_CHAT_PROMPT,
    seedContext: () => {
      shell()?.syncEditor?.();
      return formatSeedContext(shell()?.getSnapshot?.());
    },
    getQuickActions: () => buildQuickActions(shell()?.getSnapshot?.()),
    applyActions: [
      {
        id: 'latex',
        order: 1,
        label: 'Apply to editor',
        extract: extractLatexBlock,
        apply: (payload) => {
          const lx = shell();
          if (!lx) throw new Error('LaTeX editor not ready.');
          const snap = lx.getSnapshot?.();
          const mode = snap?.selection ? 'replace-selection' : 'insert-cursor';
          const result = lx.applyLatex(payload, { mode });
          if (!result?.applied) throw new Error(result?.error || 'Could not apply LaTeX.');
          return result;
        },
      },
    ],
    getApplyLabel: () => {
      const snap = shell()?.getSnapshot?.();
      return snap?.selection ? 'Apply to selection' : 'Insert at cursor';
    },
  });

  const originalOpen = assistant.open.bind(assistant);
  assistant.open = async function open(prefill, autoSend) {
    shell()?.syncEditor?.();
    return originalOpen(prefill, autoSend);
  };

  const originalSend = assistant._send.bind(assistant);
  assistant._send = async function wrappedSend() {
    shell()?.syncEditor?.();
    return originalSend();
  };

  return assistant;
}
