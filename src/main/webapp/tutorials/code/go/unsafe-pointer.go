package main

import (
	"fmt"
	"unsafe"
)

func main() {
	fmt.Println("Unsafe Package - Pointer Operations")
	fmt.Println("====================================\n")

	// Example 1: Basic pointer operations
	fmt.Println("1. Basic pointer operations:")
	x := 42
	ptr := unsafe.Pointer(&x)
	fmt.Printf("   Value: %d\n", x)
	fmt.Printf("   Pointer: %p\n", ptr)
	fmt.Printf("   Pointer size: %d bytes\n\n", unsafe.Sizeof(ptr))

	// Example 2: Converting between pointer types
	fmt.Println("2. Converting pointer types:")
	var f float64 = 3.14
	floatPtr := &f

	// Convert *float64 to unsafe.Pointer to *int64
	intPtr := (*int64)(unsafe.Pointer(floatPtr))
	fmt.Printf("   Float value: %f\n", *floatPtr)
	fmt.Printf("   As int64: %d (raw bits)\n\n", *intPtr)

	// Example 3: Pointer arithmetic (dangerous!)
	fmt.Println("3. Pointer arithmetic:")
	arr := [5]int{10, 20, 30, 40, 50}

	// Get pointer to first element
	firstPtr := unsafe.Pointer(&arr[0])
	fmt.Printf("   Array: %v\n", arr)
	fmt.Printf("   First element: %d\n", *(*int)(firstPtr))

	// Move pointer to second element (add size of int)
	secondPtr := unsafe.Pointer(uintptr(firstPtr) + unsafe.Sizeof(arr[0]))
	fmt.Printf("   Second element: %d\n", *(*int)(secondPtr))

	// Move to third element
	thirdPtr := unsafe.Pointer(uintptr(firstPtr) + 2*unsafe.Sizeof(arr[0]))
	fmt.Printf("   Third element: %d\n\n", *(*int)(thirdPtr))

	// Example 4: uintptr conversions
	fmt.Println("4. uintptr conversions:")
	y := 100
	yPtr := unsafe.Pointer(&y)

	// Convert to uintptr (integer representation)
	addr := uintptr(yPtr)
	fmt.Printf("   Address as uintptr: 0x%x\n", addr)

	// Convert back to pointer
	backPtr := unsafe.Pointer(addr)
	fmt.Printf("   Value via converted pointer: %d\n\n", *(*int)(backPtr))

	// Example 5: Pointer to slice element
	fmt.Println("5. Slice element pointer:")
	slice := []string{"Go", "is", "awesome"}

	// Get pointer to first element
	elemPtr := unsafe.Pointer(&slice[0])
	fmt.Printf("   Slice: %v\n", slice)
	fmt.Printf("   First element via pointer: %s\n\n", *(*string)(elemPtr))

	fmt.Println("⚠️  WARNING: Unsafe pointer operations:")
	fmt.Println("  • Bypass Go's type safety")
	fmt.Println("  • Can cause crashes if misused")
	fmt.Println("  • Not protected by garbage collector")
	fmt.Println("  • Use only when absolutely necessary")
	fmt.Println("  • Prefer safe alternatives when possible")
}
