package billing

import (
	"context"
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestCheckAIQuotaNoopAlwaysPasses(t *testing.T) {
	if err := (NoopStore{}).CheckAIQuota(context.Background(), UserIdentity{}); err != nil {
		t.Fatal(err)
	}
}

func TestCheckAIQuotaRequiresIdentityOnD1(t *testing.T) {
	srv := httptest.NewServer(testD1Handler(t, `{"success":true,"result":[{"success":true}]}`))
	defer srv.Close()

	store, err := NewD1Store(D1Config{
		AccountID:  "a",
		DatabaseID: "d",
		APIToken:   "t",
		APIBase:    srv.URL + "/client/v4",
		HTTPClient: srv.Client(),
	})
	if err != nil {
		t.Fatal(err)
	}

	err = store.CheckAIQuota(context.Background(), UserIdentity{AuthMode: AuthAnonymous})
	if err == nil {
		t.Fatal("expected error without anonymous id")
	}
	if !errors.Is(err, ErrBadRequest) {
		t.Fatalf("got %v", err)
	}
}

func TestGetAIQuotaGuestWithAnonymousID(t *testing.T) {
	srv := httptest.NewServer(testD1Handler(t, `{"success":true,"result":[{"success":true}]}`))
	defer srv.Close()

	store, err := NewD1Store(D1Config{
		AccountID:  "a",
		DatabaseID: "d",
		APIToken:   "t",
		APIBase:    srv.URL + "/client/v4",
		HTTPClient: srv.Client(),
	})
	if err != nil {
		t.Fatal(err)
	}

	status, err := store.GetAIQuota(context.Background(), UserIdentity{
		AuthMode:    AuthAnonymous,
		AnonymousID: "anon-123",
	})
	if err != nil {
		t.Fatal(err)
	}
	if status.PlanID != PlanGuest {
		t.Fatalf("plan = %q", status.PlanID)
	}
	// Empty D1 mock → env fallback
	if status.TokensLimit != LoadQuotaLimits().Guest {
		t.Fatalf("limit = %d", status.TokensLimit)
	}
}

func TestGetAIQuotaUsesAIPlansTable(t *testing.T) {
	aiPlansBody := `{"success":true,"result":[{"success":true,"results":[
		{"plan_id":"guest","display_name":"Guest","monthly_token_limit":55000},
		{"plan_id":"free","display_name":"Free account","monthly_token_limit":300000},
		{"plan_id":"pro","display_name":"Pro","monthly_token_limit":5000000}
	]}]}`
	usageEmpty := `{"success":true,"result":[{"success":true,"results":[]}]}`

	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		body, _ := io.ReadAll(r.Body)
		sql := extractD1SQL(body)
		switch {
		case strings.Contains(sql, "ai_plans"):
			_, _ = w.Write([]byte(aiPlansBody))
		case strings.Contains(sql, "ai_usage_periods"):
			_, _ = w.Write([]byte(usageEmpty))
		default:
			_, _ = w.Write([]byte(`{"success":true,"result":[{"success":true}]}`))
		}
	}))
	defer srv.Close()

	store, err := NewD1Store(D1Config{
		AccountID:  "a",
		DatabaseID: "d",
		APIToken:   "t",
		APIBase:    srv.URL + "/client/v4",
		HTTPClient: srv.Client(),
	})
	if err != nil {
		t.Fatal(err)
	}

	status, err := store.GetAIQuota(context.Background(), UserIdentity{
		AuthMode:    AuthAnonymous,
		AnonymousID: "anon-xyz",
	})
	if err != nil {
		t.Fatal(err)
	}
	if status.TokensLimit != 55000 {
		t.Fatalf("expected limit from ai_plans, got %d", status.TokensLimit)
	}
	if status.PlanName != "Guest" {
		t.Fatalf("plan name = %q", status.PlanName)
	}
}

func extractD1SQL(body []byte) string {
	var req struct {
		SQL string `json:"sql"`
	}
	_ = json.Unmarshal(body, &req)
	return req.SQL
}

func testD1Handler(t *testing.T, body string) http.HandlerFunc {
	t.Helper()
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write([]byte(body))
	}
}
