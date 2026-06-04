/**
 * AI assistant for the multi-pane Code Playground (code-playground/index.jsp).
 * Requires window.ppShell from the page (pane snapshot, apply, active pane).
 */
import { VibeCodingAssistant, extractFencedBlocks } from '../assistant-core.js';

const CODE_LANGS = [
  'python', 'py', 'javascript', 'js', 'typescript', 'ts', 'java', 'go', 'golang',
  'cpp', 'c++', 'cxx', 'c', 'rust', 'rs', 'ruby', 'rb', 'php', 'kotlin', 'swift',
];

const LANG_CANON = {
  py: 'python',
  python3: 'python',
  js: 'javascript',
  node: 'javascript',
  ts: 'typescript',
  golang: 'go',
  'c++': 'cpp',
  cxx: 'cpp',
  cc: 'cpp',
  rs: 'rust',
  rb: 'ruby',
};

function canonLang(lang) {
  const k = String(lang || '').trim().toLowerCase();
  if (!k) return '';
  return LANG_CANON[k] || k;
}

function langMentionedInText(t, lang) {
  const name = lang.toLowerCase();
  if (t.includes(name)) return true;
  if (name === 'javascript' && /\b(javascript|js|node)\b/.test(t)) return true;
  if (name === 'python' && /\b(python|py)\b/.test(t)) return true;
  if (name === 'cpp' && /\b(c\+\+|cpp)\b/.test(t)) return true;
  if (name === 'typescript' && /\b(typescript|ts)\b/.test(t)) return true;
  if (name === 'go' && /\b(go|golang)\b/.test(t)) return true;
  if (name === 'ruby' && /\b(ruby|rb)\b/.test(t)) return true;
  if (name === 'rust' && /\b(rust|rs)\b/.test(t)) return true;
  return false;
}

function inferTargetLangs(userText, panes, activePaneId) {
  const t = String(userText || '').toLowerCase();
  const langs = panes.map((p) => p.lang);
  if (!langs.length) return [];

  if (/\b(all|both|every|each)\b/.test(t)
    && /\b(pane|panes|side|sides|language|languages|editors?)\b/.test(t)) {
    return [...langs];
  }

  const mentioned = langs.filter((lang) => langMentionedInText(t, lang));
  if (mentioned.length) return mentioned;

  if (/\b(only|just)\b/.test(t)) {
    const scoped = langs.filter((lang) => langMentionedInText(t, lang));
    if (scoped.length) return scoped;
  }

  if (/\b(active|current|focused|this)\s*(pane|editor|side)?\b/.test(t)
    || /\b(in|on)\s+(the\s+)?(active|left|right|first|second)\s+(pane|side|editor)\b/.test(t)) {
    const active = panes.find((p) => p.id === activePaneId);
    if (active) return [active.lang];
  }

  if (langs.length === 1) return langs;

  // Multi-pane generic requests (e.g. "bubble sort") → apply all matching blocks
  return [...langs];
}

function extractPlaygroundPayload(text) {
  const blocks = extractFencedBlocks(text, { langs: CODE_LANGS, minLength: 8 });
  if (!blocks.length) return null;
  const byLang = new Map();
  for (const b of blocks) {
    const lang = canonLang(b.lang);
    if (!lang) continue;
    byLang.set(lang, b.content);
  }
  if (!byLang.size) return null;
  return { kind: 'multi', files: Array.from(byLang.entries()).map(([lang, content]) => ({ lang, content })) };
}

function buildSystemPrompt() {
  return `You are the AI assistant on **Code Playground** at 8gwifi.org — users run multiple programming languages side by side in separate editor panes.

**Layout**
- Each pane has a language (python, javascript, go, java, cpp, rust, ruby, php, typescript, c, …).
- [CURRENT CONTEXT] lists every pane: pane id, language, whether it is **active** (focused), and a code excerpt.
- Users compare implementations across languages in one view.

**Code generation rules**
1. When the user asks for code (examples, algorithms, fixes) without naming a single language:
   - If context shows **one** pane → output one fenced block tagged with that pane's language.
   - If **multiple** panes → output **one fenced block per pane language** (e.g. \`\`\`python then \`\`\`go). Same algorithm unless they ask for language-specific idioms.
2. When they say **only** / **just** one language (e.g. "modify the Python code") → output **only** that language's fenced block. Do not change other panes.
3. When they refer to the **active** pane → only update that pane's language.
4. Use correct fence tags: \`\`\`python, \`\`\`go, \`\`\`javascript, \`\`\`java, \`\`\`cpp, \`\`\`rust, \`\`\`typescript, etc.
5. Return **complete runnable source** for each block — not diffs or "..." placeholders.
6. For explain/compare questions with no code change, answer in prose without fenced code (or use fenced blocks only if showing illustrative snippets).

**Do not** invent pane languages not in context. Prefer the languages listed in [CURRENT CONTEXT].`;
}

function formatSeedContext(snapshot) {
  if (!snapshot?.panes?.length) {
    return 'No editor panes loaded yet.';
  }
  const lines = [
    `Playground: ${snapshot.panes.length} pane(s), layout: ${snapshot.layout || 'columns'}`,
  ];
  for (const p of snapshot.panes) {
    const active = p.id === snapshot.activePaneId ? ' **ACTIVE**' : '';
    const code = String(p.code || '').trim();
    const excerpt = code.length > 6000
      ? code.slice(0, 6000) + '\n… [truncated]'
      : code || '(empty)';
    lines.push('', `--- Pane ${p.index} (${p.lang}) id=${p.id}${active} ---`, excerpt);
  }
  return lines.join('\n');
}

/**
 * @param {object} opts — aiAssistantBoot fields + relies on window.ppShell
 */
export function createCodePlaygroundAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;
  const shell = () => window.ppShell;
  let lastUserPrompt = '';

  const assistant = new VibeCodingAssistant({
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
    floatingCorner: 'left',
    toolId: opts.toolId || 'developer-tools/code-playground',
    title: 'Playground AI',
    subtitle: 'Generate or edit code per pane — respects active pane and language.',
    placeholder: 'e.g. Bubble sort in all panes, or "only update the Python code"',
    footerText: 'Applies code to editor panes · Ctrl+Shift+A',
    historyTurns: 6,
    systemPrompt: buildSystemPrompt(),
    seedContext: () => {
      const snap = shell()?.getSnapshot?.();
      return formatSeedContext(snap);
    },
    getQuickActions: () => [
      { label: 'Bubble sort (all)', prompt: 'Implement bubble sort in every pane language. Use idiomatic code per language.', sendImmediately: true },
      { label: 'Active pane only', prompt: 'Improve and optimize the code in the active pane only. Return one fenced block for that language.', sendImmediately: true },
      { label: 'Explain diff', prompt: 'Explain how the two pane implementations differ — no code changes.', sendImmediately: true },
      { label: 'Add comments', prompt: 'Add clear comments to the code in the active pane only.', sendImmediately: true },
      { label: 'Hello world', prompt: 'Set a hello world program in each pane language.', sendImmediately: true },
    ],
    applyActions: [
      {
        id: 'panes',
        order: 1,
        label: 'Apply code to panes',
        extract: extractPlaygroundPayload,
        apply: (payload) => {
          const pp = shell();
          if (!pp) throw new Error('Playground shell not ready.');
          if (!payload?.files?.length) throw new Error('No language-tagged code blocks in the response.');
          const snap = pp.getSnapshot();
          const targets = inferTargetLangs(lastUserPrompt, snap.panes, snap.activePaneId);
          const filtered = payload.files.filter((f) => {
            const lang = canonLang(f.lang);
            return !targets.length || targets.includes(lang);
          });
          if (!filtered.length) {
            throw new Error('No code blocks matched the requested language(s).');
          }
          const result = pp.applyToPanes(filtered.map((f) => ({
            lang: canonLang(f.lang),
            code: f.content,
          })));
          if (!result?.applied?.length) {
            throw new Error('Could not apply code — no matching panes for those languages.');
          }
          return result;
        },
      },
    ],
    getApplyLabel: (matched) => {
      const m = matched.find((x) => x.action.id === 'panes');
      if (!m?.payload?.files?.length) return 'Apply code to panes';
      const langs = m.payload.files.map((f) => canonLang(f.lang)).filter(Boolean);
      return langs.length > 1 ? `Apply to ${langs.join(', ')}` : `Apply ${langs[0] || 'code'}`;
    },
    onTurn: (userText) => {
      lastUserPrompt = String(userText || '').trim();
      shell()?.refreshPaneCodes?.().catch(() => {});
    },
  });

  const originalOpen = assistant.open.bind(assistant);
  assistant.open = async function open(prefill, autoSend) {
    await shell()?.refreshPaneCodes?.().catch(() => {});
    return originalOpen(prefill, autoSend);
  };

  const originalSend = assistant._send.bind(assistant);
  assistant._send = async function wrappedSend() {
    await shell()?.refreshPaneCodes?.().catch(() => {});
    return originalSend();
  };

  return assistant;
}
