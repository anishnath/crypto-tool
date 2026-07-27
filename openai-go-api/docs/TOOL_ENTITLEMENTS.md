# Tool-scoped entitlements

**Status:** implemented (Manic is the reference tool)  
**Related:** [`BILLING.md`](./BILLING.md) · onecompiler [`MANIC_API.md`](../../../onecompiler/MANIC_API.md) · crypto-tool `ManicServlet`

This doc is the **commercial + entitlement** source of truth for “who is on which plan for which tool.”  
onecompiler / Manic **meters** render and voice usage for a plan slug; it does **not** sell subscriptions or decide who paid.

**Adding a new tool?** Start at **[§14 — Runbook: add a tool-specific plan](#14-runbook-add-a-tool-specific-plan-manic-template)**. Manic is the complete template.

---

## 1. Goals

1. **Tool-specific prices** — Manic Pro can cost more than Arduino Pro; catalog stays in `billing_plans (plan_key, tool_id)`.
2. **Tool-specific entitlement** — paying for tool A does not unlock expensive COGS on tool B (e.g. Arduino Pro ≠ Cartesia on Manic).
3. **Inclusive coverage from higher plans** — Manic Pro (higher price) may grant **Pro on cheaper tools**. Coverage is explicit, not inferred from dollar amount at runtime.
4. **One plan vocabulary** — `guest | free | pro | ultra` everywhere (UI, AI gateway, ManicServlet, MANIC_API).
5. **One commercial brain** — checkout, Dodo, subscriptions, upgrade UI live here (openai-go-api). No second billing system in onecompiler.
6. **Hard stop when expired** — subscription period end **or** exhausted AI tokens / Manic meters → capability stops.

---

## 2. Ownership split

| Concern | Owner | Notes |
|---|---|---|
| List price, Dodo `product_id`, checkout copy | **openai-go-api** `billing_plans` | Per `tool_id` |
| Who paid / active plan for a tool | **openai-go-api** entitlements | Per `(user_id, tool_id)` |
| Coverage (“Manic Pro includes Arduino Pro”) | **openai-go-api** coverage table | Explicit rows |
| AI tokens + default model | **openai-go-api** `ai_plans` (+ `tool_tier_models`) | Same plan slug |
| Manic render fps/scale/brand | **onecompiler** `manic_plans[slug]` | Capability map |
| Manic voice providers + credit budgets | **onecompiler** `manic_plans` + voice meters | Capability + meter |
| Inject trusted `plan` on render | **ManicServlet** (crypto-tool) | Never trust browser |
| Voice/render burn accounting | **onecompiler** | Cache hits / soft-fail → bill 0 |

```text
Browser (manic UI)
  ├─ AI assistant     → openai-go-api (tool_id=developer-tools/manic)
  ├─ Upgrade/checkout → openai-go-api billing_plans for that tool_id
  └─ Render/limits    → ManicServlet → onecompiler MANIC_API
                              ↑ injects plan slug from entitlement API
```

**Rule:** The plan slug answers “what is the user getting?”  
Money and who-has-slug live here. What Manic burns for that slug lives in onecompiler.

---

## 3. Plan slugs (product the user gets)

| Slug | Who | Typical Manic meaning (enforced in onecompiler) |
|---|---|---|
| `guest` | Anonymous | Silent / tight; no paid TTS |
| `free` | Logged in, no covering paid sub | gTTS only, low caps, branded |
| `pro` | Paid tool Pro (or covered by higher plan) | Cartesia + render Pro + AI Pro tokens |
| `ultra` | Paid Manic Ultra (Manic-only at first) | + ElevenLabs, more credits, 4K |

UI copy sells **Manic Pro / Manic Ultra** (tool-specific products).  
Capabilities for each slug are listed in the tool’s upgrade modal (`ai_plans.features_json` + Manic capability summary from limits).

---

## 4. Entitlement model

### 4.1 Per-tool record (target)

Replace authorization that depends only on global `users.is_premium` with:

```text
user_tool_entitlements
  user_id
  tool_id              -- e.g. developer-tools/manic
  plan_slug            -- free|pro|ultra  (guest is not stored; implied for anon)
  status               -- active|canceled|past_due|expired
  source_product_id    -- Dodo product
  source_subscription_id
  current_period_end
  created_at / updated_at
  PRIMARY KEY (user_id, tool_id)
```

Webhook / checkout success:

```text
Dodo product_id
  → billing_plans row (tool_id, plan_key, ai_plan_id → plan_slug)
  → UPSERT user_tool_entitlements(user, tool_id, plan_slug, active, period_end)
```

`users.is_premium` may remain a **derived badge** (“has any active pro+”) for legacy UI.  
**Authorization must use tool-scoped entitlement** (plus coverage).

### 4.2 Coverage (higher plan includes cheaper tools)

Explicit table — do **not** compare prices at runtime:

```text
plan_coverage
  purchased_tool_id     -- developer-tools/manic
  purchased_plan        -- pro | ultra
  covers_tool_id        -- electronics/arduino-simulator
  grants_plan           -- pro
  PRIMARY KEY (purchased_tool_id, purchased_plan, covers_tool_id)
```

**Agreed defaults**

| Purchased | Grants on Manic | Grants on cheaper tools |
|---|---|---|
| Manic Pro | `pro` | `pro` |
| Manic Ultra | `ultra` | `pro` |
| Arduino / other-tool Pro (cheap or global) | **none — Manic stays `free`/`guest`** | `pro` on that tool (today via global `is_premium`) |
| Legacy global `is_premium` (no Manic product) | **none** — users never paid for Manic; do **not** grandfather onto Manic Pro | unchanged for non-Manic tools |

**Manic has no existing paid cohort.** Current Pro users are on other tools / site-wide Pro.
Do not map `is_premium → manic pro` — that would unlock Cartesia for people who did not buy Manic.

Resolution for a request on tool `T`:

```text
1. If anonymous → guest
2. Direct entitlement(user, T) if active and not expired → that plan_slug
3. Else best covering purchase:
     active entitlement(user, P) where plan_coverage(P.tool, P.plan) covers T
     → grants_plan (pick highest rank if multiple)
4. Else logged-in → free
5. Enforce meters for that slug on T
```

**Rank for “best”:** `ultra > pro > free > guest`.

### 4.3 Expiry / stop conditions

| Event | Effect |
|---|---|
| `current_period_end` passed / status not active | Entitlement gone → resolve again → usually `free` |
| AI monthly tokens exhausted | AI calls stop (`quota_exceeded`); render may still work if Manic meters remain |
| Manic render or voice credits exhausted | That Manic action stops; AI may still work if tokens remain |
| Soft-fail TTS | Video may still ship; voice credits not billed for failed cold cues |

---

## 5. Manic product packaging (catalog intent)

`tool_id = developer-tools/manic`

| Product | Cadence | Target list price | plan_slug | AI allotment | Includes |
|---|---|---:|---|---|---|
| Manic Pro | monthly / yearly | **$9 / mo** ($90/yr) | `pro` | `manic_pro` (500k tokens) | Cartesia + Pro render + Pro on cheaper tools |
| Manic Ultra | monthly / yearly | **$29 / mo** ($290/yr) | `ultra` | `ultra` (1.5M tokens) | + ElevenLabs + higher Manic meters + 4K |

Checkout rows live in `billing_plans` with that `tool_id`.  
**onecompiler does not own these prices.** Optional display fields in Manic limits are denormalized hints only.

Voice credit **packs** (overage): sell as Dodo one-time / subscription add-ons here; grant pack balance that onecompiler can debit (see §7). Prefer billing to record the purchase; onecompiler to meter burn.

---

## 6. API sketch (openai-go-api)

### 6.1 Entitlement for a tool — trusted callers + UI

`GET /v1/billing/entitlement?tool_id=developer-tools/manic`

Headers: `X-User-Id` (logged in) or anonymous id.

```json
{
  "tool_id": "developer-tools/manic",
  "plan": "pro",
  "source": {
    "kind": "direct",
    "tool_id": "developer-tools/manic",
    "product_id": "pdt_…",
    "current_period_end": "2026-08-24T00:00:00Z"
  },
  "covers": [
    { "tool_id": "electronics/arduino-simulator", "grants_plan": "pro" }
  ],
  "ai": {
    "plan": "pro",
    "model_id": "…",
    "monthly_token_limit": 2000000,
    "tokens_remaining": 1500000
  },
  "upgrade": {
    "available": ["ultra"],
    "checkout_tool_id": "developer-tools/manic"
  }
}
```

Coverage example when user bought Manic Pro but opens Arduino:

```json
{
  "tool_id": "electronics/arduino-simulator",
  "plan": "pro",
  "source": {
    "kind": "coverage",
    "tool_id": "developer-tools/manic",
    "purchased_plan": "pro"
  }
}
```

### 6.2 Status (evolve)

`GET /v1/billing/status` today returns global `is_premium`.  
Extend (backward compatible):

```json
{
  "is_premium": true,
  "premium_until": "…",
  "entitlements": [
    { "tool_id": "developer-tools/manic", "plan": "pro", "current_period_end": "…" }
  ]
}
```

ManicServlet must use `GET …/entitlement?tool_id=developer-tools/manic` only —
**never** fall back to global `is_premium` (other-tool Pro ≠ Manic Pro).

### 6.3 Plans catalog (unchanged idea)

`GET /v1/billing/plans?tool_id=developer-tools/manic`  
→ prices + feature bullets for upgrade modal (tool-specific).

---

## 7. Bridge: ManicServlet

File: `crypto-tool/.../manic/servlet/ManicServlet.java`

**Target (Manic is new — no grandfather from global Pro):**

```text
anon                         → plan=guest
logged-in, no Manic purchase → plan=free   (even if is_premium from another tool)
Manic Pro / Ultra purchase   → plan=pro | ultra
inject                       → POST /api/manic { plan, userid }  (client plan ignored)
limits                       → GET /api/manic/limits?plan=<slug>&user=<id>
```

Resolve via `GET /v1/billing/entitlement?tool_id=developer-tools/manic` only.

Upgrade CTAs in the manic UI use **billing plans / checkout** for `developer-tools/manic`, not Manic API prices.

---

## 8. onecompiler role (meters only)

See onecompiler [`MANIC_API.md`](../../../onecompiler/MANIC_API.md).

- Trust API-key callers (ManicServlet).
- `manic_plans[plan]` = render + voice **capabilities** and **limits**.
- Meter renders + Manic voice credits (bill cold TTS only).
- Return `voice.mode` / remaining credits for UI.
- Do **not** implement Dodo checkout or decide `is_premium`.

Suggested pack flow later:

```text
User buys voice_pack_100k on openai-go-api
  → grant record (user, credits, expires)
  → ManicServlet or internal API informs onecompiler pack balance
  → onecompiler draws included monthly credits first, then packs
```

---

## 9. AI + Manic on the same page

One Manic subscription → one plan slug for the tool:

| Action | Gate |
|---|---|
| AI generate/fix manic | openai-go-api tokens for `developer-tools/manic` plan |
| Render / voice | same slug → onecompiler meters |

Do not sell separate “AI Pro” and “Render Pro” for Manic unless product explicitly requires two checkouts.

Included cheaper tools share the **covering subscription’s AI token pool** (simplest). When tokens hit zero, AI stops on every tool that pool covered.

---

## 10. Current implementation map (read before coding)

Verified against Go source — this is what must keep working.

### 10.1 What exists today

```text
ResolveToolEntitlement(user, tool_id)
  → guest | free | pro | ultra     (TOOL-SCOPED)
  Manic: never falls back to users.is_premium

resolvePlan(user) for AI quota
  → if tool_id = developer-tools/manic: use entitlement (pro → manic_pro AI row)
  → else: global is_premium / premium_until (legacy tools)

billing_plans.tool_id + product_id  →  checkout PRICE + webhook → user_tool_entitlements
Checkout metadata also carries tool_id + ai_plan_id

Webhook grantSubscription
  → user_subscriptions (+ plan_key still often 'pro')
  → users.is_premium = 1 (legacy dual-write for non-Manic tools)
  → SyncToolEntitlementsFromSubscriptions → user_tool_entitlements
```

| Area | Key files |
|---|---|
| Tool entitlement | `internal/billing/entitlement.go` — `ResolveToolEntitlement`, sync, coverage |
| Plan resolve (AI) | `internal/billing/quota_d1.go` — `resolvePlan` (Manic branch ignores is_premium) |
| Plan constants | `internal/billing/quota.go` + `PlanUltra` / `PlanManicPro` in entitlement.go |
| AI plans / quota | `internal/billing/ai_plans_d1.go`, `quota_d1.go` |
| Dodo webhook/checkout | `internal/billing/dodo/service.go` — `grantSubscription`, `CreateCheckout` |
| Tool price merge | `internal/billing/dodo/plans_tool.go` |
| HTTP | `internal/handler/billing.go` — status, plans, **entitlement**, checkout, webhook |
| Identity | `internal/billing/identity.go` — `X-User-Id` > Bearer > `X-Anonymous-Id` |

### 10.2 API contracts callers depend on

| Route | Must keep |
|---|---|
| `GET /v1/billing/status` | `is_premium` (bool), `premium_until`, `subscription`, `user_id` — **ManicServlet**, `AIGatewayProxyServlet`, `billing-client.js`, `BillingPageSupport` |
| `GET /v1/billing/plans?tool=` | Merge tool over global; fields `plans`, `ai_tiers`, `pricing_scope`, `tool_id` |
| `POST /v1/billing/checkout` | Requires `X-User-Id`; body `plan` (monthly/yearly), `tool_id` |
| `POST /v1/billing/webhook` | Idempotent on `webhook-id`; grant/revoke global premium |
| AI quota 402 | `code: ai_quota_exceeded` + embedded quota object |

**Status shape today (do not remove fields):**

```json
{
  "user_id": "…",
  "email": "…",
  "is_premium": true,
  "premium_until": "…",
  "dodo_customer_id": "…",
  "subscription": { "plan_key": "pro", "status": "…", "current_period_end": "…" }
}
```

Additive only: `entitlements[]` later. Never rename/remove `is_premium` until every caller migrates.

### 10.3 External callers

| Caller | Behavior today |
|---|---|
| **ManicServlet** | Uses `GET /v1/billing/entitlement?tool_id=developer-tools/manic` only — **no** `is_premium` fallback (60s cache) |
| **AIGatewayProxyServlet** | Pro bypasses Tomcat 5/min AI rate limit via global status (`is_premium`) — still global for rate-limit |
| **billing-client.js** | `fetchBillingStatus`; `fetchEntitlement(toolId)`; `fetchPlans(toolId)`; checkout with `tool_id` |
| **manic-ai.js / VCA** | `toolId: developer-tools/manic`; billing bar uses entitlement, not `is_premium` |

### 10.4 Tests that lock behavior

| Test | Locks |
|---|---|
| `identity_test.go` | User header beats anon |
| `quota_test.go` | Guest quota; CheckAIQuota needs identity |
| `ai_plans_d1_test.go` | TierModelID / ListAIPlans order |
| `dodo/plans_tool_test.go` | `mergePlanOverride`, tool pricing scope |
| `dodo/payload_test.go` | Webhook field extraction |

**Missing tests today (add before/with entitlements):** webhook grant/revoke, `BillingStatus` JSON, `userIsPro` expiry edges, entitlement resolution + coverage.

### 10.5 Critical invariants (no regression)

1. Keep writing **global** `users.is_premium` / `premium_until` on every webhook grant/revoke (dual-write with tool rows) so **non-Manic** tools keep working.
2. Keep `GET /v1/billing/status` → `is_premium` for AI gateway / billing-client / other tools — ManicServlet must **not** use it for Manic plan.
3. Keep global `resolvePlan` for AI on non-Manic tools; Manic AI uses tool entitlement when `X-Tool-Id=developer-tools/manic`.
4. Keep checkout product resolution: tool `billing_plans` → global `tool_id=''` → env `DODO_PRODUCT_PRO_*`.
5. Keep webhook idempotency + require recoverable `user_id`.
6. Do not change hardcoded `user_subscriptions.plan_key = 'pro'` without a dual-read migration (status view depends on it).
7. `X-Tool-Id` must not suddenly paywall pages that are free today — entitlement is opt-in per expensive tool.

---

## 11. Migration from global `is_premium` (safe order)

1. **Additive migration** — `user_tool_entitlements`, `plan_coverage`. No auth change.
2. **Dual-write webhook** — on grant/revoke, UPSERT tool entitlement from `product_id` → `billing_plans.tool_id` + `ai_plan_id`; **still** run existing `grantSubscription` / `syncEntitlement`.
3. **Backfill** — only for subscriptions tied to a real `tool_id` / Manic product. **Never** invent Manic `pro` from bare `is_premium`.
4. **Additive API** — `GET /v1/billing/entitlement?tool_id=`; optional `entitlements[]` on status; keep `is_premium` for other tools.
5. **ManicServlet** — Manic entitlement only; anon → `guest`; no Manic purchase → `free` even if globally premium.
6. **Seed** Manic Pro/Ultra products + coverage (Manic → cheaper tools as `pro`).
7. **Manic AI** — tool-scoped resolve when `X-Tool-Id=developer-tools/manic`; other tools keep global `resolvePlan` (existing Pro users unchanged on Arduino etc.).
8. Wire or delete dead `ResolveChatModel` / `tool_tier_models` path.

---

## 12. Decision log (locked)

| # | Decision |
|---|---|
| 1 | Tool-specific checkout prices via `billing_plans.tool_id` |
| 2 | Tool-specific entitlement `(user, tool_id) → plan_slug` |
| 3 | Manic Pro/Ultra **include** cheaper tools as `pro` via explicit coverage |
| 4 | Cheaper / legacy global Pro does **not** include Manic (no grandfather; Manic has no prior cohort) |
| 5 | Shared plan slugs: `guest \| free \| pro \| ultra` |
| 6 | openai-go-api = money + who; onecompiler = Manic capability + meters |
| 7 | Voice usage meter stays in onecompiler |
| 8 | Plan slug defines what the user is getting (AI + Manic capabilities) |
| 9 | Expiry or exhausted tokens/credits → hard stop |
| 10 | Manic AI + render/voice share one Manic purchase |

---

## 13. Implementation checklist

- [x] Migration: `user_tool_entitlements`, `plan_coverage` (`migrations/0015_user_tool_entitlements.sql`)
- [x] Webhook dual-write: `SyncToolEntitlementsFromSubscriptions` after grant/revoke
- [x] `GET /v1/billing/entitlement?tool_id=` (+ Tomcat `/api/billing/entitlement`)
- [x] Extend `/v1/billing/status` with `entitlements[]`
- [x] Seed Manic `billing_plans` + coverage rows (Dodo `product_id`s in `0015`/`0016`; expand coverage in `0017`)
- [x] ManicServlet: guest/free/pro/ultra from Manic entitlement only (no `is_premium` fallback)
- [x] Manic AI path: `resolvePlan` uses tool entitlement when `X-Tool-Id=developer-tools/manic`
- [x] manic UI: upgrade via entitlement + Ultra SKUs in plan picker; AI rate-limit bypass via Manic entitlement
- [x] onecompiler: voice meters + pack balances + `manic_plans` capabilities (see MANIC_API.md)
- [ ] Update [`BILLING.md`](./BILLING.md) §1 once live (retire “is_premium only” wording)

---

## 14. Runbook: add a tool-specific plan (Manic template)

Two patterns exist. Pick the right one before creating Dodo products.

| Pattern | When | Entitlement | Example |
|---|---|---|---|
| **A. Price override only** | Same Pro unlock as site-wide; only the checkout price/copy differs | Still `users.is_premium` / global Pro | Arduino cheaper monthly |
| **B. Tool-scoped entitlement** | Expensive COGS / new product; other-tool Pro must **not** unlock it | `(user_id, tool_id) → plan_slug` | **Manic** |

Manic is **pattern B**. Follow every step below for the next expensive tool (e.g. a future “Studio” or “Optics Pro”).

### 14.1 Checklist (pattern B)

```text
1. Choose tool_id slug          e.g. developer-tools/manic
2. Decide plan ladder           guest | free | pro [| ultra]
3. Create Dodo subscription products (unique pdt_ per SKU)
4. Optional: dedicated ai_plans row if AI budget ≠ global Pro
5. INSERT billing_plans rows    tool_id + product_id + ai_plan_id + display price
6. Optional: plan_coverage      “this purchase grants Pro on cheaper tools”
7. Wire trusted injector        servlet/proxy injects plan from entitlement API
8. Wire AI (if needed)          resolvePlan branches on X-Tool-Id == tool_id
9. UI                           fetchPlans / startCheckout / entitlement with toolId
10. Downstream meters           onecompiler (or tool service) keys off plan slug only
11. Apply D1 migration          never ship Go before tables + product_ids
12. Test                        anon→guest, global-Pro→free on new tool, buy→pro
```

### 14.2 Step-by-step (copy Manic)

#### 1) Pick a stable `tool_id`

Must match `X-Tool-Id` / AI assistant `toolId` / checkout body.

```text
developer-tools/manic
```

Convention: `{category}/{tool-slug}` (same as other 8gwifi tools).

#### 2) Create Dodo products

Dashboard → **Products → Create** → pricing type **Subscription**.

One **unique** `pdt_…` per SKU (never reuse another plan’s id):

| SKU | Interval | Manic example `product_id` |
|---|---|---|
| `{Tool} Pro Monthly` | month | `pdt_0Nk4fuArwE5DmcpU2bF7G` |
| `{Tool} Pro Yearly` | year | `pdt_0Nk4gFJ4fIn0gbPOqxeeN` |
| `{Tool} Ultra Monthly` | month | `pdt_0Nk4i8U92nyoPRLkfyvWN` |
| `{Tool} Ultra Yearly` | year | `pdt_0Nk4hpnw3U9dBNkxN7X9u` |

- **Charge amount** lives in Dodo (money authority).
- Display in D1 must **match** that charge (`price_label` / `price_amount`).
- Use Test mode first; recreate or mirror products in Live.

Webhook (once per environment): `https://8gwifi.org/api/dodo/webhook`

#### 3) AI allotment (optional but recommended for cheap entry)

If the tool’s Pro should not inherit the full global Pro token pool, add a dedicated `ai_plans` row and point `billing_plans.ai_plan_id` at it.

Manic:

| `ai_plans.plan_id` | Tokens | Used when |
|---|---:|---|
| `manic_pro` | 500_000 | Manic entitlement = `pro` + `X-Tool-Id=developer-tools/manic` |
| `ultra` | 1_500_000 | Manic entitlement = `ultra` |

**Important:** `user_tool_entitlements.plan_slug` stays `pro` | `ultra` | `free` (CHECK constraint).  
`manic_pro` is an **AI allotment id**, not an entitlement slug.  
`normalizePlanSlug("manic_pro")` → `pro` for entitlement storage; `resolvePlan` maps Manic+pro → `manic_pro` for quota.

#### 4) Seed `billing_plans`

```sql
INSERT INTO billing_plans (
  plan_key, tool_id, product_id, billing_interval, ai_plan_id, name,
  price_amount, currency, price_label, badge, description, cadence_label,
  sort_order, active
) VALUES
(
  'monthly', 'developer-tools/manic', 'pdt_…', 'month', 'manic_pro', 'Manic Pro',
  900, 'USD', '$9/mo', 'Popular',
  '…', 'Billed monthly · cancel anytime', 10, 1
),
(
  'yearly', 'developer-tools/manic', 'pdt_…', 'year', 'manic_pro', 'Manic Pro (yearly)',
  9000, 'USD', '$90/yr', 'Save 2 months',
  '…', 'Billed yearly · cancel anytime', 20, 1
),
(
  'ultra_monthly', 'developer-tools/manic', 'pdt_…', 'month', 'ultra', 'Manic Ultra',
  2900, 'USD', '$29/mo', 'Ultra',
  '…', 'Billed monthly · cancel anytime', 30, 1
),
(
  'ultra_yearly', 'developer-tools/manic', 'pdt_…', 'year', 'ultra', 'Manic Ultra (yearly)',
  29000, 'USD', '$290/yr', 'Ultra',
  '…', 'Billed yearly · cancel anytime', 40, 1
)
ON CONFLICT(plan_key, tool_id) DO UPDATE SET
  product_id = excluded.product_id,
  ai_plan_id = excluded.ai_plan_id,
  price_amount = excluded.price_amount,
  price_label = excluded.price_label,
  -- …other display fields…
  active = 1,
  updated_at = datetime('now');
```

Reference migrations: `0015_user_tool_entitlements.sql`, `0016_manic_dodo_products.sql`.

#### 5) Coverage (optional)

If buying this tool should unlock Pro on cheaper tools:

```sql
INSERT INTO plan_coverage (purchased_tool_id, purchased_plan, covers_tool_id, grants_plan)
VALUES
  ('developer-tools/manic', 'pro', 'electronics/arduino-simulator', 'pro'),
  ('developer-tools/manic', 'ultra', 'electronics/arduino-simulator', 'pro')
ON CONFLICT DO UPDATE SET grants_plan = excluded.grants_plan;
```

Do **not** add reverse coverage (Arduino → Manic). Expensive tools are never grandfathered from global / cheap Pro.

#### 6) Trusted plan injector (Tomcat)

Pattern from `ManicServlet`:

1. Anon → inject `plan=guest`
2. Logged-in → `GET {AI_GATEWAY}/v1/billing/entitlement?tool_id=…` with `X-User-Id`
3. Inject returned `plan` (`free`|`pro`|`ultra`) into upstream body/query
4. **Never** use `GET /v1/billing/status` → `is_premium` for this tool
5. Fail closed to `free` on gateway errors (cache carefully — long TTL freezes wrong tier)

Proxy route already exists: `/api/billing/entitlement` → Go.

#### 7) AI path (Go)

In `resolvePlan` (`quota_d1.go`): when `user.ToolID == "<your-tool-id>"`, call `ResolveToolEntitlement` and **ignore** `users.is_premium`.

Optional: map entitlement `pro` → dedicated AI plan id (as Manic → `manic_pro`).

Ensure the assistant / proxy sends `X-Tool-Id` on chat/completions.

#### 8) UI

```javascript
const toolId = 'developer-tools/manic';

// Catalog (prices for this tool)
await fetchPlans(ctx, { toolId });

// Checkout
await startCheckout(ctx, {
  plan: 'monthly',           // or ultra_monthly / yearly / …
  toolId,
  returnPath: location.pathname,
});

// Who am I on this tool? (not global is_premium)
const ent = await fetch('/api/billing/entitlement?tool_id=' + encodeURIComponent(toolId));
// ent.plan → guest | free | pro | ultra
```

AI adapter must set `toolId` (Manic: `manic-ai.js`).  
Upgrade bar / rate-limit for Manic read **entitlement** (`pro`|`ultra`), not global `is_premium`.
Plan picker shows Ultra SKUs when catalog includes `ultra_monthly` / `ultra_yearly`.
Coverage seeds: migration `0017_manic_plan_coverage_expand.sql`.

#### 9) Downstream capability service

onecompiler (or your tool backend) receives only the **slug**:

| Slug | Meaning |
|---|---|
| `guest` | Anonymous caps |
| `free` | Logged-in unpaid |
| `pro` / `ultra` | Paid capability rows |

No Dodo, no `is_premium`, no prices in that service — only `manic_plans`-style capability + meters.

#### 10) Ship order

1. Apply D1 migrations (`user_tool_entitlements`, `plan_coverage`, `billing_plans` rows, `ai_plans`)
2. Deploy Go (webhook dual-write + entitlement API + resolvePlan branch)
3. Deploy Tomcat injector / proxy
4. Smoke test (below)

Deploying Go **before** `user_tool_entitlements` exists can break webhook upserts — migrate first.

### 14.3 Smoke tests

| Case | Expected |
|---|---|
| Anonymous | entitlement `guest`; injector sends `guest` |
| Logged-in, never bought this tool (even if global Pro) | entitlement `free` |
| Buy `{Tool} Pro` | webhook → `user_tool_entitlements` `pro`; injector `pro` |
| Buy Ultra | entitlement `ultra` |
| Cancel / expiry | sync → expired; back to `free` |
| Coverage row | buying Manic Pro → Arduino resolves `pro` via coverage |
| Wrong product_id / NULL | checkout fails with product not configured |

### 14.4 Pattern A reminder (price only)

If you only need a different sticker price and **global Pro is enough**:

1. Create Dodo product(s)
2. `INSERT billing_plans` with `tool_id` + `product_id` + `ai_plan_id='pro'`
3. Pass `toolId` into `fetchPlans` / `startCheckout`
4. **Do not** branch `resolvePlan` on that tool — keep `is_premium`

See [`BILLING.md`](./BILLING.md) §7.B.

### 14.5 File map (Manic)

| Layer | File / artifact |
|---|---|
| Schema + seed | `migrations/0015_user_tool_entitlements.sql`, `0016_manic_dodo_products.sql` |
| Resolve / upsert | `internal/billing/entitlement.go` |
| AI plan branch | `internal/billing/quota_d1.go` (`ToolIDManic`) |
| Webhook dual-write | `internal/billing/dodo/service.go` (`grantSubscription` / `syncEntitlement`) |
| Checkout metadata | `CreateCheckout` → `tool_id`, `ai_plan_id` |
| HTTP | `GET /v1/billing/entitlement`, status `entitlements[]` |
| Tomcat proxy | `BillingGatewayProxyServlet` `/api/billing/entitlement` |
| Injector | `ManicServlet` |
| UI tool id | `manic/index.jsp` → `aiToolId`, `manic-ai.js` |
| Meters | onecompiler `manic_plans` + `MANIC_API.md` |

### 14.6 Decision cheat-sheet

```text
Is COGS or product new/expensive, and old Pro users should NOT get it?
  YES → Pattern B (this runbook). Manic template.
  NO  → Pattern A (price row only). BILLING.md §7.B.

Should buying this unlock Arduino / other cheap tools?
  YES → plan_coverage rows (explicit).
  NO  → skip coverage.

Should AI tokens be lower than global Pro?
  YES → new ai_plans id (e.g. manic_pro) + resolvePlan map.
  NO  → ai_plan_id = 'pro' or 'ultra'.
```
