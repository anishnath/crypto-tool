/**
 * RSA AI adapter for rsafunctions.jsp.
 * Chat handler: intent router → plan merge → /api/rsa/* execution.
 */
import { VibeCodingAssistant } from '../assistant-core.js';
import {
  analyzeRsaIntent,
  buildClarifyMessage,
  mergePlanWithContext,
  resolveMissingFields,
  scrubAiPlaceholdersFromPlan,
} from '../../rsa/rsa-intent-router.js';
import {
  executeRsaPlan,
  buildRsaSeedContext,
  readRsaFormContext,
  buildOperationContext,
  applyUserMessageKeys,
} from '../../rsa/rsa-chat-executor.js';
import {
  applyPendingFallback,
  clearPendingOperation,
  getPendingOperation,
  setPendingOperation,
} from '../../rsa/rsa-pending-op.js';
import { redactRsaForAi } from '../../rsa/rsa-redact.js';

const EXPLAIN_PROMPT_SUFFIX = `
You help with RSA cryptography concepts on this page.
For explain-only questions: answer clearly in plain language.
Do NOT output fake keys or ciphertext — operations run separately via the tool API.`;

const PAGE_LAYOUT_NOTE = `This is a single-page RSA tool with operation modes and one output panel:
  • Encrypt — plaintext + public key, outputs Base64 ciphertext.
  • Decrypt — Base64 ciphertext + private key.
  • Sign — message + private key, outputs Base64 signature.
  • Verify — message + public key + Base64 signature.
  • Key size chips: 512, 1024, 2048 (recommended), 4096.
  • Cipher Mode dropdown: OAEP SHA-256 (recommended) or PKCS1 for encrypt/decrypt.
  • New Keys button regenerates the key pair instantly.
Output panel has buttons: Swap, Use for Verify, Share, Copy.
When suggesting next steps, name these exact labels.`;

export function createRsaAssistant(opts) {
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
    toolId: 'cryptography/rsa-functions',
    title: 'RSA AI',
    subtitle: 'Say what you want — generate keys, encrypt, decrypt, sign, verify, or ask.',
    placeholder: 'Try: "generate 2048-bit keys", "encrypt hello with my pubkey", "sign this message"...',
    footerText: 'Operations use real RSA crypto · private keys never sent to AI',
    historyTurns: 8,
    sanitizeForAi: redactRsaForAi,
    systemPrompt: `You are an expert RSA cryptography assistant on an in-browser RSA tool.
Never ask the user to paste private keys into chat. Crypto operations run via the tool API.
${PAGE_LAYOUT_NOTE}
${EXPLAIN_PROMPT_SUFFIX}`,
    seedContext: buildRsaSeedContext,
    getQuickActions: () => [
      { label: 'Generate keys', prompt: 'Generate a 2048-bit RSA key pair.', sendImmediately: true },
      { label: 'Encrypt message', prompt: 'Encrypt a message with my public key from this session.', sendImmediately: true },
      { label: 'Decrypt ciphertext', prompt: 'Decrypt the Base64 ciphertext in the form with my private key from this session.', sendImmediately: true },
      { label: 'Sign message', prompt: 'Sign a message with my private key from this session.', sendImmediately: true },
      { label: 'Verify signature', prompt: 'Verify the signature in the form with my public key from this session.', sendImmediately: true },
      { label: 'How RSA works', prompt: 'Explain how RSA asymmetric encryption works in plain English.', sendImmediately: true },
    ],
    onSend: async (userText, ai) => handleRsaChatSend(userText, ai, ctx),
  });

  return assistant;
}

export async function handleRsaChatSend(userText, ai, ctx) {
  const pageSnapshot = buildRsaSeedContext();
  const formContext = readRsaFormContext();
  const priorHistory = ai.history.slice(-10);
  const pendingOp = getPendingOperation();
  const opContext = buildOperationContext(formContext, userText, priorHistory);

  ai.history.push({ role: 'user', content: userText });
  ai._appendBubble('user', userText, { streaming: false });

  const thinking = ai._appendBubble('assistant', 'Analyzing request…', { streaming: true });

  let plan;
  try {
    plan = await analyzeRsaIntent(ai, {
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

  if (plan.intent === 'explain') {
    clearPendingOperation();
    removeLastUserTurn(ai);
    return false;
  }

  if (plan.intent === 'clarify' && plan.clarify_message) {
    clearPendingOperation();
    pushAssistantReply(ai, plan.clarify_message);
    return true;
  }

  const merged = mergePlanWithContext(plan, opContext);
  const missing = resolveMissingFields(merged);

  if (missing.length) {
    const storeIntent = (merged.intent === 'clarify' || merged.intent === 'explain') && pendingOp?.intent
      ? pendingOp.intent
      : merged.intent;
    setPendingOperation({ ...merged, intent: storeIntent }, missing);
    pushAssistantReply(ai, buildClarifyMessage(merged, missing));
    return true;
  }

  clearPendingOperation();

  const work = ai._appendBubble('assistant', 'Running RSA operation…', { streaming: true });
  try {
    const result = await executeRsaPlan(ctx, merged, opContext);
    work.bubble.remove();
    if (result.handled) {
      pushAssistantReply(ai, result.markdown);
      return true;
    }
    ai.history.pop();
    return false;
  } catch (err) {
    work.bubble.remove();
    pushAssistantReply(ai, `**Operation failed:** ${err.message || String(err)}`);
    return true;
  }
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
