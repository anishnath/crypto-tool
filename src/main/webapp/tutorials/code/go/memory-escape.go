package main

import "fmt"

// Stays on stack - returned by value
func noEscape() int {
	x := 42
	return x
}

// Escapes to heap - pointer returned
func escapesPointer() *int {
	x := 42
	return &x // x escapes to heap
}

// Escapes to heap - stored in interface
func escapesInterface() interface{} {
	x := 42
	return x // x escapes to heap
}

// Escapes to heap - captured by closure
func escapesClosure() func() int {
	x := 42
	return func() int {
		return x // x escapes to heap
	}
}

// Escapes to heap - too large for stack
func escapesSize() *[1000000]int {
	var arr [1000000]int
	return &arr // Too large, goes to heap
}

// Stays on stack - slice with known size
func noEscapeSlice() {
	s := make([]int, 10) // Small, stays on stack
	s[0] = 1
}

// Escapes to heap - slice size unknown at compile time
func escapesSlice(n int) []int {
	s := make([]int, n) // Size unknown, goes to heap
	return s
}

func main() {
	fmt.Println("Escape Analysis Examples")
	fmt.Println("========================\n")

	fmt.Println("1. No escape (stack):")
	val := noEscape()
	fmt.Printf("   Value: %d\n\n", val)

	fmt.Println("2. Escapes via pointer:")
	ptr := escapesPointer()
	fmt.Printf("   Pointer: %p, Value: %d\n\n", ptr, *ptr)

	fmt.Println("3. Escapes via interface:")
	iface := escapesInterface()
	fmt.Printf("   Interface: %v\n\n", iface)

	fmt.Println("4. Escapes via closure:")
	fn := escapesClosure()
	fmt.Printf("   Closure result: %d\n\n", fn())

	fmt.Println("5. Escapes due to size:")
	large := escapesSize()
	fmt.Printf("   Large array pointer: %p\n\n", large)

	fmt.Println("6. No escape (small slice):")
	noEscapeSlice()
	fmt.Println("   Small slice on stack\n")

	fmt.Println("7. Escapes (dynamic slice):")
	dynSlice := escapesSlice(100)
	fmt.Printf("   Dynamic slice: %v...\n\n", dynSlice[:3])

	fmt.Println("To see escape analysis:")
	fmt.Println("  go build -gcflags='-m' memory-escape.go")
	fmt.Println("\nLook for messages like:")
	fmt.Println("  'moved to heap: x'")
	fmt.Println("  'x escapes to heap'")
}
