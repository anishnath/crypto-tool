package billing

import (
	"context"
	"errors"
	"time"

	"github.com/anish/crypto-tool/openai-go-api/internal/provider"
)

const (
	EndpointChat      = "chat_completions"
	EndpointResponses = "responses"
	ModalityChat      = "chat"
	ModalityResponses = "responses"
	StatusPending     = "pending"
	StatusCompleted   = "completed"
	StatusFailed      = "failed"
	StatusValidation  = "validation_failed"
)

var ErrBadRequest = errors.New("bad request")

// ClientMeta holds privacy-safe client attribution fields.
type ClientMeta struct {
	APIKeyID        string
	APIKeyHash      string
	ClientIPHash    string
	UserAgent       string
	RequestIDHeader string
}

// PendingRecord is written when an API request is accepted.
type PendingRecord struct {
	ID             string
	Endpoint       string
	Modality       string
	ProviderID     string
	ModelRequested string
	Stream         bool
	RequestJSON    string
	MessageCount   int
	InputCharCount int
	Task           string
	Temperature    *float64
	TopP           *float64
	ToolID         string
	StartedAt      time.Time
	ClientMeta     ClientMeta
	User           UserIdentity
}

// CompleteRecord is written when a provider call succeeds.
type CompleteRecord struct {
	ModelResolved      string
	HTTPStatus         int
	OutputCharCount    int
	Usage              provider.Usage
	ProviderResponseID string
	LatencyMS          int64
	CompletedAt        time.Time
}

// FailRecord is written when a provider call or gateway error occurs.
type FailRecord struct {
	HTTPStatus   int
	ErrorCode    string
	ErrorMessage string
	LatencyMS    int64
	CompletedAt  time.Time
}

// Store persists billing records (D1 or no-op).
type Store interface {
	APIKeyResolver
	InsertPending(ctx context.Context, rec PendingRecord) error
	InsertValidationFailure(ctx context.Context, rec PendingRecord, fail FailRecord) error
	Complete(ctx context.Context, id string, rec CompleteRecord) error
	Fail(ctx context.Context, id string, rec FailRecord) error
}
