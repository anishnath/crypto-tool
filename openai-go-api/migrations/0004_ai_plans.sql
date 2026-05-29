-- Migration 0004: AI-only usage plans (tools stay free; only LLM calls are metered)
-- Apply: make d1-migrate-remote

-- Plan definitions (monthly token limits)
CREATE TABLE IF NOT EXISTS ai_plans (
    plan_id TEXT PRIMARY KEY,
    display_name TEXT NOT NULL,
    monthly_token_limit INTEGER NOT NULL,
    description TEXT,
    active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1))
);

INSERT OR REPLACE INTO ai_plans (plan_id, display_name, monthly_token_limit, description) VALUES
    ('guest', 'Guest', 20000, 'Anonymous browser session — send X-Anonymous-Id'),
    ('free', 'Free account', 200000, 'Logged-in Google user'),
    ('pro', 'Pro', 2000000, 'Premium subscriber (users.is_premium)');

-- Monthly rollup per subject (user or anonymous session)
CREATE TABLE IF NOT EXISTS ai_usage_periods (
    subject_type TEXT NOT NULL CHECK (subject_type IN ('user', 'anonymous')),
    subject_id TEXT NOT NULL,
    period_month TEXT NOT NULL,
    plan_id TEXT NOT NULL,
    tokens_used INTEGER NOT NULL DEFAULT 0,
    request_count INTEGER NOT NULL DEFAULT 0,
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    PRIMARY KEY (subject_type, subject_id, period_month),
    FOREIGN KEY (plan_id) REFERENCES ai_plans(plan_id)
);

CREATE INDEX IF NOT EXISTS idx_ai_usage_subject_period
    ON ai_usage_periods(subject_type, subject_id, period_month);

CREATE INDEX IF NOT EXISTS idx_ai_usage_period_month
    ON ai_usage_periods(period_month);

-- Which tool triggered the AI call (analytics only — tools are not paywalled)
ALTER TABLE llm_gateway_requests ADD COLUMN tool_id TEXT;

CREATE INDEX IF NOT EXISTS idx_llm_req_tool_started
    ON llm_gateway_requests(tool_id, started_at);

-- Convenience view for dashboards
CREATE VIEW IF NOT EXISTS ai_quota_status AS
SELECT
    p.subject_type,
    p.subject_id,
    p.period_month,
    p.plan_id,
    pl.display_name AS plan_name,
    pl.monthly_token_limit AS tokens_limit,
    p.tokens_used,
    MAX(0, pl.monthly_token_limit - p.tokens_used) AS tokens_remaining,
    p.request_count,
    p.updated_at
FROM ai_usage_periods p
JOIN ai_plans pl ON pl.plan_id = p.plan_id;
