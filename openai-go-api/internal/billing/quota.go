package billing

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"
)

const (
	CodeAIQuotaExceeded    = "ai_quota_exceeded"
	CodeMissingAnonymousID = "missing_anonymous_id"

	PlanGuest = "guest"
	PlanFree  = "free"
	PlanPro   = "pro"

	SubjectUser      = "user"
	SubjectAnonymous = "anonymous"

	headerToolID = "X-Tool-Id"
)

// AIQuotaStatus is returned to the frontend for quota UI.
type AIQuotaStatus struct {
	PlanID          string `json:"plan_id"`
	PlanName        string `json:"plan_name"`
	ModelID         string `json:"model_id,omitempty"`
	SubjectType     string `json:"subject_type"`
	SubjectID       string `json:"subject_id,omitempty"`
	TokensUsed      int64  `json:"tokens_used"`
	TokensLimit     int64  `json:"tokens_limit"`
	TokensRemaining int64  `json:"tokens_remaining"`
	RequestCount    int64  `json:"request_count"`
	Period          string `json:"period"`
	PeriodEndsAt    string `json:"period_ends_at"`
	IsUnlimited     bool   `json:"is_unlimited"`
	RequiresLogin   bool   `json:"requires_login,omitempty"`
}

// QuotaExceededError is returned when monthly AI tokens are exhausted.
type QuotaExceededError struct {
	Status AIQuotaStatus
}

func (e *QuotaExceededError) Error() string {
	return fmt.Sprintf("AI quota exceeded: %d/%d tokens used this month", e.Status.TokensUsed, e.Status.TokensLimit)
}

func (e *QuotaExceededError) Is(target error) bool {
	_, ok := target.(*QuotaExceededError)
	return ok
}

// QuotaStore resolves AI plans and enforces monthly token limits.
type QuotaStore interface {
	GetAIQuota(ctx context.Context, user UserIdentity) (AIQuotaStatus, error)
	CheckAIQuota(ctx context.Context, user UserIdentity) error
	AddAIUsage(ctx context.Context, user UserIdentity, tokens int64) error
	TierModelID(ctx context.Context, user UserIdentity) (string, error)
}

// QuotaLimits holds monthly token caps (env fallback when ai_plans is unavailable).
type QuotaLimits struct {
	Guest int64
	Free  int64
	Pro   int64
}

// LoadQuotaLimits returns env-based fallback caps used only when ai_plans cannot
// be read from D1 or a plan row is missing. Source of truth: ai_plans table.
func LoadQuotaLimits() QuotaLimits {
	return QuotaLimits{
		Guest: envInt64("AI_QUOTA_GUEST", 20_000),
		Free:  envInt64("AI_QUOTA_FREE", 200_000),
		Pro:   envInt64("AI_QUOTA_PRO", 2_000_000),
	}
}

func QuotaEnabled() bool {
	return envBool("AI_QUOTA_ENABLED", true)
}

// ToolIDFromRequest returns optional tool slug for analytics (X-Tool-Id).
func ToolIDFromRequest(r *http.Request) string {
	return strings.TrimSpace(r.Header.Get(headerToolID))
}

func currentPeriodMonth(t time.Time) string {
	return t.UTC().Format("2006-01")
}

func periodEndsAt(t time.Time) string {
	y, m, _ := t.UTC().Date()
	firstNext := time.Date(y, m+1, 1, 0, 0, 0, 0, time.UTC)
	return firstNext.Format(time.RFC3339)
}

func subjectKey(user UserIdentity) (subjectType, subjectID string, err error) {
	if user.UserID != "" {
		return SubjectUser, user.UserID, nil
	}
	if user.AnonymousID != "" {
		return SubjectAnonymous, user.AnonymousID, nil
	}
	return "", "", errors.New("missing identity: send X-User-Id or X-Anonymous-Id")
}

func planLimit(limits QuotaLimits, planID string) int64 {
	switch planID {
	case PlanPro:
		return limits.Pro
	case PlanFree:
		return limits.Free
	default:
		return limits.Guest
	}
}

func envInt64(key string, fallback int64) int64 {
	v := strings.TrimSpace(os.Getenv(key))
	if v == "" {
		return fallback
	}
	n, err := strconv.ParseInt(v, 10, 64)
	if err != nil {
		return fallback
	}
	return n
}
