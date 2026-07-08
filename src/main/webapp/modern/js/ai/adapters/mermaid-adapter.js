import { VibeCodingAssistant, applyExtractors } from '../assistant-core.js';

const MERMAID_LANGS = ['mermaid', ''];

const SYSTEM_PROMPT = `You are a Mermaid.js diagram expert for an online diagram generator.
Use [CURRENT CONTEXT] for the student's existing Mermaid code and any render error.

Supported types: flowchart (TD/LR), sequenceDiagram, classDiagram, stateDiagram-v2, gantt, erDiagram, pie, journey, mindmap.

Rules:
- First line must be the diagram type keyword (e.g. flowchart TD)
- Use proper Mermaid syntax with correct indentation
- Flowcharts: --> for arrows, [] for rectangles, {} for decisions
- Sequence: ->> solid, -->> dashed
- Keep diagrams concise but complete (typically 5–15 nodes)
- For new or updated diagrams: return ONLY Mermaid code in a \`\`\`mermaid fence
- For explain/fix requests: prose is fine; include a fenced block when you change the diagram

Example:
"simple login flow"
\`\`\`mermaid
flowchart TD
    A[Login Page] --> B[Enter Credentials]
    B --> C{Valid?}
    C -->|Yes| D[Dashboard]
    C -->|No| E[Error Message]
    E --> B
\`\`\``;

const TYPE_MAP = {
  flowchart: 'flowchart',
  graph: 'flowchart',
  sequencediagram: 'sequence',
  classdiagram: 'class',
  statediagram: 'state',
  gantt: 'gantt',
  erdiagram: 'er',
  pie: 'pie',
  journey: 'journey',
  mindmap: 'mindmap',
};

function readMermaidInput() {
  const ta = document.getElementById('mermaidInput');
  return (ta?.value || '').trim();
}

function readRenderError() {
  const alert = document.getElementById('errorAlert');
  if (alert && alert.style.display !== 'none') {
    return (document.getElementById('errorText')?.textContent || '').trim();
  }
  return '';
}

function readActiveDiagramType() {
  const active = document.querySelector('#typeTabs .tool-tab.active');
  return active?.getAttribute('data-type') || '';
}

function cleanMermaidCode(raw) {
  let text = String(raw || '').trim();
  text = text.replace(/^```(?:mermaid)?\s*\n?/gim, '').replace(/\n?```\s*$/g, '').trim();
  return text;
}

function extractMermaidPayload(text) {
  let raw = applyExtractors.fencedCode(MERMAID_LANGS, {
    minLength: 8,
    fallbackTest: /^(flowchart|graph|sequenceDiagram|classDiagram|stateDiagram|erDiagram|gantt|pie|journey|mindmap)/im,
  })(text);

  if (!raw) {
    const m = /^(flowchart|graph|sequenceDiagram|classDiagram|stateDiagram[\s\S]*|erDiagram|gantt|pie|journey|mindmap)[\s\S]*/im.exec(String(text || '').trim());
    if (m) raw = m[0];
  }

  if (!raw) return null;
  const code = cleanMermaidCode(raw);
  return code.length >= 6 ? code : null;
}

function updateTypeTab(code) {
  const firstLine = String(code || '').split('\n')[0].trim().toLowerCase();
  Object.keys(TYPE_MAP).forEach((key) => {
    if (!firstLine.startsWith(key)) return;
    document.querySelectorAll('#typeTabs .tool-tab').forEach((t) => t.classList.remove('active'));
    const tab = document.querySelector(`#typeTabs .tool-tab[data-type="${TYPE_MAP[key]}"]`);
    if (tab) tab.classList.add('active');
  });
}

/**
 * Floating AI assistant for Mermaid diagram generation.
 */
export function createMermaidAssistant(opts) {
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
    toolId: opts.toolId || 'developer-tools/mermaid',
    title: 'Mermaid AI',
    subtitle: 'Describe diagrams in English — get Mermaid syntax with live preview.',
    placeholder: 'e.g. user login flow with auth check and redirect to dashboard…',
    footerText: 'Ctrl+Shift+A · Apply to editor · live preview updates automatically',
    historyTurns: 4,
    systemPrompt: SYSTEM_PROMPT,
    seedContext: () => {
      const parts = [];
      const code = readMermaidInput();
      if (code) parts.push(`Current Mermaid code:\n${code}`);
      const err = readRenderError();
      if (err) parts.push(`Last render error:\n${err}`);
      const type = readActiveDiagramType();
      if (type) parts.push(`Selected diagram type tab: ${type}`);
      return parts.join('\n\n');
    },
    getQuickActions: () => {
      const chip = (label, prompt) => ({ label, prompt, sendImmediately: true });
      const actions = [
        chip('Signup flow', 'user registration flow: sign up form, validate email, send confirmation, activate account (flowchart)'),
        chip('API sequence', 'REST API sequence: client sends request to API gateway, gateway calls auth service, then backend service responds'),
        chip('E-commerce classes', 'e-commerce class diagram with User, Product, Order, Cart, Payment classes and their relationships'),
        chip('Order states', 'order processing states: new, confirmed, shipped, delivered, cancelled with transitions'),
        chip('Project gantt', 'project timeline: design 2 weeks, development 4 weeks, testing 2 weeks, deployment 1 week'),
        { label: 'Explain', prompt: 'Explain the current Mermaid diagram in plain English.', sendImmediately: true },
        { label: 'Improve layout', prompt: 'Improve the current diagram layout and labels. Return the full updated Mermaid code.' },
      ];
      if (readRenderError()) {
        actions.unshift({
          label: 'Fix render error',
          prompt: 'Fix the Mermaid syntax so it renders without errors. Return the corrected code only.',
          sendImmediately: true,
        });
      }
      return actions;
    },
    applyActions: [
      {
        id: 'mermaid',
        order: 1,
        label: 'Apply to editor',
        extract: extractMermaidPayload,
        apply: async (code) => {
          if (!code) throw new Error('AI returned no Mermaid code to apply.');
          const ta = document.getElementById('mermaidInput');
          if (!ta) throw new Error('Mermaid editor not found.');
          ta.value = code;
          ta.dispatchEvent(new Event('input', { bubbles: true }));
          updateTypeTab(code);
          if (typeof window.renderDiagram === 'function') {
            await window.renderDiagram();
          }
        },
      },
    ],
    getApplyLabel: () => 'Apply to editor',
  });
}
