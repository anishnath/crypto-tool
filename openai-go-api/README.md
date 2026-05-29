# openai-go-api

Multi-provider LLM gateway in Go. Routes each **model** to its **provider** using a layered config design. Logs token usage to Cloudflare D1 for billing and per-user analytics.

## Architecture

```
HTTP handlers
    -> service.Gateway
        -> registry.Registry (model -> provider backend)
            -> provider/compatible.Client (per provider base URL + API key)
    -> billing.Logger -> Cloudflare D1 (llm_gateway_requests)
```

## Configuration layers

Config is split into three layers (do not mix secrets with catalog data):

| Layer | Source | Contains |
|-------|--------|----------|
| **1. Provider credentials** | `.env` / secrets | `OPENAI_API_KEY`, `MIMO_API_KEY`, `{PROVIDER}_BASE_URL` |
| **2. Model catalog** | `config/models.yaml` | Model IDs, provider, modalities, enabled flag |
| **3. Runtime policy** | `.env` | `PORT`, `DEFAULT_MODEL`, `MODEL_CATALOG_PATH`, `LOG_LEVEL` |

### Logging (`LOG_LEVEL`)

Structured logs go to **stderr** via Go `slog`.

| Value | What you see |
|-------|----------------|
| `info` (default) | Startup, billing on/off, one line per HTTP request |
| `debug` | Identity headers, quota, model routing, billing rows, API errors |
| `warn` / `error` | Higher thresholds only |

```bash
LOG_LEVEL=debug ./bin/server
```

Debug examples: `http request` (auth_mode, tool_id), `ai quota ok`, `chat route resolved` (provider/model), `billing pending`, `api error response`.

### Multi-turn chat (vibe coding)

No Go changes are required: `POST /v1/chat/completions` already accepts a full `messages[]` array (`system`, prior `user`/`assistant` turns, latest user).

Site-side reusable UI:

| File | Role |
|------|------|
| `src/main/webapp/modern/js/llm-client.js` | Identity headers + NDJSON streaming (`/ai` or `/ai-gateway`) |
| `src/main/webapp/modern/js/vibe-coding-assistant.js` | Generic `ToolAiAssistant` modal (`VibeCodingAssistant` alias) |

Arduino simulator: single **AI** button → `ToolAiAssistant` with page-specific `applyActions` (sketch + Wokwi diagram).

### Generic tool integration

```javascript
import {
  ToolAiAssistant,
  applyExtractors,
  extractLastFencedBlock,
} from '/modern/js/vibe-coding-assistant.js';

const ai = new ToolAiAssistant({
  ctx: '/myapp',
  toolId: 'category/my-tool',       // separate sessionStorage per tool
  title: 'My Tool AI',
  systemPrompt: '...',
  seedContext: () => `Current state:\n${getState()}`,
  applyActions: [
    {
      id: 'editor',
      label: 'Apply to editor',
      extract: (text) => extractLastFencedBlock(text, { langs: ['python', 'py'] }),
      apply: (code) => monacoEditor.setValue(code),
    },
    {
      id: 'config',
      label: 'Apply settings',
      extract: applyExtractors.fencedJson((o) => o && o.version),
      apply: (cfg) => loadConfig(cfg),
    },
  ],
  getApplyLabel: (matched) =>
    matched.length > 1 ? 'Apply all' : matched[0].action.label,
  // applyUi: 'separate',  // optional: one button per action
});
ai.mount();
document.getElementById('btnAI').onclick = () => ai.open();
```

Legacy shortcuts still work: `onApplyCode` / `onApplyDiagram` + `applyLabels`. Prefer `applyActions` for new pages.

### Assistant UI features

| Capability | Notes |
|------------|-------|
| Markdown rendering | Lightweight built-in renderer for headings, lists, bold/italic, inline code, links |
| Fenced code blocks | Rendered as `<pre><code>` with a per-block **Copy** button and language label |
| Stop button | Send button becomes **Stop** while streaming; aborts the in-flight request without closing the modal |
| Accessibility | `role="dialog"` + `aria-modal`, focus trap inside the modal, `aria-busy` on streaming bubble, `role="log"` on the message list, `role="alert"` for errors |
| Mobile | Modal goes full-screen below 480 px width |
| Input | Auto-grow textarea, `maxInputLength` clamp (default 8000), Enter sends, Shift+Enter newline, Esc closes |
| System bubbles | `info` (muted teal) for notices, `error` (destructive red) for failures |
| Multi-instance safe | Per-instance DOM IDs; can mount two assistants on the same page |
| Storage | `tool_ai_v1_<toolId>` in `sessionStorage`; legacy keys (`vibe_chat_*`, `tool_ai_*`) auto-migrated and removed |

### Smart conversation management

`ToolAiAssistant` trims the payload sent to the gateway so you don't blow context budget on multi-turn chats:

| Behavior | Default | Override |
|----------|---------|----------|
| History window sent to model | last **3** user+assistant pairs | `historyTurns` |
| New-project / reset detection | phrases like "new project", "start over", "/new" → drop prior history | `resetPatterns: RegExp[]` or `detectIntent(text, history)` |
| Compress old assistant turns | strip ``` fenced code/diagram blocks → marker; keep newest reply intact | `compressTurn(text, recencyIndex, role)` |
| Hide empty `[CURRENT CONTEXT]` | skip block when `seedContext()` is label-only / blank | `skipEmptyContext: false` |
| Dedupe consecutive identical turns | always on (handles retry spam) | — |
| Empty/invalid turns | filtered on load and on send | — |

When a reset is triggered the user sees a `Starting a fresh conversation…` system bubble so it's obvious history was dropped for that turn.

Why these defaults: current code/diagram is already injected fresh via `seedContext` each turn, so re-sending huge historical code fences just wastes tokens. The model only needs the *intent* of prior turns + the live state.

Built-in sampling metadata (MiMo task presets, temperature ranges) lives in **`internal/catalog/`** and merges with layer 2 by model ID.

## Setup

```bash
cd openai-go-api
cp .env.example .env
# edit .env and config/models.yaml

make build
make run
```

## Layer 1 — Provider credentials (env)

```env
OPENAI_API_KEY=sk-...
MIMO_API_KEY=...
# optional overrides
# OPENAI_BASE_URL=https://api.openai.com/v1
# MIMO_BASE_URL=https://api.xiaomimimo.com/v1
```

Defaults exist for `openai`, `mimo`, `minimax`, `deepseek`.

## Layer 2 — Model catalog (YAML)

`config/models.yaml`:

```yaml
default_model: mimo-v2.5

models:
  - id: gpt-5.4-mini
    provider: openai
    modalities: [chat, responses]

  - id: mimo-v2-flash
    provider: mimo
    modalities: [chat]
```

To enable MiMo: set `MIMO_API_KEY` and `enabled: true` on the models you want.

## Layer 3 — Runtime policy (env)

```env
PORT=8084
DEFAULT_MODEL=mimo-v2.5
MODEL_CATALOG_PATH=config/models.yaml
```

`DEFAULT_MODEL` overrides `default_model` in YAML.

## D1 billing (optional)

When `CLOUDFLARE_API_TOKEN` is set, every API call is logged to D1 (`llm_gateway_requests`).

```env
D1_BILLING_ENABLED=true
CLOUDFLARE_ACCOUNT_ID=7e50090f0972664d8e6985f1e83131a3
D1_DATABASE_ID=b146fd57-6fcc-4847-8b3f-17a9e747758b
CLOUDFLARE_API_TOKEN=...
```

```bash
make d1-migrate-remote   # apply schema
make d1-user-usage       # per-user token report
```

Schema details: [`db/SCHEMA.md`](db/SCHEMA.md)

---

## Frontend integration

Base URL: `http://localhost:8084` (or your deployed gateway). All LLM routes use `Content-Type: application/json`.

### Identity headers (login + anonymous)

Send **one** of these on every LLM request so usage can be attributed in D1:

| Header | When to send | `auth_mode` in D1 |
|--------|--------------|-------------------|
| `X-User-Id` | User logged in (Google OAuth id = `users.id`) | `authenticated` |
| `X-Anonymous-Id` | Guest / not logged in | `anonymous` |
| `Authorization: Bearer llm_...` | Programmatic per-user API key | `api_key` |

Priority: `X-User-Id` → API key → `X-Anonymous-Id` → anonymous.

Optional headers:

| Header | Purpose |
|--------|---------|
| `X-Tool-Id` | Which page/tool triggered AI (analytics only — **tools are never paywalled**) |
| `X-Request-ID` | Correlation id for support/debug |

### AI-only plans (tools are always free)

**All 451+ tool pages are free.** Only calls to this gateway consume monthly **AI token** quota.

| Plan | Who | Default monthly tokens | Default chat model (`model_id`) |
|------|-----|----------------------|-----------------------------------|
| `guest` | `X-Anonymous-Id` (same browser) | 20,000 | `gpt-5.4-nano` |
| `free` | Logged-in user (`X-User-Id`) | 200,000 | `gpt-5.4-mini` |
| `pro` | `users.is_premium = 1` in D1 | 2,000,000 | `gpt-5.4` |

When the client omits `model` on `POST /v1/chat/completions`, the gateway picks the tier’s `model_id` from `ai_plans` (migration `0010`). Explicit client `model` always wins. `GET /v1/ai/quota` returns `model_id` for UI badges.

Limits are read from the D1 **`ai_plans`** table at runtime (cached 10 min). Env vars `AI_QUOTA_*` are fallback only when `ai_plans` cannot be loaded. Change limits with:

```sql
UPDATE ai_plans SET monthly_token_limit = 250000 WHERE plan_id = 'free';
```

Guests are tracked by **browser**, not location: same `localStorage` UUID = same quota. New browser/incognito = new guest quota.

### Dodo subscriptions (Pro billing)

All subscription D1 writes happen in this service. **Tomcat is the public edge**; set `AI_GATEWAY=http://127.0.0.1:8084` (or an internal IP) on Tomcat so billing/AI proxies reach this process. Go should not be internet-facing. See [`docs/DODO_BILLING_ENV.md`](../docs/DODO_BILLING_ENV.md).

| Route | Purpose |
|-------|---------|
| `POST /v1/billing/webhook` | Dodo webhook (signature verified) |
| `POST /v1/billing/checkout` | Create checkout (`X-User-Id`, optional `X-User-Email`) |
| `GET /v1/billing/status` | Premium + active subscription |
| `POST /v1/billing/users/upsert` | Upsert `users` after Google login |

Schema: [`db/SUBSCRIPTIONS.md`](db/SUBSCRIPTIONS.md). **Ops guide:** [`docs/BILLING.md`](docs/BILLING.md). **Deploy:** [`docs/DEPLOY.md`](docs/DEPLOY.md). Env: [`docs/DODO_BILLING_ENV.md`](../docs/DODO_BILLING_ENV.md).

#### Check quota before / after AI (recommended UI)

```javascript
async function fetchAIQuota(baseUrl, { userId } = {}) {
  const res = await fetch(`${baseUrl}/v1/ai/quota`, {
    headers: llmHeaders({ userId }),
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.error || res.statusText);
  return data.quota;
}

// Example banner: "AI: 12,400 / 200,000 tokens this month (Free account)"
function renderQuotaBanner(quota) {
  if (quota.is_unlimited) return;
  const pct = quota.tokens_limit
    ? Math.round((quota.tokens_used / quota.tokens_limit) * 100)
    : 0;
  return `AI: ${quota.tokens_used.toLocaleString()} / ${quota.tokens_limit.toLocaleString()} tokens (${quota.plan_name}) — resets ${quota.period_ends_at}`;
}
```

#### When quota is exceeded (`402`)

```json
{
  "error": "AI quota exceeded: 20001/20000 tokens used this month",
  "code": "ai_quota_exceeded",
  "hint": "Sign in for a higher monthly AI limit",
  "quota": {
    "plan_id": "guest",
    "tokens_used": 20001,
    "tokens_limit": 20000,
    "tokens_remaining": 0,
    "requires_login": true
  }
}
```

**Do not disable the tool** — only disable the “Ask AI” button and show sign-in / upgrade CTA.

#### Missing guest id (`400`)

If a guest calls AI without `X-Anonymous-Id`:

```json
{
  "error": "bad request: send X-Anonymous-Id for guest AI or sign in",
  "code": "missing_anonymous_id",
  "hint": "Send X-Anonymous-Id header or sign in with X-User-Id"
}
```

#### Anonymous session (localStorage)

```javascript
function getAnonymousId() {
  const key = 'llm_anonymous_id';
  let id = localStorage.getItem(key);
  if (!id) {
    id = crypto.randomUUID();
    localStorage.setItem(key, id);
  }
  return id;
}

function llmHeaders({ userId, toolId } = {}) {
  const headers = { 'Content-Type': 'application/json' };
  if (userId) {
    headers['X-User-Id'] = userId;
  } else {
    headers['X-Anonymous-Id'] = getAnonymousId();
  }
  if (toolId) {
    headers['X-Tool-Id'] = toolId;
  }
  return headers;
}
```

#### Logged-in user

After Google sign-in, pass the same id stored in your `users` table (numeric Google subject id):

```javascript
const headers = llmHeaders({ userId: session.user.id });
```

### Pick the right endpoint

Use `GET /v1/models` to discover models. Each model lists `modalities` and `endpoints`:

| Modality | HTTP route | Use for |
|----------|------------|---------|
| `chat` | `POST /v1/chat/completions` | Most models (GPT, MiMo chat) |
| `responses` | `POST /v1/responses` | `gpt-5.4-pro`, `gpt-5.5-pro` only |

**Do not** call chat for Pro models — the gateway returns `400` with `code: "modality_not_supported"`.

```javascript
async function loadModels(baseUrl) {
  const res = await fetch(`${baseUrl}/v1/models`);
  const catalog = await res.json();
  return catalog.models;
}

function endpointForModel(model) {
  if (model.modalities.includes('chat')) return '/v1/chat/completions';
  if (model.modalities.includes('responses')) return '/v1/responses';
  throw new Error(`Model ${model.id} has no chat/responses endpoint`);
}
```

### Chat completion (non-streaming)

**Request**

```json
{
  "model": "gpt-5.4-mini",
  "messages": [
    { "role": "user", "content": "Hello" }
  ],
  "task": "general",
  "temperature": 0.7,
  "top_p": 0.95
}
```

`model` is optional (defaults to `DEFAULT_MODEL`). `task`, `temperature`, `top_p` are optional; MiMo models expose valid `task` values in `GET /v1/models` → `sampling.task_recommendations`.

**Response**

```json
{
  "id": "6e81bda4-0836-4f68-94b2-d8fa88b7068f",
  "model": "gpt-5.4-mini-2026-03-17",
  "provider": "openai",
  "content": "Hello! How can I help?",
  "provider_response_id": "chatcmpl-...",
  "usage": {
    "prompt_tokens": 8,
    "completion_tokens": 12,
    "total_tokens": 20,
    "input_tokens": 8,
    "output_tokens": 12
  }
}
```

`id` is the gateway billing row id (D1). Use it for support tickets or usage dashboards.

**Fetch example**

```javascript
async function chat(baseUrl, messages, { model, userId, toolId, stream = false } = {}) {
  const res = await fetch(`${baseUrl}/v1/chat/completions`, {
    method: 'POST',
    headers: llmHeaders({ userId, toolId }),
    body: JSON.stringify({ model, messages, stream }),
  });
  const data = await res.json();
  if (!res.ok) {
    if (data.code === 'ai_quota_exceeded') {
      // show upgrade modal; tool page stays usable
      throw Object.assign(new Error(data.error), { quota: data.quota, code: data.code });
    }
    throw new Error(data.error || res.statusText);
  }
  return data;
}
```

### Responses API (Pro models)

**Request**

```json
{
  "model": "gpt-5.4-pro",
  "input": "Say ok",
  "stream": false
}
```

**Response**

```json
{
  "id": "...",
  "model": "gpt-5.4-pro-2026-03-05",
  "provider": "openai",
  "output": "ok",
  "provider_response_id": "resp_...",
  "usage": {
    "input_tokens": 11,
    "output_tokens": 5,
    "total_tokens": 16
  }
}
```

### Streaming (SSE)

Set `"stream": true`. Response is `text/event-stream`; each line is `data: {json}\n\n`.

| Event `type` | Fields | Meaning |
|--------------|--------|---------|
| `content` | `delta` | Text chunk |
| `done` | `id`, `model`, `provider`, `usage`, `provider_response_id` | Stream finished |
| `error` | `error` | Failed mid-stream |

```javascript
async function streamChat(baseUrl, messages, { model, userId, onDelta }) {
  const res = await fetch(`${baseUrl}/v1/chat/completions`, {
    method: 'POST',
    headers: llmHeaders({ userId }),
    body: JSON.stringify({ model, messages, stream: true }),
  });
  if (!res.ok) throw new Error(await res.text());

  const reader = res.body.getReader();
  const decoder = new TextDecoder();
  let buffer = '';

  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    buffer += decoder.decode(value, { stream: true });
    const lines = buffer.split('\n');
    buffer = lines.pop() || '';
    for (const line of lines) {
      if (!line.startsWith('data: ')) continue;
      const evt = JSON.parse(line.slice(6));
      if (evt.type === 'content') onDelta(evt.delta);
      if (evt.type === 'done') return evt;
      if (evt.type === 'error') throw new Error(evt.error);
    }
  }
}
```

### Validation errors

Invalid model, modality, or sampling returns `400`:

```json
{
  "error": "model \"gpt-5.4-pro\" does not support \"chat\" on this endpoint",
  "code": "modality_not_supported",
  "model": "gpt-5.4-pro",
  "hint": "use POST /v1/responses"
}
```

Common codes: `model_not_found`, `modality_not_supported`, `invalid_task`, `invalid_sampling`.

### Recommended FE flow

1. On app load: `GET /v1/models` → populate model picker.
2. On AI surfaces: `GET /v1/ai/quota` → show usage banner.
3. Resolve endpoint from model modalities.
4. Attach `llmHeaders({ userId, toolId })` on every AI call.
5. Display `usage.total_tokens` from each AI response.
6. On `ai_quota_exceeded` (402), prompt sign-in or Pro — **never block the tool page**.
7. For Pro models, use `/v1/responses` with `input` string (not `messages`).

### Which tools use AI the most?

This tracks **AI calls only** (not page visits). Send `X-Tool-Id` on every AI request:

```javascript
llmHeaders({ userId, toolId: 'integral-calculator' })  // slug = JSP name without .jsp
```

**One command report:**

```bash
make d1-tool-usage
```

That runs `db/tool_usage_queries.sql` against remote D1 and shows:

- Top tools by **AI request count** (all time)
- Top tools by **tokens this month**
- Daily breakdown for one tool (edit `tool_id` in the SQL file)

Rows with `tool_id = (not set)` mean the frontend did not send `X-Tool-Id` for those AI calls.

**Manual query (top 20 by tokens):**

```bash
./scripts/wrangler-env.sh wrangler d1 execute exam-marker-db --remote --command="
SELECT tool_id, COUNT(*) AS requests, SUM(total_tokens) AS tokens
FROM llm_gateway_requests
WHERE tool_id IS NOT NULL AND status = 'completed'
GROUP BY tool_id ORDER BY tokens DESC LIMIT 20;"
```

---

## HTTP API reference

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/health` | Liveness |
| `GET` | `/v1/models` | Full catalog: providers, models, endpoints, sampling |
| `GET` | `/v1/models/{id}` | Single model configuration |
| `GET` | `/v1/ai/quota` | Monthly AI token usage for current caller |
| `POST` | `/v1/chat/completions` | Chat (`"stream": true` for SSE) |
| `POST` | `/v1/responses` | Responses API (`"stream": true` for SSE) |

### Model catalog

```bash
curl -s http://localhost:8084/v1/models | jq .
curl -s http://localhost:8084/v1/models/gpt-5.4-mini | jq .
```

### Chat with identity + usage

```bash
curl -s http://localhost:8084/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -H 'X-User-Id: 111513473250186617916' \
  -d '{"model":"gpt-5.4-mini","messages":[{"role":"user","content":"hello"}]}'
```

### Guest (anonymous)

```bash
curl -s http://localhost:8084/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -H 'X-Anonymous-Id: 550e8400-e29b-41d4-a716-446655440000' \
  -d '{"messages":[{"role":"user","content":"hello"}]}'
```

### Streaming

```bash
curl -N http://localhost:8084/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -H 'X-Anonymous-Id: 550e8400-e29b-41d4-a716-446655440000' \
  -d '{"stream":true,"model":"gpt-5.4-mini","messages":[{"role":"user","content":"Count 1-5"}]}'
```

## Modality → endpoint

| Modality | Endpoint | Models |
|----------|----------|--------|
| `chat` | `POST /v1/chat/completions` | `gpt-5.4`, `gpt-5.4-mini`, `gpt-5.5`, MiMo chat, … |
| `responses` | `POST /v1/responses` | `gpt-5.4-pro`, `gpt-5.5-pro` |
| `tts` | *(future)* | MiMo TTS models |

## Add a model

1. Edit **`config/models.yaml`** (not `.env`).
2. Set `id`, `provider`, `modalities`, `enabled: true`.
3. Ensure `{PROVIDER}_API_KEY` is in `.env`.
4. Restart server.

## Project layout

```
openai-go-api/
  config/models.yaml       # layer 2 catalog
  migrations/              # D1 SQL migrations
  db/SCHEMA.md             # billing schema
  db/tool_usage_queries.sql  # per-tool AI usage reports
  cmd/server/
  cmd/sanity/
  internal/
    billing/               # D1 logging + user identity
    config/
    catalog/
    handler/
    provider/
    registry/
    service/
```

## Make targets

| Target | Description |
|--------|-------------|
| `make build` | Build `bin/server` |
| `make run` | Start server (loads `.env`) |
| `make sanity` | Test all enabled models |
| `make test` / `make vet` | Go tests and vet |
| `make d1-migrate-remote` | Apply D1 migrations |
| `make d1-user-usage` | Per-user / anonymous AI token totals |
| `make d1-tool-usage` | **Top tools by AI usage** (requires `X-Tool-Id`) |

Apply migration `0004_ai_plans.sql` before using AI quotas in production.

## Sanity test

```bash
# terminal 1
make run

# terminal 2
make sanity
```

Expected: **11 passed** (chat models via `/v1/chat/completions`, Pro via `/v1/responses`).

Last verified: migrations through `0004_ai_plans`; sanity **11/11**; AI quota on `GET /v1/ai/quota`.
