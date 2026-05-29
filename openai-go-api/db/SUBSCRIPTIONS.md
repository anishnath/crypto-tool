# Dodo Payments — Subscription & Webhook Schema (D1)

**Operations guide (plans, models, Dodo vs tables):** [`docs/BILLING.md`](../docs/BILLING.md)

Migration: `migrations/0005_dodo_subscriptions.sql`

## Overview

| Table | Purpose |
|-------|---------|
| `dodo_webhook_events` | Idempotency (`webhook-id` header) + audit trail |
| `user_subscriptions` | Canonical Dodo subscription state per user |
| `dodo_payments` | Payment success/failure audit |
| `dodo_checkout_sessions` | Checkout sessions created from 8gwifi |
| `users.dodo_customer_id` | Optional link to Dodo customer |
| `billing_plans` | DB-level plan catalog (price/name override) — migration `0006` |

**Entitlement:** Go AI quota reads `users.is_premium` + `users.premium_until`. Java webhook handler updates those columns when subscription state changes.

## Lifecycle

```
Browser → POST /api/dodo/checkout (logged in)
       → Dodo POST /checkouts (metadata.user_id = Google sub)
       → User pays on Dodo hosted checkout
       → Dodo POST /api/dodo/webhook
       → INSERT dodo_webhook_events (idempotent)
       → UPSERT user_subscriptions
       → UPDATE users.is_premium / premium_until
       → Go GET /v1/ai/quota returns plan pro
```

## Tables

### `dodo_webhook_events`

| Column | Description |
|--------|-------------|
| `webhook_id` | PK — `webhook-id` header from Dodo |
| `event_type` | e.g. `subscription.active`, `payment.succeeded` |
| `processing_status` | `pending` → `processed` \| `ignored` \| `failed` |

### `user_subscriptions`

| Column | Description |
|--------|-------------|
| `dodo_subscription_id` | Unique Dodo subscription id |
| `user_id` | `users.id` (= Google OAuth sub / `X-User-Id`) |
| `status` | `active`, `trialing`, `cancelled`, `expired`, … |
| `current_period_end` | Drives `users.premium_until` |

### `dodo_payments`

One row per `payment_id` from webhook payloads.

### `dodo_checkout_sessions`

Tracks sessions created by `DodoCheckoutServlet` before payment completes.

### `billing_plans`

Migration `0006` (+ `0007`, `0008`). Checkout catalog only — **price, product, cadence, badge**.
Tier limits & feature bullets live in **`ai_plans`**, linked by `ai_plan_id` (default `pro`).

| Column | Description |
|--------|-------------|
| `plan_key` | PK part — `monthly` \| `yearly` |
| `tool_id` | PK part — `''` = site-wide default; else tool slug (e.g. `electronics/arduino-simulator`) |
| `ai_plan_id` | FK → `ai_plans.plan_id` (which tier this checkout grants) |
| `product_id` | Dodo product id; `NULL` falls back to env `DODO_PRODUCT_PRO_*` |
| `billing_interval` | `month` \| `year` |
| `name` | Checkout card title override |
| `price_amount` / `currency` / `price_label` | Price overrides |
| `badge` | e.g. `Best value` |
| `description` / `cadence_label` | Interval-specific marketing copy |
| `active` / `sort_order` | Visibility & order |

Deprecated (do not use): `billing_plans.monthly_token_limit`, `billing_plans.features_json`.

**Per-tool pricing:** insert rows with a non-empty `tool_id`. `GET /v1/billing/plans?tool=<slug>` merges tool rows over global (`tool_id = ''`). Checkout POST body includes `tool_id` so the correct Dodo `product_id` is charged.

```sql
-- Lower price for one tool (requires matching Dodo product)
INSERT INTO billing_plans (plan_key, tool_id, ai_plan_id, product_id, price_amount, currency, name, sort_order)
VALUES ('monthly', 'electronics/arduino-simulator', 'pro', 'pdt_arduino_monthly', 300, 'USD', 'Monthly', 10)
ON CONFLICT(plan_key, tool_id) DO UPDATE SET
  product_id = excluded.product_id,
  price_amount = excluded.price_amount,
  currency = excluded.currency,
  updated_at = datetime('now');
```

### `ai_plans`

Migration `0004` (+ `0008`). **Source of truth** for AI tier limits, names, and shared feature bullets.

| Column | Description |
|--------|-------------|
| `plan_id` | PK — `guest` \| `free` \| `pro` |
| `display_name` | UI label |
| `monthly_token_limit` | Enforced by Go quota + shown in plan picker |
| `description` | Tier description |
| `features_json` | JSON array of feature strings (Pro marketing bullets) |
| `model_id` | Default chat model when client omits `model` (migration `0010`) |
| `active` | `0` hides tier |

**Default tier → model mapping** (chat completions only):

| Tier | `model_id` | Notes |
|------|------------|-------|
| `guest` | `gpt-5.4-nano` | Cheapest; anonymous quota |
| `free` | `gpt-5.4-mini` | Logged-in default |
| `pro` | `gpt-5.4` | Full frontier chat model |

Do **not** set `gpt-5.4-pro` / `gpt-5.5-pro` here — those are **responses-only** endpoints, not `/v1/chat/completions`. To use MiMo instead of OpenAI, pick chat-capable ids from `config/models.yaml` (e.g. `mimo-v2.5` for pro).

```sql
-- Change Pro tokens + features (affects quota enforcement + checkout UI)
UPDATE ai_plans SET
  monthly_token_limit = 3000000,
  features_json = '["3M AI tokens per month","No rate limits","Priority support"]'
WHERE plan_id = 'pro';

-- Change tier default model (must support chat modality)
UPDATE ai_plans SET model_id = 'mimo-v2.5' WHERE plan_id = 'pro';
```

## Views

- **`user_active_subscription`** — active/trialing subs with valid period
- **`user_billing_summary`** — join users + active subscription for support UI

## Go API (single D1 writer)

Implementation: `internal/billing/dodo/` (uses [dodopayments-go](https://pkg.go.dev/github.com/dodopayments/dodopayments-go)) + `internal/handler/billing.go`

| Route | Purpose |
|-------|---------|
| `POST /v1/billing/webhook` | Dodo webhooks |
| `POST /v1/billing/checkout` | Hosted checkout |
| `GET /v1/billing/plans` | Public plan catalog (price/name from `billing_plans`) |
| `GET /v1/billing/status` | User billing status |
| `POST /v1/billing/users/upsert` | OAuth user row |

Tomcat proxies `/api/dodo/*`, `/api/billing/status`, and `/api/billing/plans` to these routes via `BillingGatewayProxyServlet`.

Env reference: [`docs/DODO_BILLING_ENV.md`](../../docs/DODO_BILLING_ENV.md).

## Webhook URL (production)

`https://8gwifi.org/api/dodo/webhook` → proxied to Go `/v1/billing/webhook`

## Subscribed events (minimum)

- `payment.succeeded`
- `payment.failed`
- `subscription.active`
- `subscription.cancelled`
- `subscription.expired`
- `subscription.on_hold` (optional)
- `subscription.renewed` (optional)

## Metadata contract

Checkout **must** include:

```json
{ "user_id": "<oauth_user_sub>", "plan_key": "pro", "billing_interval": "month" }
```

Webhook handler resolves `user_id` from `data.metadata.user_id` or nested subscription/payment metadata.
