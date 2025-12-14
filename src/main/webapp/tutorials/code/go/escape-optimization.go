package main

import "fmt"

// ❌ Unnecessary escape - returning pointer
func badReturnPointer() *int {
	x := 42
	return &x // x escapes unnecessarily
}

// ✅ Better - return by value
func goodReturnValue() int {
	x := 42
	return x // Stays on stack
}

// ❌ Unnecessary interface conversion
func badInterface(x int) {
	var i interface{} = x // x escapes
	fmt.Println(i)
}

// ✅ Better - use concrete type
func goodConcrete(x int) {
	fmt.Println(x) // No escape
}

// ❌ Large struct by value
type LargeStruct struct {
	data [10000]int
}

func badLargeValue() LargeStruct {
	s := LargeStruct{}
	return s // Large copy, slow
}

// ✅ Better - return pointer for large structs
func goodLargePointer() *LargeStruct {
	s := &LargeStruct{} // Allocated on heap anyway
	return s
}

// ❌ Slice grows dynamically
func badDynamicSlice() []int {
	var nums []int
	for i := 0; i < 1000; i++ {
		nums = append(nums, i) // Multiple reallocations
	}
	return nums
}

// ✅ Better - preallocate
func goodPreallocate() []int {
	nums := make([]int, 0, 1000) // Preallocated
	for i := 0; i < 1000; i++ {
		nums = append(nums, i) // No reallocation
	}
	return nums
}

// ❌ Closure in hot path
func badClosureLoop() {
	for i := 0; i < 1000; i++ {
		fn := func() int {
			return i * 2 // i escapes
		}
		_ = fn()
	}
}

// ✅ Better - avoid closure
func goodDirectCall() {
	for i := 0; i < 1000; i++ {
		_ = i * 2 // No escape
	}
}

// Optimization: use pointer receiver for large structs
type BigData struct {
	values [1000]int
}

// ❌ Value receiver - copies entire struct
func (b BigData) ProcessValue() {
	// Entire struct copied
}

// ✅ Pointer receiver - no copy
func (b *BigData) ProcessPointer() {
	// Only pointer copied
}

func main() {
	fmt.Println("Escape Analysis - Optimization")
	fmt.Println("===============================\n")

	fmt.Println("1. Return value vs pointer:")
	fmt.Println("   ❌ Pointer: causes escape")
	ptr := badReturnPointer()
	fmt.Printf("   Value: %d\n", *ptr)

	fmt.Println("   ✅ Value: stays on stack")
	val := goodReturnValue()
	fmt.Printf("   Value: %d\n\n", val)

	fmt.Println("2. Interface vs concrete:")
	fmt.Println("   ❌ Interface: causes escape")
	badInterface(42)

	fmt.Println("   ✅ Concrete: no escape")
	goodConcrete(42)
	fmt.Println()

	fmt.Println("3. Large struct handling:")
	fmt.Println("   ❌ By value: large copy")
	_ = badLargeValue()

	fmt.Println("   ✅ By pointer: efficient")
	_ = goodLargePointer()
	fmt.Println()

	fmt.Println("4. Slice allocation:")
	fmt.Println("   ❌ Dynamic: multiple allocations")
	_ = badDynamicSlice()

	fmt.Println("   ✅ Preallocate: single allocation")
	_ = goodPreallocate()
	fmt.Println()

	fmt.Println("5. Closure in loop:")
	fmt.Println("   ❌ Closure: variable escapes")
	badClosureLoop()

	fmt.Println("   ✅ Direct: no escape")
	goodDirectCall()
	fmt.Println()

	fmt.Println("Optimization tips:")
	fmt.Println("  ✓ Return values for small types")
	fmt.Println("  ✓ Return pointers for large types")
	fmt.Println("  ✓ Avoid unnecessary interface{}")
	fmt.Println("  ✓ Preallocate slices when size known")
	fmt.Println("  ✓ Use pointer receivers for large structs")
	fmt.Println("  ✓ Minimize closures in hot paths")

	fmt.Println("\nAnalyze with:")
	fmt.Println("  go build -gcflags='-m -m' escape-optimization.go")
}
