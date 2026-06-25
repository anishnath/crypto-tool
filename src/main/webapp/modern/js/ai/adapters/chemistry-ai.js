/**
 * Shared Chemistry AI — VCA tutor for 8gwifi.org chemistry tools.
 * Each page registers window.chemistryShell (context, chips, tool name).
 */
import { ToolAiAssistant } from '../assistant-core.js';
import { typesetKatexWhenReady } from '../../katex-render.js';
import {
  extractMolecularFormulas,
  formatFormulaApplyLabel,
} from '../chemistry-formula-extract.js';

function getShell() {
  return window.chemistryShell && typeof window.chemistryShell === 'object'
    ? window.chemistryShell
    : {};
}

function getSnapshot() {
  const shell = getShell();
  if (typeof shell.getContext === 'function') return shell.getContext();
  return null;
}

function buildChemistryPrompt(shell) {
  const toolName = shell.toolName || '8gwifi.org Chemistry tools';
  const extra = shell.promptExtra ? `\n${shell.promptExtra}\n` : '';

  return `You are a **patient chemistry tutor** for **${toolName}** on 8gwifi.org.

Use [CURRENT CONTEXT] for the live tool inputs and on-page engine results when present.

**Important:** When the page has a deterministic calculator/engine, you **explain** and teach — do not invent different numbers, structures, or answers than the engine summary unless you clearly say you are giving general theory (before the user ran the tool).

**Never generate structures or calculations:** Do not draw Lewis dot structures, bond diagrams, ASCII molecular layouts, VSEPR shapes, or formal-charge tables. The on-page program generates and renders all structures and numeric results. You interpret and teach from [CURRENT CONTEXT] only. If no engine result is present, explain concepts and direct the student to click Generate/Calculate — do not produce the structure or final numbers yourself.
${extra}
**Do not**
- Replace on-page engines; never claim you recalculated or redrawn the molecule.
- Output step-by-step Lewis drawings, lone-pair placement diagrams, or geometry sketches in chat.

**Math (KaTeX):** use \`$...$\` inline and \`$$...$$\` for display when needed. ASCII formulas like H2O are fine in prose.`;
}

function formatSeedContext(snap, shell) {
  if (typeof shell.formatContext === 'function') return shell.formatContext(snap);
  if (!snap) {
    return '(Enter values in the tool and run Generate/Calculate — then ask about the result.)';
  }
  if (typeof snap === 'string') return snap.slice(0, 6000);
  try {
    return JSON.stringify(snap, null, 2).slice(0, 6000);
  } catch (_) {
    return String(snap).slice(0, 6000);
  }
}

function defaultQuickActions() {
  const chip = (label, prompt) => ({ label, prompt, sendImmediately: true });
  return [
    chip("Don't get it", 'Explain what this tool is showing and what the inputs mean — plain language, no full worked solution yet.'),
    chip('Explain step', 'Walk through the key idea or first step for the current inputs. Tie to the engine result if available.'),
    chip('Exam tip', 'Classroom/CBSE tip: what to write, common mistakes, and how this topic is tested.'),
    chip('Practice problem', 'Suggest one similar practice problem with 1–2 hints — no full worked answer unless I ask.'),
  ];
}

function buildQuickActions(snap, shell) {
  if (typeof shell.getQuickActions === 'function') {
    const actions = shell.getQuickActions(snap);
    if (Array.isArray(actions) && actions.length) return actions;
  }
  return defaultQuickActions();
}

function appendFormulaApplyButtons(bubble, rawText) {
  const shell = getShell();
  if (shell.formulaApplyEnabled === false) return;
  if (typeof shell.applyFormula !== 'function') return;

  const items = extractMolecularFormulas(rawText);
  if (!items.length) return;

  const row = document.createElement('div');
  row.className = 'vca-apply-row vca-apply-row-multi';
  row.setAttribute('role', 'group');
  row.setAttribute('aria-label', 'Apply molecular formulas');

  for (const item of items) {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'vca-apply-btn vca-apply-btn-formula';
    btn.innerHTML = '<span class="vca-apply-icon" aria-hidden="true">↓</span><span class="vca-apply-label"></span>';
    const label = typeof shell.formatFormulaApplyLabel === 'function'
      ? shell.formatFormulaApplyLabel(item)
      : formatFormulaApplyLabel(item);
    btn.querySelector('.vca-apply-label').textContent = label;
    btn.title = `Load ${item.formula} in the editor and run Generate`;

    btn.addEventListener('click', async () => {
      const original = label;
      btn.disabled = true;
      btn.querySelector('.vca-apply-label').textContent = 'Applying…';
      try {
        const result = await shell.applyFormula(item.formula, item.charge, {
          autoGenerate: true,
          name: item.name || '',
        });
        if (result?.applied === false) {
          throw new Error(result.error || 'Could not apply formula.');
        }
        btn.querySelector('.vca-apply-label').textContent = 'Applied ✓';
        btn.classList.add('is-applied');
        const icon = btn.querySelector('.vca-apply-icon');
        if (icon) icon.textContent = '✓';
      } catch (err) {
        console.error('[Chemistry AI] apply formula failed:', err);
        btn.disabled = false;
        btn.querySelector('.vca-apply-label').textContent = original;
        if (typeof window.showToast === 'function') {
          window.showToast(err?.message || 'Could not apply formula', 'error');
        }
      }
    });

    row.appendChild(btn);
  }

  bubble.appendChild(row);
}

/**
 * @param {object} opts — aiAssistantBoot + optional chemistryShell overrides
 */
export function createChemistryAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;
  const shell = () => ({ ...getShell(), ...(opts.chemistryShell || {}) });

  return new ToolAiAssistant({
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
        features: ['Much higher monthly AI limits', 'Pro chat model tier', 'No rate-limit waiting between requests'],
      },
    },
    floatingCorner: 'right',
    toolId: opts.toolId || 'chemistry-ai',
    title: shell().panelTitle || 'Chemistry AI',
    subtitle: shell().subtitle || 'Tutor for chemistry tools',
    placeholder: shell().placeholder || 'Ask about this calculation or concept…',
    footerText: shell().footerText || 'Ctrl+Shift+A · tutor explains; engine computes',
    historyTurns: 8,
    contextValidator: false,
    systemPrompt: buildChemistryPrompt(shell()),
    seedContext: () => formatSeedContext(getSnapshot(), shell()),
    getQuickActions: () => buildQuickActions(getSnapshot(), shell()),
    onAssistantRender: (body, bubble, rawText) => {
      void typesetKatexWhenReady(body);
      if (bubble && rawText) appendFormulaApplyButtons(bubble, rawText);
    },
  });
}

export function installChemistryOpenAI(assistantApi, boot) {
  window.chemistryOpenAI = async function chemistryOpenAI(prefill, autoSend) {
    if (boot?.billing?.requireSignIn && !(boot.userId || '')) {
      if (typeof window.showToast === 'function') window.showToast('Sign in to use AI', 'warning');
    }
    await assistantApi.open(prefill || '', autoSend === true);
  };
}
