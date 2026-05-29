#!/usr/bin/env bash
# Load Cloudflare credentials for wrangler (if present).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -f "$ROOT/.dev.vars" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "$ROOT/.dev.vars"
  set +a
elif [[ -f "$ROOT/../cf-exam-marker/.dev.vars" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "$ROOT/../cf-exam-marker/.dev.vars"
  set +a
fi

exec "$@"
