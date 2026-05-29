package billing

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"time"
)

func (s *D1Store) GetAIQuota(ctx context.Context, user UserIdentity) (AIQuotaStatus, error) {
	if !QuotaEnabled() {
		return unlimitedQuotaStatus(user), nil
	}

	subjectType, subjectID, err := subjectKey(user)
	if err != nil {
		if user.UserID == "" && user.AnonymousID == "" {
			return AIQuotaStatus{
				PlanID:        PlanGuest,
				PlanName:      s.aiPlanName(ctx, PlanGuest, "Guest"),
				ModelID:       s.planModelID(ctx, PlanGuest),
				SubjectType:   SubjectAnonymous,
				TokensUsed:    0,
				TokensLimit:   s.aiPlanLimit(ctx, PlanGuest),
				Period:        currentPeriodMonth(time.Now()),
				PeriodEndsAt:  periodEndsAt(time.Now()),
				RequiresLogin: false,
			}, nil
		}
		return AIQuotaStatus{}, err
	}

	now := time.Now().UTC()
	period := currentPeriodMonth(now)
	planID, planName, err := s.resolvePlan(ctx, user)
	if err != nil {
		return AIQuotaStatus{}, err
	}

	limit := s.aiPlanLimit(ctx, planID)

	used, reqCount, err := s.tokensUsed(ctx, subjectType, subjectID, period)
	if err != nil {
		return AIQuotaStatus{}, err
	}

	remaining := limit - used
	if remaining < 0 {
		remaining = 0
	}

	modelID := s.planModelID(ctx, planID)

	status := AIQuotaStatus{
		PlanID:          planID,
		PlanName:        planName,
		ModelID:         modelID,
		SubjectType:     subjectType,
		SubjectID:       subjectID,
		TokensUsed:      used,
		TokensLimit:     limit,
		TokensRemaining: remaining,
		RequestCount:    reqCount,
		Period:          period,
		PeriodEndsAt:    periodEndsAt(now),
	}
	if user.UserID == "" && user.AnonymousID == "" {
		status.RequiresLogin = true
	}
	return status, nil
}

func (s *D1Store) CheckAIQuota(ctx context.Context, user UserIdentity) error {
	if !QuotaEnabled() {
		return nil
	}

	if user.UserID == "" && user.AnonymousID == "" {
		return fmt.Errorf("%w: send X-Anonymous-Id for guest AI or sign in", ErrBadRequest)
	}

	status, err := s.GetAIQuota(ctx, user)
	if err != nil {
		return err
	}
	if status.IsUnlimited {
		return nil
	}
	if status.TokensRemaining <= 0 {
		status.RequiresLogin = user.UserID == ""
		return &QuotaExceededError{Status: status}
	}
	return nil
}

func (s *D1Store) AddAIUsage(ctx context.Context, user UserIdentity, tokens int64) error {
	if !QuotaEnabled() || tokens <= 0 {
		return nil
	}

	subjectType, subjectID, err := subjectKey(user)
	if err != nil {
		return nil
	}

	now := time.Now().UTC()
	period := currentPeriodMonth(now)
	planID, _, err := s.resolvePlan(ctx, user)
	if err != nil {
		return err
	}

	sql := `INSERT INTO ai_usage_periods (subject_type, subject_id, period_month, plan_id, tokens_used, request_count, updated_at)
		VALUES (?, ?, ?, ?, ?, 1, ?)
		ON CONFLICT(subject_type, subject_id, period_month) DO UPDATE SET
			tokens_used = tokens_used + excluded.tokens_used,
			request_count = request_count + 1,
			plan_id = excluded.plan_id,
			updated_at = excluded.updated_at`

	_, err = s.exec(ctx, sql,
		subjectType,
		subjectID,
		period,
		planID,
		tokens,
		formatTime(now),
	)
	return err
}

func (s *D1Store) resolvePlan(ctx context.Context, user UserIdentity) (planID, planName string, err error) {
	if user.UserID != "" {
		isPro, err := s.userIsPro(ctx, user.UserID)
		if err != nil {
			return "", "", err
		}
		if isPro {
			return PlanPro, s.aiPlanName(ctx, PlanPro, "Pro"), nil
		}
		return PlanFree, s.aiPlanName(ctx, PlanFree, "Free account"), nil
	}
	return PlanGuest, s.aiPlanName(ctx, PlanGuest, "Guest"), nil
}

func (s *D1Store) userIsPro(ctx context.Context, userID string) (bool, error) {
	raw, err := s.exec(ctx,
		`SELECT is_premium, premium_until FROM users WHERE id = ? LIMIT 1`,
		userID,
	)
	if err != nil {
		return false, err
	}
	var parsed d1RowsResult
	if err := json.Unmarshal(raw, &parsed); err != nil {
		return false, err
	}
	row, ok := parsed.firstRow()
	if !ok {
		return false, nil
	}
	if row.IsPremium != 1 {
		return false, nil
	}
	until := strings.TrimSpace(row.PremiumUntil)
	if until == "" {
		return true, nil
	}
	t, err := time.Parse(time.RFC3339, until)
	if err != nil {
		t, err = time.Parse("2006-01-02 15:04:05", until)
		if err != nil {
			return true, nil
		}
	}
	return t.After(time.Now().UTC()), nil
}

func (s *D1Store) tokensUsed(ctx context.Context, subjectType, subjectID, period string) (used, requestCount int64, err error) {
	raw, err := s.exec(ctx,
		`SELECT tokens_used, request_count FROM ai_usage_periods
		 WHERE subject_type = ? AND subject_id = ? AND period_month = ? LIMIT 1`,
		subjectType, subjectID, period,
	)
	if err != nil {
		return 0, 0, err
	}
	var parsed d1RowsResult
	if err := json.Unmarshal(raw, &parsed); err != nil {
		return 0, 0, err
	}
	row, ok := parsed.firstRow()
	if !ok {
		return 0, 0, nil
	}
	return row.TokensUsed, row.RequestCount, nil
}

type d1RowsResult struct {
	Result []struct {
		Results []map[string]interface{} `json:"results"`
	} `json:"result"`
}

func (r d1RowsResult) firstRow() (usageRow, bool) {
	if len(r.Result) == 0 || len(r.Result[0].Results) == 0 {
		return usageRow{}, false
	}
	m := r.Result[0].Results[0]
	row := usageRow{}
	if v, ok := m["is_premium"].(float64); ok {
		row.IsPremium = int64(v)
	}
	if v, ok := m["premium_until"].(string); ok {
		row.PremiumUntil = v
	}
	if v, ok := m["tokens_used"].(float64); ok {
		row.TokensUsed = int64(v)
	}
	if v, ok := m["request_count"].(float64); ok {
		row.RequestCount = int64(v)
	}
	return row, true
}

type usageRow struct {
	IsPremium    int64
	PremiumUntil string
	TokensUsed   int64
	RequestCount int64
}

func unlimitedQuotaStatus(user UserIdentity) AIQuotaStatus {
	now := time.Now().UTC()
	st := AIQuotaStatus{
		PlanID:          PlanFree,
		PlanName:        "Unlimited (quota disabled)",
		TokensUsed:      0,
		TokensLimit:     0,
		TokensRemaining: 0,
		Period:          currentPeriodMonth(now),
		PeriodEndsAt:    periodEndsAt(now),
		IsUnlimited:     true,
	}
	if user.UserID != "" {
		st.SubjectType = SubjectUser
		st.SubjectID = user.UserID
	} else if user.AnonymousID != "" {
		st.SubjectType = SubjectAnonymous
		st.SubjectID = user.AnonymousID
	}
	return st
}
