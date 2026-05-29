package billing

import (
	"context"
	"net/http"
	"strings"
)

const (
	AuthAnonymous     = "anonymous"
	AuthAuthenticated = "authenticated"
	AuthAPIKey        = "api_key"

	headerUserID      = "X-User-Id"
	headerAnonymousID = "X-Anonymous-Id"
	apiKeyPrefix      = "llm_"
)

// UserIdentity identifies who made an API call (logged in, API key, or anonymous).
type UserIdentity struct {
	AuthMode    string
	UserID      string
	AnonymousID string
}

// APIKeyResolver maps a hashed API key to a user (optional; D1-backed).
type APIKeyResolver interface {
	ResolveAPIKey(ctx context.Context, keyHash string) (userID, keyID string, err error)
}

// IdentityFromRequest resolves caller identity from headers.
// Priority: X-User-Id > Bearer llm_* (via resolver) > X-Anonymous-Id > anonymous.
func IdentityFromRequest(ctx context.Context, r *http.Request, resolver APIKeyResolver) UserIdentity {
	if userID := strings.TrimSpace(r.Header.Get(headerUserID)); userID != "" {
		return UserIdentity{AuthMode: AuthAuthenticated, UserID: userID}
	}

	if token := bearerToken(r); strings.HasPrefix(token, apiKeyPrefix) && resolver != nil {
		hash := HashValue(token)
		userID, keyID, err := resolver.ResolveAPIKey(ctx, hash)
		if err == nil && userID != "" {
			_ = keyID
			return UserIdentity{AuthMode: AuthAPIKey, UserID: userID}
		}
	}

	if anonID := strings.TrimSpace(r.Header.Get(headerAnonymousID)); anonID != "" {
		return UserIdentity{AuthMode: AuthAnonymous, AnonymousID: anonID}
	}

	return UserIdentity{AuthMode: AuthAnonymous}
}

func bearerToken(r *http.Request) string {
	auth := strings.TrimSpace(r.Header.Get("Authorization"))
	if strings.HasPrefix(strings.ToLower(auth), "bearer ") {
		return strings.TrimSpace(auth[7:])
	}
	return auth
}

// RequestContext combines client metadata and user identity for billing rows.
type RequestContext struct {
	Client ClientMeta
	User   UserIdentity
}

// RequestContextFromHTTP builds billing context from an incoming HTTP request.
func RequestContextFromHTTP(ctx context.Context, r *http.Request, resolver APIKeyResolver) RequestContext {
	user := IdentityFromRequest(ctx, r, resolver)
	meta := ClientMetaFromRequest(r)

	if user.AuthMode == AuthAPIKey {
		token := bearerToken(r)
		meta.APIKeyHash = HashValue(token)
		if resolver != nil {
			if _, keyID, err := resolver.ResolveAPIKey(ctx, meta.APIKeyHash); err == nil {
				meta.APIKeyID = keyID
			}
		}
	}

	return RequestContext{Client: meta, User: user}
}
