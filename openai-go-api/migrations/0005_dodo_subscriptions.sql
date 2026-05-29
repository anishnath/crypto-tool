-- Migration 0005: Dodo Payments subscriptions, webhooks, and payment audit
-- Shared Cloudflare D1 (exam-marker-db) — same instance as users + LLM billing
--
-- Apply:
--   cd openai-go-api && make d1-migrate-remote

-- =============================================
-- 1. WEBHOOK IDEMPOTENCY + AUDIT
-- =============================================
CREATE TABLE IF NOT EXISTS dodo_webhook_events (
    webhook_id TEXT PRIMARY KEY,
    event_type TEXT NOT NULL,
    business_id TEXT,
    event_timestamp TEXT,
    payload_json TEXT NOT NULL,
    processing_status TEXT NOT NULL DEFAULT 'pending'
        CHECK (processing_status IN ('pending', 'processed', 'ignored', 'failed')),
    processing_error TEXT,
    received_at TEXT NOT NULL DEFAULT (datetime('now')),
    processed_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_dodo_webhook_events_type
    ON dodo_webhook_events(event_type, received_at);

CREATE INDEX IF NOT EXISTS idx_dodo_webhook_events_status
    ON dodo_webhook_events(processing_status, received_at);

-- =============================================
-- 2. USER SUBSCRIPTIONS (Dodo → 8gwifi Pro)
-- =============================================
CREATE TABLE IF NOT EXISTS user_subscriptions (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    dodo_subscription_id TEXT NOT NULL UNIQUE,
    dodo_customer_id TEXT,
    dodo_product_id TEXT,
    plan_key TEXT NOT NULL DEFAULT 'pro',
    status TEXT NOT NULL DEFAULT 'pending'
        CHECK (status IN (
            'pending', 'trialing', 'active', 'on_hold', 'cancelled',
            'failed', 'expired', 'past_due'
        )),
    billing_interval TEXT CHECK (billing_interval IN ('month', 'year', 'unknown')),
    currency TEXT,
    amount_cents INTEGER,
    current_period_start TEXT,
    current_period_end TEXT,
    trial_end TEXT,
    cancel_at_period_end INTEGER NOT NULL DEFAULT 0 CHECK (cancel_at_period_end IN (0, 1)),
    cancelled_at TEXT,
    metadata_json TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_user_subscriptions_user
    ON user_subscriptions(user_id);

CREATE INDEX IF NOT EXISTS idx_user_subscriptions_status
    ON user_subscriptions(status);

CREATE INDEX IF NOT EXISTS idx_user_subscriptions_customer
    ON user_subscriptions(dodo_customer_id);

CREATE INDEX IF NOT EXISTS idx_user_subscriptions_period_end
    ON user_subscriptions(current_period_end);

-- =============================================
-- 3. PAYMENT AUDIT (one row per Dodo payment id)
-- =============================================
CREATE TABLE IF NOT EXISTS dodo_payments (
    payment_id TEXT PRIMARY KEY,
    user_id TEXT,
    dodo_subscription_id TEXT,
    dodo_customer_id TEXT,
    dodo_checkout_session_id TEXT,
    event_type TEXT,
    status TEXT NOT NULL,
    amount_cents INTEGER,
    currency TEXT,
    payload_json TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_dodo_payments_user
    ON dodo_payments(user_id);

CREATE INDEX IF NOT EXISTS idx_dodo_payments_subscription
    ON dodo_payments(dodo_subscription_id);

-- =============================================
-- 4. CHECKOUT SESSION TRACKING
-- =============================================
CREATE TABLE IF NOT EXISTS dodo_checkout_sessions (
    session_id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    dodo_product_id TEXT NOT NULL,
    plan_key TEXT NOT NULL DEFAULT 'pro',
    billing_interval TEXT CHECK (billing_interval IN ('month', 'year', 'unknown')),
    status TEXT NOT NULL DEFAULT 'open'
        CHECK (status IN ('open', 'completed', 'expired', 'failed')),
    checkout_url TEXT,
    return_url TEXT,
    metadata_json TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    completed_at TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_dodo_checkout_user
    ON dodo_checkout_sessions(user_id, created_at);

-- =============================================
-- 5. USERS — Dodo customer link (optional denormalization)
-- =============================================
ALTER TABLE users ADD COLUMN dodo_customer_id TEXT;

CREATE INDEX IF NOT EXISTS idx_users_dodo_customer
    ON users(dodo_customer_id);

-- =============================================
-- 6. VIEWS
-- =============================================
CREATE VIEW IF NOT EXISTS user_active_subscription AS
SELECT
    us.*
FROM user_subscriptions us
WHERE us.status IN ('active', 'trialing')
  AND (
    us.current_period_end IS NULL
    OR us.current_period_end > datetime('now')
  );

CREATE VIEW IF NOT EXISTS user_billing_summary AS
SELECT
    u.id AS user_id,
    u.email,
    u.is_premium,
    u.premium_until,
    u.dodo_customer_id,
    s.dodo_subscription_id,
    s.status AS subscription_status,
    s.plan_key,
    s.billing_interval,
    s.current_period_end,
    s.cancel_at_period_end
FROM users u
LEFT JOIN user_active_subscription s ON s.user_id = u.id;
