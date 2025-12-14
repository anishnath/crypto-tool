package main

import (
	"fmt"
	"runtime"
	"time"
)

// Memory leak example - goroutine leak
func leakyGoroutines() {
	// ❌ Bad - goroutines never stop
	for i := 0; i < 10; i++ {
		go func() {
			for {
				// Infinite loop, never exits
				time.Sleep(time.Second)
			}
		}()
	}
	fmt.Println("Started 10 leaky goroutines")
}

// Fixed version - with cancellation
func fixedGoroutines() {
	done := make(chan struct{})

	// ✅ Good - goroutines can be stopped
	for i := 0; i < 10; i++ {
		go func() {
			for {
				select {
				case <-done:
					return // Clean exit
				default:
					time.Sleep(time.Second)
				}
			}
		}()
	}

	fmt.Println("Started 10 controlled goroutines")

	// Stop after 3 seconds
	time.Sleep(3 * time.Second)
	close(done)
	fmt.Println("Stopped all goroutines")
}

// Memory leak - forgotten references
type Cache struct {
	data map[string][]byte
}

func (c *Cache) leakyAdd(key string, value []byte) {
	// ❌ Bad - never removes old entries
	c.data[key] = value
}

func (c *Cache) fixedAdd(key string, value []byte, maxSize int) {
	// ✅ Good - limits cache size
	if len(c.data) >= maxSize {
		// Remove oldest entry (simplified)
		for k := range c.data {
			delete(c.data, k)
			break
		}
	}
	c.data[key] = value
}

func demonstrateLeaks() {
	fmt.Println("\nMemory Leak Demonstration:")
	fmt.Println("==========================\n")

	// Show goroutine count
	fmt.Printf("Initial goroutines: %d\n", runtime.NumGoroutine())

	// Create leak
	leakyGoroutines()
	time.Sleep(time.Second)
	fmt.Printf("After leaky start: %d goroutines\n", runtime.NumGoroutine())

	// Fixed version
	fixedGoroutines()
	time.Sleep(time.Second)
	fmt.Printf("After cleanup: %d goroutines\n", runtime.NumGoroutine())
}

func demonstrateCacheLeak() {
	fmt.Println("\nCache Leak Demonstration:")
	fmt.Println("=========================\n")

	cache := &Cache{data: make(map[string][]byte)}

	// Leaky cache
	fmt.Println("Adding 1000 items to leaky cache...")
	for i := 0; i < 1000; i++ {
		key := fmt.Sprintf("key%d", i)
		cache.leakyAdd(key, make([]byte, 1024))
	}
	fmt.Printf("Cache size: %d items\n", len(cache.data))

	// Fixed cache
	fixedCache := &Cache{data: make(map[string][]byte)}
	fmt.Println("\nAdding 1000 items to fixed cache (max 100)...")
	for i := 0; i < 1000; i++ {
		key := fmt.Sprintf("key%d", i)
		fixedCache.fixedAdd(key, make([]byte, 1024), 100)
	}
	fmt.Printf("Cache size: %d items (limited)\n", len(fixedCache.data))
}

func main() {
	fmt.Println("Memory Leak Prevention")
	fmt.Println("======================\n")

	demonstrateLeaks()
	demonstrateCacheLeak()

	fmt.Println("\nCommon Memory Leaks:")
	fmt.Println("  1. Goroutine leaks (no cancellation)")
	fmt.Println("  2. Unbounded caches (no eviction)")
	fmt.Println("  3. Forgotten timers (not stopped)")
	fmt.Println("  4. Circular references (rare in Go)")
	fmt.Println("  5. Global variables (never freed)")

	fmt.Println("\nPrevention Tips:")
	fmt.Println("  ✓ Always provide goroutine cancellation")
	fmt.Println("  ✓ Limit cache sizes with eviction policies")
	fmt.Println("  ✓ Stop timers when done")
	fmt.Println("  ✓ Use pprof to detect leaks")
	fmt.Println("  ✓ Monitor goroutine count in production")
}
