APP_NAME := server
BIN_DIR := bin
CMD_PATH := ./cmd/server
D1_DB := exam-marker-db
WRANGLER := ./scripts/wrangler-env.sh wrangler

ifneq (,$(wildcard .env))
include .env
export
endif

.PHONY: build run sanity test vet tidy clean
.PHONY: build-linux remote remote-status remote-logs remote-restart
.PHONY: d1-migrate-local d1-migrate-remote d1-test-local d1-test-remote d1-inspect-remote d1-user-usage d1-tool-usage d1-reset-local

REMOTE_HOST ?= 8gwifi
REMOTE_DIR ?= /opt/openai-go-api
ENV_PROD ?= .env.prod
BIN_LINUX := $(BIN_DIR)/$(APP_NAME)-linux

build:
	@mkdir -p $(BIN_DIR)
	go build -o $(BIN_DIR)/$(APP_NAME) $(CMD_PATH)

# Linux amd64 binary for Amazon Linux 2 EC2 (build on Mac or Linux dev machine).
build-linux:
	@mkdir -p $(BIN_DIR)
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags="-s -w" -o $(BIN_LINUX) $(CMD_PATH)
	@echo "Built $(BIN_LINUX) for linux/amd64"

# Deploy to EC2 via SSH host alias (default: 8gwifi). Uses local $(ENV_PROD) on remote as .env
remote: build-linux
	@test -f $(ENV_PROD) || (echo "missing $(ENV_PROD) — copy from .env.prod.example" && exit 1)
	@chmod +x scripts/deploy-remote.sh
	REMOTE_HOST=$(REMOTE_HOST) REMOTE_DIR=$(REMOTE_DIR) ENV_PROD=$(ENV_PROD) BIN_LINUX=$(BIN_LINUX) ./scripts/deploy-remote.sh

remote-status:
	ssh $(REMOTE_HOST) 'sudo systemctl --no-pager --full status openai-go-api'

remote-logs:
	ssh $(REMOTE_HOST) 'sudo journalctl -u openai-go-api -f --no-pager'

remote-restart:
	ssh $(REMOTE_HOST) 'sudo systemctl restart openai-go-api && sudo systemctl --no-pager --full status openai-go-api'

run:
	go run $(CMD_PATH)

sanity:
	go run ./cmd/sanity -base-url http://localhost:$(or $(PORT),8080)

test:
	go test ./...

vet:
	go vet ./...

tidy:
	go mod tidy

clean:
	rm -rf $(BIN_DIR)

# --- Cloudflare D1 (billing schema) ---
# Database ID: b146fd57-6fcc-4847-8b3f-17a9e747758b
# Schema: db/SCHEMA.md  |  Migrations: migrations/

d1-migrate-local:
	$(WRANGLER) d1 migrations apply $(D1_DB) --local

d1-migrate-remote:
	$(WRANGLER) d1 migrations apply $(D1_DB) --remote

d1-test-local: d1-migrate-local
	$(WRANGLER) d1 execute $(D1_DB) --local --file=db/test_queries.sql

d1-test-remote: d1-migrate-remote
	$(WRANGLER) d1 execute $(D1_DB) --remote --file=db/test_queries.sql

d1-inspect-remote:
	$(WRANGLER) d1 execute $(D1_DB) --remote --command="SELECT name, type FROM sqlite_master WHERE name LIKE 'llm_%' ORDER BY type, name;"

d1-user-usage:
	$(WRANGLER) d1 execute $(D1_DB) --remote --file=db/user_usage_queries.sql

d1-tool-usage:
	$(WRANGLER) d1 execute $(D1_DB) --remote --file=db/tool_usage_queries.sql

d1-reset-local:
	rm -rf .wrangler/state/v3/d1
