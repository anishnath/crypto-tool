-- Migration 0001: LLM Gateway billing & request logging
-- Cloudflare D1 (SQLite)
-- Database ID: b146fd57-6fcc-4847-8b3f-17a9e747758b
--
-- Apply:
--   make d1-migrate-local
--   make d1-migrate-remote

-- =============================================
-- 1. REQUEST LOG (one row per API call)
-- =============================================
CREATE TABLE IF NOT EXISTS llm_gateway_requests (
    id TEXT PRIMARY KEY,

    -- Routing
    endpoint TEXT NOT NULL CHECK (endpoint IN ('chat_completions', 'responses')),
    modality TEXT NOT NULL CHECK (modality IN ('chat', 'responses', 'tts')),
    provider_id TEXT NOT NULL,
    model_requested TEXT,
    model_resolved TEXT,

    -- Request payload (logged at call time)
    stream INTEGER NOT NULL DEFAULT 0 CHECK (stream IN (0, 1)),
    request_json TEXT NOT NULL,
    message_count INTEGER,
    input_char_count INTEGER,
    task TEXT,
    temperature REAL,
    top_p REAL,

    -- Outcome (filled when response completes or fails)
    status TEXT NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'completed', 'failed', 'validation_failed')),
    http_status INTEGER,
    error_code TEXT,
    error_message TEXT,
    output_char_count INTEGER,

    -- Token usage (chat: prompt/completion; responses: input/output; store both + raw JSON)
    prompt_tokens INTEGER,
    completion_tokens INTEGER,
    total_tokens INTEGER,
    input_tokens INTEGER,
    output_tokens INTEGER,
    reasoning_tokens INTEGER,
    cached_tokens INTEGER,
    usage_json TEXT,

    -- Upstream correlation
    provider_response_id TEXT,

    -- Timing
    started_at TEXT NOT NULL DEFAULT (datetime('now')),
    completed_at TEXT,
    latency_ms INTEGER,

    -- Client attribution (billing)
    api_key_id TEXT,
    api_key_hash TEXT,
    client_ip_hash TEXT,
    user_agent TEXT,
    request_id_header TEXT,

    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_llm_req_started
    ON llm_gateway_requests(started_at);

CREATE INDEX IF NOT EXISTS idx_llm_req_provider_model_started
    ON llm_gateway_requests(provider_id, model_resolved, started_at);

CREATE INDEX IF NOT EXISTS idx_llm_req_status_started
    ON llm_gateway_requests(status, started_at);

CREATE INDEX IF NOT EXISTS idx_llm_req_api_key_started
    ON llm_gateway_requests(api_key_hash, started_at);

CREATE INDEX IF NOT EXISTS idx_llm_req_endpoint_started
    ON llm_gateway_requests(endpoint, started_at);

-- =============================================
-- 2. MODEL PRICING REFERENCE (optional cost estimates)
-- =============================================
CREATE TABLE IF NOT EXISTS llm_model_pricing (
    model_id TEXT NOT NULL,
    provider_id TEXT NOT NULL,
    input_price_per_million REAL NOT NULL DEFAULT 0,
    output_price_per_million REAL NOT NULL DEFAULT 0,
    effective_from TEXT NOT NULL DEFAULT (date('now')),
    notes TEXT,
    PRIMARY KEY (model_id, effective_from)
);

CREATE INDEX IF NOT EXISTS idx_llm_pricing_provider
    ON llm_model_pricing(provider_id, model_id);

-- Seed placeholder pricing rows (update with real rates)
INSERT OR IGNORE INTO llm_model_pricing (model_id, provider_id, input_price_per_million, output_price_per_million, notes)
VALUES
    ('gpt-5.4-mini', 'openai', 0.15, 0.60, 'placeholder — update from OpenAI pricing'),
    ('gpt-5.4', 'openai', 2.50, 10.00, 'placeholder'),
    ('gpt-5.4-pro', 'openai', 5.00, 20.00, 'placeholder'),
    ('mimo-v2-flash', 'mimo', 0.10, 0.40, 'placeholder — update from MiMo pricing'),
    ('mimo-v2.5-pro', 'mimo', 1.00, 4.00, 'placeholder');

-- =============================================
-- 3. DAILY ROLLUP VIEW (billing dashboards)
-- =============================================
CREATE VIEW IF NOT EXISTS llm_daily_usage AS
SELECT
    date(started_at) AS usage_date,
    provider_id,
    COALESCE(model_resolved, model_requested, 'unknown') AS model,
    endpoint,
    COUNT(*) AS request_count,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed_count,
    SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) AS failed_count,
    SUM(CASE WHEN status = 'validation_failed' THEN 1 ELSE 0 END) AS validation_failed_count,
    SUM(COALESCE(prompt_tokens, input_tokens, 0)) AS input_tokens,
    SUM(COALESCE(completion_tokens, output_tokens, 0)) AS output_tokens,
    SUM(COALESCE(total_tokens, 0)) AS total_tokens,
    SUM(COALESCE(reasoning_tokens, 0)) AS reasoning_tokens,
    SUM(COALESCE(cached_tokens, 0)) AS cached_tokens,
    ROUND(AVG(latency_ms), 2) AS avg_latency_ms,
    SUM(COALESCE(output_char_count, 0)) AS total_output_chars
FROM llm_gateway_requests
WHERE started_at IS NOT NULL
GROUP BY
    date(started_at),
    provider_id,
    COALESCE(model_resolved, model_requested, 'unknown'),
    endpoint;
