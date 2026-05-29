package billing

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestIdentityFromRequestAuthenticated(t *testing.T) {
	req := httptest.NewRequest(http.MethodPost, "/v1/chat/completions", nil)
	req.Header.Set("X-User-Id", "111513473250186617916")

	id := IdentityFromRequest(req.Context(), req, NoopStore{})
	if id.AuthMode != AuthAuthenticated || id.UserID != "111513473250186617916" {
		t.Fatalf("got %+v", id)
	}
}

func TestIdentityFromRequestAnonymous(t *testing.T) {
	req := httptest.NewRequest(http.MethodPost, "/v1/chat/completions", nil)
	req.Header.Set("X-Anonymous-Id", "anon-uuid-123")

	id := IdentityFromRequest(req.Context(), req, NoopStore{})
	if id.AuthMode != AuthAnonymous || id.AnonymousID != "anon-uuid-123" {
		t.Fatalf("got %+v", id)
	}
}

func TestIdentityFromRequestDefaultAnonymous(t *testing.T) {
	req := httptest.NewRequest(http.MethodPost, "/v1/chat/completions", nil)
	id := IdentityFromRequest(req.Context(), req, NoopStore{})
	if id.AuthMode != AuthAnonymous {
		t.Fatalf("got %+v", id)
	}
}

func TestIdentityPriorityUserOverAnonymous(t *testing.T) {
	req := httptest.NewRequest(http.MethodPost, "/", nil)
	req.Header.Set("X-User-Id", "user-1")
	req.Header.Set("X-Anonymous-Id", "anon-1")

	id := IdentityFromRequest(req.Context(), req, NoopStore{})
	if id.UserID != "user-1" || id.AuthMode != AuthAuthenticated {
		t.Fatalf("got %+v", id)
	}
}

func TestRequestContextFromHTTP(t *testing.T) {
	req := httptest.NewRequest(http.MethodPost, "/", nil)
	req.Header.Set("X-User-Id", "user-1")
	req.Header.Set("User-Agent", "test-agent")

	ctx := RequestContextFromHTTP(req.Context(), req, NoopStore{})
	if ctx.User.UserID != "user-1" {
		t.Fatalf("user = %+v", ctx.User)
	}
	if ctx.Client.UserAgent != "test-agent" {
		t.Fatalf("client = %+v", ctx.Client)
	}
}
