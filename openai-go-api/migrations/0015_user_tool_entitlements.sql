-- Migration 0015: Tool-scoped entitlements + coverage
-- Apply: cd openai-go-api && make d1-migrate-remote
--
-- See docs/TOOL_ENTITLEMENTS.md
-- - user_tool_entitlements: (user_id, tool_id) → plan_slug
-- - plan_coverage: higher tool plans grant Pro on cheaper tools
-- - Manic does NOT grandfather global is_premium
-- - Global users.is_premium remains for non-Manic tools (dual-write on webhook)

CREATE TABLE IF NOT EXISTS user_tool_entitlements (
    user_id                TEXT NOT NULL,
    tool_id                TEXT NOT NULL,
    plan_slug              TEXT NOT NULL CHECK (plan_slug IN ('free', 'pro', 'ultra')),
    status                 TEXT NOT NULL DEFAULT 'active'
        CHECK (status IN ('active', 'canceled', 'past_due', 'expired')),
    source_product_id      TEXT,
    source_subscription_id TEXT,
    current_period_end     TEXT,
    created_at             TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at             TEXT NOT NULL DEFAULT (datetime('now')),
    PRIMARY KEY (user_id, tool_id)
);

CREATE INDEX IF NOT EXISTS idx_user_tool_entitlements_status
    ON user_tool_entitlements(user_id, status);

CREATE TABLE IF NOT EXISTS plan_coverage (
    purchased_tool_id TEXT NOT NULL,
    purchased_plan    TEXT NOT NULL CHECK (purchased_plan IN ('pro', 'ultra')),
    covers_tool_id    TEXT NOT NULL,
    grants_plan       TEXT NOT NULL DEFAULT 'pro' CHECK (grants_plan IN ('pro', 'ultra')),
    PRIMARY KEY (purchased_tool_id, purchased_plan, covers_tool_id)
);

-- Manic AI tier (ultra). Lower allotment to match ~$9 Pro / ~$29 Ultra packaging.
INSERT INTO ai_plans (plan_id, display_name, monthly_token_limit, description, features_json, model_id, active)
VALUES (
    'ultra',
    'Ultra',
    1500000,
    'Manic Ultra — ElevenLabs + higher render/voice',
    '["1,500,000 AI tokens per month","Manic Ultra render + ElevenLabs voice","Pro access on cheaper tools","Priority model"]',
    'gpt-5.4',
    1
)
ON CONFLICT(plan_id) DO UPDATE SET
    display_name = excluded.display_name,
    monthly_token_limit = excluded.monthly_token_limit,
    description = COALESCE(NULLIF(trim(ai_plans.description), ''), excluded.description),
    features_json = COALESCE(NULLIF(trim(ai_plans.features_json), ''), excluded.features_json),
    model_id = COALESCE(NULLIF(trim(ai_plans.model_id), ''), excluded.model_id),
    active = 1;

-- Dedicated Manic Pro AI allotment (cheaper than global Pro — $9 Manic entry).
INSERT INTO ai_plans (plan_id, display_name, monthly_token_limit, description, features_json, model_id, active)
VALUES (
    'manic_pro',
    'Manic Pro',
    500000,
    'Manic Pro — Cartesia + Pro render, modest AI budget',
    '["500,000 AI tokens per month","Manic Pro render + Cartesia voice","Pro access on cheaper tools"]',
    'gpt-5.4',
    1
)
ON CONFLICT(plan_id) DO UPDATE SET
    display_name = excluded.display_name,
    monthly_token_limit = excluded.monthly_token_limit,
    description = COALESCE(NULLIF(trim(ai_plans.description), ''), excluded.description),
    features_json = COALESCE(NULLIF(trim(ai_plans.features_json), ''), excluded.features_json),
    model_id = COALESCE(NULLIF(trim(ai_plans.model_id), ''), excluded.model_id),
    active = 1;

-- Manic checkout catalog. Dodo product_id is charge authority; amounts are display.
INSERT INTO billing_plans (
    plan_key, tool_id, product_id, billing_interval, ai_plan_id, name,
    price_amount, currency, price_label, badge, description, cadence_label,
    sort_order, active
) VALUES
(
    'monthly', 'developer-tools/manic', 'pdt_0Nk4fuArwE5DmcpU2bF7G', 'month', 'manic_pro', 'Manic Pro',
    900, 'USD', '$9/mo', 'Popular',
    'Cartesia narration, Pro render, Manic AI — includes Pro on cheaper tools',
    'Billed monthly · cancel anytime',
    10, 1
),
(
    'yearly', 'developer-tools/manic', 'pdt_0Nk4gFJ4fIn0gbPOqxeeN', 'year', 'manic_pro', 'Manic Pro (yearly)',
    9000, 'USD', '$90/yr', 'Save 2 months',
    'Cartesia narration, Pro render, Manic AI — billed yearly',
    'Billed yearly · cancel anytime',
    20, 1
),
(
    'ultra_monthly', 'developer-tools/manic', 'pdt_0Nk4i8U92nyoPRLkfyvWN', 'month', 'ultra', 'Manic Ultra',
    2900, 'USD', '$29/mo', 'Ultra',
    'ElevenLabs + Cartesia, 4K render, higher AI + voice budgets',
    'Billed monthly · cancel anytime',
    30, 1
),
(
    'ultra_yearly', 'developer-tools/manic', 'pdt_0Nk4hpnw3U9dBNkxN7X9u', 'year', 'ultra', 'Manic Ultra (yearly)',
    29000, 'USD', '$290/yr', 'Ultra',
    'ElevenLabs + Cartesia, 4K render — billed yearly',
    'Billed yearly · cancel anytime',
    40, 1
)
ON CONFLICT(plan_key, tool_id) DO UPDATE SET
    product_id = excluded.product_id,
    ai_plan_id = excluded.ai_plan_id,
    name = excluded.name,
    price_amount = excluded.price_amount,
    currency = excluded.currency,
    price_label = excluded.price_label,
    badge = excluded.badge,
    description = excluded.description,
    cadence_label = excluded.cadence_label,
    sort_order = excluded.sort_order,
    active = 1,
    updated_at = datetime('now');

-- Example coverage: Manic Pro/Ultra grant Pro on Arduino (extend as needed).
INSERT INTO plan_coverage (purchased_tool_id, purchased_plan, covers_tool_id, grants_plan) VALUES
    ('developer-tools/manic', 'pro', 'electronics/arduino-simulator', 'pro'),
    ('developer-tools/manic', 'ultra', 'electronics/arduino-simulator', 'pro')
ON CONFLICT(purchased_tool_id, purchased_plan, covers_tool_id) DO UPDATE SET
    grants_plan = excluded.grants_plan;
