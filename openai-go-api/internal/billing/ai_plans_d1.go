package billing

import (
	"context"
	"encoding/json"
	"fmt"
	"log/slog"
	"strconv"
	"strings"
	"time"
)

const aiPlansCacheTTL = 10 * time.Minute

// AIPlanRecord is a row from ai_plans — source of truth for tier limits & features.
type AIPlanRecord struct {
	PlanID            string
	DisplayName       string
	MonthlyTokenLimit int64
	Description       string
	Features          []string
	ModelID           string
}

type aiPlanEntry struct {
	DisplayName string
	TokenLimit  int64
	Description string
	Features    []string
	ModelID     string
}

// loadAIPlans reads active rows from ai_plans (cached). Missing plan_ids are
// filled from env fallbacks so enforcement still works before seed data exists.
func (s *D1Store) loadAIPlans(ctx context.Context) (map[string]aiPlanEntry, error) {
	s.aiPlansMu.RLock()
	if s.aiPlans != nil && time.Now().Before(s.aiPlansExpiry) {
		cached := s.aiPlans
		s.aiPlansMu.RUnlock()
		return cached, nil
	}
	s.aiPlansMu.RUnlock()

	rows, err := s.QueryRows(ctx,
		`SELECT plan_id, display_name, monthly_token_limit, description, features_json, model_id
		 FROM ai_plans WHERE active = 1`)
	if err != nil {
		return nil, err
	}

	plans := make(map[string]aiPlanEntry, len(rows)+3)
	for _, row := range rows {
		id := strings.TrimSpace(d1Str(row, "plan_id"))
		if id == "" {
			continue
		}
		limit, ok := d1Int(row, "monthly_token_limit")
		if !ok || limit <= 0 {
			continue
		}
		plans[id] = aiPlanEntry{
			DisplayName: strings.TrimSpace(d1Str(row, "display_name")),
			TokenLimit:  limit,
			Description: strings.TrimSpace(d1Str(row, "description")),
			Features:    parseFeaturesJSON(d1Str(row, "features_json")),
			ModelID:     strings.TrimSpace(d1Str(row, "model_id")),
		}
	}
	ensureAIPlanFallbacks(plans)

	s.aiPlansMu.Lock()
	s.aiPlans = plans
	s.aiPlansExpiry = time.Now().Add(aiPlansCacheTTL)
	s.aiPlansMu.Unlock()
	return plans, nil
}

func ensureAIPlanFallbacks(plans map[string]aiPlanEntry) {
	fb := LoadQuotaLimits()
	fill := []struct {
		id, name string
		limit    int64
	}{
		{PlanGuest, "Guest", fb.Guest},
		{PlanFree, "Free account", fb.Free},
		{PlanPro, "Pro", fb.Pro},
	}
	for _, p := range fill {
		e, ok := plans[p.id]
		if !ok {
			plans[p.id] = aiPlanEntry{DisplayName: p.name, TokenLimit: p.limit}
			continue
		}
		if e.DisplayName == "" {
			e.DisplayName = p.name
		}
		if e.TokenLimit <= 0 {
			e.TokenLimit = p.limit
		}
		plans[p.id] = e
	}
}

func (s *D1Store) aiPlanLimit(ctx context.Context, planID string) int64 {
	plans, err := s.loadAIPlans(ctx)
	if err != nil {
		slog.Warn("ai_plans: load failed; using env fallback", "error", err.Error(), "plan_id", planID)
		return planLimit(LoadQuotaLimits(), planID)
	}
	if e, ok := plans[planID]; ok && e.TokenLimit > 0 {
		return e.TokenLimit
	}
	return planLimit(LoadQuotaLimits(), planID)
}

func (s *D1Store) TierModelID(ctx context.Context, user UserIdentity) (string, error) {
	planID, _, err := s.resolvePlan(ctx, user)
	if err != nil {
		return "", err
	}
	return s.planModelID(ctx, planID), nil
}

func (s *D1Store) planModelID(ctx context.Context, planID string) string {
	plans, err := s.loadAIPlans(ctx)
	if err != nil {
		return ""
	}
	if e, ok := plans[planID]; ok {
		return strings.TrimSpace(e.ModelID)
	}
	return ""
}

func (s *D1Store) aiPlanName(ctx context.Context, planID, fallback string) string {
	plans, err := s.loadAIPlans(ctx)
	if err != nil {
		return fallback
	}
	if e, ok := plans[planID]; ok && e.DisplayName != "" {
		return e.DisplayName
	}
	return fallback
}

// GetAIPlan returns one active ai_plans row (cached).
func (s *D1Store) GetAIPlan(ctx context.Context, planID string) (AIPlanRecord, bool) {
	plans, err := s.loadAIPlans(ctx)
	if err != nil {
		return AIPlanRecord{}, false
	}
	e, ok := plans[planID]
	if !ok || e.TokenLimit <= 0 {
		return AIPlanRecord{}, false
	}
	return AIPlanRecord{
		PlanID:            planID,
		DisplayName:       e.DisplayName,
		MonthlyTokenLimit: e.TokenLimit,
		Description:       e.Description,
		Features:          append([]string(nil), e.Features...),
		ModelID:           e.ModelID,
	}, true
}

// ListAIPlans returns all active ai_plans rows ordered by token limit ascending.
func (s *D1Store) ListAIPlans(ctx context.Context) ([]AIPlanRecord, error) {
	plans, err := s.loadAIPlans(ctx)
	if err != nil {
		return nil, err
	}
	order := []string{PlanGuest, PlanFree, PlanPro}
	out := make([]AIPlanRecord, 0, len(order))
	seen := map[string]bool{}
	for _, id := range order {
		if e, ok := plans[id]; ok && e.TokenLimit > 0 {
			out = append(out, AIPlanRecord{
				PlanID:            id,
				DisplayName:       e.DisplayName,
				MonthlyTokenLimit: e.TokenLimit,
				Description:       e.Description,
				Features:          append([]string(nil), e.Features...),
				ModelID:           e.ModelID,
			})
			seen[id] = true
		}
	}
	for id, e := range plans {
		if seen[id] || e.TokenLimit <= 0 {
			continue
		}
		out = append(out, AIPlanRecord{
			PlanID:            id,
			DisplayName:       e.DisplayName,
			MonthlyTokenLimit: e.TokenLimit,
			Description:       e.Description,
			Features:          append([]string(nil), e.Features...),
			ModelID:           e.ModelID,
		})
	}
	return out, nil
}

func parseFeaturesJSON(raw string) []string {
	raw = strings.TrimSpace(raw)
	if raw == "" {
		return nil
	}
	var feats []string
	if err := json.Unmarshal([]byte(raw), &feats); err != nil {
		return nil
	}
	return feats
}

func d1Str(row map[string]interface{}, key string) string {
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

func d1Int(row map[string]interface{}, key string) (int64, bool) {
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
