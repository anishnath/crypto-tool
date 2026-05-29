package handler

import (
	"encoding/json"
	"errors"
	"io"
	"log/slog"
	"net/http"
	"strings"
	"time"
)

const maxWebhookBody = 1 << 20 // 1 MiB

// BillingWebhook handles Dodo Payments webhooks (POST /v1/billing/webhook).
func (a *API) BillingWebhook(w http.ResponseWriter, r *http.Request) {
	if a.dodo == nil {
		writeBillingError(w, http.StatusServiceUnavailable, "billing not configured")
		return
	}
	if !a.dodo.Config().WebhookEnabled() {
		writeBillingError(w, http.StatusServiceUnavailable, "webhook not configured")
		return
	}

	raw, err := io.ReadAll(io.LimitReader(r.Body, maxWebhookBody))
	if err != nil {
		writeBillingError(w, http.StatusBadRequest, "read body failed")
		return
	}

	unwrapped, err := a.dodo.UnwrapWebhook(raw, r.Header)
	if err != nil {
		slog.Debug("webhook signature verification failed", "error", err)
		writeBillingError(w, http.StatusUnauthorized, "invalid signature")
		return
	}

	webhookID := strings.TrimSpace(r.Header.Get("webhook-id"))
	eventType := string(unwrapped.Type)
	businessID := unwrapped.BusinessID
	eventTS := unwrapped.Timestamp.Format(time.RFC3339Nano)

	isNew, err := a.dodo.RecordWebhookIfNew(r.Context(), webhookID, eventType, businessID, eventTS, string(raw))
	if err != nil {
		slog.Error("webhook record failed", "webhook_id", webhookID, "error", err)
		writeBillingError(w, http.StatusInternalServerError, "storage error")
		return
	}
	if !isNew {
		writeBillingJSON(w, http.StatusOK, map[string]interface{}{"received": true, "duplicate": true})
		return
	}

	if err := a.dodo.ProcessWebhook(r.Context(), webhookID, string(raw)); err != nil {
		slog.Error("webhook process failed", "webhook_id", webhookID, "error", err)
		writeBillingError(w, http.StatusInternalServerError, "processing failed")
		return
	}
	writeBillingJSON(w, http.StatusOK, map[string]interface{}{"received": true})
}

type checkoutRequest struct {
	Plan       string `json:"plan"`
	ProductID  string `json:"product_id"`
	ToolID     string `json:"tool_id"`
	ReturnPath string `json:"return_path"`
	ReturnURL  string `json:"return_url"`
	CancelPath string `json:"cancel_path"`
	CancelURL  string `json:"cancel_url"`
}

// BillingCheckout creates a Dodo checkout session (POST /v1/billing/checkout).
// Requires X-User-Id (and optional X-User-Email) from the Java proxy or direct callers.
func (a *API) BillingCheckout(w http.ResponseWriter, r *http.Request) {
	if a.dodo == nil || !a.dodo.Config().CheckoutEnabled() {
		writeBillingError(w, http.StatusServiceUnavailable, "checkout not configured")
		return
	}
	userID := strings.TrimSpace(r.Header.Get("X-User-Id"))
	if userID == "" {
		writeBillingError(w, http.StatusUnauthorized, "login required")
		return
	}
	email := strings.TrimSpace(r.Header.Get("X-User-Email"))

	var req checkoutRequest
	if r.Body != nil {
		_ = json.NewDecoder(io.LimitReader(r.Body, 1<<16)).Decode(&req)
	}
	plan := req.Plan
	if plan == "" {
		plan = "monthly"
	}
	returnURL := req.ReturnURL
	if returnURL == "" && req.ReturnPath != "" {
		returnURL = buildReturnURL(r, req.ReturnPath)
	}
	cancelURL := req.CancelURL
	if cancelURL == "" && req.CancelPath != "" {
		cancelURL = buildReturnURL(r, req.CancelPath)
	}
	// Default cancel target to the return target's page so a "back"/cancel lands
	// the user back where they started instead of a dead end.
	if cancelURL == "" {
		cancelURL = returnURL
	}

	toolID := strings.TrimSpace(req.ToolID)
	if toolID == "" {
		toolID = strings.TrimSpace(r.Header.Get("X-Tool-Id"))
	}

	result, err := a.dodo.CreateCheckout(r.Context(), userID, email, plan, req.ProductID, toolID, returnURL, cancelURL)
	if err != nil {
		slog.Error("checkout failed", "user_id", userID, "error", err)
		writeBillingError(w, http.StatusBadGateway, err.Error())
		return
	}
	writeBillingJSON(w, http.StatusOK, result)
}

// BillingPlans returns the purchasable Pro plans (GET /v1/billing/plans).
// Public — no auth required; safe to render in the upgrade UI.
func (a *API) BillingPlans(w http.ResponseWriter, r *http.Request) {
	if a.dodo == nil || !a.dodo.Config().CheckoutEnabled() {
		writeBillingJSON(w, http.StatusOK, map[string]interface{}{
			"plans":    []interface{}{},
			"ai_tiers": []interface{}{},
		})
		return
	}
	toolID := strings.TrimSpace(r.URL.Query().Get("tool"))
	if toolID == "" {
		toolID = strings.TrimSpace(r.Header.Get("X-Tool-Id"))
	}
	catalog, err := a.dodo.PlansCatalog(r.Context(), toolID)
	if err != nil {
		slog.Error("list plans failed", "error", err)
		writeBillingError(w, http.StatusBadGateway, err.Error())
		return
	}
	if catalog == nil {
		writeBillingJSON(w, http.StatusOK, map[string]interface{}{
			"plans":    []interface{}{},
			"ai_tiers": []interface{}{},
		})
		return
	}
	writeBillingJSON(w, http.StatusOK, catalog)
}

// BillingStatus returns subscription state (GET /v1/billing/status).
func (a *API) BillingStatus(w http.ResponseWriter, r *http.Request) {
	if a.dodo == nil {
		writeBillingError(w, http.StatusServiceUnavailable, "billing not configured")
		return
	}
	userID := strings.TrimSpace(r.Header.Get("X-User-Id"))
	if userID == "" {
		writeBillingError(w, http.StatusUnauthorized, "login required")
		return
	}
	status, err := a.dodo.BillingStatus(r.Context(), userID)
	if err != nil {
		writeBillingError(w, http.StatusInternalServerError, err.Error())
		return
	}
	writeBillingJSON(w, http.StatusOK, status)
}

type upsertUserRequest struct {
	UserID string `json:"user_id"`
	Email  string `json:"email"`
	Name   string `json:"name"`
}

// BillingUpsertUser ensures a D1 users row exists (POST /v1/billing/users/upsert).
// Protected by BILLING_INTERNAL_SECRET when set.
func (a *API) BillingUpsertUser(w http.ResponseWriter, r *http.Request) {
	if a.dodo == nil {
		writeBillingError(w, http.StatusServiceUnavailable, "billing not configured")
		return
	}
	if secret := a.dodo.Config().InternalSecret; secret != "" {
		if r.Header.Get("X-Billing-Internal-Secret") != secret {
			writeBillingError(w, http.StatusForbidden, "forbidden")
			return
		}
	}
	var req upsertUserRequest
	if err := json.NewDecoder(io.LimitReader(r.Body, 1<<16)).Decode(&req); err != nil {
		writeBillingError(w, http.StatusBadRequest, "invalid json")
		return
	}
	if strings.TrimSpace(req.UserID) == "" {
		writeBillingError(w, http.StatusBadRequest, "user_id required")
		return
	}
	if err := a.dodo.UpsertUser(r.Context(), req.UserID, req.Email, req.Name); err != nil {
		writeBillingError(w, http.StatusInternalServerError, err.Error())
		return
	}
	writeBillingJSON(w, http.StatusOK, map[string]interface{}{"ok": true})
}

func writeBillingError(w http.ResponseWriter, code int, msg string) {
	writeBillingJSON(w, code, map[string]string{"error": msg})
}

func writeBillingJSON(w http.ResponseWriter, code int, v interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	_ = json.NewEncoder(w).Encode(v)
}

func buildReturnURL(r *http.Request, path string) string {
	if strings.HasPrefix(path, "http://") || strings.HasPrefix(path, "https://") {
		return path
	}
	scheme := "https"
	if r.TLS == nil {
		if xf := r.Header.Get("X-Forwarded-Proto"); xf != "" {
			scheme = xf
		} else {
			scheme = "http"
		}
	}
	host := r.Host
	if h := r.Header.Get("X-Forwarded-Host"); h != "" {
		host = h
	}
	if !strings.HasPrefix(path, "/") {
		path = "/" + path
	}
	return scheme + "://" + host + path
}

func parseBillingJSON(raw []byte) map[string]interface{} {
	var m map[string]interface{}
	_ = json.Unmarshal(raw, &m)
	return m
}

func strMap(m map[string]interface{}, keys ...string) string {
	for _, k := range keys {
		if v, ok := m[k]; ok && v != nil {
			switch t := v.(type) {
			case string:
				if t != "" {
					return t
				}
			}
		}
	}
	return ""
}

// ErrBillingNotConfigured is returned when handlers need D1 but it is disabled.
var ErrBillingNotConfigured = errors.New("billing not configured")
