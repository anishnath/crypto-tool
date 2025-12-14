package main

import (
	"fmt"
	"os"
	"runtime"
	"runtime/pprof"
)

type Data struct {
	values []int
}

func allocateData(n int) []*Data {
	data := make([]*Data, n)
	for i := 0; i < n; i++ {
		data[i] = &Data{
			values: make([]int, 1000),
		}
	}
	return data
}

func profileMemory() {
	// Create memory profile
	f, err := os.Create("mem.prof")
	if err != nil {
		fmt.Println("Could not create memory profile:", err)
		return
	}
	defer f.Close()

	runtime.GC() // Get up-to-date statistics
	if err := pprof.WriteHeapProfile(f); err != nil {
		fmt.Println("Could not write memory profile:", err)
	}

	fmt.Println("Memory profile written to mem.prof")
	fmt.Println("Analyze with: go tool pprof mem.prof")
}

func main() {
	fmt.Println("Memory Profiling Demo")
	fmt.Println("=====================\n")

	// Initial memory stats
	var m runtime.MemStats
	runtime.ReadMemStats(&m)
	fmt.Printf("Initial HeapAlloc: %v MB\n\n", m.HeapAlloc/1024/1024)

	// Allocate memory
	fmt.Println("Allocating 10,000 Data objects...")
	data := allocateData(10000)

	runtime.ReadMemStats(&m)
	fmt.Printf("After allocation: %v MB\n\n", m.HeapAlloc/1024/1024)

	// Keep data alive
	fmt.Printf("Allocated %d objects\n", len(data))

	// Profile memory
	fmt.Println("\nCreating memory profile...")
	profileMemory()

	fmt.Println("\nTo analyze the profile:")
	fmt.Println("  1. go tool pprof mem.prof")
	fmt.Println("  2. Type 'top' to see top memory consumers")
	fmt.Println("  3. Type 'list main' to see line-by-line allocation")
	fmt.Println("  4. Type 'web' to visualize (requires graphviz)")
}
