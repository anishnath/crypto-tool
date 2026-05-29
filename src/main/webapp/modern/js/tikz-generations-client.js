import { getAnonymousId } from './llm-client.js';

export const TIKZ_TOOL_ID = 'math/tikz-viewer';
const MAX_PREVIEW_SVG = 24000;

function genHeaders(userId) {
  const headers = {
    'Content-Type': 'application/json',
    'X-Tool-Id': TIKZ_TOOL_ID,
  };
  if (userId) headers['X-User-Id'] = userId;
  else headers['X-Anonymous-Id'] = getAnonymousId();
  return headers;
}

function joinUrl(ctx, path) {
  const base = String(ctx || '').replace(/\/$/, '');
  return base + path;
}

function trimPreviewSvg(previewSvg) {
  let svg = String(previewSvg || '');
  if (svg.length > MAX_PREVIEW_SVG) svg = svg.slice(0, MAX_PREVIEW_SVG);
  return svg;
}

/**
 * Persist an applied TikZ generation. Returns saved id or null.
 */
export async function saveTikzGeneration(ctx, {
  userId = '',
  source = 'ai_apply',
  userPrompt = '',
  title = '',
  tikzCode = '',
  previewSvg = '',
} = {}) {
  const code = String(tikzCode || '').trim();
  if (!code) return null;

  const payload = JSON.stringify({
    source,
    user_prompt: String(userPrompt || '').slice(0, 4000),
    title: String(title || '').slice(0, 200),
    tikz_code: code,
    preview_svg: trimPreviewSvg(previewSvg) || undefined,
  });

  try {
    const res = await fetch(joinUrl(ctx, '/api/tools/tikz/generations'), {
      method: 'POST',
      headers: genHeaders(userId),
      body: payload,
    });
    if (!res.ok) return null;
    const data = await res.json().catch(() => ({}));
    return data.id || null;
  } catch {
    return null;
  }
}

/** Attach SVG preview to a generation saved earlier on apply. */
export async function updateTikzGenerationPreview(ctx, {
  userId = '',
  id = '',
  previewSvg = '',
} = {}) {
  const genId = String(id || '').trim();
  const svg = trimPreviewSvg(previewSvg);
  if (!genId || !svg) return false;

  try {
    const res = await fetch(joinUrl(ctx, '/api/tools/tikz/generations'), {
      method: 'POST',
      headers: genHeaders(userId),
      body: JSON.stringify({ id: genId, preview_svg: svg }),
    });
    return res.ok;
  } catch {
    return false;
  }
}

export async function fetchRecentTikzGenerations(ctx, {
  userId = '',
  mineLimit = 10,
  publicLimit = null,
} = {}) {
  const params = new URLSearchParams();
  params.set('mine_limit', String(mineLimit));
  const pub = publicLimit != null
    ? publicLimit
    : (userId ? 20 : 10);
  params.set('public_limit', String(pub));
  const url = joinUrl(ctx, `/api/tools/tikz/generations/recent?${params}`);
  const res = await fetch(url, { headers: genHeaders(userId) });
  if (!res.ok) return [];
  const data = await res.json().catch(() => ({}));
  return Array.isArray(data.items) ? data.items : [];
}

export function titleFromPrompt(prompt, fallback = 'TikZ diagram') {
  const text = String(prompt || '').trim();
  if (!text) return fallback;
  return text.length > 48 ? text.slice(0, 45) + '…' : text;
}

/** Unique label for recents grid (prompt + timestamp). */
export function uniqueTitleFromPrompt(prompt, fallback = 'TikZ diagram') {
  const base = titleFromPrompt(prompt, fallback);
  const stamp = new Date().toLocaleString(undefined, {
    month: 'short',
    day: 'numeric',
    hour: 'numeric',
    minute: '2-digit',
  });
  const combined = `${base} · ${stamp}`;
  return combined.length > 200 ? combined.slice(0, 197) + '…' : combined;
}

/** Split stored TikZ (may include \\usetikzlibrary preamble) for editor load. */
export function splitStoredTikz(raw) {
  let code = String(raw || '').trim();
  let preamble = '';
  const libs = code.match(/\\usetikzlibrary\{[^}]+\}/g);
  if (libs) {
    preamble = libs.join('\n');
    code = code.replace(/\\usetikzlibrary\{[^}]+\}\s*/g, '').trim();
  }
  return { preamble, code };
}
