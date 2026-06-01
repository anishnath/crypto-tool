/**
 * Browser client for Tomcat billing proxy routes.
 *   GET  {ctx}/api/billing/status
 *   POST {ctx}/api/dodo/checkout
 */

/** Max wait for read-only billing GETs; avoids blocking page open on slow gateway. */
const BILLING_READ_TIMEOUT_MS = 5000;

function joinUrl(ctx, path) {
  const base = String(ctx || '').replace(/\/$/, '');
  const p = path.startsWith('/') ? path : `/${path}`;
  return `${base}${p}`;
}

/**
 * Strip the servlet context path from an absolute path so the OAuth callback
 * (which re-prepends the context path) does not double it.
 *   ctx="/app", path="/app/electronics/x.jsp" -> "/electronics/x.jsp"
 */
function relativeToContext(ctx, path) {
  const base = String(ctx || '').replace(/\/$/, '');
  let p = String(path || '/');
  if (base && (p === base || p.startsWith(base + '/'))) {
    p = p.slice(base.length) || '/';
  }
  return p.startsWith('/') ? p : `/${p}`;
}

async function fetchWithTimeout(url, init = {}, ms = BILLING_READ_TIMEOUT_MS) {
  const ctrl = new AbortController();
  const timer = setTimeout(() => ctrl.abort(), ms);
  try {
    return await fetch(url, { ...init, signal: ctrl.signal });
  } finally {
    clearTimeout(timer);
  }
}

function loginUrl(ctx, redirectPath) {
  const full = redirectPath
    || (typeof window !== 'undefined' ? window.location.pathname + window.location.search : '/');
  const rel = relativeToContext(ctx, full);
  return `${joinUrl(ctx, '/GoogleOAuthFunctionality')}?action=login&redirect_path=${encodeURIComponent(rel)}`;
}

async function parseJson(res, ctx) {
  const data = await res.json().catch(() => ({}));
  if (!res.ok) {
    const err = new Error(data.error || data.hint || `Request failed (${res.status})`);
    err.status = res.status;
    err.code = data.code;
    err.data = data;
    if (res.status === 401 && data.login_url) {
      const raw = String(data.login_url);
      err.loginUrl = raw.startsWith('http') ? raw : joinUrl(ctx, raw);
    }
    throw err;
  }
  return data;
}

/**
 * @param {string} ctx - servlet context path (e.g. /mywebapp)
 * @returns {Promise<{ is_premium?: boolean, premium_until?: string|null, subscription?: object|null, user_id?: string }|null>}
 * Returns null when not logged in (401).
 */
export async function fetchBillingStatus(ctx) {
  const res = await fetchWithTimeout(joinUrl(ctx, '/api/billing/status'), {
    method: 'GET',
    credentials: 'same-origin',
    headers: { Accept: 'application/json' },
  });
  if (res.status === 401) return null;
  return parseJson(res, ctx);
}

/**
 * Fetch purchasable Pro plans for a tool (per-tool price overrides with global fallback).
 * @param {string} ctx
 * @param {{ toolId?: string }} [opts]
 * @returns {Promise<{plans: Array, ai_tiers: Array, tool_id?: string, pricing_scope?: string}>}
 */
export async function fetchPlans(ctx, opts = {}) {
  const empty = { plans: [], ai_tiers: [] };
  try {
    const toolId = String(opts.toolId || '').trim();
    const qs = toolId ? `?tool=${encodeURIComponent(toolId)}` : '';
    const res = await fetchWithTimeout(joinUrl(ctx, `/api/billing/plans${qs}`), {
      method: 'GET',
      credentials: 'same-origin',
      headers: { Accept: 'application/json' },
    });
    if (!res.ok) return empty;
    const data = await res.json().catch(() => ({}));
    return {
      plans: Array.isArray(data.plans) ? data.plans : [],
      ai_tiers: Array.isArray(data.ai_tiers) ? data.ai_tiers : [],
      tool_id: data.tool_id || toolId || '',
      pricing_scope: data.pricing_scope || 'global',
    };
  } catch {
    return empty;
  }
}

/**
 * @param {string} ctx
 * @param {{ plan?: 'monthly'|'yearly', returnPath?: string }} opts
 */
function withCheckoutFlag(returnPath) {
  const path = returnPath || '/';
  const sep = path.includes('?') ? '&' : '?';
  if (/[?&]checkout=/.test(path)) return path;
  return `${path}${sep}checkout=1`;
}

export async function startCheckout(ctx, opts = {}) {
  const basePath = opts.returnPath
    || (typeof window !== 'undefined' ? window.location.pathname + window.location.search : '/');
  const returnPath = opts.skipCheckoutFlag ? basePath : withCheckoutFlag(basePath);
  // Cancel returns the user to the same page without the success flag.
  const cancelPath = opts.cancelPath || basePath;
  const res = await fetch(joinUrl(ctx, '/api/dodo/checkout'), {
    method: 'POST',
    credentials: 'same-origin',
    headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
    body: JSON.stringify({
      plan: opts.plan === 'yearly' ? 'yearly' : 'monthly',
      tool_id: opts.toolId || '',
      return_path: returnPath,
      cancel_path: cancelPath,
    }),
  });
  const data = await parseJson(res, ctx);
  if (!data.checkout_url) {
    throw new Error('Checkout URL missing from server response');
  }
  return data;
}

export { loginUrl, joinUrl };
