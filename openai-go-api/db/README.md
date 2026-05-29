# D1 billing database

Schema design: [SCHEMA.md](./SCHEMA.md)

## Quick start

```bash
# Local (no Cloudflare auth needed)
make d1-test-local

# Remote (requires auth)
export CLOUDFLARE_API_TOKEN=...   # or: wrangler login
make d1-test-remote

# Inspect remote tables
make d1-inspect-remote
```

**Database ID:** `b146fd57-6fcc-4847-8b3f-17a9e747758b`  
**Wrangler name:** `exam-marker-db` (shared instance; tables prefixed `llm_`)

## Migrations

| File | Purpose |
|------|---------|
| `migrations/0001_llm_gateway_billing.sql` | Core tables, indexes, pricing seed, daily view |
| `migrations/0002_llm_gateway_test_seed.sql` | Smoke-test row for verification |

## Application logging

When `CLOUDFLARE_API_TOKEN` is set, the Go gateway writes to `llm_gateway_requests`:

1. **INSERT on request** — model, provider, request JSON, client hashes
2. **UPDATE on response** — token usage, latency, upstream response id, status

Set in `.env`:

```
D1_BILLING_ENABLED=true
CLOUDFLARE_ACCOUNT_ID=7e50090f0972664d8e6985f1e83131a3
D1_DATABASE_ID=b146fd57-6fcc-4847-8b3f-17a9e747758b
CLOUDFLARE_API_TOKEN=...
```

Server startup prints `billing: true/false`.

## Verified locally

`make d1-test-local` confirms:

- Tables: `llm_gateway_requests`, `llm_model_pricing`
- View: `llm_daily_usage`
- Seed row with token counts
- 5 pricing placeholder rows

## Remote auth

Remote apply failed in CI/agent context without `CLOUDFLARE_API_TOKEN`. Run locally:

```bash
wrangler login
# or
export CLOUDFLARE_API_TOKEN=your-token
make d1-test-remote
```

Credentials can be placed in `openai-go-api/.dev.vars` (gitignored):

```
CLOUDFLARE_API_TOKEN=...
```

The Makefile loads `.dev.vars` or falls back to `../cf-exam-marker/.dev.vars`.
