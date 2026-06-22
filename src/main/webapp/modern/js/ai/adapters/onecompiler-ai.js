/**
 * AI assistant for onecompiler.jsp and all online-*-compiler wrapper pages.
 * Requires window.ocShell (editor snapshot + applyCode).
 */
import { VibeCodingAssistant, applyExtractors, extractFencedBlocks } from '../assistant-core.js';
import { ONECOMPILER_CHAT_PROMPT } from '../onecompiler-ai-prompt.js';

const CODE_LANGS = [
  'python', 'py', 'java', 'c', 'cpp', 'c++', 'cxx', 'csharp', 'cs', 'javascript', 'js',
  'typescript', 'ts', 'go', 'golang', 'rust', 'rs', 'ruby', 'rb', 'php', 'kotlin', 'kt',
  'swift', 'scala', 'r', 'lua', 'bash', 'shell', 'sh', 'perl', 'pl', 'haskell', 'hs', 'dart',
  'test',
];

const LANG_CANON = {
  py: 'python',
  python3: 'python',
  js: 'javascript',
  node: 'javascript',
  nodejs: 'javascript',
  ts: 'typescript',
  golang: 'go',
  'c++': 'cpp',
  cxx: 'cpp',
  cc: 'cpp',
  cs: 'csharp',
  rs: 'rust',
  rb: 'ruby',
  kt: 'kotlin',
  pl: 'perl',
  hs: 'haskell',
  sh: 'bash',
  shell: 'bash',
};

function canonLang(lang) {
  const k = String(lang || '').trim().toLowerCase();
  if (!k) return '';
  return LANG_CANON[k] || k;
}

function fenceLangForEditor(lang) {
  const c = canonLang(lang);
  if (c === 'bash') return ['bash', 'shell', 'sh'];
  if (c === 'cpp') return ['cpp', 'c++', 'cxx'];
  if (c === 'csharp') return ['csharp', 'cs'];
  if (c === 'javascript') return ['javascript', 'js'];
  if (c === 'typescript') return ['typescript', 'ts'];
  if (c === 'go') return ['go', 'golang'];
  if (c === 'rust') return ['rust', 'rs'];
  if (c === 'ruby') return ['ruby', 'rb'];
  if (c === 'perl') return ['perl', 'pl'];
  if (c === 'haskell') return ['haskell', 'hs'];
  return [c];
}

function extractEditorCode(text, preferredLang) {
  const pref = canonLang(preferredLang);
  const langs = [...new Set([...fenceLangForEditor(pref), ...CODE_LANGS])];
  const blocks = extractFencedBlocks(text, { langs, minLength: 4 });
  if (blocks.length) {
    const matching = blocks.filter((b) => canonLang(b.lang) === pref);
    const pick = (matching.length ? matching : blocks)[
      (matching.length ? matching : blocks).length - 1
    ];
    return pick.content.trim();
  }
  const fallback = applyExtractors.fencedCode(langs, { minLength: 4 })(text);
  return fallback?.trim() || null;
}

function formatSeedContext(snap) {
  if (!snap) return '(editor not ready)';
  const lines = [
    `Language: ${snap.language}${snap.languageVersion ? ` (${snap.languageVersion})` : ''}`,
    `Active file: ${snap.activeFile || 'main'}`,
  ];
  if (snap.compilerArgs) lines.push(`Compiler args: ${snap.compilerArgs}`);
  if (snap.stdin) lines.push(`Stdin:\n${snap.stdin}`);
  if (snap.selection) {
    lines.push('', 'Selected code:', snap.selection);
  }
  const code = String(snap.code || '').trim();
  const cap = 12000;
  lines.push('', 'Editor code:', code.length > cap ? `${code.slice(0, cap)}\n… [truncated]` : code || '(empty)');
  if (snap.files?.length > 1) {
    lines.push('', `Other project files (${snap.files.length - 1}):`,
      snap.files.filter((f) => f.name !== snap.activeFile).map((f) => `- ${f.name}`).join('\n'));
  }
  if (snap.output) {
    lines.push('', `Output${snap.outputIsError ? ' (errors)' : ''}:`, snap.output.slice(0, 8000));
  }
  return lines.join('\n');
}

function buildQuickActions(snap) {
  const lang = snap?.language || 'code';
  const actions = [
    {
      label: 'Hello world',
      prompt: `Write a hello world program in ${lang}. Return one complete fenced \`\`\`${lang} block.`,
      sendImmediately: true,
    },
    {
      label: 'Explain code',
      prompt: 'Explain my current code (and any errors in output). No code changes.',
      sendImmediately: true,
    },
    {
      label: 'Add comments',
      prompt: `Add clear comments to my ${lang} code. Return the full updated source in one fenced block.`,
      sendImmediately: true,
    },
    {
      label: 'Optimize',
      prompt: `Review and optimize my ${lang} code for clarity and performance. Return the improved full source in one fenced block.`,
      sendImmediately: true,
    },
  ];
  if (snap?.outputIsError) {
    actions.unshift({
      label: 'Fix errors',
      prompt: `Fix the compilation/runtime errors in context. Return complete corrected ${lang} source in one fenced block.`,
      sendImmediately: true,
    });
  }
  return actions;
}

/**
 * @param {object} opts — aiAssistantBoot fields; uses window.ocShell
 */
export function createOneCompilerAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;
  const shell = () => window.ocShell;
  let preferredLang = '';

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
    toolId: opts.toolId || 'developer-tools/online-compiler',
    title: 'Compiler AI',
    subtitle: 'Generate, fix, and explain code in your editor.',
    placeholder: 'e.g. "Binary search in Python" or "Fix my compile error"',
    footerText: 'Apply loads code into the editor · Ctrl+Shift+A',
    historyTurns: 8,
    systemPrompt: ONECOMPILER_CHAT_PROMPT,
    seedContext: () => {
      shell()?.syncEditor?.();
      const snap = shell()?.getSnapshot?.();
      preferredLang = snap?.language || preferredLang;
      return formatSeedContext(snap);
    },
    getQuickActions: () => buildQuickActions(shell()?.getSnapshot?.()),
    applyActions: [
      {
        id: 'editor',
        order: 1,
        label: 'Apply to editor',
        extract: (text) => extractEditorCode(text, preferredLang || shell()?.getSnapshot?.()?.language),
        apply: (payload) => {
          const oc = shell();
          if (!oc) throw new Error('Compiler editor not ready.');
          const result = oc.applyCode(payload);
          if (!result?.applied) throw new Error(result?.error || 'Could not apply code.');
          return result;
        },
      },
    ],
    getApplyLabel: (matched) => {
      const m = matched.find((x) => x.action.id === 'editor');
      const lang = preferredLang || shell()?.getSnapshot?.()?.language || 'code';
      return m?.payload ? `Apply ${lang} code to editor` : 'Apply to editor';
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
    preferredLang = shell()?.getSnapshot?.()?.language || preferredLang;
    return originalSend();
  };

  return assistant;
}
