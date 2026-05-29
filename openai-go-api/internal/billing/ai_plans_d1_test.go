package billing

import (
	"context"
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func testD1BySQL(t *testing.T, responses map[string]string) *httptest.Server {
	t.Helper()
	return httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		body, _ := io.ReadAll(r.Body)
		sql := extractD1SQL(body)
		for needle, resp := range responses {
			if strings.Contains(sql, needle) {
				_, _ = w.Write([]byte(resp))
				return
			}
		}
		_, _ = w.Write([]byte(`{"success":true,"result":[{"success":true,"results":[]}]}`))
	}))
}

func TestGetAIPlanIncludesFeatures(t *testing.T) {
	aiPlansBody := `{"success":true,"result":[{"success":true,"results":[
		{"plan_id":"pro","display_name":"Pro","monthly_token_limit":2000000,
		 "description":"Premium subscriber",
		 "features_json":"[\"2M tokens\",\"No rate limits\"]"}
	]}]}`

	srv := testD1BySQL(t, map[string]string{"ai_plans": aiPlansBody})
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

	rec, ok := store.GetAIPlan(context.Background(), PlanPro)
	if !ok {
		t.Fatal("expected pro plan")
	}
	if rec.MonthlyTokenLimit != 2_000_000 {
		t.Fatalf("limit = %d", rec.MonthlyTokenLimit)
	}
	if len(rec.Features) != 2 || rec.Features[0] != "2M tokens" {
		t.Fatalf("features = %#v", rec.Features)
	}
}

func TestTierModelIDForPro(t *testing.T) {
	body := `{"success":true,"result":[{"success":true,"results":[
		{"plan_id":"guest","display_name":"Guest","monthly_token_limit":20000,"model_id":"gpt-5.4-nano"},
		{"plan_id":"free","display_name":"Free","monthly_token_limit":200000,"model_id":"gpt-5.4-mini"},
		{"plan_id":"pro","display_name":"Pro","monthly_token_limit":2000000,"model_id":"gpt-5.4"}
	]}]}`
	srv := testD1BySQL(t, map[string]string{"ai_plans": body})
	defer srv.Close()
	store, err := NewD1Store(D1Config{
		AccountID: "a", DatabaseID: "d", APIToken: "t",
		APIBase: srv.URL + "/client/v4", HTTPClient: srv.Client(),
	})
	if err != nil {
		t.Fatal(err)
	}
	// Pro user
	premiumBody := `{"success":true,"result":[{"success":true,"results":[{"is_premium":1}]}]}`
	srv2 := testD1BySQL(t, map[string]string{
		"ai_plans": body,
		"users":    premiumBody,
	})
	defer srv2.Close()
	store2, _ := NewD1Store(D1Config{
		AccountID: "a", DatabaseID: "d", APIToken: "t",
		APIBase: srv2.URL + "/client/v4", HTTPClient: srv2.Client(),
	})
	model, err := store2.TierModelID(context.Background(), UserIdentity{UserID: "u1"})
	if err != nil {
		t.Fatal(err)
	}
	if model != "gpt-5.4" {
		t.Fatalf("pro model = %q", model)
	}
	_ = store
	guestModel, _ := store.TierModelID(context.Background(), UserIdentity{AnonymousID: "a1"})
	if guestModel != "gpt-5.4-nano" {
		t.Fatalf("guest model = %q", guestModel)
	}
}

func TestListAIPlansOrdered(t *testing.T) {
	aiPlansBody := `{"success":true,"result":[{"success":true,"results":[
		{"plan_id":"pro","display_name":"Pro","monthly_token_limit":2000000,"features_json":"[]"},
		{"plan_id":"guest","display_name":"Guest","monthly_token_limit":20000,"features_json":null},
		{"plan_id":"free","display_name":"Free account","monthly_token_limit":200000,"features_json":null}
	]}]}`

	srv := testD1BySQL(t, map[string]string{"ai_plans": aiPlansBody})
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

	rows, err := store.ListAIPlans(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	if len(rows) != 3 {
		t.Fatalf("got %d plans", len(rows))
	}
	if rows[0].PlanID != PlanGuest || rows[2].PlanID != PlanPro {
		t.Fatalf("order = %v %v %v", rows[0].PlanID, rows[1].PlanID, rows[2].PlanID)
	}
}
