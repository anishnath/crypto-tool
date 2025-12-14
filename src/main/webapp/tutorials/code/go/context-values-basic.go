package main

import (
	"context"
	"fmt"
)

type key string

const (
	userIDKey    key = "userID"
	requestIDKey key = "requestID"
)

func processRequest(ctx context.Context) {
	userID := ctx.Value(userIDKey)
	requestID := ctx.Value(requestIDKey)

	fmt.Printf("Processing request %v for user %v\n", requestID, userID)
}

func main() {
	// Create context with values
	ctx := context.Background()
	ctx = context.WithValue(ctx, userIDKey, "user123")
	ctx = context.WithValue(ctx, requestIDKey, "req456")

	processRequest(ctx)

	// Accessing values
	if userID, ok := ctx.Value(userIDKey).(string); ok {
		fmt.Printf("User ID: %s\n", userID)
	}
}
