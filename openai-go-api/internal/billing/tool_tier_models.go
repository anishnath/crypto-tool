package billing

import (
	"context"
	"os"
	"strings"
	"time"
)

const toolTierModelsCacheTTL = 10 * time.Minute

type toolTierModelKey struct {
	toolID string
	planID string
}

// loadToolTierModels reads active overrides (cached). Keys: (tool_id, plan_id).
func (s *D1Store) loadToolTierModels(ctx context.Context) (map[toolTierModelKey]string, error) {
	s.toolTierMu.RLock()
	if s.toolTierModels != nil && time.Now().Before(s.toolTierExpiry) {
		cached := s.toolTierModels
		s.toolTierMu.RUnlock()
		return cached, nil
	}
	s.toolTierMu.RUnlock()

	rows, err := s.QueryRows(ctx,
		`SELECT tool_id, plan_id, model_id FROM tool_tier_models WHERE active = 1`)
	if err != nil {
		return nil, err
	}

	out := make(map[toolTierModelKey]string, len(rows))
	for _, row := range rows {
		toolID := normalizeToolTierID(d1Str(row, "tool_id"))
		planID := strings.TrimSpace(d1Str(row, "plan_id"))
		modelID := strings.TrimSpace(d1Str(row, "model_id"))
		if planID == "" || modelID == "" {
			continue
		}
		if planID != PlanFree && planID != PlanPro {
			continue
		}
		out[toolTierModelKey{toolID: toolID, planID: planID}] = modelID
	}

	s.toolTierMu.Lock()
	s.toolTierModels = out
	s.toolTierExpiry = time.Now().Add(toolTierModelsCacheTTL)
	s.toolTierMu.Unlock()
	return out, nil
}

func normalizeToolTierID(toolID string) string {
	return strings.TrimSpace(toolID)
}

func envFreeLegacyModel() string {
	return strings.TrimSpace(os.Getenv("AI_TIER_FREE_LEGACY_MODEL"))
}

func (s *D1Store) toolTierModelOverride(ctx context.Context, toolID, planID string) string {
	if planID == PlanGuest {
		return ""
	}
	overrides, err := s.loadToolTierModels(ctx)
	if err != nil {
		if planID == PlanFree {
			return envFreeLegacyModel()
		}
		return ""
	}
	toolID = normalizeToolTierID(toolID)
	if toolID != "" {
		if m, ok := overrides[toolTierModelKey{toolID: toolID, planID: planID}]; ok {
			return m
		}
	}
	if m, ok := overrides[toolTierModelKey{toolID: "", planID: planID}]; ok {
		return m
	}
	if planID == PlanFree {
		return envFreeLegacyModel()
	}
	return ""
}

// ResolveChatModel picks the chat model for a caller + optional tool slug.
// Guest tier never uses tool_tier_models (ai_plans only).
func (s *D1Store) ResolveChatModel(ctx context.Context, user UserIdentity, toolID string) (string, error) {
	planID, _, err := s.resolvePlan(ctx, user)
	if err != nil {
		return "", err
	}
	if planID == PlanGuest {
		return s.planModelID(ctx, planID), nil
	}
	if m := s.toolTierModelOverride(ctx, toolID, planID); m != "" {
		return m, nil
	}
	return s.planModelID(ctx, planID), nil
}
