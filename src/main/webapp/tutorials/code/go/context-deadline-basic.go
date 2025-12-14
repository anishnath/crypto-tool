package main

import (
	"context"
	"fmt"
	"time"
)

func processWithDeadline(ctx context.Context) {
	deadline, ok := ctx.Deadline()
	if ok {
		fmt.Printf("Deadline: %v\n", deadline.Format("15:04:05"))
	}

	for i := 1; i <= 5; i++ {
		select {
		case <-ctx.Done():
			fmt.Println("Deadline exceeded!")
			return
		default:
			fmt.Printf("Processing step %d...\n", i)
			time.Sleep(500 * time.Millisecond)
		}
	}

	fmt.Println("Processing completed")
}

func main() {
	deadline := time.Now().Add(2 * time.Second)
	ctx, cancel := context.WithDeadline(
		context.Background(),
		deadline,
	)
	defer cancel()

	fmt.Println("Starting process...")
	processWithDeadline(ctx)
}
