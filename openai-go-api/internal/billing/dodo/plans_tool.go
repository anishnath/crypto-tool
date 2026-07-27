package dodo

import (
	"context"
	"errors"
	"strings"
)

var errProductNotConfigured = errors.New("product id not configured")

// normalizeToolID trims a tool slug; empty means global-only catalog.
func normalizeToolID(toolID string) string {
	return strings.TrimSpace(toolID)
}

// mergePlanOverride layers a tool-specific billing_plans row over the global row.
// Tool fields win when set; unset tool fields inherit from global.
func mergePlanOverride(global, tool planOverride) planOverride {
	if tool.productID == "" && tool.name == "" && !tool.hasAmount && tool.priceLabel == "" &&
		tool.badge == "" && tool.description == "" && tool.cadence == "" &&
		tool.aiPlanID == "" && tool.interval == "" {
		return global
	}
	out := global
	if tool.productID != "" {
		out.productID = tool.productID
	}
	if tool.interval != "" {
		out.interval = tool.interval
	}
	if tool.name != "" {
		out.name = tool.name
	}
	if tool.hasAmount {
		out.priceAmount = tool.priceAmount
		out.hasAmount = true
		out.currency = tool.currency
	}
	if tool.priceLabel != "" {
		out.priceLabel = tool.priceLabel
	}
	if tool.badge != "" {
		out.badge = tool.badge
	}
	if tool.description != "" {
		out.description = tool.description
	}
	if tool.cadence != "" {
		out.cadence = tool.cadence
	}
	if tool.aiPlanID != "" {
		out.aiPlanID = tool.aiPlanID
	}
	if tool.hasToolOverride {
		out.hasToolOverride = true
	}
	return out
}

func appendUniqueKey(keys []string, key string) []string {
	for _, k := range keys {
		if k == key {
			return keys
		}
	}
	return append(keys, key)
}

// ResolveCheckoutProduct picks the Dodo product for checkout (tool override → global → env).
// aiPlanID is the entitlement tier (pro|ultra) from billing_plans.ai_plan_id; defaults to pro.
func (s *Service) ResolveCheckoutProduct(ctx context.Context, toolID, planKey string) (productID, interval, aiPlanID string, err error) {
	overrides, _, _ := s.loadPlanOverrides(ctx, toolID)
	o, ok := overrides[planKey]
	if !ok {
		o = planOverride{}
	}
	productID = o.productID
	interval = o.interval
	aiPlanID = strings.TrimSpace(o.aiPlanID)
	if aiPlanID == "" {
		aiPlanID = "pro"
	}
	if interval == "" {
		interval = intervalForKey(planKey)
	}
	if productID == "" {
		productID = s.productForKey(planKey)
	}
	if productID == "" {
		return "", interval, aiPlanID, errProductNotConfigured
	}
	return productID, interval, aiPlanID, nil
}
