package dodo

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"strconv"
	"strings"
	"sync"
	"time"

	dodopayments "github.com/dodopayments/dodopayments-go"

	"github.com/anish/crypto-tool/openai-go-api/internal/billing"
)

// Service handles Dodo webhooks, checkout, and D1 subscription state.
type Service struct {
	d1  *billing.D1Store
	cfg Config
	api *dodopayments.Client

	plansMu     sync.Mutex
	plansCache  map[string]*plansCacheEntry
}

type plansCacheEntry struct {
	catalog *PlansCatalog
	expiry  time.Time
}

// PlanInfo describes a purchasable Pro plan for the frontend picker.
type PlanInfo struct {
	Key                string   `json:"key"`      // "monthly" | "yearly"
	Interval           string   `json:"interval"` // "month" | "year"
	ProductID          string   `json:"product_id"`
	Name               string   `json:"name,omitempty"`
	Description        string   `json:"description,omitempty"`
	Cadence            string   `json:"cadence,omitempty"`
	Recurring          bool     `json:"recurring"`
	PriceAmount        int64    `json:"price_amount,omitempty"` // minor units (e.g. cents)
	Currency           string   `json:"currency,omitempty"`
	PriceLabel         string   `json:"price_label,omitempty"`
	Badge              string   `json:"badge,omitempty"`
	MonthlyTokenLimit  int64    `json:"monthly_token_limit,omitempty"`
	MonthlyTokenLabel  string   `json:"monthly_token_label,omitempty"`
	Features           []string `json:"features,omitempty"`
}

// AITierInfo describes a non-purchasable AI quota tier (guest/free/pro).
type AITierInfo struct {
	PlanID            string `json:"plan_id"`
	DisplayName       string `json:"display_name"`
	MonthlyTokenLimit int64  `json:"monthly_token_limit"`
	TokenLabel        string `json:"token_label,omitempty"`
	ModelID           string `json:"model_id,omitempty"`
	Description       string `json:"description,omitempty"`
}

// PlansCatalog is the public plan-picker payload.
type PlansCatalog struct {
	ToolID        string       `json:"tool_id,omitempty"`
	PricingScope  string       `json:"pricing_scope,omitempty"` // "tool" | "global"
	Plans         []PlanInfo   `json:"plans"`
	AITiers       []AITierInfo `json:"ai_tiers"`
}

// NewService wires a Dodo billing service on top of the D1 store.
func NewService(store billing.Store, cfg Config) (*Service, error) {
	d1, err := billing.D1FromStore(store)
	if err != nil {
		return nil, err
	}
	var api *dodopayments.Client
	if cfg.APIKey != "" {
		api = newAPIClient(cfg)
	}
	return &Service{d1: d1, cfg: cfg, api: api}, nil
}

// UnwrapWebhook verifies Standard Webhooks headers and parses the event via the official SDK.
func (s *Service) UnwrapWebhook(payload []byte, headers http.Header) (*dodopayments.UnwrapWebhookEvent, error) {
	if s.api == nil || !s.cfg.WebhookEnabled() {
		return nil, errors.New("webhook not configured")
	}
	return s.api.Webhooks.Unwrap(payload, headers)
}

// UpsertUser ensures a users row exists (Google OAuth login).
func (s *Service) UpsertUser(ctx context.Context, userID, email, name string) error {
	if strings.TrimSpace(userID) == "" {
		return errors.New("user_id required")
	}
	now := time.Now().UTC().Format("2006-01-02 15:04:05")
	return s.d1.Exec(ctx,
		`INSERT INTO users (id, email, name, auth_provider, auth_id, created_at, last_active_at)
		 VALUES (?, ?, ?, 'google', ?, ?, ?)
		 ON CONFLICT(id) DO UPDATE SET
		   email = COALESCE(excluded.email, users.email),
		   name = COALESCE(excluded.name, users.name),
		   last_active_at = excluded.last_active_at`,
		userID, nullStr(email), nullStr(name), userID, now, now,
	)
}

// RecordWebhookIfNew inserts the webhook row; returns false if duplicate.
// Stores sanitized JSON only (no card/billing street PII).
func (s *Service) RecordWebhookIfNew(ctx context.Context, webhookID, eventType, businessID, eventTS, raw string) (bool, error) {
	exists, err := s.d1.Exists(ctx, `SELECT 1 FROM dodo_webhook_events WHERE webhook_id = ? LIMIT 1`, webhookID)
	if err != nil {
		return false, err
	}
	if exists {
		return false, nil
	}
	safe := SanitizeWebhookJSON(raw)
	err = s.d1.Exec(ctx,
		`INSERT INTO dodo_webhook_events (webhook_id, event_type, business_id, event_timestamp, payload_json)
		 VALUES (?, ?, ?, ?, ?)`,
		webhookID, eventType, businessID, eventTS, safe,
	)
	return err == nil, err
}

// ProcessWebhook applies a verified webhook payload.
func (s *Service) ProcessWebhook(ctx context.Context, webhookID, raw string) error {
	root := parseEvent(raw)
	eventType := str(root, "type")
	if eventType == "" {
		return s.markProcessed(ctx, webhookID, "ignored", "missing event type")
	}
	data := eventData(root)
	userID, _ := s.resolveUserID(ctx, root, data)

	var procErr error
	switch eventType {
	case "subscription.active", "subscription.renewed", "subscription.trialing":
		procErr = s.handleSubscriptionActive(ctx, userID, data, raw, subscriptionStatus(data, eventType))
	case "subscription.cancelled", "subscription.expired", "subscription.failed":
		procErr = s.handleSubscriptionEnded(ctx, userID, data, subscriptionStatus(data, eventType))
	case "subscription.on_hold":
		procErr = s.handleSubscriptionActive(ctx, userID, data, raw, "on_hold")
	case "payment.succeeded":
		procErr = s.handlePayment(ctx, userID, data, eventType, "succeeded", raw)
	case "payment.failed":
		procErr = s.handlePayment(ctx, userID, data, eventType, "failed", raw)
	case "payment.processing":
		procErr = s.handlePayment(ctx, userID, data, eventType, "processing", raw)
	default:
		return s.markProcessed(ctx, webhookID, "ignored", "unhandled: "+eventType)
	}
	if procErr != nil {
		_ = s.markProcessed(ctx, webhookID, "failed", procErr.Error())
		return procErr
	}
	return s.markProcessed(ctx, webhookID, "processed", "")
}

func (s *Service) resolveUserID(ctx context.Context, root eventRoot, data map[string]interface{}) (string, error) {
	if uid := metadataUserID(root); uid != "" {
		return uid, nil
	}
	if sid := checkoutSessionID(data); sid != "" {
		uid, err := s.userFromCheckoutSession(ctx, sid)
		if err != nil {
			return "", err
		}
		if uid != "" {
			return uid, nil
		}
	}
	return s.resolveUserByCustomer(ctx, customerID(data))
}

func (s *Service) userFromCheckoutSession(ctx context.Context, sessionID string) (string, error) {
	rows, err := s.d1.QueryRows(ctx,
		`SELECT user_id FROM dodo_checkout_sessions WHERE session_id = ? LIMIT 1`, sessionID)
	if err != nil {
		return "", err
	}
	if len(rows) == 0 {
		return "", nil
	}
	return str(rows[0], "user_id"), nil
}

func (s *Service) markProcessed(ctx context.Context, webhookID, status, errMsg string) error {
	return s.d1.Exec(ctx,
		`UPDATE dodo_webhook_events SET processing_status = ?, processing_error = ?, processed_at = datetime('now')
		 WHERE webhook_id = ?`,
		status, nullStr(errMsg), webhookID,
	)
}

func (s *Service) handleSubscriptionActive(ctx context.Context, userID string, data map[string]interface{}, raw, status string) error {
	subID := subscriptionID(data)
	if subID == "" {
		return errors.New("subscription event missing subscription_id")
	}
	if userID == "" {
		slog.Warn("subscription webhook without user_id", "subscription_id", subID, "customer_id", customerID(data))
		return errors.New("subscription event missing user_id (set metadata.user_id on checkout)")
	}
	safe := SanitizeWebhookJSON(raw)
	amount := recurringAmountCents(data)
	if amount == 0 {
		amount = paymentAmountCents(data)
	}
	if err := s.grantSubscription(ctx, userID, subID, customerID(data), productIDFromData(data), status,
		billingInterval(data, s.cfg), periodStart(data), periodEnd(data),
		"", cancelAtPeriodEnd(data),
		safe, customerID(data), str(data, "currency"), amount); err != nil {
		return err
	}
	_ = s.completeCheckout(ctx, userID, checkoutSessionID(data))
	return nil
}

func (s *Service) handleSubscriptionEnded(ctx context.Context, userID string, data map[string]interface{}, status string) error {
	subID := subscriptionID(data)
	if userID == "" {
		var err error
		userID, err = s.resolveUserByCustomer(ctx, customerID(data))
		if err != nil {
			return err
		}
	}
	if subID != "" {
		if err := s.d1.Exec(ctx,
			`UPDATE user_subscriptions SET status = ?, cancelled_at = COALESCE(?, cancelled_at), updated_at = datetime('now')
			 WHERE dodo_subscription_id = ?`,
			status, nullStr(str(data, "cancelled_at", "cancelledAt")), subID,
		); err != nil {
			return err
		}
	}
	if userID != "" {
		return s.syncEntitlement(ctx, userID)
	}
	return nil
}

func (s *Service) handlePayment(ctx context.Context, userID string, data map[string]interface{}, eventType, payStatus, raw string) error {
	pid := paymentID(data)
	if pid == "" {
		return nil
	}
	if userID == "" {
		var err error
		userID, err = s.resolveUserByCustomer(ctx, customerID(data))
		if err != nil {
			return err
		}
	}
	amount := paymentAmountCents(data)
	safe := SanitizeWebhookJSON(raw)
	if err := s.d1.Exec(ctx,
		`INSERT INTO dodo_payments (payment_id, user_id, dodo_subscription_id, dodo_customer_id,
		 dodo_checkout_session_id, event_type, status, amount_cents, currency, payload_json)
		 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
		 ON CONFLICT(payment_id) DO UPDATE SET
		   status = excluded.status,
		   amount_cents = excluded.amount_cents,
		   payload_json = excluded.payload_json`,
		pid, nullStr(userID), nullStr(subscriptionID(data)), nullStr(customerID(data)),
		nullStr(checkoutSessionID(data)), eventType, payStatus, nullInt64(amount),
		nullStr(str(data, "currency")), safe,
	); err != nil {
		return err
	}
	// Only succeeded + subscription unlocks Pro; processing is audit-only.
	if payStatus != "succeeded" {
		return nil
	}
	subID := subscriptionID(data)
	if subID != "" && userID != "" {
		return s.handleSubscriptionActive(ctx, userID, data, raw, "active")
	}
	if userID != "" && checkoutSessionID(data) != "" {
		_ = s.completeCheckout(ctx, userID, checkoutSessionID(data))
	}
	return nil
}

func (s *Service) grantSubscription(ctx context.Context, userID, subID, custID, productID, status, interval, periodStart, periodEnd, trialEnd string, cancelAt int, metaJSON, linkCustomer, currency string, amountCents int64) error {
	rowID := subID
	if rowID == "" {
		rowID = fmt.Sprintf("sub_%d", time.Now().UnixNano())
	}
	if err := s.d1.Exec(ctx,
		`INSERT INTO user_subscriptions (
			id, user_id, dodo_subscription_id, dodo_customer_id, dodo_product_id, plan_key, status,
			billing_interval, currency, amount_cents, current_period_start, current_period_end, trial_end,
			cancel_at_period_end, metadata_json, created_at, updated_at
		) VALUES (?, ?, ?, ?, ?, 'pro', ?, ?, ?, ?, ?, ?, ?, ?, ?, datetime('now'), datetime('now'))
		ON CONFLICT(dodo_subscription_id) DO UPDATE SET
			user_id = excluded.user_id,
			dodo_customer_id = COALESCE(excluded.dodo_customer_id, user_subscriptions.dodo_customer_id),
			dodo_product_id = COALESCE(excluded.dodo_product_id, user_subscriptions.dodo_product_id),
			status = excluded.status,
			billing_interval = COALESCE(excluded.billing_interval, user_subscriptions.billing_interval),
			currency = COALESCE(excluded.currency, user_subscriptions.currency),
			amount_cents = COALESCE(excluded.amount_cents, user_subscriptions.amount_cents),
			current_period_start = COALESCE(excluded.current_period_start, user_subscriptions.current_period_start),
			current_period_end = COALESCE(excluded.current_period_end, user_subscriptions.current_period_end),
			trial_end = COALESCE(excluded.trial_end, user_subscriptions.trial_end),
			cancel_at_period_end = excluded.cancel_at_period_end,
			metadata_json = COALESCE(excluded.metadata_json, user_subscriptions.metadata_json),
			updated_at = datetime('now')`,
		rowID, userID, subID, nullStr(custID), nullStr(productID), status,
		nullStr(interval), nullStr(currency), nullInt64(amountCents),
		nullStr(periodStart), nullStr(periodEnd), nullStr(trialEnd),
		cancelAt, nullStr(metaJSON),
	); err != nil {
		return err
	}
	if linkCustomer != "" {
		_ = s.d1.Exec(ctx,
			`UPDATE users SET dodo_customer_id = COALESCE(dodo_customer_id, ?) WHERE id = ?`,
			linkCustomer, userID,
		)
	}
	switch status {
	case "active", "trialing":
		return s.d1.Exec(ctx,
			`UPDATE users SET is_premium = 1, premium_until = ? WHERE id = ?`,
			nullStr(periodEnd), userID,
		)
	case "cancelled", "expired", "failed":
		return s.syncEntitlement(ctx, userID)
	}
	return nil
}

func (s *Service) syncEntitlement(ctx context.Context, userID string) error {
	rows, err := s.d1.QueryRows(ctx,
		`SELECT current_period_end FROM user_subscriptions
		 WHERE user_id = ? AND status IN ('active', 'trialing')
		 ORDER BY current_period_end DESC LIMIT 1`, userID)
	if err != nil {
		return err
	}
	if len(rows) == 0 {
		return s.d1.Exec(ctx, `UPDATE users SET is_premium = 0, premium_until = NULL WHERE id = ?`, userID)
	}
	end := str(rows[0], "current_period_end")
	return s.d1.Exec(ctx, `UPDATE users SET is_premium = 1, premium_until = ? WHERE id = ?`, nullStr(end), userID)
}

func (s *Service) resolveUserByCustomer(ctx context.Context, customerID string) (string, error) {
	if customerID == "" {
		return "", nil
	}
	rows, err := s.d1.QueryRows(ctx,
		`SELECT user_id FROM user_subscriptions WHERE dodo_customer_id = ? LIMIT 1`, customerID)
	if err != nil {
		return "", err
	}
	if len(rows) > 0 {
		return str(rows[0], "user_id"), nil
	}
	rows, err = s.d1.QueryRows(ctx, `SELECT id FROM users WHERE dodo_customer_id = ? LIMIT 1`, customerID)
	if err != nil || len(rows) == 0 {
		return "", err
	}
	return str(rows[0], "id"), nil
}

func (s *Service) completeCheckout(ctx context.Context, userID, sessionID string) error {
	if sessionID == "" {
		return nil
	}
	return s.d1.Exec(ctx,
		`UPDATE dodo_checkout_sessions SET status = 'completed', completed_at = datetime('now')
		 WHERE session_id = ? AND user_id = ?`, sessionID, userID)
}

// CreateCheckout starts a Dodo hosted checkout for a logged-in user.
// productID may be empty — resolved from billing_plans (tool override → global → env).
func (s *Service) CreateCheckout(ctx context.Context, userID, email, plan, productID, toolID, returnURL, cancelURL string) (*CheckoutResult, error) {
	if s.api == nil || !s.cfg.CheckoutEnabled() {
		return nil, errors.New("checkout not configured")
	}
	toolID = normalizeToolID(toolID)
	planKey := plan
	if planKey == "" {
		planKey = "monthly"
	}
	interval := intervalForKey(planKey)
	if productID == "" {
		var err error
		productID, interval, err = s.ResolveCheckoutProduct(ctx, toolID, planKey)
		if err != nil {
			return nil, err
		}
	} else if s.cfg.ProductYearly != "" && productID == s.cfg.ProductYearly {
		interval = "year"
	}
	if productID == "" {
		return nil, errProductNotConfigured
	}
	meta := map[string]string{
		"user_id":          userID,
		"plan_key":         "pro",
		"billing_interval": interval,
	}
	if toolID != "" {
		meta["tool_id"] = toolID
	}

	// Debug: log exactly what we send to Dodo so failures are diagnosable.
	mode := "test"
	if s.cfg.LiveMode {
		mode = "live"
	}
	slog.Info("dodo checkout: creating session",
		"mode", mode,
		"user_id", userID,
		"has_email", email != "",
		"plan", planKey,
		"tool_id", toolID,
		"interval", interval,
		"product_id", productID,
		"return_url", returnURL,
		"cancel_url", cancelURL,
		"api_base_override", s.cfg.APIBaseOverride,
	)

	req := dodopayments.CheckoutSessionRequestParam{
		ProductCart: dodopayments.F([]dodopayments.ProductItemReqParam{{
			ProductID: dodopayments.F(productID),
			Quantity:  dodopayments.F(int64(1)),
		}}),
		Metadata:  dodopayments.F(meta),
		ReturnURL: dodopayments.F(returnURL),
	}
	if cancelURL != "" {
		req.CancelURL = dodopayments.F(cancelURL)
	}
	if email != "" {
		req.Customer = dodopayments.F[dodopayments.CustomerRequestUnionParam](dodopayments.CustomerRequestParam{
			Email: dodopayments.F(email),
		})
	}
	sess, err := s.api.CheckoutSessions.New(ctx, dodopayments.CheckoutSessionNewParams{
		CheckoutSessionRequest: req,
	})
	if err != nil {
		// Surface the full upstream response so the exact missing field / connector
		// problem is visible in logs (Dodo errors carry the raw JSON body).
		var apiErr *dodopayments.Error
		if errors.As(err, &apiErr) {
			slog.Error("dodo checkout: API error",
				"mode", mode,
				"user_id", userID,
				"product_id", productID,
				"status", apiErr.StatusCode,
				"body", apiErr.Error(),
			)
		} else {
			slog.Error("dodo checkout: transport error",
				"mode", mode, "user_id", userID, "product_id", productID, "error", err.Error())
		}
		return nil, err
	}
	if sess.SessionID == "" || sess.CheckoutURL == "" {
		slog.Error("dodo checkout: incomplete response",
			"session_id", sess.SessionID, "has_checkout_url", sess.CheckoutURL != "")
		return nil, fmt.Errorf("unexpected checkout response: missing session_id or checkout_url")
	}
	slog.Info("dodo checkout: session created",
		"user_id", userID, "session_id", sess.SessionID, "product_id", productID)

	result := &CheckoutResult{SessionID: sess.SessionID, CheckoutURL: sess.CheckoutURL}
	metaJSON, _ := json.Marshal(meta)
	_ = s.d1.Exec(ctx,
		`INSERT INTO dodo_checkout_sessions (session_id, user_id, dodo_product_id, plan_key, billing_interval,
		 status, checkout_url, return_url, metadata_json) VALUES (?, ?, ?, 'pro', ?, 'open', ?, ?, ?)`,
		result.SessionID, userID, productID, interval, result.CheckoutURL, returnURL, string(metaJSON),
	)
	return result, nil
}

// planOverride is a billing_plans row (price/checkout display only).
// Tier limits & features come from ai_plans via aiPlanID.
type planOverride struct {
	productID         string
	interval          string
	name              string
	priceAmount       int64
	hasAmount         bool
	currency          string
	priceLabel        string
	badge             string
	description       string
	cadence           string
	aiPlanID          string
	hasToolOverride   bool
	sortOrder         int64
}

// PlansCatalog returns purchasable Pro plans plus AI tier comparison rows.
// toolID selects per-tool price overrides; falls back to global (tool_id '').
func (s *Service) PlansCatalog(ctx context.Context, toolID string) (*PlansCatalog, error) {
	toolID = normalizeToolID(toolID)
	cacheKey := toolID

	s.plansMu.Lock()
	if s.plansCache != nil {
		if entry, ok := s.plansCache[cacheKey]; ok && time.Now().Before(entry.expiry) {
			cached := entry.catalog
			s.plansMu.Unlock()
			return cached, nil
		}
	}
	s.plansMu.Unlock()

	catalog, err := s.buildPlansCatalog(ctx, toolID)
	if err != nil {
		return nil, err
	}

	s.plansMu.Lock()
	if s.plansCache == nil {
		s.plansCache = map[string]*plansCacheEntry{}
	}
	s.plansCache[cacheKey] = &plansCacheEntry{
		catalog: catalog,
		expiry:  time.Now().Add(10 * time.Minute),
	}
	s.plansMu.Unlock()
	return catalog, nil
}

// ListPlans returns only the purchasable plan rows (compat helper).
func (s *Service) ListPlans(ctx context.Context, toolID string) ([]PlanInfo, error) {
	catalog, err := s.PlansCatalog(ctx, toolID)
	if err != nil {
		return nil, err
	}
	if catalog == nil {
		return nil, nil
	}
	return catalog.Plans, nil
}

func (s *Service) buildPlansCatalog(ctx context.Context, toolID string) (*PlansCatalog, error) {
	overrides, dbOrder, hasToolPricing := s.loadPlanOverrides(ctx, toolID)

	type spec struct {
		key, interval, productID, badge string
	}
	var specs []spec
	if len(dbOrder) > 0 {
		// DB defines the catalog (active rows only, in sort order).
		for _, key := range dbOrder {
			o := overrides[key]
			productID := o.productID
			if productID == "" {
				productID = s.productForKey(key)
			}
			interval := o.interval
			if interval == "" {
				interval = intervalForKey(key)
			}
			specs = append(specs, spec{key, interval, productID, o.badge})
		}
	} else {
		// No DB rows: fall back to env-configured products.
		if s.cfg.ProductMonthly != "" {
			specs = append(specs, spec{"monthly", "month", s.cfg.ProductMonthly, ""})
		}
		if s.cfg.ProductYearly != "" {
			specs = append(specs, spec{"yearly", "year", s.cfg.ProductYearly, "Best value"})
		}
	}

	plans := make([]PlanInfo, 0, len(specs))
	for _, sp := range specs {
		o := overrides[sp.key]
		p := PlanInfo{Key: sp.key, Interval: sp.interval, ProductID: sp.productID, Badge: sp.badge}

		// Billing-specific display from billing_plans.
		if o.name != "" {
			p.Name = o.name
		}
		if o.description != "" {
			p.Description = o.description
		}
		if o.cadence != "" {
			p.Cadence = o.cadence
		}
		if o.priceLabel != "" {
			p.PriceLabel = o.priceLabel
		}
		if o.hasAmount {
			p.PriceAmount = o.priceAmount
			p.Currency = o.currency
			if p.PriceLabel == "" {
				p.PriceLabel = formatMoney(o.priceAmount, o.currency)
			}
		}

		// Tier commons from ai_plans (linked by ai_plan_id, default pro).
		aiPlanID := o.aiPlanID
		if aiPlanID == "" {
			aiPlanID = billing.PlanPro
		}
		if rec, ok := s.d1.GetAIPlan(ctx, aiPlanID); ok {
			p.MonthlyTokenLimit = rec.MonthlyTokenLimit
			p.MonthlyTokenLabel = formatTokenLimit(rec.MonthlyTokenLimit) + " / month"
			if len(rec.Features) > 0 {
				p.Features = append([]string(nil), rec.Features...)
			}
		}
		if p.Cadence == "" {
			if sp.key == "yearly" {
				p.Cadence = "Billed yearly"
			} else {
				p.Cadence = "Billed monthly · cancel anytime"
			}
		}

		// Fill any gaps the DB didn't specify from the live Dodo product.
		if (p.Name == "" || p.PriceLabel == "") && s.api != nil && sp.productID != "" {
			prod, err := s.api.Products.Get(ctx, sp.productID)
			if err != nil {
				slog.Warn("dodo plans: product fetch failed", "product_id", sp.productID, "error", err.Error())
			} else if prod != nil {
				p.Recurring = prod.IsRecurring
				if p.Name == "" {
					p.Name = prod.Name
				}
				if !o.hasAmount {
					p.PriceAmount = prod.Price.Price
					p.Currency = string(prod.Price.Currency)
				}
				if p.PriceLabel == "" {
					p.PriceLabel = formatMoney(prod.Price.Price, string(prod.Price.Currency))
				}
			}
		}
		if len(p.Features) == 0 && p.MonthlyTokenLimit > 0 {
			p.Features = defaultProFeatures(p.MonthlyTokenLimit)
		}
		plans = append(plans, p)
	}

	return &PlansCatalog{
		ToolID:       toolID,
		PricingScope: pricingScope(toolID, hasToolPricing),
		Plans:        plans,
		AITiers:      s.loadAITiers(ctx),
	}, nil
}

func pricingScope(toolID string, hasToolPricing bool) string {
	if toolID != "" && hasToolPricing {
		return "tool"
	}
	return "global"
}

// loadPlanOverrides merges global (tool_id '') and tool-specific billing_plans rows.
func (s *Service) loadPlanOverrides(ctx context.Context, toolID string) (map[string]planOverride, []string, bool) {
	overrides := map[string]planOverride{}
	var order []string
	hasToolPricing := false
	if s.d1 == nil {
		return overrides, order, false
	}

	toolID = normalizeToolID(toolID)
	sql := `SELECT plan_key, tool_id, product_id, billing_interval, name, price_amount, currency, price_label, badge,
	               description, cadence_label, ai_plan_id, sort_order
	        FROM billing_plans WHERE active = 1 AND tool_id = ''`
	params := []interface{}{}
	if toolID != "" {
		sql = `SELECT plan_key, tool_id, product_id, billing_interval, name, price_amount, currency, price_label, badge,
		              description, cadence_label, ai_plan_id, sort_order
		       FROM billing_plans WHERE active = 1 AND (tool_id = '' OR tool_id = ?)
		       ORDER BY sort_order, plan_key`
		params = append(params, toolID)
	} else {
		sql += ` ORDER BY sort_order, plan_key`
	}

	rows, err := s.d1.QueryRows(ctx, sql, params...)
	if err != nil {
		slog.Warn("dodo plans: billing_plans query failed; using env/Dodo", "error", err.Error(), "tool_id", toolID)
		return overrides, order, false
	}

	global := map[string]planOverride{}
	tool := map[string]planOverride{}
	globalOrder := []string{}
	toolOrder := []string{}

	for _, row := range rows {
		key := strings.TrimSpace(rowStr(row, "plan_key"))
		if key == "" {
			continue
		}
		o := parsePlanOverrideRow(row)
		tid := strings.TrimSpace(rowStr(row, "tool_id"))
		if tid == "" {
			global[key] = o
			globalOrder = appendUniqueKey(globalOrder, key)
		} else {
			o.hasToolOverride = true
			tool[key] = o
			toolOrder = appendUniqueKey(toolOrder, key)
			hasToolPricing = true
		}
	}

	order = globalOrder
	for _, k := range toolOrder {
		order = appendUniqueKey(order, k)
	}
	if len(order) == 0 {
		order = toolOrder
	}

	for _, key := range order {
		overrides[key] = mergePlanOverride(global[key], tool[key])
	}
	return overrides, order, hasToolPricing
}

func parsePlanOverrideRow(row map[string]interface{}) planOverride {
	o := planOverride{
		productID:   strings.TrimSpace(rowStr(row, "product_id")),
		interval:    strings.TrimSpace(rowStr(row, "billing_interval")),
		name:        strings.TrimSpace(rowStr(row, "name")),
		currency:    strings.TrimSpace(rowStr(row, "currency")),
		priceLabel:  strings.TrimSpace(rowStr(row, "price_label")),
		badge:       strings.TrimSpace(rowStr(row, "badge")),
		description: strings.TrimSpace(rowStr(row, "description")),
		cadence:     strings.TrimSpace(rowStr(row, "cadence_label")),
		aiPlanID:    strings.TrimSpace(rowStr(row, "ai_plan_id")),
	}
	if amt, ok := rowInt(row, "price_amount"); ok {
		o.priceAmount = amt
		o.hasAmount = true
	}
	if sort, ok := rowInt(row, "sort_order"); ok {
		o.sortOrder = sort
	}
	return o
}

func (s *Service) productForKey(key string) string {
	if key == "yearly" || key == "year" {
		return s.cfg.ProductYearly
	}
	return s.cfg.ProductMonthly
}

func intervalForKey(key string) string {
	if key == "yearly" || key == "year" {
		return "year"
	}
	return "month"
}

// rowStr coerces a D1 column value to a trimmed-friendly string.
func rowStr(row map[string]interface{}, key string) string {
	v, ok := row[key]
	if !ok || v == nil {
		return ""
	}
	switch t := v.(type) {
	case string:
		return t
	case float64:
		return strconv.FormatFloat(t, 'f', -1, 64)
	default:
		return fmt.Sprintf("%v", t)
	}
}

// rowInt coerces a D1 numeric column (JSON number/string) to int64.
func rowInt(row map[string]interface{}, key string) (int64, bool) {
	v, ok := row[key]
	if !ok || v == nil {
		return 0, false
	}
	switch t := v.(type) {
	case float64:
		return int64(t), true
	case int64:
		return t, true
	case string:
		n, err := strconv.ParseInt(strings.TrimSpace(t), 10, 64)
		if err != nil {
			return 0, false
		}
		return n, true
	default:
		return 0, false
	}
}

func (s *Service) loadAITiers(ctx context.Context) []AITierInfo {
	if s.d1 == nil {
		return defaultAITiers()
	}
	rows, err := s.d1.ListAIPlans(ctx)
	if err != nil || len(rows) == 0 {
		if err != nil {
			slog.Warn("dodo plans: ai_plans list failed; using defaults", "error", err.Error())
		}
		return defaultAITiers()
	}
	out := make([]AITierInfo, 0, len(rows))
	for _, row := range rows {
		out = append(out, AITierInfo{
			PlanID:            row.PlanID,
			DisplayName:       row.DisplayName,
			MonthlyTokenLimit: row.MonthlyTokenLimit,
			TokenLabel:        formatTokenLimit(row.MonthlyTokenLimit) + " / month",
			ModelID:           row.ModelID,
			Description:       row.Description,
		})
	}
	return out
}

func defaultAITiers() []AITierInfo {
	return []AITierInfo{
		{PlanID: "guest", DisplayName: "Guest", MonthlyTokenLimit: 20_000, TokenLabel: "20K / month", ModelID: "gpt-5.4-nano"},
		{PlanID: "free", DisplayName: "Free account", MonthlyTokenLimit: 200_000, TokenLabel: "200K / month", ModelID: "gpt-5.4-mini"},
		{PlanID: "pro", DisplayName: "Pro", MonthlyTokenLimit: 2_000_000, TokenLabel: "2M / month", ModelID: "gpt-5.4"},
	}
}

func defaultProFeatures(tokenLimit int64) []string {
	label := formatTokenLimit(tokenLimit)
	if label == "" {
		label = "Higher"
	}
	return []string{
		label + " AI tokens per month",
		"No rate-limit waiting between requests",
		"Priority access on Arduino & other tools",
	}
}

func formatTokenLimit(n int64) string {
	if n <= 0 {
		return ""
	}
	if n >= 1_000_000 {
		whole := n / 1_000_000
		rem := (n % 1_000_000) / 100_000
		if rem == 0 {
			return fmt.Sprintf("%dM", whole)
		}
		return fmt.Sprintf("%.1fM", float64(n)/1_000_000.0)
	}
	if n >= 1_000 {
		whole := n / 1_000
		if n%1_000 == 0 {
			return fmt.Sprintf("%dK", whole)
		}
		return fmt.Sprintf("%.1fK", float64(n)/1_000.0)
	}
	return strconv.FormatInt(n, 10)
}

// formatMoney renders minor-unit amounts (e.g. cents) into a display label.
// Assumes 2-decimal currencies; callers may override labels on the frontend.
func formatMoney(amountMinor int64, currency string) string {
	if amountMinor <= 0 || currency == "" {
		return ""
	}
	cur := strings.ToUpper(currency)
	symbols := map[string]string{
		"USD": "$", "EUR": "\u20ac", "GBP": "\u00a3", "INR": "\u20b9",
		"AUD": "A$", "CAD": "C$", "SGD": "S$", "JPY": "\u00a5",
	}
	// JPY is zero-decimal.
	if cur == "JPY" {
		return symbols[cur] + strconv.FormatInt(amountMinor, 10)
	}
	major := float64(amountMinor) / 100.0
	amt := strconv.FormatFloat(major, 'f', 2, 64)
	if sym, ok := symbols[cur]; ok {
		return sym + amt
	}
	return cur + " " + amt
}

// BillingStatus returns premium + subscription info for a user.
func (s *Service) BillingStatus(ctx context.Context, userID string) (map[string]interface{}, error) {
	users, err := s.d1.QueryRows(ctx,
		`SELECT id, email, is_premium, premium_until, dodo_customer_id FROM users WHERE id = ? LIMIT 1`, userID)
	if err != nil {
		return nil, err
	}
	subs, err := s.d1.QueryRows(ctx,
		`SELECT dodo_subscription_id, status, plan_key, billing_interval, current_period_end, cancel_at_period_end
		 FROM user_active_subscription WHERE user_id = ? LIMIT 1`, userID)
	if err != nil {
		return nil, err
	}
	out := map[string]interface{}{
		"user_id": userID,
	}
	if len(users) > 0 {
		u := users[0]
		out["email"] = u["email"]
		out["is_premium"] = asBoolInt(u["is_premium"])
		out["premium_until"] = u["premium_until"]
		out["dodo_customer_id"] = u["dodo_customer_id"]
	} else {
		out["is_premium"] = false
	}
	if len(subs) > 0 {
		out["subscription"] = subs[0]
	} else {
		out["subscription"] = nil
	}
	return out, nil
}

func (s *Service) Config() Config { return s.cfg }

func nullStr(v string) interface{} {
	v = strings.TrimSpace(v)
	if v == "" {
		return nil
	}
	return v
}

func nullInt64(v int64) interface{} {
	if v == 0 {
		return nil
	}
	return v
}

func asBoolInt(v interface{}) bool {
	switch t := v.(type) {
	case float64:
		return int(t) == 1
	case int:
		return t == 1
	case int64:
		return t == 1
	default:
		return false
	}
}
