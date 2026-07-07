package service

import (
	"context"
	"fmt"
	"log/slog"
	"slices"
	"strings"

	"github.com/anish/crypto-tool/openai-go-api/internal/logging"
	"github.com/anish/crypto-tool/openai-go-api/internal/provider"
	"github.com/anish/crypto-tool/openai-go-api/internal/registry"
)

var ErrBadRequest = registry.ErrBadRequest

// ValidateChatRequest checks model, modality, sampling, and messages before calling a provider.
func (g *Gateway) ValidateChatRequest(req ChatRequest) error {
	entry, err := g.reg.ValidateModel(req.Model, provider.ModalityChat)
	if err != nil {
		return err
	}
	if err := registry.ValidateSampling(entry.Sampling, req.Task, req.Temperature, req.TopP); err != nil {
		return err
	}
	if requestHasImages(req.Messages) && !slices.Contains(entry.Capabilities, "vision") {
		return fmt.Errorf("%w: model %q does not support image input (choose a vision-capable model)", ErrBadRequest, req.Model)
	}
	return validateMessages(SanitizeChatMessages(req.Messages))
}

func requestHasImages(msgs []ChatMessage) bool {
	for _, m := range msgs {
		if len(m.Images) > 0 {
			return true
		}
	}
	return false
}

// Image guardrails for multimodal (vision) requests.
const (
	maxImagesPerMessage  = 4
	maxImageDataURLBytes = 7 * 1024 * 1024 // ~5MB decoded image (base64 is ~1.33x)
)

// SanitizeChatMessages removes turns with empty content (e.g. failed client
// streams) — but keeps a turn that carries images, since an image-only user
// message is valid for vision requests.
func SanitizeChatMessages(msgs []ChatMessage) []ChatMessage {
	out := make([]ChatMessage, 0, len(msgs))
	for _, m := range msgs {
		if strings.TrimSpace(m.Content) == "" && len(m.Images) == 0 {
			continue
		}
		out = append(out, m)
	}
	return out
}

// ValidateResponseRequest checks model and modality before calling a provider.
func (g *Gateway) ValidateResponseRequest(req ResponseRequest) error {
	if strings.TrimSpace(req.Input) == "" {
		return fmt.Errorf("%w: input is required", ErrBadRequest)
	}
	_, err := g.reg.ValidateModel(req.Model, provider.ModalityResponses)
	return err
}

func (g *Gateway) prepareChat(ctx context.Context, req ChatRequest) (provider.ChatBackend, string, provider.SamplingConfig, error) {
	_ = ctx
	if err := g.ValidateChatRequest(req); err != nil {
		return nil, "", provider.SamplingConfig{}, err
	}

	backend, model, err := g.reg.Resolve(req.Model, provider.ModalityChat)
	if err != nil {
		return nil, "", provider.SamplingConfig{}, err
	}
	entry, ok := g.reg.GetEntry(model)
	if !ok || entry.Sampling == nil {
		return backend, model, provider.SamplingConfig{}, nil
	}
	resolved, err := entry.Sampling.Resolve(req.Task, req.Temperature, req.TopP)
	if err != nil {
		return nil, "", provider.SamplingConfig{}, err
	}
	sampling := provider.SamplingConfig{
		Set:         true,
		Temperature: resolved.Temperature,
		TopP:        resolved.TopP,
	}
	if logging.IsDebug() {
		slog.Debug("chat route resolved",
			"requested_model", req.Model,
			"resolved_model", model,
			"provider", backend.ID(),
			"task", req.Task,
			"temperature", resolved.Temperature,
			"top_p", resolved.TopP,
		)
	}
	return backend, model, sampling, nil
}

func validateMessages(msgs []ChatMessage) error {
	if len(msgs) == 0 {
		return fmt.Errorf("%w: at least one message is required", ErrBadRequest)
	}
	for i, m := range msgs {
		role := strings.TrimSpace(m.Role)
		content := strings.TrimSpace(m.Content)
		if content == "" && len(m.Images) == 0 {
			return fmt.Errorf("%w: message[%d] content is required", ErrBadRequest, i)
		}
		if len(m.Images) > maxImagesPerMessage {
			return fmt.Errorf("%w: message[%d] has %d images (max %d)", ErrBadRequest, i, len(m.Images), maxImagesPerMessage)
		}
		for j, img := range m.Images {
			if strings.TrimSpace(img) == "" {
				return fmt.Errorf("%w: message[%d] image[%d] is empty", ErrBadRequest, i, j)
			}
			if len(img) > maxImageDataURLBytes {
				return fmt.Errorf("%w: message[%d] image[%d] too large (max ~5MB)", ErrBadRequest, i, j)
			}
		}
		switch role {
		case "system", "developer", "assistant", "user", "":
			if role == "" {
				// default to user in provider layer
			}
		default:
			return fmt.Errorf("%w: message[%d] role %q is invalid", ErrBadRequest, i, m.Role)
		}
	}
	return nil
}
