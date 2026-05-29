package handler

import (
	"context"
	"log/slog"
	"strings"

	"github.com/anish/crypto-tool/openai-go-api/internal/billing"
	"github.com/anish/crypto-tool/openai-go-api/internal/provider"
	"github.com/anish/crypto-tool/openai-go-api/internal/service"
)

// applyTierChatModel sets req.Model from ai_plans when the client omitted model.
func (a *API) applyTierChatModel(ctx context.Context, user billing.UserIdentity, req *service.ChatRequest, bodyModel *string) {
	if strings.TrimSpace(req.Model) != "" {
		return
	}
	tierModel, err := a.billing.TierChatModel(ctx, user)
	if err != nil || tierModel == "" {
		return
	}
	if _, err := a.gateway.ResolveProvider(tierModel, provider.ModalityChat); err != nil {
		slog.Warn("tier model not usable for chat; using gateway default",
			"model", tierModel, "error", err.Error())
		return
	}
	req.Model = tierModel
	if bodyModel != nil {
		*bodyModel = tierModel
	}
}
