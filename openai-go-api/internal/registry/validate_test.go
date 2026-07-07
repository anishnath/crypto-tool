package registry

import (
	"context"
	"testing"

	"github.com/anish/crypto-tool/openai-go-api/internal/provider"
)

type stubBackend struct{ id string }

func (s stubBackend) ID() string { return s.id }
func (s stubBackend) Chat(context.Context, string, []provider.Message, provider.SamplingConfig) (provider.ChatResult, error) {
	return provider.ChatResult{}, nil
}
func (s stubBackend) StreamChat(context.Context, string, []provider.Message, provider.SamplingConfig, func(string) error) (provider.ChatResult, error) {
	return provider.ChatResult{}, nil
}
func (s stubBackend) Response(context.Context, string, string) (provider.ResponseResult, error) {
	return provider.ResponseResult{}, nil
}
func (s stubBackend) StreamResponse(context.Context, string, string, func(string) error) (provider.ResponseResult, error) {
	return provider.ResponseResult{}, nil
}

func TestValidateModelNotFound(t *testing.T) {
	reg := testRegistry(t)
	_, err := reg.ValidateModel("missing-model", provider.ModalityChat)
	assertValidationCode(t, err, CodeModelNotFound)
}

func TestValidateModalityNotSupported(t *testing.T) {
	reg := testRegistry(t)
	_, err := reg.ValidateModel("gpt-5.4-pro", provider.ModalityChat)
	assertValidationCode(t, err, CodeModalityNotSupported)
}

func TestValidateModalityOK(t *testing.T) {
	reg := testRegistry(t)
	_, err := reg.ValidateModel("gpt-5.4-mini", provider.ModalityChat)
	if err != nil {
		t.Fatalf("expected pass, got %v", err)
	}
}

func assertValidationCode(t *testing.T, err error, code string) {
	t.Helper()
	mve, ok := err.(*ModelValidationError)
	if !ok {
		t.Fatalf("expected ModelValidationError, got %T: %v", err, err)
	}
	if mve.Code != code {
		t.Fatalf("code = %q, want %q", mve.Code, code)
	}
}

func testRegistry(t *testing.T) *Registry {
	t.Helper()
	backend := stubBackend{id: "openai"}
	reg, err := New("gpt-5.4-mini", "", "test.yaml", []ModelEntry{
		{ID: "gpt-5.4-mini", ProviderID: "openai", Modalities: []string{"chat", "responses"}, Backend: backend},
		{ID: "gpt-5.4-pro", ProviderID: "openai", Modalities: []string{"responses"}, Backend: backend},
	}, []ProviderInfo{{ID: "openai", BaseURL: "https://example.com/v1", ModelIDs: []string{"gpt-5.4-mini", "gpt-5.4-pro"}}})
	if err != nil {
		t.Fatal(err)
	}
	return reg
}
