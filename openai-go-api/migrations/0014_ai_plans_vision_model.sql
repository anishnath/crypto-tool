-- Migration 0014: per-tier vision model.
-- Mirrors model_id (text model per tier). Image requests from a tier auto-route
-- to this model; if empty/unset, the gateway's global default_vision_model is used.
-- Values must be vision-capable models enabled in config/models.yaml.

ALTER TABLE ai_plans ADD COLUMN vision_model_id TEXT;

UPDATE ai_plans SET vision_model_id = 'gpt-5.4-nano' WHERE plan_id = 'guest';
UPDATE ai_plans SET vision_model_id = 'gpt-5.4-mini' WHERE plan_id = 'free';
UPDATE ai_plans SET vision_model_id = 'gpt-5.4'      WHERE plan_id = 'pro';
