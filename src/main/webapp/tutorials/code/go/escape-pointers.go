package main

import "fmt"

// Pointer return causes escape
func returnPointer() *int {
	x := 42
	return &x // x escapes: pointer returned
}

// Pointer parameter - value may escape
func storePointer(ptr **int) {
	x := 100
	*ptr = &x // x escapes: stored in pointer parameter
}

// Pointer to local - no escape
func localPointer() {
	x := 42
	ptr := &x // ptr points to local, doesn't escape
	fmt.Println(*ptr)
}

// Multiple return - both escape
func multipleReturn() (*int, *string) {
	x := 42
	s := "hello"
	return &x, &s // Both escape
}

// Pointer in struct - escapes
type Container struct {
	Value *int
}

func structWithPointer() Container {
	x := 42
	return Container{Value: &x} // x escapes: stored in struct
}

// Pointer slice - elements escape
func pointerSlice() []*int {
	a, b, c := 1, 2, 3
	return []*int{&a, &b, &c} // All escape
}

func main() {
	fmt.Println("Escape Analysis - Pointers")
	fmt.Println("==========================\n")

	fmt.Println("1. Return pointer:")
	ptr1 := returnPointer()
	fmt.Printf("   Value: %d (escaped to heap)\n\n", *ptr1)

	fmt.Println("2. Store in pointer parameter:")
	var ptr2 *int
	storePointer(&ptr2)
	fmt.Printf("   Value: %d (escaped to heap)\n\n", *ptr2)

	fmt.Println("3. Local pointer (no escape):")
	localPointer()
	fmt.Println()

	fmt.Println("4. Multiple return:")
	ptrInt, ptrStr := multipleReturn()
	fmt.Printf("   Int: %d, String: %s (both escaped)\n\n", *ptrInt, *ptrStr)

	fmt.Println("5. Pointer in struct:")
	container := structWithPointer()
	fmt.Printf("   Container value: %d (escaped)\n\n", *container.Value)

	fmt.Println("6. Pointer slice:")
	ptrs := pointerSlice()
	fmt.Printf("   Slice: [%d, %d, %d] (all escaped)\n\n", *ptrs[0], *ptrs[1], *ptrs[2])

	fmt.Println("Escape analysis command:")
	fmt.Println("  go build -gcflags='-m -m' escape-pointers.go")
	fmt.Println("\nThe -m -m flag shows detailed escape analysis")
}
