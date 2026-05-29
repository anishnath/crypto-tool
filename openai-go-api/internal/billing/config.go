package billing

import (
	"log/slog"
	"os"
	"strings"
)

const (
	defaultAccountID  = "7e50090f0972664d8e6985f1e83131a3"
	defaultDatabaseID = "b146fd57-6fcc-4847-8b3f-17a9e747758b"
)

// LoadStore returns a D1 store when configured, otherwise a no-op store.
func LoadStore() Store {
	if !envBool("D1_BILLING_ENABLED", true) {
		slog.Info("billing disabled", "reason", "D1_BILLING_ENABLED=false")
		return NoopStore{}
	}
	token := strings.TrimSpace(os.Getenv("CLOUDFLARE_API_TOKEN"))
	accountID := envOr("CLOUDFLARE_ACCOUNT_ID", defaultAccountID)
	databaseID := envOr("D1_DATABASE_ID", defaultDatabaseID)
	if token == "" {
		slog.Info("billing disabled", "reason", "CLOUDFLARE_API_TOKEN not set")
		return NoopStore{}
	}
	store, err := NewD1Store(D1Config{
		AccountID:  accountID,
		DatabaseID: databaseID,
		APIToken:   token,
	})
	if err != nil {
		slog.Warn("billing disabled", "error", err)
		return NoopStore{}
	}
	slog.Info("billing enabled", "database_id", databaseID)
	return store
}

func envOr(key, fallback string) string {
	if v := strings.TrimSpace(os.Getenv(key)); v != "" {
		return v
	}
	return fallback
}

func envBool(key string, fallback bool) bool {
	v := strings.TrimSpace(os.Getenv(key))
	if v == "" {
		return fallback
	}
	switch strings.ToLower(v) {
	case "1", "true", "yes", "on":
		return true
	case "0", "false", "no", "off":
		return false
	default:
		return fallback
	}
}
