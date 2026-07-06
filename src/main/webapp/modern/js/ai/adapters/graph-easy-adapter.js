import { VibeCodingAssistant, applyExtractors } from '../assistant-core.js';

const GRAPH_EASY_LANGS = ['graph-easy', 'grapheasy', 'text', ''];

const SYSTEM_PROMPT = `You are a Graph-Easy notation expert for an online ASCII diagram generator.
Use [CURRENT CONTEXT] for the student's existing notation and any render error.

Graph-Easy syntax rules:
- Nodes: [Node Name]
- Directed edge: [A] -> [B]
- Bidirectional: [A] <-> [B]
- Undirected: [A] -- [B]
- Edge label: [A] -> { label: yes; } [B]
- Edge style: [A] -> { style: dashed; } [B]
- Groups: ( Group Name ) with indented child nodes
- Each connection on its own line
- For new or updated diagrams: return ONLY Graph-Easy code in a \`\`\`graph-easy fence.
- For explain/fix requests: prose is fine; include a fenced block when you change the diagram.

Examples:
"simple pipeline: A to B to C"
\`\`\`graph-easy
[ A ] -> [ B ] -> [ C ]
\`\`\`

"microservices with gateway"
\`\`\`graph-easy
( Frontend )
  [ Browser ] -> [ API Gateway ]

( Backend )
  [ API Gateway ] -> [ User Service ]
  [ API Gateway ] -> [ Order Service ]
  [ User Service ] -> [ User DB ]
  [ Order Service ] -> [ Order DB ]
\`\`\``;

function readGraphInput() {
  return (document.getElementById('graphInput')?.value || '').trim();
}

function readRenderError() {
  const out = document.getElementById('graphOutput')?.value || '';
  if (out.startsWith('Error:')) return out.replace(/^Error:\s*/, '').trim();
  const status = document.getElementById('statusText')?.textContent || '';
  if (/^error:/i.test(status)) return status.replace(/^error:\s*/i, '').trim();
  return '';
}

function cleanGraphEasyCode(raw) {
  let text = String(raw || '').trim();
  text = text.replace(/^```[a-z-]*\s*\n?/gim, '').replace(/\n?```\s*$/g, '').trim();
  return text;
}

function extractGraphEasyPayload(text) {
  let raw = applyExtractors.fencedCode(GRAPH_EASY_LANGS, {
    minLength: 8,
    fallbackTest: /\[[^\]]+\][\s\S]*(->|<->|--)/,
  })(text);

  if (!raw) {
    const lines = String(text || '')
      .split('\n')
      .filter((line) => /\[[^\]]+\]/.test(line) && /(->|<->|--)/.test(line));
    if (lines.length) raw = lines.join('\n');
  }

  if (!raw) return null;
  const code = cleanGraphEasyCode(raw);
  return code.length >= 4 ? code : null;
}

/**
 * Floating AI assistant for Graph-Easy (generate / refine / explain diagrams).
 */
export function createGraphEasyAssistant(opts) {
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
    toolId: opts.toolId || 'developer-tools/graph-easy',
    title: 'Graph-Easy AI',
    subtitle: 'Describe diagrams in English — get Graph-Easy notation you can render instantly.',
    placeholder: 'e.g. CI/CD pipeline with build, test, staging deploy, production deploy…',
    footerText: 'Ctrl+Shift+A · Apply to editor · then Render Graph',
    historyTurns: 4,
    systemPrompt: SYSTEM_PROMPT,
    seedContext: () => {
      const parts = [];
      const code = readGraphInput();
      if (code) parts.push(`Current Graph-Easy notation:\n${code}`);
      const err = readRenderError();
      if (err) parts.push(`Last render error:\n${err}`);
      const format = document.getElementById('formatSelect')?.value;
      if (format) parts.push(`Output format: ${format}`);
      return parts.join('\n\n');
    },
    getQuickActions: () => {
      const chip = (label, prompt) => ({ label, prompt, sendImmediately: true });
      const actions = [
        chip('CI/CD', 'CI/CD pipeline: code commit, build, unit tests, integration tests, staging deploy, production deploy'),
        chip('Microservices', 'microservice architecture: API gateway connects to user service, order service, payment service, each has its own database'),
        chip('Git flow', 'git branching: main branch, develop branch, feature branch merges to develop, develop merges to main, hotfix from main'),
        chip('TCP handshake', 'TCP three-way handshake: client sends SYN, server sends SYN-ACK, client sends ACK, connection established'),
        { label: 'Explain', prompt: 'Explain the current Graph-Easy diagram in plain English.', sendImmediately: true },
        { label: 'Improve layout', prompt: 'Improve the current diagram layout and labels. Return the full updated Graph-Easy notation.' },
      ];
      if (readRenderError()) {
        actions.unshift({
          label: 'Fix render error',
          prompt: 'Fix the Graph-Easy notation so it renders without errors. Return the corrected notation only.',
          sendImmediately: true,
        });
      }
      return actions;
    },
    applyActions: [
      {
        id: 'graph-easy',
        order: 1,
        label: 'Apply to editor',
        extract: extractGraphEasyPayload,
        apply: async (code) => {
          if (!code) throw new Error('AI returned no Graph-Easy notation to apply.');
          const ta = document.getElementById('graphInput');
          if (!ta) throw new Error('Graph input not found.');
          ta.value = code;
          ta.dispatchEvent(new Event('input', { bubbles: true }));
          const renderBtn = document.getElementById('renderBtn');
          if (renderBtn && !renderBtn.disabled) renderBtn.click();
        },
      },
    ],
    getApplyLabel: () => 'Apply to editor',
  });
}
