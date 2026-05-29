-- Migration 0010: Tier-based default model (chat) per ai_plans row
-- Apply: cd openai-go-api && make d1-migrate-remote
--
-- Used when the client omits "model" on POST /v1/chat/completions.
-- Must be a model with "chat" modality (not gpt-5.4-pro — that is responses-only).

ALTER TABLE ai_plans ADD COLUMN model_id TEXT;

UPDATE ai_plans SET model_id = 'gpt-5.4-nano' WHERE plan_id = 'guest';
UPDATE ai_plans SET model_id = 'gpt-5.4-mini' WHERE plan_id = 'free';
UPDATE ai_plans SET model_id = 'gpt-5.4'      WHERE plan_id = 'pro';
