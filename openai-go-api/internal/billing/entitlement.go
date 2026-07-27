package billing

import (
	"context"
	"encoding/json"
	"strings"
	"time"
)

// ToolIDManic is the billing/tool slug for the manic playground.
const ToolIDManic = "developer-tools/manic"

// PlanUltra is the Manic Ultra tier slug (also an ai_plans row).
const PlanUltra = "ultra"

// PlanManicPro is the AI allotment for Manic Pro purchases (lower than global Pro).
// Entitlement plan_slug stays "pro"; only AI quota resolution uses this id.
const PlanManicPro = "manic_pro"

// ToolEntitlement is the resolved plan for a user on a specific tool.
type ToolEntitlement struct {
	ToolID  string                 `json:"tool_id"`
	Plan    string                 `json:"plan"` // guest | free | pro | ultra
	Source  ToolEntitlementSource  `json:"source"`
	Covers  []ToolCoverageGrant    `json:"covers,omitempty"`
	Upgrade ToolEntitlementUpgrade `json:"upgrade,omitempty"`
}

// ToolEntitlementSource explains how the plan was resolved.
type ToolEntitlementSource struct {
	Kind          string `json:"kind"` // anonymous | free | direct | coverage
	ToolID        string `json:"tool_id,omitempty"`
	PurchasedPlan string `json:"purchased_plan,omitempty"`
	ProductID     string `json:"product_id,omitempty"`
	PeriodEnd     string `json:"current_period_end,omitempty"`
}

// ToolCoverageGrant is a cheaper tool unlocked by a higher purchase.
type ToolCoverageGrant struct {
	ToolID     string `json:"tool_id"`
	GrantsPlan string `json:"grants_plan"`
}

// ToolEntitlementUpgrade hints checkout options for the UI.
type ToolEntitlementUpgrade struct {
	Available      []string `json:"available,omitempty"`
	CheckoutToolID string   `json:"checkout_tool_id,omitempty"`
}

type toolEntRow struct {
	ToolID             string
	PlanSlug           string
	Status             string
	SourceProductID    string
	SourceSubscription string
	PeriodEnd          string
}

// ResolveToolEntitlement returns the plan slug for user on toolID.
//
// Manic never falls back to global is_premium — other-tool Pro ≠ Manic Pro.
// Anonymous → guest; logged-in with no direct/coverage grant → free.
func (s *D1Store) ResolveToolEntitlement(ctx context.Context, userID, toolID string) (ToolEntitlement, error) {
	toolID = strings.TrimSpace(toolID)
	out := ToolEntitlement{
		ToolID: toolID,
		Plan:   PlanGuest,
		Source: ToolEntitlementSource{Kind: "anonymous"},
		Upgrade: ToolEntitlementUpgrade{
			CheckoutToolID: toolID,
		},
	}
	if toolID == "" {
		return out, nil
	}

	if userID == "" {
		out.Upgrade.Available = upgradeSlugs(toolID, PlanGuest)
		return out, nil
	}

	out.Plan = PlanFree
	out.Source = ToolEntitlementSource{Kind: "free"}

	direct, err := s.activeToolEntitlement(ctx, userID, toolID)
	if err != nil {
		return out, err
	}
	if direct != nil {
		out.Plan = normalizePlanSlug(direct.PlanSlug)
		out.Source = ToolEntitlementSource{
			Kind:      "direct",
			ToolID:    toolID,
			ProductID: direct.SourceProductID,
			PeriodEnd: direct.PeriodEnd,
		}
		covers, _ := s.coverageGrants(ctx, toolID, out.Plan)
		out.Covers = covers
		out.Upgrade.Available = upgradeSlugs(toolID, out.Plan)
		return out, nil
	}

	covered, err := s.bestCoverageEntitlement(ctx, userID, toolID)
	if err != nil {
		return out, err
	}
	if covered != nil {
		out.Plan = normalizePlanSlug(covered.grantsPlan)
		out.Source = ToolEntitlementSource{
			Kind:          "coverage",
			ToolID:        covered.purchasedTool,
			PurchasedPlan: covered.purchasedPlan,
			PeriodEnd:     covered.periodEnd,
		}
		out.Upgrade.Available = upgradeSlugs(toolID, out.Plan)
		return out, nil
	}

	out.Upgrade.Available = upgradeSlugs(toolID, PlanFree)
	return out, nil
}

// ListUserToolEntitlements returns active direct entitlements for status payloads.
func (s *D1Store) ListUserToolEntitlements(ctx context.Context, userID string) ([]map[string]interface{}, error) {
	userID = strings.TrimSpace(userID)
	if userID == "" {
		return nil, nil
	}
	rows, err := s.QueryRows(ctx,
		`SELECT tool_id, plan_slug, status, source_product_id, source_subscription_id, current_period_end
		 FROM user_tool_entitlements
		 WHERE user_id = ? AND status = 'active'`, userID)
	if err != nil {
		// Table may not exist yet before migration.
		if strings.Contains(strings.ToLower(err.Error()), "no such table") {
			return nil, nil
		}
		return nil, err
	}
	out := make([]map[string]interface{}, 0, len(rows))
	now := time.Now().UTC()
	for _, row := range rows {
		plan := normalizePlanSlug(d1Str(row, "plan_slug"))
		end := strings.TrimSpace(d1Str(row, "current_period_end"))
		if end != "" && periodEnded(end, now) {
			continue
		}
		out = append(out, map[string]interface{}{
			"tool_id":              d1Str(row, "tool_id"),
			"plan":                 plan,
			"status":               d1Str(row, "status"),
			"source_product_id":    d1Str(row, "source_product_id"),
			"source_subscription_id": d1Str(row, "source_subscription_id"),
			"current_period_end":   end,
		})
	}
	return out, nil
}

func (s *D1Store) activeToolEntitlement(ctx context.Context, userID, toolID string) (*toolEntRow, error) {
	rows, err := s.QueryRows(ctx,
		`SELECT tool_id, plan_slug, status, source_product_id, source_subscription_id, current_period_end
		 FROM user_tool_entitlements
		 WHERE user_id = ? AND tool_id = ? AND status = 'active' LIMIT 1`,
		userID, toolID)
	if err != nil {
		if strings.Contains(strings.ToLower(err.Error()), "no such table") {
			return nil, nil
		}
		return nil, err
	}
	if len(rows) == 0 {
		return nil, nil
	}
	row := rows[0]
	end := strings.TrimSpace(d1Str(row, "current_period_end"))
	if end != "" && periodEnded(end, time.Now().UTC()) {
		return nil, nil
	}
	return &toolEntRow{
		ToolID:             d1Str(row, "tool_id"),
		PlanSlug:           d1Str(row, "plan_slug"),
		Status:             d1Str(row, "status"),
		SourceProductID:    d1Str(row, "source_product_id"),
		SourceSubscription: d1Str(row, "source_subscription_id"),
		PeriodEnd:          end,
	}, nil
}

type coverageHit struct {
	purchasedTool string
	purchasedPlan string
	grantsPlan    string
	periodEnd     string
}

func (s *D1Store) bestCoverageEntitlement(ctx context.Context, userID, toolID string) (*coverageHit, error) {
	rows, err := s.QueryRows(ctx,
		`SELECT e.tool_id AS purchased_tool_id, e.plan_slug AS purchased_plan,
		        e.current_period_end, c.grants_plan
		 FROM user_tool_entitlements e
		 JOIN plan_coverage c
		   ON c.purchased_tool_id = e.tool_id AND c.purchased_plan = e.plan_slug
		 WHERE e.user_id = ? AND e.status = 'active' AND c.covers_tool_id = ?`,
		userID, toolID)
	if err != nil {
		if strings.Contains(strings.ToLower(err.Error()), "no such table") {
			return nil, nil
		}
		return nil, err
	}
	now := time.Now().UTC()
	var best *coverageHit
	bestRank := -1
	for _, row := range rows {
		end := strings.TrimSpace(d1Str(row, "current_period_end"))
		if end != "" && periodEnded(end, now) {
			continue
		}
		grant := normalizePlanSlug(d1Str(row, "grants_plan"))
		r := planRank(grant)
		if r > bestRank {
			bestRank = r
			best = &coverageHit{
				purchasedTool: d1Str(row, "purchased_tool_id"),
				purchasedPlan: d1Str(row, "purchased_plan"),
				grantsPlan:    grant,
				periodEnd:     end,
			}
		}
	}
	return best, nil
}

func (s *D1Store) coverageGrants(ctx context.Context, purchasedTool, purchasedPlan string) ([]ToolCoverageGrant, error) {
	rows, err := s.QueryRows(ctx,
		`SELECT covers_tool_id, grants_plan FROM plan_coverage
		 WHERE purchased_tool_id = ? AND purchased_plan = ?`,
		purchasedTool, purchasedPlan)
	if err != nil {
		if strings.Contains(strings.ToLower(err.Error()), "no such table") {
			return nil, nil
		}
		return nil, err
	}
	out := make([]ToolCoverageGrant, 0, len(rows))
	for _, row := range rows {
		out = append(out, ToolCoverageGrant{
			ToolID:     d1Str(row, "covers_tool_id"),
			GrantsPlan: normalizePlanSlug(d1Str(row, "grants_plan")),
		})
	}
	return out, nil
}

// UpsertToolEntitlement writes/activates a tool-scoped entitlement (webhook dual-write).
func (s *D1Store) UpsertToolEntitlement(ctx context.Context, userID, toolID, planSlug, status, productID, subID, periodEnd string) error {
	userID = strings.TrimSpace(userID)
	toolID = strings.TrimSpace(toolID)
	planSlug = normalizePlanSlug(planSlug)
	if userID == "" || toolID == "" {
		return nil
	}
	if planSlug == PlanGuest || planSlug == PlanFree {
		planSlug = PlanPro
	}
	if status == "" {
		status = "active"
	}
	return s.Exec(ctx,
		`INSERT INTO user_tool_entitlements (
			user_id, tool_id, plan_slug, status, source_product_id, source_subscription_id,
			current_period_end, created_at, updated_at
		) VALUES (?, ?, ?, ?, ?, ?, ?, datetime('now'), datetime('now'))
		ON CONFLICT(user_id, tool_id) DO UPDATE SET
			plan_slug = excluded.plan_slug,
			status = excluded.status,
			source_product_id = COALESCE(excluded.source_product_id, user_tool_entitlements.source_product_id),
			source_subscription_id = COALESCE(excluded.source_subscription_id, user_tool_entitlements.source_subscription_id),
			current_period_end = COALESCE(excluded.current_period_end, user_tool_entitlements.current_period_end),
			updated_at = datetime('now')`,
		userID, toolID, planSlug, status,
		nullIfEmpty(productID), nullIfEmpty(subID), nullIfEmpty(periodEnd),
	)
}

// SyncToolEntitlementsFromSubscriptions rebuilds active tool rows from active subs.
func (s *D1Store) SyncToolEntitlementsFromSubscriptions(ctx context.Context, userID string) error {
	userID = strings.TrimSpace(userID)
	if userID == "" {
		return nil
	}
	subs, err := s.QueryRows(ctx,
		`SELECT dodo_subscription_id, dodo_product_id, current_period_end, metadata_json, status
		 FROM user_subscriptions
		 WHERE user_id = ? AND status IN ('active', 'trialing')`, userID)
	if err != nil {
		return err
	}

	activeTools := map[string]bool{}
	for _, sub := range subs {
		productID := strings.TrimSpace(d1Str(sub, "dodo_product_id"))
		subID := strings.TrimSpace(d1Str(sub, "dodo_subscription_id"))
		periodEnd := strings.TrimSpace(d1Str(sub, "current_period_end"))
		metaTool, metaPlan := parseEntitlementMeta(d1Str(sub, "metadata_json"))
		toolID, planSlug, ok := s.lookupProductEntitlement(ctx, productID)
		if !ok {
			toolID, planSlug = metaTool, metaPlan
		}
		if strings.TrimSpace(toolID) == "" {
			continue
		}
		if planSlug == "" {
			planSlug = PlanPro
		}
		if err := s.UpsertToolEntitlement(ctx, userID, toolID, planSlug, "active", productID, subID, periodEnd); err != nil {
			return err
		}
		activeTools[toolID] = true
	}

	existing, err := s.QueryRows(ctx,
		`SELECT tool_id FROM user_tool_entitlements WHERE user_id = ? AND status = 'active'`, userID)
	if err != nil {
		if strings.Contains(strings.ToLower(err.Error()), "no such table") {
			return nil
		}
		return err
	}
	for _, row := range existing {
		tid := d1Str(row, "tool_id")
		if activeTools[tid] {
			continue
		}
		if err := s.Exec(ctx,
			`UPDATE user_tool_entitlements SET status = 'expired', updated_at = datetime('now')
			 WHERE user_id = ? AND tool_id = ?`, userID, tid); err != nil {
			return err
		}
	}
	return nil
}

// lookupProductEntitlement maps a Dodo product_id to tool_id + ai_plan_id.
func (s *D1Store) lookupProductEntitlement(ctx context.Context, productID string) (toolID, planSlug string, ok bool) {
	productID = strings.TrimSpace(productID)
	if productID == "" {
		return "", "", false
	}
	rows, err := s.QueryRows(ctx,
		`SELECT tool_id, ai_plan_id FROM billing_plans
		 WHERE product_id = ? AND active = 1 LIMIT 1`, productID)
	if err != nil || len(rows) == 0 {
		return "", "", false
	}
	toolID = strings.TrimSpace(d1Str(rows[0], "tool_id"))
	planSlug = normalizePlanSlug(d1Str(rows[0], "ai_plan_id"))
	if toolID == "" {
		return "", "", false
	}
	if planSlug == PlanGuest || planSlug == PlanFree {
		planSlug = PlanPro
	}
	return toolID, planSlug, true
}

func parseEntitlementMeta(raw string) (toolID, planSlug string) {
	raw = strings.TrimSpace(raw)
	if raw == "" {
		return "", ""
	}
	var m map[string]interface{}
	if err := json.Unmarshal([]byte(raw), &m); err != nil {
		return "", ""
	}
	toolID, planSlug = entitlementFieldsFromMap(m)
	if toolID != "" {
		return toolID, planSlug
	}
	// Dodo webhook bodies nest checkout metadata under data.metadata.
	if data, ok := m["data"].(map[string]interface{}); ok {
		if meta, ok := data["metadata"].(map[string]interface{}); ok {
			toolID, planSlug = entitlementFieldsFromMap(meta)
			if toolID != "" {
				return toolID, planSlug
			}
		}
		toolID, planSlug = entitlementFieldsFromMap(data)
	}
	if toolID == "" {
		if meta, ok := m["metadata"].(map[string]interface{}); ok {
			toolID, planSlug = entitlementFieldsFromMap(meta)
		}
	}
	return toolID, planSlug
}

func entitlementFieldsFromMap(m map[string]interface{}) (toolID, planSlug string) {
	if m == nil {
		return "", ""
	}
	toolID = strings.TrimSpace(fmtString(m["tool_id"]))
	planSlug = normalizePlanSlug(fmtString(m["ai_plan_id"]))
	if planSlug == "" || planSlug == PlanGuest {
		planSlug = normalizePlanSlug(fmtString(m["plan_slug"]))
	}
	if planSlug == "" || planSlug == PlanGuest {
		// CreateCheckout historically used plan_key for the AI tier.
		pk := normalizePlanSlug(fmtString(m["plan_key"]))
		if pk == PlanPro || pk == PlanUltra {
			planSlug = pk
		}
	}
	return toolID, planSlug
}

func fmtString(v interface{}) string {
	if v == nil {
		return ""
	}
	switch t := v.(type) {
	case string:
		return t
	default:
		return ""
	}
}

func normalizePlanSlug(s string) string {
	switch strings.ToLower(strings.TrimSpace(s)) {
	case PlanUltra:
		return PlanUltra
	case PlanPro, "premium", PlanManicPro:
		return PlanPro
	case PlanFree:
		return PlanFree
	case PlanGuest, "":
		return PlanGuest
	default:
		return PlanFree
	}
}

func planRank(plan string) int {
	switch normalizePlanSlug(plan) {
	case PlanUltra:
		return 3
	case PlanPro:
		return 2
	case PlanFree:
		return 1
	default:
		return 0
	}
}

func periodEnded(end string, now time.Time) bool {
	t, err := time.Parse(time.RFC3339, end)
	if err != nil {
		t, err = time.Parse("2006-01-02 15:04:05", end)
		if err != nil {
			return false
		}
	}
	return !t.After(now)
}

func upgradeSlugs(toolID, current string) []string {
	cur := planRank(current)
	var out []string
	if toolID == ToolIDManic {
		if cur < planRank(PlanPro) {
			out = append(out, PlanPro)
		}
		if cur < planRank(PlanUltra) {
			out = append(out, PlanUltra)
		}
		return out
	}
	if cur < planRank(PlanPro) {
		out = append(out, PlanPro)
	}
	return out
}
