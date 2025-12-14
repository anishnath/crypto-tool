package main

import (
	"fmt"
	"time"
)

// Fibonacci with no optimization
func fibonacciSlow(n int) int {
	if n <= 1 {
		return n
	}
	return fibonacciSlow(n-1) + fibonacciSlow(n-2)
}

// Fibonacci with memoization
var memo = make(map[int]int)

func fibonacciFast(n int) int {
	if n <= 1 {
		return n
	}

	if val, ok := memo[n]; ok {
		return val
	}

	result := fibonacciFast(n-1) + fibonacciFast(n-2)
	memo[n] = result
	return result
}

// Inline candidate (small function)
//
//go:inline
func add(a, b int) int {
	return a + b
}

// No inline (large function)
//
//go:noinline
func complexCalculation(n int) int {
	result := 0
	for i := 0; i < n; i++ {
		result += i * i
	}
	return result
}

func main() {
	fmt.Println("Optimization Levels Demo")
	fmt.Println("========================\n")

	// Test inlining
	fmt.Println("1. Inlining Test:")
	start := time.Now()
	sum := 0
	for i := 0; i < 1000000; i++ {
		sum = add(sum, i)
	}
	fmt.Printf("   Inlined add: %v (sum=%d)\n\n", time.Since(start), sum)

	// Test optimization
	fmt.Println("2. Optimization Test:")
	n := 35

	start = time.Now()
	result := fibonacciSlow(n)
	slowTime := time.Since(start)
	fmt.Printf("   Slow (no memo): %v (result=%d)\n", slowTime, result)

	start = time.Now()
	result = fibonacciFast(n)
	fastTime := time.Since(start)
	fmt.Printf("   Fast (memo): %v (result=%d)\n", fastTime, result)
	fmt.Printf("   Speedup: %.2fx\n\n", float64(slowTime)/float64(fastTime))

	// Compiler directives
	fmt.Println("3. Compiler Directives:")
	fmt.Println("   //go:noinline      # Prevent inlining")
	fmt.Println("   //go:inline        # Suggest inlining")
	fmt.Println("   //go:noescape      # Pointer doesn't escape")
	fmt.Println("   //go:nosplit       # Don't grow stack")
	fmt.Println("   //go:linkname      # Link to another symbol")
	fmt.Println()

	// Build modes
	fmt.Println("4. Optimization Flags:")
	fmt.Println("   Default Build:")
	fmt.Println("     go build")
	fmt.Println("     • Full optimizations")
	fmt.Println("     • Inlining enabled")
	fmt.Println("     • Dead code elimination")
	fmt.Println()

	fmt.Println("   Debug Build:")
	fmt.Println("     go build -gcflags=\"-N -l\"")
	fmt.Println("     • -N: Disable optimizations")
	fmt.Println("     • -l: Disable inlining")
	fmt.Println("     • Better for debugging")
	fmt.Println()

	fmt.Println("   Size Optimized:")
	fmt.Println("     go build -ldflags=\"-s -w\"")
	fmt.Println("     • -s: Strip symbol table")
	fmt.Println("     • -w: Strip DWARF debug info")
	fmt.Println("     • Smallest binary size")
	fmt.Println()

	fmt.Println("5. Optimization Tips:")
	fmt.Println("   ✓ Profile before optimizing")
	fmt.Println("   ✓ Use benchmarks to measure")
	fmt.Println("   ✓ Default optimizations are good")
	fmt.Println("   ✓ Avoid premature optimization")
	fmt.Println("   ✓ Use -gcflags=\"-m\" to see optimizations")
}
