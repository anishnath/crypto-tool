-- Migration 0003: Per-user API usage tracking (login + anonymous)
-- Links llm_gateway_requests to users table; supports anonymous sessions.
--
-- Auth modes (auth_mode column):
--   anonymous      — no login; track via X-Anonymous-Id (client UUID)
--   authenticated  — logged-in user via X-User-Id (matches users.id)
--   api_key        — Bearer llm_* key mapped in llm_user_api_keys
--
-- Client headers:
--   X-User-Id:       Google user id from exam-marker login
--   X-Anonymous-Id:  stable UUID from localStorage for guests
--   Authorization:   Bearer llm_<secret> for programmatic access

ALTER TABLE llm_gateway_requests ADD COLUMN user_id TEXT;
ALTER TABLE llm_gateway_requests ADD COLUMN anonymous_id TEXT;
ALTER TABLE llm_gateway_requests ADD COLUMN auth_mode TEXT NOT NULL DEFAULT 'anonymous'
    CHECK (auth_mode IN ('anonymous', 'authenticated', 'api_key'));

CREATE INDEX IF NOT EXISTS idx_llm_req_user_started
    ON llm_gateway_requests(user_id, started_at);

CREATE INDEX IF NOT EXISTS idx_llm_req_anonymous_started
    ON llm_gateway_requests(anonymous_id, started_at);

CREATE INDEX IF NOT EXISTS idx_llm_req_auth_mode_started
    ON llm_gateway_requests(auth_mode, started_at);

-- Per-user API keys (optional programmatic access tied to users.id)
CREATE TABLE IF NOT EXISTS llm_user_api_keys (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    key_hash TEXT NOT NULL UNIQUE,
    label TEXT,
    is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    last_used_at TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_llm_api_keys_user
    ON llm_user_api_keys(user_id);

CREATE INDEX IF NOT EXISTS idx_llm_api_keys_active_hash
    ON llm_user_api_keys(key_hash, is_active);

-- Daily usage rollup by user or anonymous session
CREATE VIEW IF NOT EXISTS llm_user_usage AS
SELECT
    r.user_id,
    r.anonymous_id,
    r.auth_mode,
    u.email AS user_email,
    u.name AS user_name,
    date(r.started_at) AS usage_date,
    COUNT(*) AS request_count,
    SUM(CASE WHEN r.status = 'completed' THEN 1 ELSE 0 END) AS completed_count,
    SUM(CASE WHEN r.status = 'failed' THEN 1 ELSE 0 END) AS failed_count,
    SUM(COALESCE(r.prompt_tokens, r.input_tokens, 0)) AS input_tokens,
    SUM(COALESCE(r.completion_tokens, r.output_tokens, 0)) AS output_tokens,
    SUM(COALESCE(r.total_tokens, 0)) AS total_tokens,
    ROUND(AVG(r.latency_ms), 2) AS avg_latency_ms
FROM llm_gateway_requests r
LEFT JOIN users u ON u.id = r.user_id
GROUP BY
    r.user_id,
    r.anonymous_id,
    r.auth_mode,
    u.email,
    u.name,
    date(r.started_at);

-- Lifetime totals per logged-in user
CREATE VIEW IF NOT EXISTS llm_user_usage_totals AS
SELECT
    r.user_id,
    u.email AS user_email,
    u.name AS user_name,
    COUNT(*) AS request_count,
    SUM(CASE WHEN r.status = 'completed' THEN 1 ELSE 0 END) AS completed_count,
    SUM(COALESCE(r.total_tokens, 0)) AS total_tokens,
    MIN(r.started_at) AS first_request_at,
    MAX(r.started_at) AS last_request_at
FROM llm_gateway_requests r
LEFT JOIN users u ON u.id = r.user_id
WHERE r.user_id IS NOT NULL
GROUP BY r.user_id, u.email, u.name;

-- Lifetime totals per anonymous session
CREATE VIEW IF NOT EXISTS llm_anonymous_usage_totals AS
SELECT
    r.anonymous_id,
    COUNT(*) AS request_count,
    SUM(CASE WHEN r.status = 'completed' THEN 1 ELSE 0 END) AS completed_count,
    SUM(COALESCE(r.total_tokens, 0)) AS total_tokens,
    MIN(r.started_at) AS first_request_at,
    MAX(r.started_at) AS last_request_at
FROM llm_gateway_requests r
WHERE r.auth_mode = 'anonymous' AND r.anonymous_id IS NOT NULL
GROUP BY r.anonymous_id;
