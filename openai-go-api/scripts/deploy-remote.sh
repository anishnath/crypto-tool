#!/usr/bin/env bash
# Build locally (make build-linux), upload artifacts to EC2, install systemd unit, restart.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

REMOTE_HOST="${REMOTE_HOST:-8gwifi}"
REMOTE_DIR="${REMOTE_DIR:-/opt/openai-go-api}"
SERVICE_NAME="${SERVICE_NAME:-openai-go-api}"
ENV_PROD="${ENV_PROD:-.env.prod}"
BIN_LINUX="${BIN_LINUX:-bin/server-linux}"

die() { echo "deploy-remote: $*" >&2; exit 1; }

[[ -f "$ENV_PROD" ]] || die "missing $ENV_PROD (copy from .env.prod.example)"
[[ -f "$BIN_LINUX" ]] || die "missing $BIN_LINUX — run: make build-linux"
[[ -f config/models.yaml ]] || die "missing config/models.yaml"
[[ -f deploy/openai-go-api.service ]] || die "missing deploy/openai-go-api.service"

echo "==> Deploying to ${REMOTE_HOST}:${REMOTE_DIR}"

# Remote layout + ownership (ec2-user runs the service)
ssh "$REMOTE_HOST" "sudo mkdir -p '${REMOTE_DIR}/bin' '${REMOTE_DIR}/config' && sudo chown -R ec2-user:ec2-user '${REMOTE_DIR}'"

echo "==> Stop service before binary upload (avoids scp failure on locked ExecStart path)"
ssh "$REMOTE_HOST" "if systemctl is-active --quiet ${SERVICE_NAME} 2>/dev/null; then sudo systemctl stop ${SERVICE_NAME}; fi" || true

echo "==> Upload binary, config, env"
scp -q "$BIN_LINUX" "${REMOTE_HOST}:${REMOTE_DIR}/bin/server.new"
ssh "$REMOTE_HOST" "mv -f '${REMOTE_DIR}/bin/server.new' '${REMOTE_DIR}/bin/server' && chmod 755 '${REMOTE_DIR}/bin/server'"
scp -q config/models.yaml "${REMOTE_HOST}:${REMOTE_DIR}/config/models.yaml"
scp -q "$ENV_PROD" "${REMOTE_HOST}:${REMOTE_DIR}/.env"
ssh "$REMOTE_HOST" "chmod 600 '${REMOTE_DIR}/.env'"

echo "==> Install systemd unit"
scp -q deploy/openai-go-api.service "${REMOTE_HOST}:/tmp/${SERVICE_NAME}.service"
ssh "$REMOTE_HOST" "sudo mv /tmp/${SERVICE_NAME}.service /etc/systemd/system/${SERVICE_NAME}.service && sudo chmod 644 /etc/systemd/system/${SERVICE_NAME}.service"

echo "==> Enable and restart service"
ssh "$REMOTE_HOST" "sudo systemctl daemon-reload && sudo systemctl enable ${SERVICE_NAME} && sudo systemctl restart ${SERVICE_NAME}"

echo "==> Service status"
ssh "$REMOTE_HOST" "sudo systemctl --no-pager --full status ${SERVICE_NAME}" || true

echo "==> Health check (localhost on remote)"
sleep 2
LOCAL_PORT="$(grep -E '^PORT=' "$ENV_PROD" | head -1 | cut -d= -f2- | tr -d '\r\"' || true)"
LOCAL_PORT="${LOCAL_PORT:-8084}"
if ssh "$REMOTE_HOST" "curl -sf --max-time 5 http://127.0.0.1:${LOCAL_PORT}/health"; then
  echo ""
  echo "OK: /health responded on remote port ${LOCAL_PORT}"
else
  echo "WARN: /health did not respond on port ${LOCAL_PORT} — check: ssh ${REMOTE_HOST} 'sudo journalctl -u ${SERVICE_NAME} -n 50 --no-pager'"
fi

echo "Done. Logs: make remote-logs"
