package main

import (
	"context"
	"fmt"
	"time"
)

func main() {
	// Context with timeout
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()
	
	select {
	case <-time.After(3 * time.Second):
		fmt.Println("Operation completed")
	case <-ctx.Done():
		fmt.Println("Timeout:", ctx.Err())
	}
}
