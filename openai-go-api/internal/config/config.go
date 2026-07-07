package config

import (
	"fmt"
	"os"
	"slices"
	"strings"

	"github.com/anish/crypto-tool/openai-go-api/internal/billing"
	"github.com/anish/crypto-tool/openai-go-api/internal/catalog"
	"github.com/anish/crypto-tool/openai-go-api/internal/provider/compatible"
	"github.com/anish/crypto-tool/openai-go-api/internal/registry"
)

// Config is the assembled runtime configuration.
type Config struct {
	Port               string
	DefaultModel       string
	DefaultVisionModel string
	CatalogPath        string
	Registry           *registry.Registry
	Billing            billing.Store
}

// Load builds config from three layers:
//  1. Provider credentials (env secrets)
//  2. Model catalog (YAML file)
//  3. Runtime policy (PORT, DEFAULT_MODEL, MODEL_CATALOG_PATH)
func Load() (Config, error) {
	policy := loadPolicy()

	catalogFile, err := loadCatalogFile(policy.ModelCatalogPath)
	if err != nil {
		return Config{}, err
	}

	defaultModel, err := catalogFile.resolveDefault(policy.DefaultModel)
	if err != nil {
		return Config{}, err
	}

	visionModel, err := catalogFile.resolveVisionModel(policy.DefaultVisionModel)
	if err != nil {
		return Config{}, err
	}

	providers, err := loadProviders(catalogFile.providerIDs())
	if err != nil {
		return Config{}, err
	}

	entries, err := buildRegistryEntries(catalogFile.activeModels(), providers)
	if err != nil {
		return Config{}, err
	}

	providerInfos := buildProviderInfos(catalogFile.activeModels(), providers)
	reg, err := registry.New(defaultModel, visionModel, policy.ModelCatalogPath, entries, providerInfos)
	if err != nil {
		return Config{}, err
	}

	return Config{
		Port:               policy.Port,
		DefaultModel:       defaultModel,
		DefaultVisionModel: visionModel,
		CatalogPath:        policy.ModelCatalogPath,
		Registry:           reg,
		Billing:            billing.LoadStore(),
	}, nil
}

func buildRegistryEntries(models []ModelDecl, providers map[string]*compatible.Client) ([]registry.ModelEntry, error) {
	entries := make([]registry.ModelEntry, 0, len(models))
	for _, m := range models {
		providerID := strings.ToLower(strings.TrimSpace(m.Provider))
		backend, ok := providers[providerID]
		if !ok {
			return nil, fmt.Errorf("provider %q has no API key for model %q", providerID, m.ID)
		}
		modalities := catalog.MergeModalities(m.ID, m.Modalities)
		var sampling *catalog.SamplingProfile
		if profile, ok := catalog.Lookup(m.ID); ok {
			s := profile.Sampling
			sampling = &s
		}
		entries = append(entries, registry.ModelEntry{
			ID:           m.ID,
			ProviderID:   providerID,
			Modalities:   modalities,
			Capabilities: m.Capabilities,
			Sampling:     sampling,
			Backend:      backend,
		})
	}
	return entries, nil
}

func buildProviderInfos(models []ModelDecl, clients map[string]*compatible.Client) []registry.ProviderInfo {
	byProvider := make(map[string][]string)
	for _, m := range models {
		pid := strings.ToLower(strings.TrimSpace(m.Provider))
		byProvider[pid] = append(byProvider[pid], m.ID)
	}
	infos := make([]registry.ProviderInfo, 0, len(clients))
	for pid := range clients {
		baseURL := strings.TrimSpace(os.Getenv(providerEnvKey(pid, "BASE_URL")))
		if baseURL == "" {
			baseURL = defaultBaseURLs[pid]
		}
		infos = append(infos, registry.ProviderInfo{
			ID:       pid,
			BaseURL:  baseURL,
			ModelIDs: byProvider[pid],
		})
	}
	slices.SortFunc(infos, func(a, b registry.ProviderInfo) int {
		return strings.Compare(a.ID, b.ID)
	})
	return infos
}

func envOrDefault(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}
