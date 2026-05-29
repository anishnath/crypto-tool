-- Migration 0007: Plan picker details (tokens, features, cadence copy)
-- Apply: cd openai-go-api && make d1-migrate-remote

ALTER TABLE billing_plans ADD COLUMN monthly_token_limit INTEGER;
ALTER TABLE billing_plans ADD COLUMN features_json TEXT;
ALTER TABLE billing_plans ADD COLUMN description TEXT;
ALTER TABLE billing_plans ADD COLUMN cadence_label TEXT;

-- Seed Pro plan display details (price still falls back to Dodo until overridden).
UPDATE billing_plans SET
    monthly_token_limit = 2000000,
    features_json = '["2,000,000 AI tokens per month","No rate-limit waiting between requests","Priority access on Arduino & other tools"]',
    cadence_label = 'Billed monthly · cancel anytime',
    description = 'Pro subscription with monthly billing',
    updated_at = datetime('now')
WHERE plan_key = 'monthly';

UPDATE billing_plans SET
    monthly_token_limit = 2000000,
    features_json = '["2,000,000 AI tokens per month","No rate-limit waiting between requests","Priority access on Arduino & other tools","Save with yearly billing"]',
    cadence_label = 'Billed yearly',
    description = 'Pro subscription with yearly billing',
    updated_at = datetime('now')
WHERE plan_key = 'yearly';
