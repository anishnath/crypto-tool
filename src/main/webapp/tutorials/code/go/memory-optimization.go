package main

import (
	"fmt"
	"runtime"
)

// ❌ Bad - creates many small allocations
func inefficientConcat(n int) string {
	result := ""
	for i := 0; i < n; i++ {
		result += "x" // Each += allocates new string
	}
	return result
}

// ✅ Good - preallocates slice
func efficientBuild(n int) string {
	buf := make([]byte, 0, n) // Preallocate capacity
	for i := 0; i < n; i++ {
		buf = append(buf, 'x')
	}
	return string(buf)
}

// ❌ Bad - slice grows dynamically
func inefficientSlice() []int {
	var nums []int // No capacity
	for i := 0; i < 10000; i++ {
		nums = append(nums, i) // Reallocates multiple times
	}
	return nums
}

// ✅ Good - preallocates slice
func efficientSlice() []int {
	nums := make([]int, 0, 10000) // Preallocate capacity
	for i := 0; i < 10000; i++ {
		nums = append(nums, i) // No reallocation
	}
	return nums
}

// ❌ Bad - pointer escapes unnecessarily
func inefficientPointer() *int {
	x := 42
	return &x // x escapes to heap
}

// ✅ Good - return by value
func efficientValue() int {
	x := 42
	return x // Stays on stack
}

func measureAllocations(name string, fn func()) {
	var m1, m2 runtime.MemStats

	runtime.ReadMemStats(&m1)
	fn()
	runtime.ReadMemStats(&m2)

	allocs := m2.Mallocs - m1.Mallocs
	fmt.Printf("%s:\n", name)
	fmt.Printf("  Allocations: %d\n", allocs)
	fmt.Printf("  Allocated: %d bytes\n\n", m2.TotalAlloc-m1.TotalAlloc)
}

func main() {
	fmt.Println("Memory Optimization Techniques")
	fmt.Println("==============================\n")

	// String concatenation
	fmt.Println("1. String Building:")
	measureAllocations("Inefficient (+=)", func() {
		_ = inefficientConcat(1000)
	})
	measureAllocations("Efficient (preallocate)", func() {
		_ = efficientBuild(1000)
	})

	// Slice allocation
	fmt.Println("2. Slice Allocation:")
	measureAllocations("Inefficient (grow)", func() {
		_ = inefficientSlice()
	})
	measureAllocations("Efficient (preallocate)", func() {
		_ = efficientSlice()
	})

	// Pointer vs value
	fmt.Println("3. Return Type:")
	measureAllocations("Inefficient (pointer)", func() {
		for i := 0; i < 10000; i++ {
			_ = inefficientPointer()
		}
	})
	measureAllocations("Efficient (value)", func() {
		for i := 0; i < 10000; i++ {
			_ = efficientValue()
		}
	})

	fmt.Println("Optimization Tips:")
	fmt.Println("  ✓ Preallocate slices with make([]T, 0, capacity)")
	fmt.Println("  ✓ Use strings.Builder for string concatenation")
	fmt.Println("  ✓ Return values instead of pointers when possible")
	fmt.Println("  ✓ Reuse objects with sync.Pool")
	fmt.Println("  ✓ Profile with pprof to find hotspots")
}
