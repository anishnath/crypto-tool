-- Migration 0008: Tier commons live in ai_plans; billing_plans links via ai_plan_id
-- Apply: cd openai-go-api && make d1-migrate-remote
--
-- ai_plans     → monthly_token_limit, features_json, display_name (shared tier data)
-- billing_plans → price, product_id, cadence, badge + ai_plan_id (checkout catalog)

ALTER TABLE ai_plans ADD COLUMN features_json TEXT;

UPDATE ai_plans SET features_json = '["2,000,000 AI tokens per month","No rate-limit waiting between requests","Priority access on Arduino & other tools"]'
WHERE plan_id = 'pro';

ALTER TABLE billing_plans ADD COLUMN ai_plan_id TEXT NOT NULL DEFAULT 'pro';

UPDATE billing_plans SET ai_plan_id = 'pro' WHERE ai_plan_id IS NULL OR trim(ai_plan_id) = '';

-- Drop duplicated tier fields from billing_plans (deprecated in 0007)
UPDATE billing_plans SET monthly_token_limit = NULL, features_json = NULL;

-- Interval-specific copy stays on billing_plans only
UPDATE billing_plans SET
    description = 'Pro subscription with monthly billing',
    cadence_label = 'Billed monthly · cancel anytime',
    updated_at = datetime('now')
WHERE plan_key = 'monthly';

UPDATE billing_plans SET
    description = 'Pro subscription with yearly billing — best value',
    cadence_label = 'Billed yearly',
    updated_at = datetime('now')
WHERE plan_key = 'yearly';
