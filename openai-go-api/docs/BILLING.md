# Billing & AI plans — operations guide

How Pro subscriptions, AI quotas, model routing, and the plan picker work — and **where to change each knob** (Dodo dashboard vs D1 tables vs env vars).

**Related docs**

| Doc | Purpose |
|-----|---------|
| [`db/SUBSCRIPTIONS.md`](../db/SUBSCRIPTIONS.md) | D1 schema reference (columns, migrations) |
| [`../../docs/DODO_BILLING_ENV.md`](../../docs/DODO_BILLING_ENV.md) | Env vars, network topology, webhook URL |
| [`../README.md`](../README.md) | Gateway API, quota headers, frontend examples |
| [`../config/models.yaml`](../config/models.yaml) | Which model ids exist and their modalities |

---

## 1. What is billed today

| Thing | Billed? | Where enforced |
|-------|---------|----------------|
| **Tool pages** (451+ calculators, SEO, Arduino UI, etc.) | **No** — always free to use | — |
| **AI calls** (`POST /v1/chat/completions` via `/ai` proxy) | **Yes** — monthly **token** quota | Go gateway + D1 `ai_plans` |
| **Pro subscription** (Dodo) | Money via Dodo; unlocks Pro **AI tier** | Dodo → webhook → D1 `users.is_premium` |

`X-Tool-Id` is **analytics and per-tool checkout pricing only**. It does not paywall a tool page.

**Not built yet:** per-tool numeric limits (e.g. “SEO checker: 10 pages free, 1000 Pro”). That would need a separate `tool_plan_limits` table + tool-specific enforcement. Do not use `ai_plans` for non-AI caps.

---

## 2. Architecture (who owns what)

```
Browser
  ├─ GET  /api/billing/plans?tool=…     → Tomcat → Go → D1 billing_plans + ai_plans
  ├─ POST /api/dodo/checkout            → Tomcat → Go → Dodo API + D1 checkout session
  ├─ GET  /api/billing/status           → Tomcat → Go → D1 users + subscriptions
  └─ POST /ai …                         → Tomcat → Go → LLM provider + D1 quota

Dodo (internet)
  └─ POST /api/dodo/webhook             → Tomcat → Go → D1 users.is_premium, user_subscriptions
```

| Layer | Owns | Change when… |
|-------|------|--------------|
| **Dodo dashboard** | Products, live prices, payment methods, webhook endpoint URL | New product SKU, real money price, tax, payment provider |
| **D1 `billing_plans`** | Checkout **display** + which Dodo `product_id` to charge; optional **per-tool price** | Show different price on one tool, badge/cadence copy, hide a plan |
| **D1 `ai_plans`** | **AI tier** limits, feature bullets, **default chat model** | Token limits, Pro marketing bullets, tier → model mapping |
| **D1 `users`** | `is_premium`, `premium_until` | Usually **automatic** via webhook; manual support override only |
| **Go `.env`** | Fallback product ids, fallback token limits, API keys | Bootstrap before DB rows exist; emergency fallback |
| **`config/models.yaml`** | Valid model ids + chat vs responses modality | Add/remove models; gateway default when tier model invalid |

**Rule of thumb:** If it affects **money or SKU**, touch Dodo + `billing_plans.product_id`. If it affects **AI usage or model**, touch `ai_plans`. If it affects **what the upgrade modal shows**, touch both.

### Go caching (`GET /v1/billing/plans`)

| Layer | TTL | Notes |
|-------|-----|-------|
| Full catalog (per `tool_id`) | **1 hour** | In-memory; D1 `billing_plans` + `ai_plans` |
| Dodo product name/price | **24 hours** | Only when DB rows lack `name` or `price_label` |
| Failed Dodo product fetch | **5 minutes** | Avoids hammering Dodo on outage |

**Browser client (`billing-client.js`):** status GET **10s** abort; plans GET (**See Pro plans**) **20s** abort; plans cached **1h** in `sessionStorage`. Tomcat proxy socket **60s** to Go.

**Skip Dodo entirely:** set `name`, `price_label` (or `price_amount` + `currency`) on `billing_plans` — Go uses DB values and never calls `Products.Get`.

Restart Go or wait for TTL after changing Dodo prices or D1 display copy.

---

## 3. AI tiers (guest / free / pro)

Resolved at runtime by Go (`internal/billing/quota_d1.go`):

| Tier | Who | How detected |
|------|-----|--------------|
| `guest` | Anonymous | No `X-User-Id`; requires `X-Anonymous-Id` |
| `free` | Logged in | `X-User-Id` set, `users.is_premium = 0` |
| `pro` | Subscriber | `users.is_premium = 1` and valid `premium_until` |

Tomcat also bypasses **5 req/min AI rate limit** for Pro (`AIGatewayProxyServlet`).

### Defaults (D1 `ai_plans`)

| `plan_id` | Monthly tokens | Default chat model (`model_id`) |
|-----------|----------------|----------------------------------|
| `guest` | 20,000 | `gpt-5.4-nano` |
| `free` | 200,000 | `gpt-5.4-mini` |
| `pro` | 2,000,000 | `gpt-5.4` |

Cached ~10 minutes in Go after a D1 read.

**Fallback:** env `AI_QUOTA_GUEST`, `AI_QUOTA_FREE`, `AI_QUOTA_PRO` only apply if `ai_plans` cannot be loaded.

---

## 4. Model selection

### Automatic (recommended for assistants)

1. Frontend **does not** send `model` (see `llm-client.js`, Arduino adapter).
2. Go `applyTierChatModel` reads `ai_plans.model_id` for the user’s tier.
3. If the model is missing or not **chat**-capable, gateway falls back to `models.yaml` → `default_model`.

### Change Pro’s model

```sql
-- Must exist in config/models.yaml with modality "chat"
UPDATE ai_plans SET model_id = 'gpt-5.4' WHERE plan_id = 'pro';
UPDATE ai_plans SET model_id = 'gpt-5.4-mini' WHERE plan_id = 'free';
UPDATE ai_plans SET model_id = 'gpt-5.4-nano' WHERE plan_id = 'guest';

-- Example: MiMo for Pro only
UPDATE ai_plans SET model_id = 'mimo-v2.5-pro' WHERE plan_id = 'pro';
```

Apply migration `0010_ai_plans_model_id.sql` if the column is missing:

```bash
cd openai-go-api && make d1-migrate-remote
```

### Models you must **not** put on chat tiers

| Model id | Why |
|----------|-----|
| `gpt-5.4-pro`, `gpt-5.5-pro` | **Responses API only** in `models.yaml` — not `/v1/chat/completions` |

To use `*-pro` models you need a `/v1/responses` code path for Pro users (not wired in the assistant today).

### Explicit client override

If the client sends `model` in the JSON body, that wins. Tomcat’s AI proxy only forwards `gpt-*` / `mimo-*` when the client sets them.

### UI: show current model

`GET /v1/ai/quota` (proxied as `/ai-gateway/...` or direct on Go) returns `model_id` in the quota object.

---

## 5. Table cheat sheet

### `ai_plans` — **AI entitlement & marketing (global tiers)**

| Column | Use |
|--------|-----|
| `plan_id` | `guest` \| `free` \| `pro` |
| `monthly_token_limit` | **Enforced** token cap / month |
| `features_json` | JSON array of strings shown in plan picker (“2M tokens”, “No rate limits”) |
| `model_id` | Default chat model when client omits `model` |
| `display_name`, `description` | UI labels |
| `active` | `0` = hide tier |

**Update here:** token limits, feature bullet list, tier default models.

### `billing_plans` — **Checkout catalog (price & Dodo product)**

Primary key: `(plan_key, tool_id)` where `tool_id = ''` is site-wide default.

| Column | Use |
|--------|-----|
| `plan_key` | `monthly` \| `yearly` |
| `tool_id` | `''` = global; else slug e.g. `electronics/arduino-simulator` |
| `product_id` | Dodo product charged at checkout; `NULL` → env `DODO_PRODUCT_PRO_*` |
| `price_amount`, `currency`, `price_label` | Display price (label wins over amount) |
| `name`, `badge`, `description`, `cadence_label` | Checkout card copy |
| `ai_plan_id` | Which `ai_plans` row supplies tokens/features for the picker (default `pro`) |
| `active`, `sort_order` | Visibility and order |

**Deprecated — do not use:** `billing_plans.features_json`, `billing_plans.monthly_token_limit`.

**Update here:** price shown on upgrade modal, which Dodo product is charged, per-tool pricing, cadence/badge text.

### Dodo-related tables (mostly automatic)

| Table | Purpose |
|-------|---------|
| `user_subscriptions` | Subscription state from webhooks |
| `dodo_webhook_events` | Idempotency |
| `dodo_checkout_sessions` | Checkout audit |
| `dodo_payments` | Payment audit |
| `users` | `is_premium`, `premium_until`, `dodo_customer_id` |

---

## 6. Decision tree: “I want to change X”

```
Change monthly AI token limit for all Pro users?
  → UPDATE ai_plans … WHERE plan_id = 'pro'

Change Pro feature bullets in upgrade modal?
  → UPDATE ai_plans SET features_json = '["…"]' WHERE plan_id = 'pro'

Change which LLM Pro users get (when client omits model)?
  → UPDATE ai_plans SET model_id = '…' WHERE plan_id = 'pro'
  → Verify id exists in config/models.yaml (chat modality)

Change global Pro price ($/mo or $/yr)?
  1. Create/update product in Dodo dashboard (real charge amount)
  2. UPDATE billing_plans SET product_id = 'pdt_…', price_amount = … WHERE plan_key = 'monthly' AND tool_id = ''

Lower price on ONE tool only (e.g. Arduino)?
  1. Create separate Dodo product for that price
  2. INSERT/UPDATE billing_plans with tool_id = 'electronics/arduino-simulator'
  3. Frontend must pass toolId to fetchPlans / startCheckout

Add a new billing interval (e.g. quarterly)?
  → Not supported out of the box — needs new plan_key row + Go catalog logic + Dodo product

Hide yearly plan from picker?
  → UPDATE billing_plans SET active = 0 WHERE plan_key = 'yearly' AND tool_id = ''

Manually grant Pro to a user (support)?
  → UPDATE users SET is_premium = 1, premium_until = '…' WHERE id = '…'
  → Prefer fixing subscription via Dodo when possible
```

---

## 7. Adding or changing Pro plans

### A. Global monthly + yearly (default)

**1. Dodo** — create recurring products; note product ids (`pdt_…`).

**2. Env (optional bootstrap)** on Go process:

```bash
DODO_PRODUCT_PRO_MONTHLY=pdt_…
DODO_PRODUCT_PRO_YEARLY=pdt_…
```

**3. D1** — set or override display + product link:

```sql
UPDATE billing_plans SET
  product_id = 'pdt_monthly_live',
  price_amount = 500,
  currency = 'USD',
  name = 'Monthly Pro',
  badge = NULL,
  description = 'Full AI access',
  cadence_label = 'Billed monthly · cancel anytime'
WHERE plan_key = 'monthly' AND tool_id = '';

UPDATE billing_plans SET
  product_id = 'pdt_yearly_live',
  price_amount = 4800,
  currency = 'USD',
  name = 'Yearly Pro',
  badge = 'Best value',
  cadence_label = 'Billed yearly'
WHERE plan_key = 'yearly' AND tool_id = '';
```

**4. D1 `ai_plans`** — what Pro **includes** (tokens, bullets, model):

```sql
UPDATE ai_plans SET
  monthly_token_limit = 2000000,
  features_json = '["2M AI tokens per month","No rate-limit waiting","Priority model"]',
  model_id = 'gpt-5.4'
WHERE plan_id = 'pro';
```

**5. Webhook** — register in Dodo:

`https://8gwifi.org/api/dodo/webhook` → Tomcat → Go `/v1/billing/webhook`

### B. Per-tool pricing (~80% global, some tools cheaper)

**1.** Create tool-specific Dodo product(s).

**2.** Insert tool rows (merge over global at read time):

```sql
INSERT INTO billing_plans (
  plan_key, tool_id, ai_plan_id, product_id, price_amount, currency,
  name, sort_order, description, cadence_label
) VALUES (
  'monthly', 'electronics/arduino-simulator', 'pro', 'pdt_arduino_mo', 300, 'USD',
  'Monthly', 10, 'Pro for Arduino simulator', 'Billed monthly · cancel anytime'
)
ON CONFLICT(plan_key, tool_id) DO UPDATE SET
  product_id = excluded.product_id,
  price_amount = excluded.price_amount,
  currency = excluded.currency,
  updated_at = datetime('now');
```

**3.** Frontend — pass the same slug:

```javascript
import { fetchPlans, startCheckout } from '/modern/js/billing-client.js';

const toolId = 'electronics/arduino-simulator';
const catalog = await fetchPlans(ctx, { toolId });
await startCheckout(ctx, { plan: 'monthly', toolId, returnPath: location.pathname });
```

Arduino adapter sets `toolId: 'electronics/arduino-simulator'` in `arduino-simulator-adapter.js`.

**Important:** Display price in D1 must match the Dodo `product_id` on that row — otherwise users see one price and pay another.

### C. Tool-specific feature **copy** only (same Pro entitlement)

Option 1 — separate `ai_plans` row for marketing:

```sql
INSERT INTO ai_plans (plan_id, display_name, monthly_token_limit, features_json, model_id, active)
VALUES ('pro-arduino', 'Pro', 2000000,
  '["2M tokens","Arduino wiring + code AI","No rate limits"]', 'gpt-5.4', 1);

UPDATE billing_plans SET ai_plan_id = 'pro-arduino'
WHERE tool_id = 'electronics/arduino-simulator';
```

Users still get Pro via `is_premium`; quota remains tied to tier resolution (`pro`), not `ai_plan_id`. The linked `ai_plans` row mainly drives **plan picker display** for that tool’s checkout catalog.

---

## 8. End-to-end subscription flow

```
1. User opens tool → vibe-coding-assistant.js loads fetchPlans(ctx, { toolId })
2. User clicks Upgrade → startCheckout → POST /api/dodo/checkout { plan, tool_id, return_path }
3. Go ResolveCheckoutProduct(tool_id, plan_key) → billing_plans → Dodo product_id
4. User pays on Dodo hosted checkout
5. Dodo POST webhook → users.is_premium=1, premium_until, user_subscriptions upsert
6. User returns with ?checkout=1 → fetchBillingStatus → is_premium true
7. AI calls: Go resolvePlan → pro → ai_plans limits + model_id
8. Tomcat AI proxy: Pro bypasses 5/min rate limit
```

Checkout metadata must include `user_id` (Google sub) — set by Go when creating the session.

---

## 9. Frontend integration

| File | Role |
|------|------|
| `src/main/webapp/modern/js/billing-client.js` | `fetchBillingStatus`, `fetchPlans`, `startCheckout` |
| `src/main/webapp/modern/js/vibe-coding-assistant.js` | Plan picker UI, tier badge, quota display |
| `src/main/webapp/modern/js/ai/adapters/*-adapter.js` | Per-tool `toolId` for plans/checkout/analytics |

Tomcat routes (`web.xml`):

| Public URL | Go route |
|------------|----------|
| `GET /api/billing/plans` | `GET /v1/billing/plans` |
| `GET /api/billing/status` | `GET /v1/billing/status` |
| `POST /api/dodo/checkout` | `POST /v1/billing/checkout` |
| `POST /api/dodo/webhook` | `POST /v1/billing/webhook` |

Tomcat needs `AI_GATEWAY=http://127.0.0.1:8084` (or internal IP). See [`DODO_BILLING_ENV.md`](../../docs/DODO_BILLING_ENV.md).

---

## 10. Migrations

Apply all pending migrations to shared D1:

```bash
cd openai-go-api
make d1-migrate-remote
```

| Migration | Adds |
|-----------|------|
| `0004_ai_plans` | `ai_plans`, usage periods |
| `0005_dodo_subscriptions` | Dodo tables, `users.is_premium` |
| `0006_billing_plans` | Checkout catalog |
| `0007` | Plan picker details on billing_plans (partially superseded) |
| `0008` | `features_json` on **ai_plans**; link `billing_plans.ai_plan_id` |
| `0009` | `tool_id` on **billing_plans** (per-tool pricing) |
| `0010` | `model_id` on **ai_plans** (tier model routing) |
| `0011` | `tool_tier_models` (per-tool free/pro model overrides) |
| `0012` | Pro catalog copy — `ai_plans` features + model marketing |

Column-level detail: [`db/SUBSCRIPTIONS.md`](../db/SUBSCRIPTIONS.md).

---

## 11. Environment variables (quick reference)

**Go process** — full list in [`.env.example`](../.env.example) and [`DODO_BILLING_ENV.md`](../../docs/DODO_BILLING_ENV.md).

| Variable | When to set |
|----------|-------------|
| `DODO_PAYMENTS_API_KEY` | Checkout |
| `DODO_PAYMENTS_WEBHOOK_KEY` | Webhook verification |
| `DODO_PAYMENTS_MODE` | `test` or `live` |
| `DODO_PRODUCT_PRO_MONTHLY` / `YEARLY` | Fallback if `billing_plans.product_id` NULL |
| `CLOUDFLARE_*`, `D1_DATABASE_ID` | D1 access |
| `AI_QUOTA_*` | Emergency fallback token limits |
| `DEFAULT_MODEL` / `MODEL_CATALOG_PATH` | Gateway default model file |
| `BILLING_INTERNAL_SECRET` | Protects `POST /v1/billing/users/upsert` |

**Tomcat:** `AI_GATEWAY` (required in prod).

---

## 12. Common SQL recipes

```sql
-- See current tiers
SELECT plan_id, display_name, monthly_token_limit, model_id, features_json FROM ai_plans;

-- See checkout catalog (global)
SELECT plan_key, tool_id, product_id, price_amount, currency, ai_plan_id, active
FROM billing_plans ORDER BY tool_id, sort_order;

-- See checkout catalog for one tool (merged view is computed in Go; inspect both rows)
SELECT * FROM billing_plans
WHERE tool_id IN ('', 'electronics/arduino-simulator') AND active = 1;

-- Check if user is Pro
SELECT id, is_premium, premium_until FROM users WHERE id = '<google_sub>';
```

---

## 13. Troubleshooting

| Symptom | Check |
|---------|--------|
| Plan picker empty | `billing_plans.active=1`; Dodo env products set; Go logs `dodo plans:` |
| Wrong price at checkout | `billing_plans.product_id` vs Dodo product amount; tool_id on checkout POST |
| Paid but still Free tier | Webhook delivery; `users.is_premium`; `premium_until` in future |
| Pro but still rate limited | Tomcat premium cache (5 min); billing status reachable from Tomcat |
| Pro but wrong model | `ai_plans.model_id`; model in `models.yaml` with `chat`; client not sending `model` |
| Quota not updating | `ai_usage_periods`; `AI_QUOTA_ENABLED`; D1 connectivity |
| Migration missing column | `make d1-migrate-remote` |

---

## 14. Key source files

| Area | Path |
|------|------|
| Plans catalog + checkout | `openai-go-api/internal/billing/dodo/service.go` |
| Per-tool plan merge | `openai-go-api/internal/billing/dodo/plans_tool.go` |
| AI quota + tiers | `openai-go-api/internal/billing/quota_d1.go`, `ai_plans_d1.go` |
| Tier → model on chat | `openai-go-api/internal/handler/tier_model.go`, `chat.go` |
| HTTP routes | `openai-go-api/internal/handler/billing.go` |
| Tomcat billing proxy | `src/main/java/z/y/x/billing/BillingGatewayProxyServlet.java` |
| Tomcat AI + Pro rate bypass | `src/main/java/z/y/x/ai/AIGatewayProxyServlet.java` |
| Model catalog | `openai-go-api/config/models.yaml` |

---

*Last updated: migrations through `0010_ai_plans_model_id`.*
