-- Migration 0011: Per-tool chat model overrides by tier (free/pro only)
-- Apply: cd openai-go-api && make d1-migrate-remote
--
-- Resolution on POST /v1/chat/completions when client omits model:
--   guest     → ai_plans.model_id only (this table is NOT used)
--   free/pro  → tool row → global row (tool_id '') → ai_plans.model_id
--
-- Example: logged-in free users get a cheaper "legacy" model site-wide;
-- Arduino can override with a different model for free tier only.

CREATE TABLE IF NOT EXISTS tool_tier_models (
    tool_id   TEXT NOT NULL DEFAULT '',   -- '' = site-wide default for tier
    plan_id   TEXT NOT NULL CHECK (plan_id IN ('free', 'pro')),
    model_id  TEXT NOT NULL,
    active    INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1)),
    PRIMARY KEY (tool_id, plan_id)
);

-- Legacy model for logged-in free accounts (guest stays on ai_plans guest model_id).
INSERT INTO tool_tier_models (tool_id, plan_id, model_id)
VALUES ('', 'free', 'gpt-5.4-nano')
ON CONFLICT(tool_id, plan_id) DO UPDATE SET
    model_id = excluded.model_id,
    active = 1;

-- Per-tool example (uncomment / edit as needed):
-- INSERT INTO tool_tier_models (tool_id, plan_id, model_id)
-- VALUES ('electronics/arduino-simulator', 'free', 'mimo-v2-flash')
-- ON CONFLICT(tool_id, plan_id) DO UPDATE SET model_id = excluded.model_id, active = 1;
