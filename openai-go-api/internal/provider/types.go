package provider

import "context"

// Modality is a capability supported by a model.
type Modality string

const (
	ModalityChat      Modality = "chat"
	ModalityResponses Modality = "responses"
	ModalityTTS       Modality = "tts"
)

// SamplingConfig is optional temperature/top_p sent to the provider.
type SamplingConfig struct {
	Set         bool
	Temperature float64
	TopP        float64
}

// Message is a chat role/content pair.
type Message struct {
	Role    string
	Content string
}

// ChatResult is a chat completion result (non-streaming or aggregated stream).
type ChatResult struct {
	Model              string
	Content            string
	Usage              Usage
	ProviderResponseID string
}

// ResponseResult is a responses API result (non-streaming or aggregated stream).
type ResponseResult struct {
	Model              string
	Output             string
	Usage              Usage
	ProviderResponseID string
}

// ChatBackend performs provider-specific LLM calls.
type ChatBackend interface {
	ID() string
	Chat(ctx context.Context, model string, messages []Message, sampling SamplingConfig) (ChatResult, error)
	StreamChat(ctx context.Context, model string, messages []Message, sampling SamplingConfig, emit func(delta string) error) (ChatResult, error)
	Response(ctx context.Context, model string, input string) (ResponseResult, error)
	StreamResponse(ctx context.Context, model string, input string, emit func(delta string) error) (ResponseResult, error)
}
