-- Migration 0006: DB-level Pro plan catalog (overrides Dodo live price/name)
-- Shared Cloudflare D1 (exam-marker-db)
--
-- Apply:
--   cd openai-go-api && make d1-migrate-remote
--
-- Purpose: keep plan display (price/name/badge) in the DB so it can be changed
-- without touching the Dodo dashboard or redeploying. The Go ListPlans resolver
-- layers values as:  DB override  >  Dodo live product  >  nothing.
--
-- Override knobs per row:
--   product_id    NULL -> fall back to env DODO_PRODUCT_PRO_{MONTHLY,YEARLY}
--   price_label   set  -> shown verbatim (wins over price_amount)
--   price_amount  set  -> minor units (cents); formatted client-side label
--   currency      ISO 4217 (e.g. 'USD'); pairs with price_amount
--   name / badge  display overrides
--   active=0      hides the plan from the picker
--   sort_order    ascending display order

CREATE TABLE IF NOT EXISTS billing_plans (
    plan_key         TEXT PRIMARY KEY,            -- 'monthly' | 'yearly'
    product_id       TEXT,                        -- Dodo product id (overrides env)
    billing_interval TEXT CHECK (billing_interval IN ('month', 'year', 'unknown')),
    name             TEXT,                        -- display name override
    price_amount     INTEGER,                     -- minor units (e.g. cents) override
    currency         TEXT,                        -- ISO 4217, pairs with price_amount
    price_label      TEXT,                        -- explicit display label (wins over amount)
    badge            TEXT,                        -- e.g. 'Best value'
    sort_order       INTEGER NOT NULL DEFAULT 0,
    active           INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1)),
    created_at       TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at       TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Seed the two standard plans. Price columns left NULL so they fall back to the
-- live Dodo product price until an admin sets an override, e.g.:
--   UPDATE billing_plans SET price_amount = 500, currency = 'USD' WHERE plan_key = 'monthly';
--   UPDATE billing_plans SET price_label = '$48 / yr'            WHERE plan_key = 'yearly';
INSERT OR IGNORE INTO billing_plans (plan_key, billing_interval, name, badge, sort_order)
VALUES
    ('monthly', 'month', 'Monthly', NULL,          10),
    ('yearly',  'year',  'Yearly',  'Best value',  20);
