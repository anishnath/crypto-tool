package main

import (
	"context"
	"fmt"
	"time"
)

func worker(ctx context.Context, id int) {
	for {
		select {
		case <-ctx.Done():
			fmt.Printf("Worker %d cancelled: %v\n", id, ctx.Err())
			return
		default:
			fmt.Printf("Worker %d working...\n", id)
			time.Sleep(500 * time.Millisecond)
		}
	}
}

func main() {
	ctx, cancel := context.WithCancel(context.Background())

	// Start workers
	for i := 1; i <= 3; i++ {
		go worker(ctx, i)
	}

	// Let them work for 2 seconds
	time.Sleep(2 * time.Second)

	// Cancel all workers
	fmt.Println("Cancelling workers...")
	cancel()

	// Give time to see cancellation
	time.Sleep(time.Second)
}
