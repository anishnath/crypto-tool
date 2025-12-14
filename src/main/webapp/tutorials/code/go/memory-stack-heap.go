package main

import (
	"fmt"
	"runtime"
)

// Stack allocation - value stays on stack
func stackAllocation() int {
	x := 42 // Allocated on stack
	return x
}

// Heap allocation - value escapes to heap
func heapAllocation() *int {
	x := 42 // Escapes to heap (returned pointer)
	return &x
}

// Large struct on stack
type SmallStruct struct {
	a, b int
}

func smallOnStack() SmallStruct {
	s := SmallStruct{a: 1, b: 2}
	return s // Returned by value, stays on stack
}

// Large struct escapes to heap
type LargeStruct struct {
	data [1000]int
}

func largeOnHeap() *LargeStruct {
	s := &LargeStruct{} // Large allocation, goes to heap
	return s
}

func printMemStats() {
	var m runtime.MemStats
	runtime.ReadMemStats(&m)
	fmt.Printf("Alloc = %v MB", m.Alloc/1024/1024)
	fmt.Printf("\tTotalAlloc = %v MB", m.TotalAlloc/1024/1024)
	fmt.Printf("\tSys = %v MB", m.Sys/1024/1024)
	fmt.Printf("\tNumGC = %v\n", m.NumGC)
}

func main() {
	fmt.Println("Stack vs Heap Allocation Demo")
	fmt.Println("==============================\n")

	// Stack allocation
	fmt.Println("Stack allocation:")
	val := stackAllocation()
	fmt.Printf("Value: %d (on stack)\n\n", val)

	// Heap allocation
	fmt.Println("Heap allocation:")
	ptr := heapAllocation()
	fmt.Printf("Value: %d (on heap, pointer: %p)\n\n", *ptr, ptr)

	// Small struct on stack
	fmt.Println("Small struct (stack):")
	small := smallOnStack()
	fmt.Printf("Struct: %+v\n\n", small)

	// Large struct on heap
	fmt.Println("Large struct (heap):")
	large := largeOnHeap()
	fmt.Printf("Struct pointer: %p\n\n", large)

	// Memory stats
	fmt.Println("Memory Statistics:")
	printMemStats()
}
