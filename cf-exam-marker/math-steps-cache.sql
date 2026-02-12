-- Math Steps Cache & Request Tracking
-- Apply: wrangler d1 execute exam-marker-db --file=math-steps-cache.sql --local
-- Apply: wrangler d1 execute exam-marker-db --file=math-steps-cache.sql --remote

-- Cache table: stores AI-generated steps so repeated queries skip OpenAI
CREATE TABLE IF NOT EXISTS math_steps_cache (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cache_key TEXT NOT NULL UNIQUE,          -- normalized key: operation|expression|variable|lower|upper
    operation TEXT NOT NULL DEFAULT 'integrate',
    expression TEXT NOT NULL,
    variable TEXT NOT NULL DEFAULT 'x',
    answer TEXT NOT NULL,
    bounds_lower TEXT,                        -- NULL for indefinite
    bounds_upper TEXT,                        -- NULL for indefinite
    steps_json TEXT NOT NULL,                 -- JSON: [{"title":"...","latex":"..."}]
    method TEXT,                              -- e.g. "Power Rule", "Integration by Parts"
    hit_count INTEGER NOT NULL DEFAULT 0,     -- times served from cache
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    last_accessed_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Index for fast lookups
CREATE INDEX IF NOT EXISTS idx_math_steps_cache_key ON math_steps_cache(cache_key);

-- Request log: tracks every request for analytics (cache hit or miss)
CREATE TABLE IF NOT EXISTS math_steps_requests (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    expression TEXT NOT NULL,
    operation TEXT NOT NULL DEFAULT 'integrate',
    variable TEXT NOT NULL DEFAULT 'x',
    bounds_lower TEXT,
    bounds_upper TEXT,
    cache_hit INTEGER NOT NULL DEFAULT 0,     -- 1 = served from cache, 0 = called AI
    tokens_used INTEGER,                      -- NULL for cache hits
    response_time_ms INTEGER,                 -- time to respond
    ip_hash TEXT,                             -- SHA-256 of IP (privacy-safe tracking)
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Index for analytics queries
CREATE INDEX IF NOT EXISTS idx_math_steps_requests_created ON math_steps_requests(created_at);
CREATE INDEX IF NOT EXISTS idx_math_steps_requests_expr ON math_steps_requests(expression);
