package main

import (
	"fmt"
	"runtime"
	"time"
)

func allocateMemory() {
	// Allocate many small objects
	for i := 0; i < 1000000; i++ {
		_ = make([]byte, 100)
	}
}

func printGCStats() {
	var m runtime.MemStats
	runtime.ReadMemStats(&m)

	fmt.Printf("GC Stats:\n")
	fmt.Printf("  NumGC: %d\n", m.NumGC)
	fmt.Printf("  PauseTotal: %v ms\n", float64(m.PauseTotalNs)/1e6)
	fmt.Printf("  HeapAlloc: %v MB\n", m.HeapAlloc/1024/1024)
	fmt.Printf("  HeapSys: %v MB\n", m.HeapSys/1024/1024)
	fmt.Printf("  HeapIdle: %v MB\n", m.HeapIdle/1024/1024)
	fmt.Printf("  HeapInuse: %v MB\n", m.HeapInuse/1024/1024)
	fmt.Printf("  NextGC: %v MB\n\n", m.NextGC/1024/1024)
}

func main() {
	fmt.Println("Garbage Collection Demo")
	fmt.Println("========================\n")

	// Initial stats
	fmt.Println("Before allocation:")
	printGCStats()

	// Allocate memory
	fmt.Println("Allocating 1M objects...")
	allocateMemory()

	fmt.Println("\nAfter allocation (before GC):")
	printGCStats()

	// Force garbage collection
	fmt.Println("Running GC...")
	runtime.GC()

	fmt.Println("\nAfter GC:")
	printGCStats()

	// Watch GC over time
	fmt.Println("Watching GC for 5 seconds...")
	ticker := time.NewTicker(time.Second)
	defer ticker.Stop()

	count := 0
	for range ticker.C {
		allocateMemory()
		count++
		fmt.Printf("Iteration %d - NumGC: ", count)
		var m runtime.MemStats
		runtime.ReadMemStats(&m)
		fmt.Printf("%d, HeapAlloc: %v MB\n", m.NumGC, m.HeapAlloc/1024/1024)

		if count >= 5 {
			break
		}
	}

	fmt.Println("\nFinal stats:")
	printGCStats()
}
