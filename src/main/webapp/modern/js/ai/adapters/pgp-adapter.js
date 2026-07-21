/**
 * Unified PGP AI adapter — used by both pgpencdec.jsp and pgpkeyfunction.jsp.
 *
 * Both pages now share the same 4-tab UI (Encrypt, Decrypt, Generate Keys, Inspect/Dump)
 * via modern/components/pgp-tool-input-tabs.inc.jsp, so a single assistant config serves both.
 *
 * The chat handler (intent router → plan merge → operation execution) lives here too —
 * any helper module can import handlePgpChatSend if needed.
 */
import { VibeCodingAssistant } from '../assistant-core.js';
import {
  analyzePgpIntent,
  buildClarifyMessage,
  mergePlanWithContext,
  resolveMissingFields,
  scrubAiPlaceholdersFromPlan,
} from '../../pgp/pgp-intent-router.js';
import {
  executePgpPlan,
  buildPgpSeedContext,
  readPgpFormContext,
  buildOperationContext,
  applyUserMessageKeys,
} from '../../pgp/pgp-chat-executor.js';
import {
  applyPendingFallback,
  clearPendingOperation,
  getPendingOperation,
  setPendingOperation,
} from '../../pgp/pgp-pending-op.js';
import { redactPgpForAi, isAiPlaceholderSecret } from '../../pgp/pgp-redact.js';

const EXPLAIN_PROMPT_SUFFIX = `
You help with OpenPGP (RFC 4880) concepts on this page.
For explain-only questions: answer clearly in plain language.
Do NOT output fake keys or ciphertext — operations run separately via the tool API.`;

const PAGE_LAYOUT_NOTE = `This is a single-page PGP tool with four input tabs and one output panel:
  • Encrypt Message — paste plaintext + recipient public key.
  • Decrypt Message — paste PGP message + private key + passphrase.
  • Generate Keys — identity + passphrase + cipher (AES-256 default) + RSA size (2048 default).
  • Inspect / Dump — paste any armored block to see RFC 4880 packet structure.
Output panel has buttons: Copy, Download, Email (sends the encrypted result on the encrypt tab), Share (URL).
When suggesting next steps, name the tab or button by these exact labels.`;

export function createPgpAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;

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
    toolId: 'cryptography/pgp',
    title: 'PGP AI',
    subtitle: 'Say what you want in plain language — generate, encrypt, decrypt, sign, inspect, or ask.',
    placeholder: 'Try: "keys for me@example.com", "encrypt hello with my pubkey", "what is RSA?"',
    footerText: 'Operations use real OpenPGP crypto · private keys never sent to AI',
    historyTurns: 8,
    sanitizeForAi: redactPgpForAi,
    systemPrompt: `You are an expert OpenPGP assistant on an in-browser PGP tool.
Never ask the user to paste private keys into chat. Crypto operations run via the tool API.
${PAGE_LAYOUT_NOTE}
${EXPLAIN_PROMPT_SUFFIX}`,
    seedContext: buildPgpSeedContext,
    getQuickActions: () => [
      { label: 'Generate keys', prompt: 'Generate a 2048-bit RSA PGP key pair for me@example.com with AES-256.', sendImmediately: true },
      { label: 'Encrypt message', prompt: 'Encrypt a message with my public key from this session.', sendImmediately: true },
      { label: 'Decrypt message', prompt: 'Decrypt the PGP message using my session private key — use the form field or the last encrypted message from this chat.', sendImmediately: true },
      { label: 'Sign message', prompt: 'Sign a message with my private key from this session.', sendImmediately: true },
      { label: 'Inspect a key', prompt: 'Dump and analyze my PGP public key from this session — show packet tags, algorithm, key size, and fingerprint.', sendImmediately: true },
      { label: 'How PGP works', prompt: 'Explain how PGP hybrid encryption works in plain English.', sendImmediately: true },
    ],
    onSend: async (userText, ai) => handlePgpChatSend(userText, ai, ctx),
  });

  return assistant;
}

export async function handlePgpChatSend(userText, ai, ctx) {
  const pageSnapshot = buildPgpSeedContext();
  const formContext = readPgpFormContext();
  const priorHistory = ai.history.slice(-10);
  const pendingOp = getPendingOperation();
  const opContext = buildOperationContext(formContext, userText, priorHistory);

  ai.history.push({ role: 'user', content: userText });
  ai._appendBubble('user', userText, { streaming: false });

  const thinking = ai._appendBubble('assistant', 'Analyzing request…', { streaming: true });

  let plan;
  try {
    plan = await analyzePgpIntent(ai, {
      pageSnapshot,
      pendingOp,
      recentChat: priorHistory,
      userText,
    });
    plan = applyPendingFallback(userText, pendingOp, plan);
    plan = scrubAiPlaceholdersFromPlan(plan);
  } catch (err) {
    thinking.bubble.remove();
    removeLastUserTurn(ai);
    return false;
  }

  thinking.bubble.remove();

  plan = applyUserMessageKeys(plan, userText);

  if (isAiPlaceholderSecret(String(userText || '').trim())) {
    pushAssistantReply(
      ai,
      'That text is a **privacy placeholder** from chat — not real key material. '
      + 'Session keys are already loaded in this browser. Paste the **PGP message** block here, '
      + 'or run encryption first and use **Decrypt message** again.',
    );
    return true;
  }

  if (plan.intent === 'explain') {
    clearPendingOperation();
    removeLastUserTurn(ai);
    return false;
  }

  const merged = mergePlanWithContext(plan, opContext);
  const missing = resolveMissingFields(merged);

  if (missing.length) {
    const storeIntent = (merged.intent === 'clarify' || merged.intent === 'explain') && pendingOp?.intent
      ? pendingOp.intent
      : merged.intent;
    setPendingOperation({ ...merged, intent: storeIntent }, missing);
    pushAssistantReply(ai, refineClarifyMessage(merged, missing, opContext));
    return true;
  }

  clearPendingOperation();

  const work = ai._appendBubble('assistant', 'Running PGP operation…', { streaming: true });
  try {
    const result = await executePgpPlan(ctx, merged, opContext);
    work.bubble.remove();
    if (result.handled) {
      pushAssistantReply(ai, result.markdown);
      return true;
    }
    removeLastUserTurn(ai);
    return false;
  } catch (err) {
    work.bubble.remove();
    pushAssistantReply(ai, `**Operation failed:** ${err.message || String(err)}`);
    return true;
  }
}

function refineClarifyMessage(plan, missing, opContext) {
  if (
    plan.intent === 'decrypt'
    && opContext?.hasSessionKeys
    && missing.length === 1
    && missing[0] === 'pgpMessage'
  ) {
    return 'Paste the armored **PGP message** here, or encrypt a message first — the ciphertext will appear in the Decrypt tab automatically.';
  }
  if (
    plan.intent === 'decrypt'
    && opContext?.hasSessionKeys
    && missing.every((m) => m === 'pgpMessage' || m === 'privateKey' || m === 'passphrase')
    && !missing.includes('pgpMessage')
  ) {
    return buildClarifyMessage(plan, missing.filter((m) => m !== 'privateKey' && m !== 'passphrase'));
  }
  return buildClarifyMessage(plan, missing);
}

function removeLastUserTurn(ai) {
  if (ai.history.length && ai.history[ai.history.length - 1].role === 'user') {
    ai.history.pop();
  }
  const msgs = ai._els?.messages;
  const last = msgs?.lastElementChild;
  if (last?.classList.contains('user') && last.classList.contains('vca-msg')) {
    last.remove();
  }
}

function pushAssistantReply(ai, markdown) {
  const { bubble, body } = ai._appendBubble('assistant', '', { streaming: false });
  ai._finalizeAssistantBubble(bubble, body, markdown);
  ai.history.push({ role: 'assistant', content: markdown });
  ai._saveHistory();
  ai._scroll();
  ai.onTurn?.(ai.history[ai.history.length - 2]?.content, markdown);
}
