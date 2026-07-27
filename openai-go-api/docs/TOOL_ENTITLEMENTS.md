# Tool-scoped entitlements — design draft

**Status:** draft (agreed direction; not fully implemented yet)  
**Related:** [`BILLING.md`](./BILLING.md) · onecompiler [`MANIC_API.md`](../../../onecompiler/MANIC_API.md) · crypto-tool `ManicServlet`

This doc is the **commercial + entitlement** source of truth for “who is on which plan for which tool.”  
onecompiler / Manic **meters** render and voice usage for a plan slug; it does **not** sell subscriptions or decide who paid.

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
resolvePlan(user)  →  guest | free | pro     (GLOBAL; ignores tool_id)
                      ↑
                 userIsPro ← users.is_premium + premium_until

billing_plans.tool_id  →  checkout PRICE / catalog only
X-Tool-Id              →  analytics + plans?tool= merge; NOT entitlement

Webhook grantSubscription
  → user_subscriptions.plan_key HARDCODED 'pro'
  → users.is_premium = 1, premium_until = period_end
  → does NOT write tool-scoped rows (tool_id in checkout metadata unused for auth)
```

| Area | Key files |
|---|---|
| Plan resolve | `internal/billing/quota_d1.go` — `resolvePlan`, `userIsPro` |
| Plan constants | `internal/billing/quota.go` — `PlanGuest`, `PlanFree`, `PlanPro` (no `ultra`) |
| AI plans / quota | `internal/billing/ai_plans_d1.go`, `quota_d1.go` |
| Tool tier models | `internal/billing/tool_tier_models.go` — **`ResolveChatModel` has no callers**; chat uses `TierModelID` / `ai_plans` only |
| Dodo webhook/checkout | `internal/billing/dodo/service.go` — `grantSubscription`, `syncEntitlement`, `CreateCheckout`, `BillingStatus` |
| Tool price merge | `internal/billing/dodo/plans_tool.go` — `mergePlanOverride`, `ResolveCheckoutProduct` |
| HTTP | `internal/handler/billing.go`, `quota.go`, `chat.go` — routes in `internal/server/server.go` |
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
| **ManicServlet** | Today may use `is_premium`; **target:** Manic purchase only — **no** `is_premium` fallback (Manic is new; other-tool Pro must not unlock Manic) |
| **AIGatewayProxyServlet** | Pro bypasses Tomcat 5/min AI rate limit via same status |
| **billing-client.js** | `is_premium`; `fetchPlans(toolId)`; checkout with `tool_id` |
| **manic-ai.js** | `toolId: developer-tools/manic` for plans/checkout/analytics |

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
- [x] Seed Manic `billing_plans` + coverage rows (set real Dodo `product_id`s before live)
- [x] ManicServlet: guest/free/pro/ultra from Manic entitlement only (no `is_premium` fallback)
- [x] Manic AI path: `resolvePlan` uses tool entitlement when `X-Tool-Id=developer-tools/manic`
- [ ] manic UI: upgrade via billing plans for `developer-tools/manic`
- [ ] onecompiler: voice meters + `manic_plans` capabilities only (see MANIC_API.md)
- [ ] Update [`BILLING.md`](./BILLING.md) §1 once live (retire “is_premium only” wording)
- [ ] Ops: apply migration + set Manic Dodo `product_id`s on `billing_plans`
