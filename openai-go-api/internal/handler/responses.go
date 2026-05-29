package handler

import (
	"encoding/json"
	"net/http"

	"github.com/anish/crypto-tool/openai-go-api/internal/billing"
	"github.com/anish/crypto-tool/openai-go-api/internal/provider"
	"github.com/anish/crypto-tool/openai-go-api/internal/service"
)

type createResponseRequest struct {
	Model  string `json:"model"`
	Input  string `json:"input"`
	Stream bool   `json:"stream"`
}

type createResponseResponse struct {
	ID                 string     `json:"id,omitempty"`
	Model              string     `json:"model"`
	Provider           string     `json:"provider"`
	Output             string     `json:"output"`
	ProviderResponseID string     `json:"provider_response_id,omitempty"`
	Usage              *usageBody `json:"usage,omitempty"`
}

// Responses handles POST /v1/responses.
func (a *API) Responses(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var body createResponseRequest
	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		writeJSON(w, http.StatusBadRequest, errorResponse{Error: "invalid JSON body"})
		return
	}

	req := service.ResponseRequest{
		Model:  body.Model,
		Input:  body.Input,
		Stream: body.Stream,
	}

	providerID, _ := a.gateway.ResolveProvider(req.Model, provider.ModalityResponses)
	reqCtx := a.billing.RequestContext(r.Context(), r)
	debugHTTPRequest(r, reqCtx, "model", body.Model, "stream", body.Stream)
	pending := responsesPendingRecord(r, body, providerID, reqCtx)

	if err := a.gateway.ValidateResponseRequest(req); err != nil {
		a.billing.LogValidationFailure(r.Context(), pending, http.StatusBadRequest, validationErrorCode(err), err.Error())
		writeError(w, err)
		return
	}

	if err := a.billing.CheckAIQuota(r.Context(), reqCtx.User); err != nil {
		if st, qerr := a.billing.GetAIQuota(r.Context(), reqCtx.User); qerr == nil {
			debugQuota(reqCtx.User, st, err)
		}
		writeError(w, err)
		return
	}

	if providerID == "" {
		providerID, _ = a.gateway.ResolveProvider(req.Model, provider.ModalityResponses)
		pending.ProviderID = providerID
	}

	if body.Stream {
		tracker := a.billing.Begin(r.Context(), pending)
		a.streamResponses(w, r, req, tracker)
		return
	}

	tracker := a.billing.Begin(r.Context(), pending)
	result, err := a.gateway.CreateResponse(r.Context(), req)
	if err != nil {
		tracker.Fail(billingFailFromProvider(err))
		writeError(w, err)
		return
	}

	tracker.Complete(billing.CompleteRecord{
		ModelResolved:      result.Model,
		HTTPStatus:         http.StatusOK,
		OutputCharCount:    len(result.Output),
		Usage:              result.Usage,
		ProviderResponseID: result.ProviderResponseID,
	})

	writeJSON(w, http.StatusOK, createResponseResponse{
		ID:                 tracker.ID(),
		Model:              result.Model,
		Provider:           result.Provider,
		Output:             result.Output,
		ProviderResponseID: result.ProviderResponseID,
		Usage:              usageBodyFrom(result.Usage),
	})
}

func (a *API) streamResponses(w http.ResponseWriter, r *http.Request, req service.ResponseRequest, tracker *billing.Tracker) {
	flusher, err := setupSSE(w)
	if err != nil {
		tracker.Fail(billing.FailRecord{
			HTTPStatus:   http.StatusInternalServerError,
			ErrorCode:    "stream_unsupported",
			ErrorMessage: err.Error(),
		})
		writeJSON(w, http.StatusInternalServerError, errorResponse{Error: err.Error()})
		return
	}

	result, err := a.gateway.StreamResponse(r.Context(), req, func(delta string) error {
		return writeSSE(w, flusher, streamEvent{Type: "content", Delta: delta})
	})
	if err != nil {
		tracker.Fail(billingFailFromProvider(err))
		_ = writeSSE(w, flusher, streamEvent{Type: "error", Error: err.Error()})
		return
	}

	tracker.Complete(billing.CompleteRecord{
		ModelResolved:      result.Model,
		HTTPStatus:         http.StatusOK,
		OutputCharCount:    len(result.Output),
		Usage:              result.Usage,
		ProviderResponseID: result.ProviderResponseID,
	})

	_ = writeSSE(w, flusher, streamEvent{
		Type:               "done",
		ID:                 tracker.ID(),
		Model:              result.Model,
		Provider:           result.Provider,
		ProviderResponseID: result.ProviderResponseID,
		Usage:              usageBodyFrom(result.Usage),
	})
}

func responsesPendingRecord(r *http.Request, body createResponseRequest, providerID string, reqCtx billing.RequestContext) billing.PendingRecord {
	requestJSON, _ := json.Marshal(map[string]any{
		"model":  body.Model,
		"input":  body.Input,
		"stream": body.Stream,
	})
	return billing.PendingRecord{
		ID:             billing.NewRequestID(),
		Endpoint:       billing.EndpointResponses,
		Modality:       billing.ModalityResponses,
		ProviderID:     providerID,
		ModelRequested: body.Model,
		Stream:         body.Stream,
		RequestJSON:    string(requestJSON),
		InputCharCount: len(body.Input),
		ClientMeta:     reqCtx.Client,
		User:           reqCtx.User,
		ToolID:         billing.ToolIDFromRequest(r),
	}
}
