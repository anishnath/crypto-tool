package provider

import (
	"encoding/json"

	openaisdk "github.com/openai/openai-go/v3"
	"github.com/openai/openai-go/v3/responses"
)

// Usage holds token counts from an upstream provider response.
type Usage struct {
	PromptTokens     int64
	CompletionTokens int64
	TotalTokens      int64
	InputTokens      int64
	OutputTokens     int64
	ReasoningTokens  int64
	CachedTokens     int64
	RawJSON          string
}

func (u Usage) IsZero() bool {
	return u.TotalTokens == 0 &&
		u.PromptTokens == 0 &&
		u.CompletionTokens == 0 &&
		u.InputTokens == 0 &&
		u.OutputTokens == 0
}

// UsageFromCompletion maps chat completion usage.
func UsageFromCompletion(u openaisdk.CompletionUsage) Usage {
	out := Usage{
		PromptTokens:     u.PromptTokens,
		CompletionTokens: u.CompletionTokens,
		TotalTokens:      u.TotalTokens,
		InputTokens:      u.PromptTokens,
		OutputTokens:     u.CompletionTokens,
		ReasoningTokens:  u.CompletionTokensDetails.ReasoningTokens,
		CachedTokens:     u.PromptTokensDetails.CachedTokens,
	}
	if raw, err := json.Marshal(u); err == nil {
		out.RawJSON = string(raw)
	}
	return out
}

// UsageFromResponse maps responses API usage.
func UsageFromResponse(u responses.ResponseUsage) Usage {
	out := Usage{
		InputTokens:      u.InputTokens,
		OutputTokens:     u.OutputTokens,
		TotalTokens:      u.TotalTokens,
		PromptTokens:     u.InputTokens,
		CompletionTokens: u.OutputTokens,
		ReasoningTokens:  u.OutputTokensDetails.ReasoningTokens,
		CachedTokens:     u.InputTokensDetails.CachedTokens,
	}
	if raw, err := json.Marshal(u); err == nil {
		out.RawJSON = string(raw)
	}
	return out
}
