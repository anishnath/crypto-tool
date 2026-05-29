package handler

import (
	"log/slog"
	"net/http"

	"github.com/anish/crypto-tool/openai-go-api/internal/billing"
	"github.com/anish/crypto-tool/openai-go-api/internal/logging"
)

func debugHTTPRequest(r *http.Request, reqCtx billing.RequestContext, extra ...any) {
	if !logging.IsDebug() {
		return
	}
	args := []any{
		"method", r.Method,
		"path", r.URL.Path,
		"auth_mode", reqCtx.User.AuthMode,
		"tool_id", billing.ToolIDFromRequest(r),
	}
	if reqCtx.User.UserID != "" {
		args = append(args, "user_id", logging.TruncateID(reqCtx.User.UserID, 12))
	}
	if reqCtx.User.AnonymousID != "" {
		args = append(args, "anonymous_id", logging.TruncateID(reqCtx.User.AnonymousID, 12))
	}
	if h := reqCtx.Client.ClientIPHash; h != "" {
		args = append(args, "client_ip_hash", logging.TruncateID(h, 12))
	}
	args = append(args, extra...)
	slog.Debug("http request", args...)
}

func debugQuota(user billing.UserIdentity, status billing.AIQuotaStatus, err error) {
	if !logging.IsDebug() {
		return
	}
	args := []any{
		"plan", status.PlanID,
		"tokens_used", status.TokensUsed,
		"tokens_limit", status.TokensLimit,
		"tokens_remaining", status.TokensRemaining,
		"auth_mode", user.AuthMode,
	}
	if err != nil {
		args = append(args, "error", err.Error())
		slog.Debug("ai quota check failed", args...)
		return
	}
	slog.Debug("ai quota ok", args...)
}

func debugGatewayCall(endpoint, model, provider string, stream bool, messageCount int, err error) {
	if !logging.IsDebug() {
		return
	}
	args := []any{
		"endpoint", endpoint,
		"model", model,
		"provider", provider,
		"stream", stream,
		"messages", messageCount,
	}
	if err != nil {
		args = append(args, "error", err.Error())
		slog.Debug("gateway call failed", args...)
		return
	}
	slog.Debug("gateway call ok", args...)
}
