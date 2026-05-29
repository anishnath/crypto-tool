package billing

import (
	"context"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/anish/crypto-tool/openai-go-api/internal/provider"
)

func TestD1StoreInsertAndComplete(t *testing.T) {
	var gotBody string
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			t.Fatalf("method = %s", r.Method)
		}
		if !strings.Contains(r.URL.Path, "/d1/database/db-id/query") {
			t.Fatalf("path = %s", r.URL.Path)
		}
		if auth := r.Header.Get("Authorization"); auth != "Bearer test-token" {
			t.Fatalf("auth = %q", auth)
		}
		buf, _ := io.ReadAll(r.Body)
		gotBody = string(buf)
		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write([]byte(`{"success":true,"result":[{"success":true}]}`))
	}))
	defer srv.Close()

	store, err := NewD1Store(D1Config{
		AccountID:  "acct",
		DatabaseID: "db-id",
		APIToken:   "test-token",
		APIBase:    srv.URL + "/client/v4",
		HTTPClient: srv.Client(),
	})
	if err != nil {
		t.Fatal(err)
	}

	temp := 0.7
	rec := PendingRecord{
		ID:             "req-1",
		Endpoint:       EndpointChat,
		Modality:       ModalityChat,
		ProviderID:     "openai",
		ModelRequested: "gpt-5.4-mini",
		RequestJSON:    `{"model":"gpt-5.4-mini"}`,
		MessageCount:   1,
		InputCharCount: 5,
		Temperature:    &temp,
		StartedAt:      time.Date(2026, 5, 27, 12, 0, 0, 0, time.UTC),
		ClientMeta:     ClientMeta{APIKeyHash: "abc"},
	}
	if err := store.InsertPending(context.Background(), rec); err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(gotBody, "INSERT INTO llm_gateway_requests") {
		t.Fatalf("expected insert SQL, got %s", gotBody)
	}

	usage := provider.Usage{PromptTokens: 10, CompletionTokens: 5, TotalTokens: 15, RawJSON: `{"total_tokens":15}`}
	if err := store.Complete(context.Background(), "req-1", CompleteRecord{
		ModelResolved:      "gpt-5.4-mini",
		HTTPStatus:         200,
		OutputCharCount:    12,
		Usage:              usage,
		ProviderResponseID: "cmpl-1",
		LatencyMS:          42,
		CompletedAt:        time.Date(2026, 5, 27, 12, 0, 1, 0, time.UTC),
	}); err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(gotBody, "UPDATE llm_gateway_requests SET") {
		t.Fatalf("expected update SQL, got %s", gotBody)
	}
}

func TestD1StoreInsertValidationFailure(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write([]byte(`{"success":true,"result":[{"success":true}]}`))
	}))
	defer srv.Close()

	store, err := NewD1Store(D1Config{
		AccountID:  "acct",
		DatabaseID: "db-id",
		APIToken:   "test-token",
		APIBase:    srv.URL + "/client/v4",
		HTTPClient: srv.Client(),
	})
	if err != nil {
		t.Fatal(err)
	}

	err = store.InsertValidationFailure(context.Background(), PendingRecord{
		ID:          "bad-1",
		Endpoint:    EndpointChat,
		Modality:    ModalityChat,
		RequestJSON: `{}`,
		StartedAt:   time.Now().UTC(),
	}, FailRecord{
		HTTPStatus:   400,
		ErrorCode:    "model_not_found",
		ErrorMessage: "missing",
		CompletedAt:  time.Now().UTC(),
	})
	if err != nil {
		t.Fatal(err)
	}
}

func TestUsageFromCompletion(t *testing.T) {
	u := provider.Usage{
		PromptTokens: 1, CompletionTokens: 2, TotalTokens: 3,
	}
	if u.IsZero() {
		t.Fatal("expected non-zero usage")
	}
}

func TestHashValue(t *testing.T) {
	if HashValue("") != "" {
		t.Fatal("empty hash should be empty")
	}
	if len(HashValue("secret")) != 64 {
		t.Fatalf("expected sha256 hex, got len %d", len(HashValue("secret")))
	}
}

func TestD1QueryError(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusUnauthorized)
		_, _ = w.Write([]byte(`{"success":false}`))
	}))
	defer srv.Close()

	store, err := NewD1Store(D1Config{
		AccountID:  "acct",
		DatabaseID: "db-id",
		APIToken:   "bad",
		APIBase:    srv.URL + "/client/v4",
		HTTPClient: srv.Client(),
	})
	if err != nil {
		t.Fatal(err)
	}
	err = store.InsertPending(context.Background(), PendingRecord{ID: "x", Endpoint: EndpointChat, Modality: ModalityChat, RequestJSON: "{}"})
	if err == nil {
		t.Fatal("expected error")
	}
}

func TestD1QueryResponseParse(t *testing.T) {
	raw := `{"success":false,"errors":[{"code":7500,"message":"no such table"}]}`
	var parsed d1QueryResponse
	if err := json.Unmarshal([]byte(raw), &parsed); err != nil {
		t.Fatal(err)
	}
	if parsed.Success || len(parsed.Errors) != 1 {
		t.Fatalf("unexpected parse: %+v", parsed)
	}
}
