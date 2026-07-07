package service

import (
	"context"

	"github.com/anish/crypto-tool/openai-go-api/internal/provider"
	"github.com/anish/crypto-tool/openai-go-api/internal/registry"
)

// Gateway is the HTTP-facing LLM service backed by a multi-provider registry.
type Gateway struct {
	reg *registry.Registry
}

func NewGateway(reg *registry.Registry) *Gateway {
	return &Gateway{reg: reg}
}

type ChatRequest struct {
	Model       string
	Messages    []ChatMessage
	Stream      bool
	Task        string
	Temperature *float64
	TopP        *float64
}

type ChatMessage struct {
	Role    string
	Content string
	Images  []string
}

type ChatResult struct {
	Model              string
	Provider           string
	Content            string
	Usage              provider.Usage
	ProviderResponseID string
}

type ResponseRequest struct {
	Model  string
	Input  string
	Stream bool
}

type ResponseResult struct {
	Model              string
	Provider           string
	Output             string
	Usage              provider.Usage
	ProviderResponseID string
}

// ModelCatalog is the public model catalog with configuration metadata.
type ModelCatalog = registry.CatalogSnapshot

// ModelSpec is a single model in the catalog.
type ModelSpec = registry.ModelSpec

func (g *Gateway) DefaultModel() string { return g.reg.DefaultModel() }

// DefaultVisionModel returns the model that image requests auto-route to ("" if unset).
func (g *Gateway) DefaultVisionModel() string { return g.reg.DefaultVisionModel() }

// SupportsVision reports whether the model (empty → default) accepts image input.
func (g *Gateway) SupportsVision(model string) bool { return g.reg.SupportsVision(model) }

func (g *Gateway) ProviderIDs() []string { return g.reg.ProviderIDs() }

func (g *Gateway) Catalog() ModelCatalog { return g.reg.Catalog() }

func (g *Gateway) GetModel(id string) (ModelSpec, bool) { return g.reg.GetModel(id) }

func (g *Gateway) ResolveProvider(model string, modality provider.Modality) (string, error) {
	entry, err := g.reg.ValidateModel(model, modality)
	if err != nil {
		return "", err
	}
	return entry.ProviderID, nil
}

func (g *Gateway) CreateChatCompletion(ctx context.Context, req ChatRequest) (ChatResult, error) {
	backend, model, sampling, err := g.prepareChat(ctx, req)
	if err != nil {
		return ChatResult{}, err
	}
	msgs, err := toProviderMessages(req.Messages)
	if err != nil {
		return ChatResult{}, err
	}
	res, err := backend.Chat(ctx, model, msgs, sampling)
	if err != nil {
		return ChatResult{}, err
	}
	return ChatResult{
		Model:              res.Model,
		Provider:           backend.ID(),
		Content:            res.Content,
		Usage:              res.Usage,
		ProviderResponseID: res.ProviderResponseID,
	}, nil
}

func (g *Gateway) StreamChatCompletion(ctx context.Context, req ChatRequest, emit func(delta string) error) (ChatResult, error) {
	backend, model, sampling, err := g.prepareChat(ctx, req)
	if err != nil {
		return ChatResult{}, err
	}
	msgs, err := toProviderMessages(req.Messages)
	if err != nil {
		return ChatResult{}, err
	}
	res, err := backend.StreamChat(ctx, model, msgs, sampling, emit)
	if err != nil {
		return ChatResult{}, err
	}
	return ChatResult{
		Model:              res.Model,
		Provider:           backend.ID(),
		Content:            res.Content,
		Usage:              res.Usage,
		ProviderResponseID: res.ProviderResponseID,
	}, nil
}

func (g *Gateway) CreateResponse(ctx context.Context, req ResponseRequest) (ResponseResult, error) {
	if err := g.ValidateResponseRequest(req); err != nil {
		return ResponseResult{}, err
	}
	backend, model, err := g.reg.Resolve(req.Model, provider.ModalityResponses)
	if err != nil {
		return ResponseResult{}, err
	}
	res, err := backend.Response(ctx, model, req.Input)
	if err != nil {
		return ResponseResult{}, err
	}
	return ResponseResult{
		Model:              res.Model,
		Provider:           backend.ID(),
		Output:             res.Output,
		Usage:              res.Usage,
		ProviderResponseID: res.ProviderResponseID,
	}, nil
}

func (g *Gateway) StreamResponse(ctx context.Context, req ResponseRequest, emit func(delta string) error) (ResponseResult, error) {
	if err := g.ValidateResponseRequest(req); err != nil {
		return ResponseResult{}, err
	}
	backend, model, err := g.reg.Resolve(req.Model, provider.ModalityResponses)
	if err != nil {
		return ResponseResult{}, err
	}
	res, err := backend.StreamResponse(ctx, model, req.Input, emit)
	if err != nil {
		return ResponseResult{}, err
	}
	return ResponseResult{
		Model:              res.Model,
		Provider:           backend.ID(),
		Output:             res.Output,
		Usage:              res.Usage,
		ProviderResponseID: res.ProviderResponseID,
	}, nil
}

func toProviderMessages(msgs []ChatMessage) ([]provider.Message, error) {
	msgs = SanitizeChatMessages(msgs)
	if err := validateMessages(msgs); err != nil {
		return nil, err
	}
	out := make([]provider.Message, len(msgs))
	for i, m := range msgs {
		out[i] = provider.Message{Role: m.Role, Content: m.Content, Images: m.Images}
	}
	return out, nil
}
