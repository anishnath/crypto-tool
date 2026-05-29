/**
 * LlmClient — shared transport for site AI (Ollama /ai or Go gateway /ai-gateway).
 * Handles identity headers (openai-go-api README) and NDJSON streaming.
 *
 * ES module: import { streamChat, getAnonymousId } from '.../llm-client.js'
 * Legacy:     window.LlmClient after script load
 */

const ANON_KEY = 'llm_anonymous_id';

export function getAnonymousId() {
  let id = localStorage.getItem(ANON_KEY);
  if (!id) {
    id = (typeof crypto !== 'undefined' && crypto.randomUUID)
      ? crypto.randomUUID()
      : 'anon-' + Date.now() + '-' + Math.random().toString(36).slice(2, 11);
    localStorage.setItem(ANON_KEY, id);
  }
  return id;
}

/**
 * @param {object} opts
 * @param {boolean} [opts.useGateway]
 * @param {string} [opts.userId]
 * @param {string} [opts.toolId]
 */
export function buildHeaders(opts = {}) {
  const headers = { 'Content-Type': 'application/json' };
  const useGateway = opts.useGateway === true
    || (opts.aiUrl && String(opts.aiUrl).includes('/ai-gateway'));
  if (useGateway) {
    if (opts.userId) {
      headers['X-User-Id'] = opts.userId;
    } else {
      headers['X-Anonymous-Id'] = getAnonymousId();
    }
    if (opts.toolId) headers['X-Tool-Id'] = opts.toolId;
  }
  return headers;
}

/**
 * Stream chat; calls onDelta for each text chunk. Resolves with full text.
 * @param {string} aiUrl - e.g. ctx + '/ai-gateway'
 * @param {object} body - { messages, stream: true, model? }
 * @param {object} opts - headers + signal
 */
export async function streamChat(aiUrl, body, opts = {}) {
  const useGateway = opts.useGateway === true || String(aiUrl).includes('/ai-gateway');
  const res = await fetch(aiUrl, {
    method: 'POST',
    headers: buildHeaders({ ...opts, useGateway, aiUrl }),
    body: JSON.stringify({ ...body, stream: true }),
    signal: opts.signal,
  });

  if (!res.ok) {
    const data = await res.json().catch(() => ({}));
    const err = new Error(data.error || data.hint || `AI request failed (${res.status})`);
    err.status = res.status;
    err.code = data.code;
    err.quota = data.quota;
    err.retryAfter = data.retryAfter ?? data.retry_after;
    err.upgrade = data.upgrade === true;
    err.loggedIn = data.logged_in;
    throw err;
  }

  if (!res.body?.getReader) {
    const data = await res.json();
    const text = data.message?.content || data.content || '';
    opts.onDelta?.(text, text);
    return text;
  }

  const reader = res.body.getReader();
  const decoder = new TextDecoder();
  let buffer = '';
  let accumulated = '';

  const processChunk = async (result) => {
    if (result.done) return accumulated;
    buffer += decoder.decode(result.value, { stream: true });
    const lines = buffer.split('\n');
    buffer = lines.pop();

    for (const line of lines) {
      const trimmed = line.trim();
      if (!trimmed) continue;
      try {
        const obj = JSON.parse(trimmed);
        let delta = '';
        if (obj.message?.content) delta = obj.message.content;
        else if (obj.type === 'content' && typeof obj.delta === 'string') delta = obj.delta;
        else if (typeof obj.delta === 'string') delta = obj.delta;
        else if (typeof obj.response === 'string') delta = obj.response;
        if (delta) {
          accumulated += delta;
          opts.onDelta?.(delta, accumulated);
        }
        if (obj.done === true) return accumulated;
      } catch {
        /* skip malformed line */
      }
    }
    return reader.read().then(processChunk);
  };

  return reader.read().then(processChunk);
}

/** Non-streaming chat. */
export async function chat(aiUrl, body, opts = {}) {
  const useGateway = opts.useGateway === true || String(aiUrl).includes('/ai-gateway');
  const res = await fetch(aiUrl, {
    method: 'POST',
    headers: buildHeaders({ ...opts, useGateway, aiUrl }),
    body: JSON.stringify({ ...body, stream: false }),
    signal: opts.signal,
  });
  const data = await res.json().catch(() => ({}));
  if (!res.ok) {
    const err = new Error(data.error || data.hint || `AI request failed (${res.status})`);
    err.status = res.status;
    err.code = data.code;
    err.quota = data.quota;
    err.retryAfter = data.retryAfter ?? data.retry_after;
    err.upgrade = data.upgrade === true;
    err.loggedIn = data.logged_in;
    throw err;
  }
  return data.message?.content || data.content || '';
}

if (typeof window !== 'undefined') {
  window.LlmClient = { getAnonymousId, buildHeaders, streamChat, chat };
}
