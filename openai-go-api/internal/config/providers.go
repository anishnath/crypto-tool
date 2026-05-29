package config

import (
	"fmt"
	"os"
	"strings"

	"github.com/anish/crypto-tool/openai-go-api/internal/provider/compatible"
)

var defaultBaseURLs = map[string]string{
	"openai":   "https://api.openai.com/v1",
	"minimax":  "https://api.minimaxi.com/v1",
	"mimo":     "https://api.xiaomimimo.com/v1",
	"deepseek": "https://api.deepseek.com/v1",
}

func loadProviders(providerIDs []string) (map[string]*compatible.Client, error) {
	out := make(map[string]*compatible.Client, len(providerIDs))
	for _, id := range providerIDs {
		client, err := loadProviderClient(id)
		if err != nil {
			return nil, err
		}
		out[id] = client
	}
	return out, nil
}

func loadProviderClient(providerID string) (*compatible.Client, error) {
	key := providerEnvKey(providerID, "API_KEY")
	apiKey := strings.TrimSpace(os.Getenv(key))
	if apiKey == "" {
		return nil, fmt.Errorf("missing %s for provider %q (layer 1: provider credentials)", key, providerID)
	}
	baseURL := strings.TrimSpace(os.Getenv(providerEnvKey(providerID, "BASE_URL")))
	if baseURL == "" {
		baseURL = defaultBaseURLs[providerID]
	}
	if baseURL == "" {
		return nil, fmt.Errorf("missing %s_BASE_URL for provider %q (no default)", strings.ToUpper(providerID), providerID)
	}
	return compatible.NewClient(providerID, apiKey, baseURL), nil
}

func providerEnvKey(providerID, suffix string) string {
	return strings.ToUpper(providerID) + "_" + suffix
}
