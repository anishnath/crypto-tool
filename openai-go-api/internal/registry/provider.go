package registry

// ProviderInfo is public metadata for a configured provider (no secrets).
type ProviderInfo struct {
	ID       string   `json:"id"`
	BaseURL  string   `json:"base_url"`
	ModelIDs []string `json:"model_ids"`
}
