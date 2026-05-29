package billing

import (
	"bytes"
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
	"sync"
	"time"
)

const defaultD1APIBase = "https://api.cloudflare.com/client/v4"

// D1Config configures the Cloudflare D1 HTTP client.
type D1Config struct {
	AccountID  string
	DatabaseID string
	APIToken   string
	APIBase    string
	HTTPClient *http.Client
}

// D1Store persists billing rows via the Cloudflare D1 REST API.
type D1Store struct {
	cfg D1Config

	aiPlansMu     sync.RWMutex
	aiPlans       map[string]aiPlanEntry
	aiPlansExpiry time.Time
}

func NewD1Store(cfg D1Config) (*D1Store, error) {
	cfg.AccountID = strings.TrimSpace(cfg.AccountID)
	cfg.DatabaseID = strings.TrimSpace(cfg.DatabaseID)
	cfg.APIToken = strings.TrimSpace(cfg.APIToken)
	if cfg.AccountID == "" || cfg.DatabaseID == "" || cfg.APIToken == "" {
		return nil, fmt.Errorf("D1 billing requires CLOUDFLARE_ACCOUNT_ID, D1_DATABASE_ID, and CLOUDFLARE_API_TOKEN")
	}
	if cfg.APIBase == "" {
		cfg.APIBase = defaultD1APIBase
	}
	if cfg.HTTPClient == nil {
		cfg.HTTPClient = http.DefaultClient
	}
	return &D1Store{cfg: cfg}, nil
}

func (s *D1Store) ResolveAPIKey(ctx context.Context, keyHash string) (string, string, error) {
	if strings.TrimSpace(keyHash) == "" {
		return "", "", nil
	}
	raw, err := s.exec(ctx, `SELECT id, user_id FROM llm_user_api_keys WHERE key_hash = ? AND is_active = 1 LIMIT 1`, keyHash)
	if err != nil {
		return "", "", err
	}
	var parsed struct {
		Result []struct {
			Results []struct {
				ID     string `json:"id"`
				UserID string `json:"user_id"`
			} `json:"results"`
		} `json:"result"`
	}
	if err := json.Unmarshal(raw, &parsed); err != nil {
		return "", "", err
	}
	if len(parsed.Result) == 0 || len(parsed.Result[0].Results) == 0 {
		return "", "", nil
	}
	row := parsed.Result[0].Results[0]
	go func() {
		_, _ = s.exec(context.Background(), `UPDATE llm_user_api_keys SET last_used_at = ? WHERE id = ?`, formatTime(time.Now().UTC()), row.ID)
	}()
	return row.UserID, row.ID, nil
}

func authModeOrDefault(mode string) string {
	if strings.TrimSpace(mode) == "" {
		return AuthAnonymous
	}
	return mode
}

func (s *D1Store) InsertPending(ctx context.Context, rec PendingRecord) error {
	sql := `INSERT INTO llm_gateway_requests (
		id, endpoint, modality, provider_id, model_requested, stream,
		request_json, message_count, input_char_count, task, temperature, top_p,
		status, started_at,
		user_id, anonymous_id, auth_mode, tool_id,
		api_key_id, api_key_hash, client_ip_hash, user_agent, request_id_header,
		created_at, updated_at
	) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`
	_, err := s.exec(ctx, sql,
		rec.ID,
		rec.Endpoint,
		rec.Modality,
		rec.ProviderID,
		nullIfEmpty(rec.ModelRequested),
		boolInt(rec.Stream),
		rec.RequestJSON,
		nullInt(rec.MessageCount),
		nullInt(rec.InputCharCount),
		nullIfEmpty(rec.Task),
		rec.Temperature,
		rec.TopP,
		StatusPending,
		formatTime(rec.StartedAt),
		nullIfEmpty(rec.User.UserID),
		nullIfEmpty(rec.User.AnonymousID),
		authModeOrDefault(rec.User.AuthMode),
		nullIfEmpty(rec.ToolID),
		nullIfEmpty(rec.ClientMeta.APIKeyID),
		nullIfEmpty(rec.ClientMeta.APIKeyHash),
		nullIfEmpty(rec.ClientMeta.ClientIPHash),
		nullIfEmpty(rec.ClientMeta.UserAgent),
		nullIfEmpty(rec.ClientMeta.RequestIDHeader),
		formatTime(rec.StartedAt),
		formatTime(rec.StartedAt),
	)
	return err
}

func (s *D1Store) InsertValidationFailure(ctx context.Context, rec PendingRecord, fail FailRecord) error {
	sql := `INSERT INTO llm_gateway_requests (
		id, endpoint, modality, provider_id, model_requested, stream,
		request_json, message_count, input_char_count, task, temperature, top_p,
		status, http_status, error_code, error_message, latency_ms,
		started_at, completed_at,
		user_id, anonymous_id, auth_mode, tool_id,
		api_key_id, api_key_hash, client_ip_hash, user_agent, request_id_header,
		created_at, updated_at
	) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`
	_, err := s.exec(ctx, sql,
		rec.ID,
		rec.Endpoint,
		rec.Modality,
		rec.ProviderID,
		nullIfEmpty(rec.ModelRequested),
		boolInt(rec.Stream),
		rec.RequestJSON,
		nullInt(rec.MessageCount),
		nullInt(rec.InputCharCount),
		nullIfEmpty(rec.Task),
		rec.Temperature,
		rec.TopP,
		StatusValidation,
		fail.HTTPStatus,
		nullIfEmpty(fail.ErrorCode),
		nullIfEmpty(fail.ErrorMessage),
		fail.LatencyMS,
		formatTime(rec.StartedAt),
		formatTime(fail.CompletedAt),
		nullIfEmpty(rec.User.UserID),
		nullIfEmpty(rec.User.AnonymousID),
		authModeOrDefault(rec.User.AuthMode),
		nullIfEmpty(rec.ToolID),
		nullIfEmpty(rec.ClientMeta.APIKeyID),
		nullIfEmpty(rec.ClientMeta.APIKeyHash),
		nullIfEmpty(rec.ClientMeta.ClientIPHash),
		nullIfEmpty(rec.ClientMeta.UserAgent),
		nullIfEmpty(rec.ClientMeta.RequestIDHeader),
		formatTime(rec.StartedAt),
		formatTime(fail.CompletedAt),
	)
	return err
}

func (s *D1Store) Complete(ctx context.Context, id string, rec CompleteRecord) error {
	sql := `UPDATE llm_gateway_requests SET
		status = ?,
		http_status = ?,
		model_resolved = ?,
		output_char_count = ?,
		prompt_tokens = ?,
		completion_tokens = ?,
		total_tokens = ?,
		input_tokens = ?,
		output_tokens = ?,
		reasoning_tokens = ?,
		cached_tokens = ?,
		usage_json = ?,
		provider_response_id = ?,
		latency_ms = ?,
		completed_at = ?,
		updated_at = ?
	WHERE id = ?`
	_, err := s.exec(ctx, sql,
		StatusCompleted,
		rec.HTTPStatus,
		nullIfEmpty(rec.ModelResolved),
		nullInt(rec.OutputCharCount),
		nullInt64(rec.Usage.PromptTokens),
		nullInt64(rec.Usage.CompletionTokens),
		nullInt64(rec.Usage.TotalTokens),
		nullInt64(rec.Usage.InputTokens),
		nullInt64(rec.Usage.OutputTokens),
		nullInt64(rec.Usage.ReasoningTokens),
		nullInt64(rec.Usage.CachedTokens),
		nullIfEmpty(rec.Usage.RawJSON),
		nullIfEmpty(rec.ProviderResponseID),
		rec.LatencyMS,
		formatTime(rec.CompletedAt),
		formatTime(rec.CompletedAt),
		id,
	)
	return err
}

func (s *D1Store) Fail(ctx context.Context, id string, rec FailRecord) error {
	status := StatusFailed
	if rec.HTTPStatus == http.StatusBadRequest {
		status = StatusValidation
	}
	sql := `UPDATE llm_gateway_requests SET
		status = ?,
		http_status = ?,
		error_code = ?,
		error_message = ?,
		latency_ms = ?,
		completed_at = ?,
		updated_at = ?
	WHERE id = ?`
	_, err := s.exec(ctx, sql,
		status,
		rec.HTTPStatus,
		nullIfEmpty(rec.ErrorCode),
		nullIfEmpty(rec.ErrorMessage),
		rec.LatencyMS,
		formatTime(rec.CompletedAt),
		formatTime(rec.CompletedAt),
		id,
	)
	return err
}

type d1QueryRequest struct {
	SQL    string        `json:"sql"`
	Params []interface{} `json:"params,omitempty"`
}

type d1QueryResponse struct {
	Success bool `json:"success"`
	Errors  []struct {
		Code    int    `json:"code"`
		Message string `json:"message"`
	} `json:"errors"`
	Result []struct {
		Success bool   `json:"success"`
		Error   string `json:"error"`
	} `json:"result"`
}

func (s *D1Store) exec(ctx context.Context, sql string, params ...interface{}) (json.RawMessage, error) {
	body, err := json.Marshal(d1QueryRequest{SQL: sql, Params: params})
	if err != nil {
		return nil, err
	}
	url := fmt.Sprintf("%s/accounts/%s/d1/database/%s/query", s.cfg.APIBase, s.cfg.AccountID, s.cfg.DatabaseID)
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, url, bytes.NewReader(body))
	if err != nil {
		return nil, err
	}
	req.Header.Set("Authorization", "Bearer "+s.cfg.APIToken)
	req.Header.Set("Content-Type", "application/json")

	resp, err := s.cfg.HTTPClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	raw, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	if resp.StatusCode >= 400 {
		return nil, fmt.Errorf("d1 query http %d: %s", resp.StatusCode, truncate(string(raw), 300))
	}

	var parsed d1QueryResponse
	if err := json.Unmarshal(raw, &parsed); err != nil {
		return nil, err
	}
	if !parsed.Success {
		if len(parsed.Errors) > 0 {
			return nil, fmt.Errorf("d1 query failed: %s", parsed.Errors[0].Message)
		}
		return nil, fmt.Errorf("d1 query failed")
	}
	for _, r := range parsed.Result {
		if !r.Success {
			return nil, fmt.Errorf("d1 statement failed: %s", r.Error)
		}
	}
	return raw, nil
}

func boolInt(v bool) int {
	if v {
		return 1
	}
	return 0
}

func nullIfEmpty(v string) interface{} {
	if strings.TrimSpace(v) == "" {
		return nil
	}
	return v
}

func nullInt(v int) interface{} {
	if v == 0 {
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

func formatTime(t time.Time) string {
	if t.IsZero() {
		t = time.Now().UTC()
	}
	return t.UTC().Format("2006-01-02 15:04:05")
}

func truncate(s string, n int) string {
	if len(s) <= n {
		return s
	}
	return s[:n] + "..."
}

// HashValue returns a SHA-256 hex digest for privacy-safe attribution.
func HashValue(v string) string {
	v = strings.TrimSpace(v)
	if v == "" {
		return ""
	}
	sum := sha256.Sum256([]byte(v))
	return hex.EncodeToString(sum[:])
}

// ClientMetaFromRequest extracts billing attribution from an HTTP request.
func ClientMetaFromRequest(r *http.Request) ClientMeta {
	auth := strings.TrimSpace(r.Header.Get("Authorization"))
	if strings.HasPrefix(strings.ToLower(auth), "bearer ") {
		auth = strings.TrimSpace(auth[7:])
	}
	return ClientMeta{
		APIKeyHash:      HashValue(auth),
		ClientIPHash:    HashValue(clientIP(r)),
		UserAgent:       r.UserAgent(),
		RequestIDHeader: strings.TrimSpace(r.Header.Get("X-Request-ID")),
	}
}

func clientIP(r *http.Request) string {
	if xff := strings.TrimSpace(r.Header.Get("X-Forwarded-For")); xff != "" {
		parts := strings.Split(xff, ",")
		return strings.TrimSpace(parts[0])
	}
	host := r.RemoteAddr
	if i := strings.LastIndex(host, ":"); i > 0 {
		return host[:i]
	}
	return host
}
