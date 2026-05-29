-- Migration 0009: Per-tool billing_plans overrides (tool_id '' = global default)
-- Apply: cd openai-go-api && make d1-migrate-remote
--
-- Resolution: billing_plans WHERE tool_id = '<tool>' overrides rows where tool_id = ''.
-- ai_plans stays global (same Pro entitlements); only price/product/cadence vary per tool.

CREATE TABLE billing_plans_v2 (
    plan_key         TEXT NOT NULL,
    tool_id          TEXT NOT NULL DEFAULT '',   -- '' = site-wide default (~80% of tools)
    product_id       TEXT,
    billing_interval TEXT CHECK (billing_interval IN ('month', 'year', 'unknown')),
    ai_plan_id       TEXT NOT NULL DEFAULT 'pro',
    name             TEXT,
    price_amount     INTEGER,
    currency         TEXT,
    price_label      TEXT,
    badge            TEXT,
    description      TEXT,
    cadence_label    TEXT,
    sort_order       INTEGER NOT NULL DEFAULT 0,
    active           INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1)),
    created_at       TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at       TEXT NOT NULL DEFAULT (datetime('now')),
    PRIMARY KEY (plan_key, tool_id)
);

INSERT INTO billing_plans_v2 (
    plan_key, tool_id, product_id, billing_interval, ai_plan_id, name,
    price_amount, currency, price_label, badge, description, cadence_label,
    sort_order, active, created_at, updated_at
)
SELECT
    plan_key,
    '',
    product_id,
    billing_interval,
    COALESCE(ai_plan_id, 'pro'),
    name,
    price_amount,
    currency,
    price_label,
    badge,
    description,
    cadence_label,
    sort_order,
    active,
    created_at,
    updated_at
FROM billing_plans;

DROP TABLE billing_plans;
ALTER TABLE billing_plans_v2 RENAME TO billing_plans;

-- Example: lower price for one tool (set product_id to a matching Dodo product):
-- INSERT INTO billing_plans (plan_key, tool_id, ai_plan_id, product_id, price_amount, currency, name, sort_order, description, cadence_label)
-- VALUES ('monthly', 'electronics/arduino-simulator', 'pro', 'pdt_arduino_monthly', 300, 'USD', 'Monthly', 10,
--         'Pro for Arduino simulator', 'Billed monthly · cancel anytime')
-- ON CONFLICT(plan_key, tool_id) DO UPDATE SET
--   product_id = excluded.product_id,
--   price_amount = excluded.price_amount,
--   currency = excluded.currency,
--   updated_at = datetime('now');
