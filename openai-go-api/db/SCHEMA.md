# LLM Gateway — D1 Billing Schema

Cloudflare D1 (SQLite) tables for request logging and token-based billing.

**Database ID:** `b146fd57-6fcc-4847-8b3f-17a9e747758b`  
**Wrangler name:** `exam-marker-db` (shared D1 instance; LLM tables use `llm_` prefix)

**Dodo subscriptions:** see [`SUBSCRIPTIONS.md`](SUBSCRIPTIONS.md) (`migrations/0005_dodo_subscriptions.sql`).

## Design goals

1. **Log on request** — capture incoming payload (messages/input, model, sampling) when the API is called.
2. **Complete on response** — update the same row with token usage, latency, status, and upstream IDs.
3. **Billing-ready** — indexes and a daily rollup view for cost reporting by provider, model, and API key.

## Lifecycle

```
POST /v1/chat/completions  or  POST /v1/responses
        │
        ▼
  INSERT llm_gateway_requests  (status=pending, request_json, started_at)
        │
        ▼
  Call provider (OpenAI / MiMo)
        │
        ├── success ──► UPDATE (status=completed, usage_*, latency_ms, completed_at)
        ├── validation error ──► UPDATE (status=validation_failed, http_status=400)
        └── provider error ──► UPDATE (status=failed, error_message, http_status)
```

Streaming uses the same row; `completed_at` and usage are written when the stream finishes.

## Tables

### `llm_gateway_requests`

One row per gateway API call.

| Column | Type | Phase | Description |
|--------|------|-------|-------------|
| `id` | TEXT PK | request | UUID v4 correlation id |
| `endpoint` | TEXT | request | `chat_completions` \| `responses` |
| `modality` | TEXT | request | `chat` \| `responses` |
| `provider_id` | TEXT | request | `openai`, `mimo`, … |
| `model_requested` | TEXT | request | Model from client body (empty = default) |
| `model_resolved` | TEXT | response | Model returned by provider |
| `stream` | INTEGER | request | 0/1 |
| `request_json` | TEXT | request | Sanitized JSON body (messages or input) |
| `message_count` | INTEGER | request | Chat: number of messages |
| `input_char_count` | INTEGER | request | Characters in input/messages |
| `task` | TEXT | request | MiMo task preset if set |
| `temperature` | REAL | request | Sampling override |
| `top_p` | REAL | request | Sampling override |
| `status` | TEXT | both | `pending` → `completed` \| `failed` \| `validation_failed` |
| `http_status` | INTEGER | response | Gateway HTTP status sent to client |
| `error_code` | TEXT | response | e.g. `model_not_found`, provider error code |
| `error_message` | TEXT | response | Human-readable error |
| `output_char_count` | INTEGER | response | Response text length (billing proxy) |
| `prompt_tokens` | INTEGER | response | Chat completions usage |
| `completion_tokens` | INTEGER | response | Chat completions usage |
| `total_tokens` | INTEGER | response | Total billed tokens |
| `input_tokens` | INTEGER | response | Responses API usage |
| `output_tokens` | INTEGER | response | Responses API usage |
| `reasoning_tokens` | INTEGER | response | Reasoning breakdown if present |
| `cached_tokens` | INTEGER | response | Prompt cache hits if present |
| `usage_json` | TEXT | response | Full upstream `usage` object |
| `provider_response_id` | TEXT | response | Upstream completion/response id |
| `started_at` | TEXT | request | ISO8601 UTC |
| `completed_at` | TEXT | response | ISO8601 UTC |
| `latency_ms` | INTEGER | response | `completed_at - started_at` |
| `api_key_id` | TEXT | request | Optional tenant/key label |
| `api_key_hash` | TEXT | request | SHA-256 prefix for attribution |
| `client_ip_hash` | TEXT | request | Privacy-safe client IP hash |
| `user_agent` | TEXT | request | Client User-Agent |
| `request_id_header` | TEXT | request | `X-Request-ID` if provided |
| `user_id` | TEXT | request | Logged-in user (`users.id`), nullable |
| `anonymous_id` | TEXT | request | Guest session UUID, nullable |
| `auth_mode` | TEXT | request | `anonymous` \| `authenticated` \| `api_key` |
| `created_at` | TEXT | request | Row insert time |
| `updated_at` | TEXT | both | Last update time |

### `llm_model_pricing` (optional reference)

Static per-model pricing for estimated cost (USD per 1M tokens). Populated separately; not required for raw usage logging.

| Column | Type | Description |
|--------|------|-------------|
| `model_id` | TEXT PK | Catalog model id |
| `provider_id` | TEXT | Provider |
| `input_price_per_million` | REAL | USD per 1M input/prompt tokens |
| `output_price_per_million` | REAL | USD per 1M output/completion tokens |
| `effective_from` | TEXT | Price effective date |
| `notes` | TEXT | Source / comment |

## Views

### `llm_daily_usage`

Aggregated token usage by day, provider, and model for billing dashboards.

## Indexes

- Time-range billing queries: `(started_at)`, `(provider_id, model_resolved, started_at)`
- Per-key attribution: `(api_key_hash, started_at)`
- Status monitoring: `(status, started_at)`

### `llm_user_api_keys`

Per-user programmatic API keys (`Bearer llm_...`).

| Column | Type | Description |
|--------|------|-------------|
| `id` | TEXT PK | Key record id |
| `user_id` | TEXT FK | References `users.id` |
| `key_hash` | TEXT UNIQUE | SHA-256 of secret key |
| `label` | TEXT | Optional label |
| `is_active` | INTEGER | 1 = active |
| `last_used_at` | TEXT | Updated on each use |

### Views

- **`llm_user_usage`** — daily tokens by user or anonymous session
- **`llm_user_usage_totals`** — lifetime totals per logged-in user
- **`llm_anonymous_usage_totals`** — lifetime totals per anonymous session

## Client identity (login + anonymous)

Send headers on every gateway request:

| Header | When | Maps to |
|--------|------|---------|
| `X-User-Id` | User logged in (Google OAuth) | `user_id` + `auth_mode=authenticated` |
| `X-Anonymous-Id` | Guest / no login | `anonymous_id` + `auth_mode=anonymous` |
| `Authorization: Bearer llm_...` | Programmatic key | `user_id` via `llm_user_api_keys` |

Priority: `X-User-Id` > API key > `X-Anonymous-Id` > anonymous.

## Example queries

```sql
-- Pending requests older than 5 minutes (stuck / crashed)
SELECT id, endpoint, model_requested, started_at
FROM llm_gateway_requests
WHERE status = 'pending'
  AND started_at < datetime('now', '-5 minutes');

-- Daily tokens by model (last 7 days)
SELECT * FROM llm_daily_usage
WHERE usage_date >= date('now', '-7 days')
ORDER BY total_tokens DESC;

-- Insert on request (application code)
INSERT INTO llm_gateway_requests (
  id, endpoint, modality, provider_id, model_requested, stream,
  request_json, message_count, input_char_count, task, temperature, top_p,
  status, started_at, api_key_hash, client_ip_hash, user_agent
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending', datetime('now'), ?, ?, ?);

-- Update on success (application code)
UPDATE llm_gateway_requests SET
  status = 'completed',
  model_resolved = ?,
  http_status = 200,
  prompt_tokens = ?,
  completion_tokens = ?,
  total_tokens = ?,
  input_tokens = ?,
  output_tokens = ?,
  reasoning_tokens = ?,
  cached_tokens = ?,
  usage_json = ?,
  provider_response_id = ?,
  output_char_count = ?,
  latency_ms = ?,
  completed_at = datetime('now'),
  updated_at = datetime('now')
WHERE id = ?;
```
