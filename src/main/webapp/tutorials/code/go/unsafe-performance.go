package main

import (
	"fmt"
	"time"
	"unsafe"
)

// StringHeader represents string internal structure
type StringHeader struct {
	Data uintptr
	Len  int
}

// SliceHeader represents slice internal structure
type SliceHeader struct {
	Data uintptr
	Len  int
	Cap  int
}

// Safe string to bytes conversion (copies)
func safeStringToBytes(s string) []byte {
	return []byte(s)
}

// Unsafe string to bytes conversion (zero-copy)
func unsafeStringToBytes(s string) []byte {
	strHeader := (*StringHeader)(unsafe.Pointer(&s))
	sliceHeader := SliceHeader{
		Data: strHeader.Data,
		Len:  strHeader.Len,
		Cap:  strHeader.Len,
	}
	return *(*[]byte)(unsafe.Pointer(&sliceHeader))
}

// Safe bytes to string conversion (copies)
func safeBytesToString(b []byte) string {
	return string(b)
}

// Unsafe bytes to string conversion (zero-copy)
func unsafeBytesToString(b []byte) string {
	sliceHeader := (*SliceHeader)(unsafe.Pointer(&b))
	strHeader := StringHeader{
		Data: sliceHeader.Data,
		Len:  sliceHeader.Len,
	}
	return *(*string)(unsafe.Pointer(&strHeader))
}

func main() {
	fmt.Println("Unsafe Performance Comparisons")
	fmt.Println("===============================\n")

	// Benchmark 1: String to bytes conversion
	fmt.Println("1. String to []byte conversion:")
	testStr := "Hello, World! This is a test string for performance comparison."
	iterations := 10000000

	// Safe version
	start := time.Now()
	for i := 0; i < iterations; i++ {
		_ = safeStringToBytes(testStr)
	}
	safeDuration := time.Since(start)

	// Unsafe version
	start = time.Now()
	for i := 0; i < iterations; i++ {
		_ = unsafeStringToBytes(testStr)
	}
	unsafeDuration := time.Since(start)

	fmt.Printf("   Safe:   %v\n", safeDuration)
	fmt.Printf("   Unsafe: %v\n", unsafeDuration)
	fmt.Printf("   Speedup: %.2fx\n\n", float64(safeDuration)/float64(unsafeDuration))

	// Benchmark 2: Bytes to string conversion
	fmt.Println("2. []byte to string conversion:")
	testBytes := []byte("Hello, World! This is a test string for performance comparison.")

	// Safe version
	start = time.Now()
	for i := 0; i < iterations; i++ {
		_ = safeBytesToString(testBytes)
	}
	safeDuration = time.Since(start)

	// Unsafe version
	start = time.Now()
	for i := 0; i < iterations; i++ {
		_ = unsafeBytesToString(testBytes)
	}
	unsafeDuration = time.Since(start)

	fmt.Printf("   Safe:   %v\n", safeDuration)
	fmt.Printf("   Unsafe: %v\n", unsafeDuration)
	fmt.Printf("   Speedup: %.2fx\n\n", float64(safeDuration)/float64(unsafeDuration))

	// Benchmark 3: Struct field access
	fmt.Println("3. Struct field access:")

	type Data struct {
		A int
		B int
		C int
		D int
	}

	data := Data{1, 2, 3, 4}
	sum := 0

	// Normal access
	start = time.Now()
	for i := 0; i < iterations; i++ {
		sum = data.A + data.B + data.C + data.D
	}
	normalDuration := time.Since(start)

	// Unsafe access
	start = time.Now()
	basePtr := unsafe.Pointer(&data)
	for i := 0; i < iterations; i++ {
		sum = *(*int)(basePtr) +
			*(*int)(unsafe.Pointer(uintptr(basePtr) + unsafe.Sizeof(data.A))) +
			*(*int)(unsafe.Pointer(uintptr(basePtr) + 2*unsafe.Sizeof(data.A))) +
			*(*int)(unsafe.Pointer(uintptr(basePtr) + 3*unsafe.Sizeof(data.A)))
	}
	unsafeDuration = time.Since(start)

	fmt.Printf("   Normal: %v (sum=%d)\n", normalDuration, sum)
	fmt.Printf("   Unsafe: %v (sum=%d)\n", unsafeDuration, sum)
	fmt.Printf("   Difference: %.2fx\n\n", float64(normalDuration)/float64(unsafeDuration))

	// Memory usage comparison
	fmt.Println("4. Memory usage:")

	type LargeStruct struct {
		Data [1000]byte
	}

	// Safe copy
	original := LargeStruct{}
	copy := original

	// Unsafe pointer (no copy)
	ptr := &original

	fmt.Printf("   Original size: %d bytes\n", unsafe.Sizeof(original))
	fmt.Printf("   Copy size:     %d bytes (duplicated)\n", unsafe.Sizeof(copy))
	fmt.Printf("   Pointer size:  %d bytes (no duplication)\n", unsafe.Sizeof(ptr))
	fmt.Printf("   Memory saved:  %d bytes\n\n", unsafe.Sizeof(copy)-unsafe.Sizeof(ptr))

	fmt.Println("Performance Guidelines:")
	fmt.Println("  ✓ Unsafe is faster but dangerous")
	fmt.Println("  ✓ Use for hot paths only")
	fmt.Println("  ✓ Profile before optimizing")
	fmt.Println("  ✓ Measure actual gains")
	fmt.Println("  ✓ Consider maintainability cost")
	fmt.Println("  ✓ Document unsafe code clearly")

	fmt.Println("\nWhen to use unsafe:")
	fmt.Println("  • Zero-copy string/byte conversions")
	fmt.Println("  • Low-level system programming")
	fmt.Println("  • Performance-critical code")
	fmt.Println("  • Interop with C libraries")

	fmt.Println("\nWhen NOT to use unsafe:")
	fmt.Println("  • Regular application code")
	fmt.Println("  • When safe alternatives exist")
	fmt.Println("  • Without thorough testing")
	fmt.Println("  • In public APIs")
}
