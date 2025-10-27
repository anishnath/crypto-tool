// Minimal Cloudflare Worker URL shortener with D1
// Schema (run via wrangler d1 execute):
// CREATE TABLE IF NOT EXISTS urls (
//   id INTEGER PRIMARY KEY AUTOINCREMENT,
//   short_code TEXT UNIQUE NOT NULL,
//   original_url TEXT NOT NULL,
//   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
//   click_count INTEGER DEFAULT 0
// );
// -- Analytics extensions --
// CREATE TABLE IF NOT EXISTS url_daily (
//   short_code TEXT NOT NULL,
//   day TEXT NOT NULL, -- YYYY-MM-DD UTC
//   clicks INTEGER DEFAULT 0,
//   unique_clicks INTEGER DEFAULT 0,
//   PRIMARY KEY (short_code, day)
// );
// CREATE TABLE IF NOT EXISTS url_uniques (
//   short_code TEXT NOT NULL,
//   day TEXT NOT NULL,
//   hash TEXT NOT NULL, -- truncated, salted hash of IP+UA
//   PRIMARY KEY (short_code, day, hash)
// );
// CREATE TABLE IF NOT EXISTS url_countries (
//   short_code TEXT NOT NULL,
//   day TEXT NOT NULL,
//   country TEXT NOT NULL,
//   clicks INTEGER DEFAULT 0,
//   PRIMARY KEY (short_code, day, country)
// );
// CREATE TABLE IF NOT EXISTS url_referrers (
//   short_code TEXT NOT NULL,
//   day TEXT NOT NULL,
//   referrer_host TEXT NOT NULL,
//   clicks INTEGER DEFAULT 0,
//   PRIMARY KEY (short_code, day, referrer_host)
// );

const ALPHABET = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
const CODE_LEN = 7; // 6-8 is fine; default 7

const ALLOWED_ORIGINS = new Set([
  'http://localhost:8080',
  'https://8gwifi.org',
]);

function generateShortCode(length = CODE_LEN) {
  const bytes = new Uint8Array(length);
  crypto.getRandomValues(bytes);
  let out = '';
  for (let i = 0; i < length; i++) {
    // Simple mapping; modulo bias is negligible for 62, acceptable for minimalism
    out += ALPHABET[bytes[i] % ALPHABET.length];
  }
  return out;
}

function isValidHttpUrl(value) {
  try {
    const u = new URL(value);
    return u.protocol === 'http:' || u.protocol === 'https:';
  } catch {
    return false;
  }
}

function isValidShortCode(value) {
  return /^[A-Za-z0-9]{4,12}$/.test(value);
}

function jsonResponse(body, init = {}) {
  return new Response(JSON.stringify(body), {
    headers: { 'content-type': 'application/json; charset=utf-8' },
    ...init,
  });
}

function withCors(resp, origin) {
  try {
    const h = new Headers(resp.headers);
    if (ALLOWED_ORIGINS.has(origin)) {
      h.set('Access-Control-Allow-Origin', origin);
      h.set('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
      h.set('Access-Control-Allow-Headers', 'content-type');
      h.set('Access-Control-Max-Age', '86400');
      h.append('Vary', 'Origin');
    }
    return new Response(resp.body, { status: resp.status, headers: h });
  } catch {
    return resp;
  }
}

let schemaEnsured = false;
async function ensureSchema(env) {
  if (schemaEnsured) return;
  try {
    await env.DB.batch([
      env.DB.prepare('CREATE TABLE IF NOT EXISTS url_daily (short_code TEXT NOT NULL, day TEXT NOT NULL, clicks INTEGER DEFAULT 0, unique_clicks INTEGER DEFAULT 0, PRIMARY KEY (short_code, day))'),
      env.DB.prepare('CREATE TABLE IF NOT EXISTS url_uniques (short_code TEXT NOT NULL, day TEXT NOT NULL, hash TEXT NOT NULL, PRIMARY KEY (short_code, day, hash))'),
      env.DB.prepare('CREATE TABLE IF NOT EXISTS url_countries (short_code TEXT NOT NULL, day TEXT NOT NULL, country TEXT NOT NULL, clicks INTEGER DEFAULT 0, PRIMARY KEY (short_code, day, country))'),
      env.DB.prepare('CREATE TABLE IF NOT EXISTS url_referrers (short_code TEXT NOT NULL, day TEXT NOT NULL, referrer_host TEXT NOT NULL, clicks INTEGER DEFAULT 0, PRIMARY KEY (short_code, day, referrer_host))'),
    ]);
  } catch (e) {
    console.error('Schema ensure error:', e);
  } finally {
    schemaEnsured = true;
  }
}

const te = new TextEncoder();
async function sha256Hex(input) {
  const data = typeof input === 'string' ? te.encode(input) : input;
  const digest = await crypto.subtle.digest('SHA-256', data);
  const bytes = new Uint8Array(digest);
  let hex = '';
  for (let i = 0; i < bytes.length; i++) {
    const h = bytes[i].toString(16).padStart(2, '0');
    hex += h;
  }
  return hex;
}

async function handleShorten(request, env) {
  const origin = new URL(request.url).origin;
  let payload;
  try {
    payload = await request.json();
  } catch {
    return jsonResponse({ error: 'Invalid JSON body' }, { status: 400 });
  }
  const originalUrl = (payload && payload.url && String(payload.url).trim()) || '';
  if (!originalUrl || !isValidHttpUrl(originalUrl)) {
    return jsonResponse({ error: 'Provide a valid http(s) URL in "url"' }, { status: 400 });
  }

  // Try to insert with up to 3 attempts in case of collision
  let shortCode = '';
  for (let attempt = 0; attempt < 3; attempt++) {
    shortCode = generateShortCode();
    try {
      const res = await env.DB
        .prepare('INSERT OR IGNORE INTO urls (short_code, original_url) VALUES (?, ?)')
        .bind(shortCode, originalUrl)
        .run();
      if (res && res.meta && res.meta.changes === 1) {
        const shortUrl = `${origin}/${shortCode}`;
        return jsonResponse({ short_url: shortUrl }, { status: 201 });
      }
      // Likely short_code collision; retry
    } catch (err) {
      console.error('Insert error:', err);
      return jsonResponse({ error: 'Internal error' }, { status: 500 });
    }
  }
  return jsonResponse({ error: 'Failed to generate unique short code' }, { status: 500 });
}

async function handleRedirect(pathname, env, request) {
  const code = pathname.slice(1); // remove leading '/'
  if (!isValidShortCode(code)) return new Response('Not Found', { status: 404 });
  try {
    console.log('redirect code', code, 'method', request.method);
    const row = await env.DB
      .prepare('SELECT original_url FROM urls WHERE short_code = ?')
      .bind(code)
      .first();
    if (!row || !row.original_url) {
      console.log('redirect not found', code);
      return new Response('Not Found', { status: 404 });
    }
    // Count only GET as a click; HEAD should redirect but not count
    if (request.method === 'GET') {
      await ensureSchema(env);
      const now = new Date();
      const day = now.toISOString().slice(0, 10);
      const ip = request.headers.get('cf-connecting-ip') || '';
      const ua = request.headers.get('user-agent') || '';
      const country = (request.cf && request.cf.country) ? String(request.cf.country) : 'XX';
      let refHost = '';
      const ref = request.headers.get('referer') || '';
      try { if (ref) refHost = new URL(ref).hostname || ''; } catch {}

      const salt = env.ANALYTICS_SALT || '';
      // Use salted hash if salt is provided; else skip uniques
      let uniqueHash = '';
      if (salt && (ip || ua)) {
        uniqueHash = (await sha256Hex(`${salt}|${ip}|${ua}`)).slice(0, 16);
      }

      // Update core counters
      try {
        await env.DB.batch([
          env.DB.prepare('UPDATE urls SET click_count = click_count + 1 WHERE short_code = ?').bind(code),
          env.DB.prepare('INSERT INTO url_daily (short_code, day, clicks, unique_clicks) VALUES (?, ?, 1, 0) ON CONFLICT(short_code, day) DO UPDATE SET clicks = url_daily.clicks + 1').bind(code, day),
          env.DB.prepare('INSERT INTO url_countries (short_code, day, country, clicks) VALUES (?, ?, ?, 1) ON CONFLICT(short_code, day, country) DO UPDATE SET clicks = url_countries.clicks + 1').bind(code, day, country),
          ...(refHost ? [env.DB.prepare('INSERT INTO url_referrers (short_code, day, referrer_host, clicks) VALUES (?, ?, ?, 1) ON CONFLICT(short_code, day, referrer_host) DO UPDATE SET clicks = url_referrers.clicks + 1').bind(code, day, refHost)] : []),
        ]);
      } catch (err) {
        console.error('Stats base update error:', err);
      }

      if (uniqueHash) {
        try {
          const res = await env.DB
            .prepare('INSERT OR IGNORE INTO url_uniques (short_code, day, hash) VALUES (?, ?, ?)')
            .bind(code, day, uniqueHash)
            .run();
          if (res && res.meta && res.meta.changes === 1) {
            await env.DB
              .prepare('UPDATE url_daily SET unique_clicks = unique_clicks + 1 WHERE short_code = ? AND day = ?')
              .bind(code, day)
              .run();
          }
        } catch (err) {
          console.error('Unique insert error:', err);
        }
      }
    }
    return Response.redirect(row.original_url, 302);
  } catch (err) {
    console.error('Redirect error:', err);
    return new Response('Internal Error', { status: 500 });
  }
}

async function handleAnalytics(pathname, env, url) {
  const parts = pathname.split('/');
  const code = parts[parts.length - 1];
  if (!isValidShortCode(code)) return jsonResponse({ error: 'Not Found' }, { status: 404 });
  try {
    await ensureSchema(env);
    const q = url.searchParams;
    const days = Math.max(1, Math.min(365, parseInt(q.get('days') || '30', 10) || 30));
    const topCountries = Math.max(0, Math.min(20, parseInt(q.get('top_countries') || '0', 10) || 0));
    const topReferrers = Math.max(0, Math.min(20, parseInt(q.get('top_referrers') || '0', 10) || 0));

    const base = await env.DB
      .prepare('SELECT click_count, created_at FROM urls WHERE short_code = ?')
      .bind(code)
      .first();
    if (!base) return jsonResponse({ error: 'Not Found' }, { status: 404 });

    const startDay = new Date(Date.now() - (days - 1) * 24 * 60 * 60 * 1000).toISOString().slice(0, 10);

    const daily = await env.DB
      .prepare('SELECT day, clicks, unique_clicks FROM url_daily WHERE short_code = ? AND day >= ? ORDER BY day ASC')
      .bind(code, startDay)
      .all();
    const series = (daily.results || []).map(r => ({ day: r.day, clicks: r.clicks, unique_clicks: r.unique_clicks }));
    let total_clicks = 0, total_unique_clicks = 0;
    for (const r of series) { total_clicks += r.clicks | 0; total_unique_clicks += r.unique_clicks | 0; }

    const response = {
      click_count: base.click_count,
      created_at: base.created_at,
      window_days: days,
      total_clicks,
      total_unique_clicks,
      series,
    };

    if (topCountries > 0) {
      const cc = await env.DB
        .prepare('SELECT country, SUM(clicks) AS clicks FROM url_countries WHERE short_code = ? AND day >= ? GROUP BY country ORDER BY clicks DESC LIMIT ?')
        .bind(code, startDay, topCountries)
        .all();
      response.top_countries = (cc.results || []).map(r => ({ country: r.country, clicks: r.clicks }));
    }

    if (topReferrers > 0) {
      const rr = await env.DB
        .prepare('SELECT referrer_host, SUM(clicks) AS clicks FROM url_referrers WHERE short_code = ? AND day >= ? GROUP BY referrer_host ORDER BY clicks DESC LIMIT ?')
        .bind(code, startDay, topReferrers)
        .all();
      response.top_referrers = (rr.results || []).map(r => ({ referrer: r.referrer_host, clicks: r.clicks }));
    }

    return jsonResponse(response);
  } catch (err) {
    console.error('Analytics error:', err);
    return jsonResponse({ error: 'Internal error' }, { status: 500 });
  }
}

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const { pathname } = url;
    const reqOrigin = request.headers.get('Origin') || '';

    try {
      if (pathname === '/api/shorten' && request.method === 'POST') {
        const r = await handleShorten(request, env);
        return withCors(r, reqOrigin);
      }

      if (pathname.startsWith('/api/analytics/') && request.method === 'GET') {
        const r = await handleAnalytics(pathname, env, url);
        return withCors(r, reqOrigin);
      }

      // Redirect handler for GET|HEAD /{short_code}
      if ((request.method === 'GET' || request.method === 'HEAD') && pathname.length > 1 && !pathname.startsWith('/api/')) {
        return await handleRedirect(pathname, env, request);
      }

      // Fallbacks
      if (request.method === 'OPTIONS') {
        // Allow CORS preflight only for API paths
        if (pathname.startsWith('/api/')) {
          return withCors(new Response(null, { status: 204 }), reqOrigin);
        }
        return new Response(null, { status: 204 });
      }

      return new Response('Not Found', { status: 404 });
    } catch (err) {
      console.error('Unhandled error:', err);
      return new Response('Internal Error', { status: 500 });
    }
  },
};
