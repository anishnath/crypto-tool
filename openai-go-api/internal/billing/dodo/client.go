package dodo

import (
	dodopayments "github.com/dodopayments/dodopayments-go"
	"github.com/dodopayments/dodopayments-go/option"
)

// newAPIClient builds the official Dodo Payments SDK client.
// See https://pkg.go.dev/github.com/dodopayments/dodopayments-go
func newAPIClient(cfg Config) *dodopayments.Client {
	opts := []option.RequestOption{
		option.WithBearerToken(cfg.APIKey),
	}
	if cfg.LiveMode {
		opts = append(opts, option.WithEnvironmentLiveMode())
	} else {
		opts = append(opts, option.WithEnvironmentTestMode())
	}
	if cfg.WebhookKey != "" {
		opts = append(opts, option.WithWebhookKey(cfg.WebhookKey))
	}
	// DODO_PAYMENTS_BASE_URL is read automatically by DefaultClientOptions when set;
	// we apply it explicitly when overriding test/live hosts.
	if base := cfg.APIBaseOverride; base != "" {
		opts = append(opts, option.WithBaseURL(base))
	}
	return dodopayments.NewClient(opts...)
}
