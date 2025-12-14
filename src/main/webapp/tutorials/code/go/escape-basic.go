package main

import "fmt"

// Example 1: Value stays on stack
func stackValue() int {
	x := 42
	return x // Returned by value, stays on stack
}

// Example 2: Pointer escapes to heap
func heapPointer() *int {
	x := 42
	return &x // Pointer returned, x escapes to heap
}

// Example 3: Small struct on stack
type Point struct {
	X, Y int
}

func stackStruct() Point {
	p := Point{X: 10, Y: 20}
	return p // Returned by value, stays on stack
}

// Example 4: Pointer to struct escapes
func heapStruct() *Point {
	p := Point{X: 10, Y: 20}
	return &p // Pointer returned, p escapes to heap
}

// Example 5: Slice with known size (stack)
func stackSlice() {
	s := make([]int, 10) // Small, fixed size
	s[0] = 1
	// s is deallocated when function returns
}

// Example 6: Slice with unknown size (heap)
func heapSlice(n int) []int {
	s := make([]int, n) // Size unknown at compile time
	return s            // Escapes to heap
}

func main() {
	fmt.Println("Escape Analysis - Basic Examples")
	fmt.Println("=================================\n")

	fmt.Println("1. Stack value (no escape):")
	val := stackValue()
	fmt.Printf("   Value: %d\n\n", val)

	fmt.Println("2. Heap pointer (escapes):")
	ptr := heapPointer()
	fmt.Printf("   Pointer: %p, Value: %d\n\n", ptr, *ptr)

	fmt.Println("3. Stack struct (no escape):")
	point := stackStruct()
	fmt.Printf("   Point: %+v\n\n", point)

	fmt.Println("4. Heap struct pointer (escapes):")
	pointPtr := heapStruct()
	fmt.Printf("   Point: %+v\n\n", *pointPtr)

	fmt.Println("5. Stack slice (fixed size):")
	stackSlice()
	fmt.Println("   Slice allocated and freed on stack\n")

	fmt.Println("6. Heap slice (dynamic size):")
	dynSlice := heapSlice(100)
	fmt.Printf("   Slice length: %d (on heap)\n\n", len(dynSlice))

	fmt.Println("To see escape analysis:")
	fmt.Println("  go build -gcflags='-m' escape-basic.go")
	fmt.Println("\nLook for:")
	fmt.Println("  'moved to heap: x'")
	fmt.Println("  'x escapes to heap'")
	fmt.Println("  'x does not escape'")
}
