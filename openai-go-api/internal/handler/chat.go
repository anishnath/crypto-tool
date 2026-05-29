package handler

import (
	"encoding/json"
	"net/http"

	"github.com/anish/crypto-tool/openai-go-api/internal/billing"
	"github.com/anish/crypto-tool/openai-go-api/internal/provider"
	"github.com/anish/crypto-tool/openai-go-api/internal/service"
)

type chatCompletionRequest struct {
	Model       string            `json:"model"`
	Messages    []chatMessageBody `json:"messages"`
	Stream      bool              `json:"stream"`
	Task        string            `json:"task,omitempty"`
	Temperature *float64          `json:"temperature,omitempty"`
	TopP        *float64          `json:"top_p,omitempty"`
}

type chatMessageBody struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

type chatCompletionResponse struct {
	ID                 string     `json:"id,omitempty"`
	Model              string     `json:"model"`
	Provider           string     `json:"provider"`
	Content            string     `json:"content"`
	ProviderResponseID string     `json:"provider_response_id,omitempty"`
	Usage              *usageBody `json:"usage,omitempty"`
}

// ChatCompletions handles POST /v1/chat/completions.
func (a *API) ChatCompletions(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var body chatCompletionRequest
	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		writeJSON(w, http.StatusBadRequest, errorResponse{Error: "invalid JSON body"})
		return
	}

	messages := make([]service.ChatMessage, 0, len(body.Messages))
	for _, m := range body.Messages {
		messages = append(messages, service.ChatMessage{
			Role:    m.Role,
			Content: m.Content,
		})
	}
	messages = service.SanitizeChatMessages(messages)

	req := service.ChatRequest{
		Model:       body.Model,
		Messages:    messages,
		Stream:      body.Stream,
		Task:        body.Task,
		Temperature: body.Temperature,
		TopP:        body.TopP,
	}

	reqCtx := a.billing.RequestContext(r.Context(), r)
	a.applyTierChatModel(r.Context(), reqCtx.User, &req, &body.Model)

	providerID, _ := a.gateway.ResolveProvider(req.Model, provider.ModalityChat)
	debugHTTPRequest(r, reqCtx,
		"model", req.Model,
		"stream", body.Stream,
		"messages", len(body.Messages),
	)
	pending := chatPendingRecord(r, body, providerID, reqCtx)

	if err := a.gateway.ValidateChatRequest(req); err != nil {
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
	if st, err := a.billing.GetAIQuota(r.Context(), reqCtx.User); err == nil {
		debugQuota(reqCtx.User, st, nil)
	}

	if providerID == "" {
		providerID, _ = a.gateway.ResolveProvider(req.Model, provider.ModalityChat)
		pending.ProviderID = providerID
	}

	if body.Stream {
		tracker := a.billing.Begin(r.Context(), pending)
		a.streamChatCompletions(w, r, req, tracker)
		return
	}

	tracker := a.billing.Begin(r.Context(), pending)
	result, err := a.gateway.CreateChatCompletion(r.Context(), req)
	if err != nil {
		tracker.Fail(billingFailFromProvider(err))
		writeError(w, err)
		return
	}

	tracker.Complete(billing.CompleteRecord{
		ModelResolved:      result.Model,
		HTTPStatus:         http.StatusOK,
		OutputCharCount:    len(result.Content),
		Usage:              result.Usage,
		ProviderResponseID: result.ProviderResponseID,
	})
	debugGatewayCall("chat", result.Model, result.Provider, false, len(body.Messages), nil)

	writeJSON(w, http.StatusOK, chatCompletionResponse{
		ID:                 tracker.ID(),
		Model:              result.Model,
		Provider:           result.Provider,
		Content:            result.Content,
		ProviderResponseID: result.ProviderResponseID,
		Usage:              usageBodyFrom(result.Usage),
	})
}

func (a *API) streamChatCompletions(w http.ResponseWriter, r *http.Request, req service.ChatRequest, tracker *billing.Tracker) {
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

	result, err := a.gateway.StreamChatCompletion(r.Context(), req, func(delta string) error {
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
		OutputCharCount:    len(result.Content),
		Usage:              result.Usage,
		ProviderResponseID: result.ProviderResponseID,
	})
	debugGatewayCall("chat", result.Model, result.Provider, true, len(req.Messages), nil)

	_ = writeSSE(w, flusher, streamEvent{
		Type:               "done",
		ID:                 tracker.ID(),
		Model:              result.Model,
		Provider:           result.Provider,
		ProviderResponseID: result.ProviderResponseID,
		Usage:              usageBodyFrom(result.Usage),
	})
}

func chatPendingRecord(r *http.Request, body chatCompletionRequest, providerID string, reqCtx billing.RequestContext) billing.PendingRecord {
	requestJSON, _ := json.Marshal(map[string]any{
		"model":       body.Model,
		"messages":    body.Messages,
		"stream":      body.Stream,
		"task":        body.Task,
		"temperature": body.Temperature,
		"top_p":       body.TopP,
	})
	inputChars := 0
	for _, m := range body.Messages {
		inputChars += len(m.Content)
	}
	return billing.PendingRecord{
		ID:             billing.NewRequestID(),
		Endpoint:       billing.EndpointChat,
		Modality:       billing.ModalityChat,
		ProviderID:     providerID,
		ModelRequested: body.Model,
		Stream:         body.Stream,
		RequestJSON:    string(requestJSON),
		MessageCount:   len(body.Messages),
		InputCharCount: inputChars,
		Task:           body.Task,
		Temperature:    body.Temperature,
		TopP:           body.TopP,
		ClientMeta:     reqCtx.Client,
		User:           reqCtx.User,
		ToolID:         billing.ToolIDFromRequest(r),
	}
}
