package main

import (
	"context"
	"fmt"
	"time"
)

func slowOperation(ctx context.Context) error {
	select {
	case <-time.After(3 * time.Second):
		fmt.Println("Operation completed")
		return nil
	case <-ctx.Done():
		fmt.Println("Operation cancelled:", ctx.Err())
		return ctx.Err()
	}
}

func main() {
	// Create context with 1 second timeout
	ctx, cancel := context.WithTimeout(
		context.Background(),
		1*time.Second,
	)
	defer cancel()

	fmt.Println("Starting operation with 1s timeout...")
	err := slowOperation(ctx)

	if err != nil {
		fmt.Printf("Error: %v\n", err)
	}
}
