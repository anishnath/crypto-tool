package main

import (
	"fmt"
	"sync"
)

type Buffer struct {
	data []byte
}

var bufferPool = sync.Pool{
	New: func() interface{} {
		// Create new buffer when pool is empty
		return &Buffer{
			data: make([]byte, 1024),
		}
	},
}

func processWithoutPool(n int) {
	for i := 0; i < n; i++ {
		// Allocate new buffer each time
		buf := &Buffer{
			data: make([]byte, 1024),
		}
		// Use buffer
		_ = buf
		// Buffer is garbage collected
	}
}

func processWithPool(n int) {
	for i := 0; i < n; i++ {
		// Get buffer from pool
		buf := bufferPool.Get().(*Buffer)

		// Use buffer
		_ = buf

		// Return buffer to pool
		bufferPool.Put(buf)
	}
}

func benchmark(name string, fn func(int), iterations int) {
	fmt.Printf("\n%s:\n", name)

	// Run and time
	start := make(chan struct{})
	done := make(chan struct{})

	go func() {
		<-start
		fn(iterations)
		close(done)
	}()

	close(start)
	<-done

	fmt.Printf("Completed %d iterations\n", iterations)
}

func main() {
	fmt.Println("sync.Pool Optimization Demo")
	fmt.Println("============================\n")

	iterations := 1000000

	fmt.Println("Processing without pool (allocates every time):")
	benchmark("Without Pool", processWithoutPool, iterations)

	fmt.Println("\nProcessing with pool (reuses buffers):")
	benchmark("With Pool", processWithPool, iterations)

	fmt.Println("\nBenefits of sync.Pool:")
	fmt.Println("  ✓ Reduces allocations")
	fmt.Println("  ✓ Reduces GC pressure")
	fmt.Println("  ✓ Improves performance")
	fmt.Println("  ✓ Reuses memory")

	fmt.Println("\nBest practices:")
	fmt.Println("  • Use for frequently allocated objects")
	fmt.Println("  • Reset object state before Put()")
	fmt.Println("  • Don't rely on objects staying in pool")
	fmt.Println("  • Pool is safe for concurrent use")
}
