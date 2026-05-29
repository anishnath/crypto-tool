-- Migration 0012: Pro plan picker — model tier labels + marketing copy
-- Apply: cd openai-go-api && make d1-migrate-remote
--
-- Prerequisite: 0010 (model_id column), 0008 (features_json), 0006 (billing_plans).
-- Pricing display: set billing_plans.product_id OR price_amount/price_label OR rely on
-- Dodo live fetch (DODO_PRODUCT_PRO_* env on Go). Example:
--   UPDATE billing_plans SET product_id = 'pdt_…', price_amount = 900, currency = 'USD'
--     WHERE plan_key = 'monthly' AND tool_id = '';

-- Idempotent model_id (safe if 0010 already ran)
UPDATE ai_plans SET model_id = 'gpt-5.4-nano'
WHERE plan_id = 'guest' AND (model_id IS NULL OR trim(model_id) = '');

UPDATE ai_plans SET model_id = 'gpt-5.4-mini'
WHERE plan_id = 'free' AND (model_id IS NULL OR trim(model_id) = '');

UPDATE ai_plans SET model_id = 'gpt-5.4'
WHERE plan_id = 'pro' AND (model_id IS NULL OR trim(model_id) = '');

UPDATE ai_plans SET
  display_name = 'Guest',
  description = 'Anonymous tier — gpt-5.4-nano chat model',
  monthly_token_limit = COALESCE(NULLIF(monthly_token_limit, 0), 20000)
WHERE plan_id = 'guest';

UPDATE ai_plans SET
  display_name = 'Free account',
  description = 'Signed-in free tier — gpt-5.4-mini chat model',
  monthly_token_limit = COALESCE(NULLIF(monthly_token_limit, 0), 200000)
WHERE plan_id = 'free';

UPDATE ai_plans SET
  display_name = 'Pro',
  description = 'Pro tier — gpt-5.4 default chat model',
  monthly_token_limit = COALESCE(NULLIF(monthly_token_limit, 0), 2000000),
  features_json = '["2,000,000 AI tokens per month","gpt-5.4 Pro chat model","No rate-limit waiting between requests","Priority access on all tools"]'
WHERE plan_id = 'pro';
