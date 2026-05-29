-- Migration 0013: Per-tool AI generation history (audit / recents UI)
-- Opt-in per tool on the API layer (currently math/tikz-viewer).
--
-- Apply:
--   make d1-migrate-local
--   make d1-migrate-remote

CREATE TABLE IF NOT EXISTS tool_ai_generations (
    id TEXT PRIMARY KEY,
    tool_id TEXT NOT NULL,
    user_id TEXT,
    anonymous_id TEXT,
    source TEXT NOT NULL DEFAULT 'ai_apply'
        CHECK (source IN ('ai_apply', 'image_convert', 'manual')),
    user_prompt TEXT,
    title TEXT,
    tikz_code TEXT NOT NULL,
    preview_svg TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_tool_ai_gen_user_tool_created
    ON tool_ai_generations(user_id, tool_id, created_at);

CREATE INDEX IF NOT EXISTS idx_tool_ai_gen_anon_tool_created
    ON tool_ai_generations(anonymous_id, tool_id, created_at);
