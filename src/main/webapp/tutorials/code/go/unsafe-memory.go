package main

import (
	"fmt"
	"unsafe"
)

func main() {
	fmt.Println("Unsafe Memory Operations")
	fmt.Println("=========================\n")

	// Example 1: Memory size and alignment
	fmt.Println("1. Size and alignment:")

	var b bool
	var i8 int8
	var i16 int16
	var i32 int32
	var i64 int64
	var f32 float32
	var f64 float64
	var ptr *int

	fmt.Printf("   bool:    size=%d align=%d\n", unsafe.Sizeof(b), unsafe.Alignof(b))
	fmt.Printf("   int8:    size=%d align=%d\n", unsafe.Sizeof(i8), unsafe.Alignof(i8))
	fmt.Printf("   int16:   size=%d align=%d\n", unsafe.Sizeof(i16), unsafe.Alignof(i16))
	fmt.Printf("   int32:   size=%d align=%d\n", unsafe.Sizeof(i32), unsafe.Alignof(i32))
	fmt.Printf("   int64:   size=%d align=%d\n", unsafe.Sizeof(i64), unsafe.Alignof(i64))
	fmt.Printf("   float32: size=%d align=%d\n", unsafe.Sizeof(f32), unsafe.Alignof(f32))
	fmt.Printf("   float64: size=%d align=%d\n", unsafe.Sizeof(f64), unsafe.Alignof(f64))
	fmt.Printf("   pointer: size=%d align=%d\n\n", unsafe.Sizeof(ptr), unsafe.Alignof(ptr))

	// Example 2: Struct layout and padding
	fmt.Println("2. Struct layout and padding:")

	type BadLayout struct {
		a bool  // 1 byte
		b int64 // 8 bytes (7 bytes padding before)
		c bool  // 1 byte (7 bytes padding after)
	}

	type GoodLayout struct {
		b int64 // 8 bytes
		a bool  // 1 byte
		c bool  // 1 byte (6 bytes padding after)
	}

	bad := BadLayout{}
	good := GoodLayout{}

	fmt.Printf("   BadLayout:  size=%d\n", unsafe.Sizeof(bad))
	fmt.Printf("   GoodLayout: size=%d\n", unsafe.Sizeof(good))
	fmt.Printf("   Savings: %d bytes\n\n", unsafe.Sizeof(bad)-unsafe.Sizeof(good))

	// Example 3: Direct memory manipulation
	fmt.Println("3. Direct memory write:")

	var x int64 = 0
	fmt.Printf("   Before: %d\n", x)

	// Write directly to memory
	ptr := unsafe.Pointer(&x)
	*(*int64)(ptr) = 42
	fmt.Printf("   After:  %d\n\n", x)

	// Example 4: Array to slice conversion
	fmt.Println("4. Array to slice (zero-copy):")

	arr := [5]int{1, 2, 3, 4, 5}
	fmt.Printf("   Array: %v\n", arr)

	// Normal conversion (copies)
	normalSlice := arr[:]
	fmt.Printf("   Normal slice: %v\n", normalSlice)

	// Unsafe conversion (no copy, shares memory)
	type SliceHeader struct {
		Data uintptr
		Len  int
		Cap  int
	}

	sliceHeader := SliceHeader{
		Data: uintptr(unsafe.Pointer(&arr[0])),
		Len:  len(arr),
		Cap:  len(arr),
	}
	unsafeSlice := *(*[]int)(unsafe.Pointer(&sliceHeader))
	fmt.Printf("   Unsafe slice: %v\n", unsafeSlice)

	// Modify through unsafe slice
	unsafeSlice[0] = 99
	fmt.Printf("   Array after modify: %v\n\n", arr)

	// Example 5: Memory clearing
	fmt.Println("5. Fast memory clearing:")

	data := make([]byte, 1000)
	for i := range data {
		data[i] = byte(i % 256)
	}
	fmt.Printf("   First 10 bytes before: %v\n", data[:10])

	// Clear using unsafe (faster for large slices)
	if len(data) > 0 {
		ptr := unsafe.Pointer(&data[0])
		for i := 0; i < len(data); i++ {
			*(*byte)(unsafe.Pointer(uintptr(ptr) + uintptr(i))) = 0
		}
	}
	fmt.Printf("   First 10 bytes after:  %v\n\n", data[:10])

	fmt.Println("Memory Safety Rules:")
	fmt.Println("  ⚠️  Pointer arithmetic is dangerous")
	fmt.Println("  ⚠️  Respect alignment requirements")
	fmt.Println("  ⚠️  Don't create invalid pointers")
	fmt.Println("  ⚠️  GC doesn't track unsafe pointers")
	fmt.Println("  ⚠️  Can cause data races")
	fmt.Println("  ⚠️  Platform-dependent behavior")
}
