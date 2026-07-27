package billing

import (
	"context"
	"net/http/httptest"
	"testing"
)

func TestNormalizePlanSlug(t *testing.T) {
	cases := map[string]string{
		"":        PlanGuest,
		"guest":   PlanGuest,
		"free":    PlanFree,
		"pro":     PlanPro,
		"premium": PlanPro,
		"ultra":   PlanUltra,
		"ULTRA":   PlanUltra,
		"other":   PlanFree,
	}
	for in, want := range cases {
		if got := normalizePlanSlug(in); got != want {
			t.Fatalf("normalizePlanSlug(%q)=%q want %q", in, got, want)
		}
	}
}

func TestResolveToolEntitlementAnonymousIsGuest(t *testing.T) {
	srv := testD1BySQL(t, nil)
	defer srv.Close()
	store := mustTestStore(t, srv)

	ent, err := store.ResolveToolEntitlement(context.Background(), "", ToolIDManic)
	if err != nil {
		t.Fatal(err)
	}
	if ent.Plan != PlanGuest {
		t.Fatalf("plan=%q want guest", ent.Plan)
	}
	if ent.Source.Kind != "anonymous" {
		t.Fatalf("source=%q", ent.Source.Kind)
	}
}

func TestResolveToolEntitlementLoggedInNoPurchaseIsFree(t *testing.T) {
	empty := `{"success":true,"result":[{"success":true,"results":[]}]}`
	srv := testD1BySQL(t, map[string]string{
		"user_tool_entitlements": empty,
		"plan_coverage":          empty,
	})
	defer srv.Close()
	store := mustTestStore(t, srv)

	ent, err := store.ResolveToolEntitlement(context.Background(), "user-1", ToolIDManic)
	if err != nil {
		t.Fatal(err)
	}
	if ent.Plan != PlanFree {
		t.Fatalf("plan=%q want free (is_premium must not unlock Manic)", ent.Plan)
	}
	if ent.Source.Kind != "free" {
		t.Fatalf("source=%q", ent.Source.Kind)
	}
}

func TestResolveToolEntitlementDirectPro(t *testing.T) {
	direct := `{"success":true,"result":[{"success":true,"results":[
		{"tool_id":"developer-tools/manic","plan_slug":"pro","status":"active",
		 "source_product_id":"prod_m","source_subscription_id":"sub_1","current_period_end":"2099-01-01T00:00:00Z"}
	]}]}`
	covers := `{"success":true,"result":[{"success":true,"results":[
		{"covers_tool_id":"electronics/arduino-simulator","grants_plan":"pro"}
	]}]}`
	srv := testD1BySQL(t, map[string]string{
		"FROM user_tool_entitlements": direct,
		"FROM plan_coverage":          covers,
	})
	defer srv.Close()
	store := mustTestStore(t, srv)

	ent, err := store.ResolveToolEntitlement(context.Background(), "user-1", ToolIDManic)
	if err != nil {
		t.Fatal(err)
	}
	if ent.Plan != PlanPro || ent.Source.Kind != "direct" {
		t.Fatalf("got %+v", ent)
	}
	if len(ent.Covers) != 1 || ent.Covers[0].ToolID != "electronics/arduino-simulator" {
		t.Fatalf("covers=%+v", ent.Covers)
	}
}

func TestResolveToolEntitlementCoverage(t *testing.T) {
	noDirect := `{"success":true,"result":[{"success":true,"results":[]}]}`
	covered := `{"success":true,"result":[{"success":true,"results":[
		{"purchased_tool_id":"developer-tools/manic","purchased_plan":"ultra",
		 "current_period_end":"2099-01-01T00:00:00Z","grants_plan":"pro"}
	]}]}`
	srv := testD1BySQL(t, map[string]string{
		"WHERE user_id = ? AND tool_id = ?": noDirect,
		"JOIN plan_coverage":                covered,
	})
	defer srv.Close()
	store := mustTestStore(t, srv)

	ent, err := store.ResolveToolEntitlement(context.Background(), "user-1", "electronics/arduino-simulator")
	if err != nil {
		t.Fatal(err)
	}
	if ent.Plan != PlanPro || ent.Source.Kind != "coverage" {
		t.Fatalf("got %+v", ent)
	}
	if ent.Source.PurchasedPlan != PlanUltra {
		t.Fatalf("purchased_plan=%q", ent.Source.PurchasedPlan)
	}
}

func TestResolvePlanManicIgnoresGlobalPremium(t *testing.T) {
	// Premium user row exists, but no Manic entitlement → free for Manic AI.
	premium := `{"success":true,"result":[{"success":true,"results":[{"is_premium":1}]}]}`
	empty := `{"success":true,"result":[{"success":true,"results":[]}]}`
	aiPlans := `{"success":true,"result":[{"success":true,"results":[
		{"plan_id":"free","display_name":"Free account","monthly_token_limit":200000},
		{"plan_id":"pro","display_name":"Pro","monthly_token_limit":2000000}
	]}]}`
	srv := testD1BySQL(t, map[string]string{
		"users":                  premium,
		"user_tool_entitlements": empty,
		"plan_coverage":          empty,
		"ai_plans":               aiPlans,
	})
	defer srv.Close()
	store := mustTestStore(t, srv)

	planID, _, err := store.resolvePlan(context.Background(), UserIdentity{
		AuthMode: AuthAuthenticated,
		UserID:   "premium-user",
		ToolID:   ToolIDManic,
	})
	if err != nil {
		t.Fatal(err)
	}
	if planID != PlanFree {
		t.Fatalf("Manic plan=%q want free (global is_premium must not unlock)", planID)
	}

	// Same user without Manic tool id still gets Pro from is_premium.
	planID, _, err = store.resolvePlan(context.Background(), UserIdentity{
		AuthMode: AuthAuthenticated,
		UserID:   "premium-user",
		ToolID:   "electronics/arduino-simulator",
	})
	if err != nil {
		t.Fatal(err)
	}
	if planID != PlanPro {
		t.Fatalf("non-Manic plan=%q want pro", planID)
	}
}

func TestParseEntitlementMetaNestedWebhook(t *testing.T) {
	raw := `{
	  "type":"subscription.active",
	  "data":{
	    "product_id":"pdt_x",
	    "metadata":{"user_id":"u1","tool_id":"developer-tools/manic","ai_plan_id":"ultra","plan_key":"ultra"}
	  }
	}`
	toolID, plan := parseEntitlementMeta(raw)
	if toolID != ToolIDManic || plan != PlanUltra {
		t.Fatalf("got tool=%q plan=%q", toolID, plan)
	}
}

func TestUpgradeSlugsManic(t *testing.T) {
	got := upgradeSlugs(ToolIDManic, PlanFree)
	if len(got) != 2 || got[0] != PlanPro || got[1] != PlanUltra {
		t.Fatalf("free upgrades=%v", got)
	}
	got = upgradeSlugs(ToolIDManic, PlanPro)
	if len(got) != 1 || got[0] != PlanUltra {
		t.Fatalf("pro upgrades=%v", got)
	}
	got = upgradeSlugs(ToolIDManic, PlanUltra)
	if len(got) != 0 {
		t.Fatalf("ultra upgrades=%v", got)
	}
}

func mustTestStore(t *testing.T, srv *httptest.Server) *D1Store {
	t.Helper()
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
	return store
}
