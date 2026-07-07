package registry

import (
	"errors"
	"fmt"
	"slices"
	"strings"

	"github.com/anish/crypto-tool/openai-go-api/internal/catalog"
	"github.com/anish/crypto-tool/openai-go-api/internal/provider"
)

var ErrBadRequest = errors.New("bad request")

// ModelSpec describes a routable model in the catalog.
type ModelSpec struct {
	ID         string                   `json:"id"`
	ProviderID string                   `json:"provider"`
	Modalities []string                 `json:"modalities"`
	Endpoints  []EndpointInfo           `json:"endpoints"`
	Sampling   *catalog.SamplingProfile `json:"sampling,omitempty"`
	IsDefault  bool                     `json:"is_default"`
}

// CatalogSnapshot is the full model catalog exposed by the API.
type CatalogSnapshot struct {
	DefaultModel string         `json:"default_model"`
	CatalogPath  string         `json:"catalog_path"`
	Providers    []ProviderInfo `json:"providers"`
	Models       []ModelSpec    `json:"models"`
}

// ModelEntry binds a model ID to a provider backend and capabilities.
type ModelEntry struct {
	ID           string
	ProviderID   string
	Modalities   []string
	Capabilities []string // e.g. "vision" — extra capabilities beyond endpoint modalities
	Sampling     *catalog.SamplingProfile
	Backend      provider.ChatBackend
}

// Registry routes model IDs to provider backends.
type Registry struct {
	defaultModel       string
	defaultVisionModel string
	catalogPath        string
	entries            map[string]ModelEntry
	providers          []ProviderInfo
}

// New builds a registry from model entries and a default model ID.
func New(defaultModel, defaultVisionModel, catalogPath string, entries []ModelEntry, providers []ProviderInfo) (*Registry, error) {
	if len(entries) == 0 {
		return nil, fmt.Errorf("at least one model must be configured")
	}
	m := make(map[string]ModelEntry, len(entries))

	for _, e := range entries {
		if e.ID == "" || e.Backend == nil {
			return nil, fmt.Errorf("invalid model entry %q", e.ID)
		}
		if _, exists := m[e.ID]; exists {
			return nil, fmt.Errorf("duplicate model id %q", e.ID)
		}
		m[e.ID] = e
	}

	def := strings.TrimSpace(defaultModel)
	if def == "" {
		return nil, fmt.Errorf("DEFAULT_MODEL is required")
	}
	if _, ok := m[def]; !ok {
		return nil, fmt.Errorf("DEFAULT_MODEL %q is not in the model catalog", def)
	}

	return &Registry{
		defaultModel:       def,
		defaultVisionModel: strings.TrimSpace(defaultVisionModel),
		catalogPath:        catalogPath,
		entries:            m,
		providers:          providers,
	}, nil
}

// DefaultModel returns the configured default model ID.
func (r *Registry) DefaultModel() string { return r.defaultModel }

// DefaultVisionModel returns the model image requests auto-route to ("" if unset).
func (r *Registry) DefaultVisionModel() string { return r.defaultVisionModel }

// SupportsVision reports whether the model (empty → default) can accept images.
func (r *Registry) SupportsVision(modelID string) bool {
	id := strings.TrimSpace(modelID)
	if id == "" {
		id = r.defaultModel
	}
	entry, ok := r.entries[id]
	if !ok {
		return false
	}
	return slices.Contains(entry.Capabilities, "vision")
}

// CatalogPath returns the YAML catalog file path.
func (r *Registry) CatalogPath() string { return r.catalogPath }

// ProviderIDs returns configured provider identifiers.
func (r *Registry) ProviderIDs() []string {
	out := make([]string, len(r.providers))
	for i, p := range r.providers {
		out[i] = p.ID
	}
	return out
}

// Catalog returns the full model catalog for API consumers.
func (r *Registry) Catalog() CatalogSnapshot {
	return CatalogSnapshot{
		DefaultModel: r.defaultModel,
		CatalogPath:  r.catalogPath,
		Providers:    r.providers,
		Models:       r.ListModels(),
	}
}

// GetModel returns one model spec by ID.
func (r *Registry) GetModel(id string) (ModelSpec, bool) {
	e, ok := r.entries[id]
	if !ok {
		return ModelSpec{}, false
	}
	return r.entryToSpec(e), true
}

func (r *Registry) entryToSpec(e ModelEntry) ModelSpec {
	return ModelSpec{
		ID:         e.ID,
		ProviderID: e.ProviderID,
		Modalities: e.Modalities,
		Endpoints:  DeriveEndpoints(e.Modalities),
		Sampling:   e.Sampling,
		IsDefault:  e.ID == r.defaultModel,
	}
}

// ListModels returns catalog metadata for GET /v1/models.
func (r *Registry) ListModels() []ModelSpec {
	specs := make([]ModelSpec, 0, len(r.entries))
	for _, e := range r.entries {
		specs = append(specs, r.entryToSpec(e))
	}
	slices.SortFunc(specs, func(a, b ModelSpec) int {
		if a.ProviderID != b.ProviderID {
			return strings.Compare(a.ProviderID, b.ProviderID)
		}
		return strings.Compare(a.ID, b.ID)
	})
	return specs
}

// Resolve picks backend + model for a request after validation.
func (r *Registry) Resolve(requested string, required provider.Modality) (provider.ChatBackend, string, error) {
	entry, err := r.ValidateModel(requested, required)
	if err != nil {
		return nil, "", err
	}
	return entry.Backend, entry.ID, nil
}

// GetEntry returns catalog metadata for a resolved model ID.
func (r *Registry) GetEntry(modelID string) (ModelEntry, bool) {
	e, ok := r.entries[modelID]
	return e, ok
}
