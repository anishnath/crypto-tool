package dodo

import (
	"os"
	"strings"
)

// Config holds Dodo Payments settings from environment variables.
type Config struct {
	APIKey          string
	WebhookKey      string
	LiveMode        bool
	APIBaseOverride string // optional; SDK default is test/live host
	ProductMonthly  string
	ProductYearly   string
	InternalSecret  string
}

// LoadConfig reads Dodo settings from the environment.
func LoadConfig() Config {
	mode := strings.ToLower(strings.TrimSpace(os.Getenv("DODO_PAYMENTS_MODE")))
	live := mode == "live"
	// Official SDK also reads DODO_PAYMENTS_BASE_URL; we support both names.
	base := strings.TrimSpace(os.Getenv("DODO_PAYMENTS_BASE_URL"))
	if base == "" {
		base = strings.TrimSpace(os.Getenv("DODO_PAYMENTS_API_BASE"))
	}
	base = strings.TrimRight(base, "/")
	return Config{
		APIKey:          strings.TrimSpace(os.Getenv("DODO_PAYMENTS_API_KEY")),
		WebhookKey:      strings.TrimSpace(os.Getenv("DODO_PAYMENTS_WEBHOOK_KEY")),
		LiveMode:        live,
		APIBaseOverride: base,
		ProductMonthly:  strings.TrimSpace(os.Getenv("DODO_PRODUCT_PRO_MONTHLY")),
		ProductYearly:   strings.TrimSpace(os.Getenv("DODO_PRODUCT_PRO_YEARLY")),
		InternalSecret:  strings.TrimSpace(os.Getenv("BILLING_INTERNAL_SECRET")),
	}
}

func (c Config) CheckoutEnabled() bool {
	return c.APIKey != "" && (c.ProductMonthly != "" || c.ProductYearly != "")
}

func (c Config) WebhookEnabled() bool {
	return c.WebhookKey != ""
}
