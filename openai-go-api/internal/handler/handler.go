package handler

import (
	"encoding/json"
	"errors"
	"log/slog"
	"net/http"

	openaisdk "github.com/openai/openai-go/v3"

	"github.com/anish/crypto-tool/openai-go-api/internal/logging"

	"github.com/anish/crypto-tool/openai-go-api/internal/billing"
	"github.com/anish/crypto-tool/openai-go-api/internal/billing/dodo"
	"github.com/anish/crypto-tool/openai-go-api/internal/provider"
	"github.com/anish/crypto-tool/openai-go-api/internal/registry"
	"github.com/anish/crypto-tool/openai-go-api/internal/service"
)

// API groups HTTP handlers for LLM and billing routes.
type API struct {
	gateway *service.Gateway
	billing *billing.Logger
	dodo    *dodo.Service
}

// NewAPI returns handlers wired to the gateway service.
func NewAPI(gateway *service.Gateway, billingLogger *billing.Logger, dodoSvc *dodo.Service) *API {
	return &API{gateway: gateway, billing: billingLogger, dodo: dodoSvc}
}

type errorResponse struct {
	Error string     `json:"error"`
	Code  string     `json:"code,omitempty"`
	Model string     `json:"model,omitempty"`
	Hint  string     `json:"hint,omitempty"`
	Quota *quotaBody `json:"quota,omitempty"`
}

type usageBody struct {
	PromptTokens     int64 `json:"prompt_tokens,omitempty"`
	CompletionTokens int64 `json:"completion_tokens,omitempty"`
	TotalTokens      int64 `json:"total_tokens,omitempty"`
	InputTokens      int64 `json:"input_tokens,omitempty"`
	OutputTokens     int64 `json:"output_tokens,omitempty"`
	ReasoningTokens  int64 `json:"reasoning_tokens,omitempty"`
	CachedTokens     int64 `json:"cached_tokens,omitempty"`
}

func writeJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(v)
}

func writeError(w http.ResponseWriter, err error) {
	status := http.StatusInternalServerError
	resp := errorResponse{Error: err.Error()}

	var apiErr *openaisdk.Error
	if errors.As(err, &apiErr) {
		switch {
		case apiErr.StatusCode >= 400 && apiErr.StatusCode < 500:
			status = apiErr.StatusCode
		case apiErr.StatusCode >= 500:
			status = http.StatusBadGateway
		}
	}

	var mve *registry.ModelValidationError
	if errors.As(err, &mve) {
		status = http.StatusBadRequest
		resp.Error = mve.Error()
		resp.Code = mve.Code
		resp.Model = mve.Model
		resp.Hint = mve.Hint
	} else if errors.Is(err, billing.ErrBadRequest) {
		status = http.StatusBadRequest
		resp.Code = billing.CodeMissingAnonymousID
		resp.Hint = "Send X-Anonymous-Id header or sign in with X-User-Id"
	} else if errors.Is(err, service.ErrBadRequest) {
		status = http.StatusBadRequest
	} else if qe := quotaExceeded(err); qe != nil {
		status = http.StatusPaymentRequired
		resp.Error = qe.Error()
		resp.Code = billing.CodeAIQuotaExceeded
		body := quotaBodyFromStatus(qe.Status)
		resp.Quota = &body
		if qe.Status.RequiresLogin {
			resp.Hint = "Sign in for a higher monthly AI limit"
		} else {
			resp.Hint = "Upgrade to Pro for more AI tokens"
		}
	}

	if logging.IsDebug() {
		args := []any{"status", status, "error", resp.Error}
		if resp.Code != "" {
			args = append(args, "code", resp.Code)
		}
		if resp.Model != "" {
			args = append(args, "model", resp.Model)
		}
		slog.Debug("api error response", args...)
	}

	writeJSON(w, status, resp)
}

func usageBodyFrom(u provider.Usage) *usageBody {
	if u.IsZero() {
		return nil
	}
	return &usageBody{
		PromptTokens:     u.PromptTokens,
		CompletionTokens: u.CompletionTokens,
		TotalTokens:      u.TotalTokens,
		InputTokens:      u.InputTokens,
		OutputTokens:     u.OutputTokens,
		ReasoningTokens:  u.ReasoningTokens,
		CachedTokens:     u.CachedTokens,
	}
}

func validationErrorCode(err error) string {
	var mve *registry.ModelValidationError
	if errors.As(err, &mve) {
		return mve.Code
	}
	return "bad_request"
}

func billingFailFromError(err error, httpStatus int) billing.FailRecord {
	return billing.FailRecord{
		HTTPStatus:   httpStatus,
		ErrorCode:    validationErrorCode(err),
		ErrorMessage: err.Error(),
	}
}

func billingFailFromProvider(err error) billing.FailRecord {
	status := http.StatusBadGateway
	var apiErr *openaisdk.Error
	if errors.As(err, &apiErr) && apiErr.StatusCode >= 400 && apiErr.StatusCode < 600 {
		if apiErr.StatusCode < 500 {
			status = apiErr.StatusCode
		}
	}
	var mve *registry.ModelValidationError
	if errors.As(err, &mve) {
		status = http.StatusBadRequest
	}
	if errors.Is(err, service.ErrBadRequest) {
		status = http.StatusBadRequest
	}
	return billingFailFromError(err, status)
}

func quotaExceeded(err error) *billing.QuotaExceededError {
	var qe *billing.QuotaExceededError
	if errors.As(err, &qe) {
		return qe
	}
	return nil
}
