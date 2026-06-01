/**
 * SSH AI adapter — two-stage architecture.
 *
 *   Stage 1: classify intent via ssh-intent-router.js (returns strict JSON plan).
 *   Stage 2: if generate → execute silently via window.sshGenerate; the page renders the keys.
 *            if explain  → fall through to default streaming with SSH_TUTOR_PROMPT
 *                          (which contains NO action contract, so the model can't
 *                          accidentally emit a JSON action block).
 *
 * Mirrors the pgp-adapter pattern (intent router + onSend handler).
 */
import { ToolAiAssistant } from '../assistant-core.js';
import { SSH_TUTOR_PROMPT } from '../../ssh/ssh-tutor-prompt.js';
import { classifySshIntent } from '../../ssh/ssh-intent-router.js';

const VALID_ALGOS = new Set(['ED25519', 'RSA', 'ECDSA', 'DSA']);
const KEYSIZE_BY_ALGO = {
  ED25519: ['256'],
  RSA: ['1024', '2048', '4096'],
  ECDSA: ['256', '384', '521'],
  DSA: ['1024'],
};
const DEFAULT_KEYSIZE = { ED25519: '256', RSA: '2048', ECDSA: '256', DSA: '1024' };

// ─── Seed context (what the model sees about page state) ────────────────────

function readForm() {
  const algo = document.querySelector('input[name="sshalgo"]:checked')?.value || '';
  const keysize = document.getElementById('sshkeysize')?.value || '';
  const comment = document.getElementById('ssh_comment')?.value || '';
  return { algo, keysize, comment };
}

function readPublicMaterial() {
  // Public key + fingerprint only. NEVER reads #privateKeyOutput.
  const pub = document.getElementById('publicKeyOutput')?.value || '';
  const codeEls = document.querySelectorAll('#output code');
  let fp = '';
  for (const el of codeEls) {
    const t = (el.textContent || '').trim();
    if (/^[A-Fa-f0-9:]{20,}$/.test(t) || /^SHA256:/i.test(t)) { fp = t; break; }
  }
  return { pub, fp };
}

function buildSeedContext() {
  const form = readForm();
  const { pub, fp } = readPublicMaterial();
  const parts = [];
  if (form.algo)    parts.push(`Form algorithm: ${form.algo}`);
  if (form.keysize) parts.push(`Form key size: ${form.keysize}`);
  if (form.comment) parts.push(`Form comment/identity: ${form.comment}`);
  if (pub) {
    parts.push(`Public key generated: yes (${pub.length} chars on page — full key NOT sent to AI)`);
    const head = (pub.split(/\s+/).slice(0, 1)[0] || '').slice(0, 16);
    if (head) parts.push(`Public key type prefix: ${head}`);
  } else {
    parts.push('Public key generated: no');
  }
  if (fp) parts.push(`Fingerprint: ${fp}`);
  parts.push('Private key bytes on file: NEVER sent to AI under any circumstance.');
  return parts.join('\n');
}

// ─── Action handling ────────────────────────────────────────────────────────

function applyGenerationConfig(plan) {
  const algo = String(plan?.algorithm || '').toUpperCase();
  if (!VALID_ALGOS.has(algo)) {
    console.warn('[ssh-ai] invalid algorithm', plan?.algorithm);
    return false;
  }
  const allowed = KEYSIZE_BY_ALGO[algo];
  let keysize = String(plan?.keysize || DEFAULT_KEYSIZE[algo]);
  if (!allowed.includes(keysize)) keysize = DEFAULT_KEYSIZE[algo];

  // Toggle the "Also produce .ppk" checkbox before submission.
  const ppkCheckbox = document.getElementById('include_ppk');
  if (ppkCheckbox) {
    ppkCheckbox.checked = plan?.ppk === true;
    ppkCheckbox.dispatchEvent(new Event('change', { bubbles: true }));
  }

  if (typeof window.sshGenerate === 'function') {
    return window.sshGenerate({
      algorithm: algo,
      keysize,
      comment: typeof plan?.comment === 'string' ? plan.comment.trim() : '',
    });
  }
  console.warn('[ssh-ai] window.sshGenerate not found — is sshfunctions.jsp loaded?');
  return false;
}

/** Helper: push a small assistant message into chat without a second LLM call. */
function pushAssistantMessage(ai, markdown) {
  const { bubble, body } = ai._appendBubble('assistant', '', { streaming: false });
  ai._finalizeAssistantBubble(bubble, body, markdown);
  ai.history.push({ role: 'assistant', content: markdown });
  ai._saveHistory();
  ai._scroll();
}

/** Helper: drop the user turn we manually pushed (only used when falling through to streaming). */
function removeLastUserTurn(ai) {
  if (ai.history.length && ai.history[ai.history.length - 1].role === 'user') {
    ai.history.pop();
  }
  const last = ai._els?.messages?.lastElementChild;
  if (last?.classList.contains('user') && last.classList.contains('vca-msg')) {
    last.remove();
  }
}

/**
 * The handler hooked into ToolAiAssistant.onSend.
 * Returning true → we handled this turn, don't stream.
 * Returning false → caller streams a normal reply (using SSH_TUTOR_PROMPT, which has no JSON contract).
 */
async function handleSshTurn(userText, ai) {
  // Push the user bubble + history entry up-front (the core would have done this
  // for us if we returned false, but we need it visible while the router thinks).
  ai.history.push({ role: 'user', content: userText });
  ai._appendBubble('user', userText, { streaming: false });

  const thinking = ai._appendBubble('assistant', 'Thinking…', { streaming: true });

  let plan;
  try {
    plan = await classifySshIntent(ai, userText);
  } catch (err) {
    console.warn('[ssh-ai] router exception:', err);
    plan = { intent: 'explain' };
  }

  thinking.bubble.remove();

  if (plan.intent === 'generate') {
    console.info('[ssh-ai] router → generate:', plan);
    // Execute silently — the page renders the resulting keys in the output column.
    const ok = applyGenerationConfig(plan);
    if (ok) {
      const algoLabel = plan.algorithm + (plan.algorithm === 'ED25519' ? '' : ` ${plan.keysize}`);
      const ppkSuffix = plan.ppk ? ' + .ppk for PuTTY' : '';
      pushAssistantMessage(ai, `Generating **${algoLabel}**${plan.comment ? ` for \`${plan.comment}\`` : ''}${ppkSuffix} — keys will appear in the output panel.`);
    } else {
      pushAssistantMessage(ai, '**Could not trigger key generation.** Check that the page is loaded fully, or click the Generate button manually.');
    }
    return true;  // handled — no further streaming
  }

  // intent === 'explain' → fall through to default streaming.
  // Remove the user-turn artifacts we added above; the core will re-add them.
  removeLastUserTurn(ai);
  return false;
}

// ─── Factory ────────────────────────────────────────────────────────────────

export function createSshAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;

  return new ToolAiAssistant({
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
    toolId: 'security/ssh',
    title: 'SSH AI',
    subtitle: 'SSH tutor — keys, agent, config, port forwarding, GitHub/AWS, troubleshooting.',
    placeholder: 'Try: "generate ED25519 for me@laptop", "multi-account GitHub config", "tunnel postgres through bastion"',
    footerText: 'Keys generated locally · private keys never sent to AI',
    historyTurns: 10,
    systemPrompt: SSH_TUTOR_PROMPT,
    seedContext: buildSeedContext,
    getQuickActions: () => [
      { label: 'Generate ED25519',       prompt: 'Generate an ED25519 SSH key with the comment me@laptop.', sendImmediately: true },
      { label: 'Generate for PuTTY',     prompt: 'Generate an RSA 4096 SSH key for me@windows — I need it as .ppk to use with PuTTY/Pageant.', sendImmediately: true },
      { label: 'Multi-account GitHub',   prompt: 'Show me a ~/.ssh/config for using two GitHub accounts (work + personal) with separate keys.', sendImmediately: true },
      { label: 'ssh-agent setup',        prompt: 'Walk me through setting up ssh-agent and adding my key so I don\'t retype the passphrase.', sendImmediately: true },
      { label: 'Tunnel via bastion',     prompt: 'I need to reach a Postgres instance only accessible from a bastion host. Show me the SSH config + command.', sendImmediately: true },
      { label: 'Harden sshd',            prompt: 'Give me a hardened /etc/ssh/sshd_config that disables password auth and root login, with rationale.', sendImmediately: true },
      { label: 'Permission denied?',     prompt: 'I get "Permission denied (publickey)" when connecting. Walk me through diagnosing it.', sendImmediately: true },
      { label: 'ED25519 vs RSA',         prompt: 'Compare ED25519 vs RSA for SSH — security, compatibility, performance. When would I pick RSA?', sendImmediately: true },
    ],
    onSend: async (userText, ai) => handleSshTurn(userText, ai),
  });
}
