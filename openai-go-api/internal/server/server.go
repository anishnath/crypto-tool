package server

import (
	"log/slog"
	"net/http"

	"github.com/anish/crypto-tool/openai-go-api/internal/billing"
	"github.com/anish/crypto-tool/openai-go-api/internal/billing/dodo"
	"github.com/anish/crypto-tool/openai-go-api/internal/config"
	"github.com/anish/crypto-tool/openai-go-api/internal/handler"
	"github.com/anish/crypto-tool/openai-go-api/internal/middleware"
	"github.com/anish/crypto-tool/openai-go-api/internal/service"
)

// Server is the HTTP API server.
type Server struct {
	cfg     config.Config
	gateway *service.Gateway
	billing *billing.Logger
	dodo    *dodo.Service
}

// New builds a Server from configuration.
func New(cfg config.Config) *Server {
	var dodoSvc *dodo.Service
	if svc, err := dodo.NewService(cfg.Billing, dodo.LoadConfig()); err == nil {
		dodoSvc = svc
	} else {
		slog.Debug("dodo billing unavailable", "error", err)
	}
	return &Server{
		cfg:     cfg,
		gateway: service.NewGateway(cfg.Registry),
		billing: billing.NewLogger(cfg.Billing),
		dodo:    dodoSvc,
	}
}

// Handler returns the root HTTP handler with all routes registered.
func (s *Server) Handler() http.Handler {
	api := handler.NewAPI(s.gateway, s.billing, s.dodo)
	mux := http.NewServeMux()

	mux.HandleFunc("GET /health", api.Health)
	mux.HandleFunc("GET /v1/models", api.Models)
	mux.HandleFunc("GET /v1/models/{id}", api.ModelByID)
	mux.HandleFunc("GET /v1/ai/quota", api.AIQuota)
	mux.HandleFunc("POST /v1/chat/completions", api.ChatCompletions)
	mux.HandleFunc("POST /v1/responses", api.Responses)

	// Dodo subscriptions — all D1 writes happen here
	mux.HandleFunc("POST /v1/billing/webhook", api.BillingWebhook)
	mux.HandleFunc("POST /v1/billing/checkout", api.BillingCheckout)
	mux.HandleFunc("GET /v1/billing/plans", api.BillingPlans)
	mux.HandleFunc("GET /v1/billing/status", api.BillingStatus)
	mux.HandleFunc("POST /v1/billing/users/upsert", api.BillingUpsertUser)

	return middleware.Logging(mux)
}

// ListenAndServe starts the HTTP server on the configured port.
func (s *Server) ListenAndServe() error {
	addr := ":" + s.cfg.Port
	slog.Info("server listening",
		"addr", "http://localhost"+addr,
		"catalog", s.cfg.CatalogPath,
		"default_model", s.cfg.DefaultModel,
		"providers", s.gateway.ProviderIDs(),
		"billing", s.billing.Enabled(),
		"dodo_billing", s.dodo != nil,
	)
	return http.ListenAndServe(addr, s.Handler())
}
