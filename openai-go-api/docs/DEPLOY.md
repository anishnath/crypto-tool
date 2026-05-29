# Remote deployment (Amazon Linux 2)

Deploy the Go gateway to the **8gwifi** EC2 host from your laptop. Tomcat stays the public edge; this service listens on **localhost:8084** (or `PORT` in `.env.prod`).

## Prerequisites

| Item | Notes |
|------|--------|
| SSH | `~/.ssh/config` host alias **`8gwifi`** → EC2 (user `ec2-user`) |
| Local Go | Cross-compiles to `linux/amd64` |
| `.env.prod` | Production secrets — **gitignored**; copy from `.env.prod.example` |
| Remote sudo | `ec2-user` can `systemctl` (default on Amazon Linux) |

Tomcat on the same box needs:

```bash
AI_GATEWAY=http://127.0.0.1:8084
```

## One-command deploy

From `openai-go-api/`:

```bash
cp .env.prod.example .env.prod   # first time only — fill in secrets
make remote
```

This will:

1. `GOOS=linux GOARCH=amd64` build → `bin/server-linux`
2. Stop `openai-go-api` if running (Linux locks the running binary)
3. Upload to `bin/server.new`, atomically replace `bin/server`, plus `config/models.yaml` and `.env.prod` → `/opt/openai-go-api/`
4. Install `deploy/openai-go-api.service` → `/etc/systemd/system/`
5. `systemctl enable --now openai-go-api`
6. Curl `GET /health` on the remote

## Remote layout

```
/opt/openai-go-api/
  bin/server          # linux amd64 binary
  config/models.yaml
  .env                # copied from local .env.prod (mode 600)
```

## Make targets

| Target | Action |
|--------|--------|
| `make build-linux` | Cross-compile only |
| `make remote` | Build + deploy + restart |
| `make remote-status` | `systemctl status openai-go-api` |
| `make remote-logs` | `journalctl -u openai-go-api -f` |
| `make remote-restart` | Restart without redeploy |

Override host or path:

```bash
make remote REMOTE_HOST=8gwifi REMOTE_DIR=/opt/openai-go-api
```

## systemd

Unit file: [`deploy/openai-go-api.service`](../deploy/openai-go-api.service)

```bash
ssh 8gwifi 'sudo systemctl status openai-go-api'
ssh 8gwifi 'sudo journalctl -u openai-go-api -n 100 --no-pager'
```

## Verify after deploy

On EC2:

```bash
curl -s http://127.0.0.1:8084/health
curl -s http://127.0.0.1:8084/v1/models | head
```

From Tomcat (billing status proxied):

```bash
curl -s http://127.0.0.1:8084/v1/billing/plans | head
```

Dodo webhook stays on Tomcat: `https://8gwifi.org/api/dodo/webhook` — not this port.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `scp: dest open .../bin/server: Failure` | Service was running — redeploy with `make remote` (script stops service first) or `make remote-restart` after manual upload |
| Plans API returns `{"plans":[],"ai_tiers":[]}` | Go checkout disabled — set `DODO_PAYMENTS_API_KEY` + `DODO_PRODUCT_PRO_*` in `/opt/openai-go-api/.env`, then `make remote-restart` |
| `missing .env.prod` | `cp .env.prod.example .env.prod` and fill secrets |
| Service fails start | `make remote-logs` — often missing API key or D1 token |
| Tomcat can't reach Go | Confirm `AI_GATEWAY=http://127.0.0.1:8084` and `ss -lntp \| grep 8084` on EC2 |
| Wrong arch | Rebuild with `make build-linux` (amd64 for Amazon Linux 2 x86_64) |

## Security

- `.env.prod` is never committed (see repo `.gitignore`).
- Go binds `0.0.0.0:$PORT` by default — keep **8084 off the public security group**; only Tomcat should call it.
- Rotate keys if `.env.prod` was ever exposed.
