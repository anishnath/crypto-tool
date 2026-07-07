package billing

import (
	"context"
	"crypto/rand"
	"fmt"
	"log/slog"
	"net/http"
	"time"

	"github.com/anish/crypto-tool/openai-go-api/internal/logging"
)

// NoopStore discards billing records.
type NoopStore struct{}

func (NoopStore) ResolveAPIKey(context.Context, string) (string, string, error) {
	return "", "", nil
}
func (NoopStore) InsertPending(context.Context, PendingRecord) error { return nil }
func (NoopStore) InsertValidationFailure(context.Context, PendingRecord, FailRecord) error {
	return nil
}
func (NoopStore) Complete(context.Context, string, CompleteRecord) error { return nil }
func (NoopStore) Fail(context.Context, string, FailRecord) error         { return nil }

// NewRequestID returns a random UUID v4 string.
func NewRequestID() string {
	b := make([]byte, 16)
	_, _ = rand.Read(b)
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

// Tracker correlates a single API call with D1 rows.
type Tracker struct {
	id      string
	started time.Time
	store   Store
	user    UserIdentity
}

// Logger records request lifecycle events to a Store.
type Logger struct {
	store Store
}

func NewLogger(store Store) *Logger {
	if store == nil {
		store = NoopStore{}
	}
	return &Logger{store: store}
}

func (l *Logger) Enabled() bool {
	_, ok := l.store.(NoopStore)
	return !ok
}

func (l *Logger) RequestContext(ctx context.Context, r *http.Request) RequestContext {
	return RequestContextFromHTTP(ctx, r, l.store)
}

func (l *Logger) CheckAIQuota(ctx context.Context, user UserIdentity) error {
	if qs, ok := l.store.(QuotaStore); ok {
		return qs.CheckAIQuota(ctx, user)
	}
	return nil
}

func (l *Logger) TierChatModel(ctx context.Context, user UserIdentity) (string, error) {
	if qs, ok := l.store.(QuotaStore); ok {
		return qs.TierModelID(ctx, user)
	}
	return "", nil
}

func (l *Logger) TierVisionModel(ctx context.Context, user UserIdentity) (string, error) {
	if qs, ok := l.store.(QuotaStore); ok {
		return qs.TierVisionModelID(ctx, user)
	}
	return "", nil
}

func (l *Logger) GetAIQuota(ctx context.Context, user UserIdentity) (AIQuotaStatus, error) {
	if qs, ok := l.store.(QuotaStore); ok {
		return qs.GetAIQuota(ctx, user)
	}
	return unlimitedQuotaStatus(user), nil
}

func (l *Logger) Begin(ctx context.Context, rec PendingRecord) *Tracker {
	if rec.ID == "" {
		rec.ID = NewRequestID()
	}
	if rec.StartedAt.IsZero() {
		rec.StartedAt = time.Now().UTC()
	}
	if err := l.store.InsertPending(ctx, rec); err != nil {
		slog.Warn("billing insert pending failed", "request_id", rec.ID, "error", err)
	} else if logging.IsDebug() {
		slog.Debug("billing pending",
			"request_id", rec.ID,
			"endpoint", rec.Endpoint,
			"model", rec.ModelRequested,
			"provider", rec.ProviderID,
			"auth_mode", rec.User.AuthMode,
			"tool_id", rec.ToolID,
		)
	}
	return &Tracker{id: rec.ID, started: rec.StartedAt, store: l.store, user: rec.User}
}

func (l *Logger) LogValidationFailure(ctx context.Context, rec PendingRecord, httpStatus int, errorCode, errorMessage string) {
	if rec.ID == "" {
		rec.ID = NewRequestID()
	}
	if rec.StartedAt.IsZero() {
		rec.StartedAt = time.Now().UTC()
	}
	fail := FailRecord{
		HTTPStatus:   httpStatus,
		ErrorCode:    errorCode,
		ErrorMessage: errorMessage,
		LatencyMS:    time.Since(rec.StartedAt).Milliseconds(),
		CompletedAt:  time.Now().UTC(),
	}
	if err := l.store.InsertValidationFailure(ctx, rec, fail); err != nil {
		slog.Warn("billing validation failure write failed", "request_id", rec.ID, "error", err)
	} else if logging.IsDebug() {
		slog.Debug("billing validation failure",
			"request_id", rec.ID,
			"code", fail.ErrorCode,
			"message", fail.ErrorMessage,
		)
	}
}

func (t *Tracker) ID() string { return t.id }

func (t *Tracker) Complete(rec CompleteRecord) {
	if rec.CompletedAt.IsZero() {
		rec.CompletedAt = time.Now().UTC()
	}
	if rec.LatencyMS == 0 {
		rec.LatencyMS = rec.CompletedAt.Sub(t.started).Milliseconds()
	}
	go func() {
		bg := context.Background()
		_ = t.store.Complete(bg, t.id, rec)
		if qs, ok := t.store.(QuotaStore); ok && rec.Usage.TotalTokens > 0 {
			_ = qs.AddAIUsage(bg, t.user, rec.Usage.TotalTokens)
		}
	}()
}

func (t *Tracker) Fail(rec FailRecord) {
	if rec.CompletedAt.IsZero() {
		rec.CompletedAt = time.Now().UTC()
	}
	if rec.LatencyMS == 0 {
		rec.LatencyMS = rec.CompletedAt.Sub(t.started).Milliseconds()
	}
	go func() {
		_ = t.store.Fail(context.Background(), t.id, rec)
	}()
}
