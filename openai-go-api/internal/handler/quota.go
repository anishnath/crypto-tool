package handler

import (
	"net/http"

	"github.com/anish/crypto-tool/openai-go-api/internal/billing"
)

type aiQuotaResponse struct {
	Quota quotaBody `json:"quota"`
}

type quotaBody struct {
	PlanID          string `json:"plan_id"`
	PlanName        string `json:"plan_name"`
	ModelID         string `json:"model_id,omitempty"`
	SubjectType     string `json:"subject_type"`
	SubjectID       string `json:"subject_id,omitempty"`
	TokensUsed      int64  `json:"tokens_used"`
	TokensLimit     int64  `json:"tokens_limit"`
	TokensRemaining int64  `json:"tokens_remaining"`
	RequestCount    int64  `json:"request_count"`
	Period          string `json:"period"`
	PeriodEndsAt    string `json:"period_ends_at"`
	IsUnlimited     bool   `json:"is_unlimited"`
	RequiresLogin   bool   `json:"requires_login,omitempty"`
}

// AIQuota handles GET /v1/ai/quota — monthly AI token usage for the current caller.
func (a *API) AIQuota(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	reqCtx := a.billing.RequestContext(r.Context(), r)
	debugHTTPRequest(r, reqCtx)
	status, err := a.billing.GetAIQuota(r.Context(), reqCtx.User)
	if err != nil {
		writeError(w, err)
		return
	}

	debugQuota(reqCtx.User, status, nil)
	writeJSON(w, http.StatusOK, aiQuotaResponse{Quota: quotaBodyFromStatus(status)})
}

func quotaBodyFromStatus(s billing.AIQuotaStatus) quotaBody {
	return quotaBody{
		PlanID:          s.PlanID,
		PlanName:        s.PlanName,
		ModelID:         s.ModelID,
		SubjectType:     s.SubjectType,
		SubjectID:       s.SubjectID,
		TokensUsed:      s.TokensUsed,
		TokensLimit:     s.TokensLimit,
		TokensRemaining: s.TokensRemaining,
		RequestCount:    s.RequestCount,
		Period:          s.Period,
		PeriodEndsAt:    s.PeriodEndsAt,
		IsUnlimited:     s.IsUnlimited,
		RequiresLogin:   s.RequiresLogin,
	}
}
