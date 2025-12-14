package main

import (
	"fmt"
	"unsafe"
)

func main() {
	fmt.Println("Unsafe Type Conversions")
	fmt.Println("=======================\n")

	// Example 1: Float to int conversion (reinterpret bits)
	fmt.Println("1. Float to int bit conversion:")
	f := float32(3.14)
	fmt.Printf("   Float32: %f\n", f)

	// Reinterpret float32 bits as uint32
	bits := *(*uint32)(unsafe.Pointer(&f))
	fmt.Printf("   As uint32 bits: 0x%08x\n", bits)
	fmt.Printf("   Binary: %032b\n\n", bits)

	// Example 2: String to byte slice (zero-copy)
	fmt.Println("2. String to []byte (zero-copy):")
	str := "Hello, unsafe!"

	// Normal conversion (copies)
	normalBytes := []byte(str)
	fmt.Printf("   Normal conversion: %v\n", normalBytes)

	// Unsafe conversion (no copy, dangerous!)
	type StringHeader struct {
		Data uintptr
		Len  int
	}
	type SliceHeader struct {
		Data uintptr
		Len  int
		Cap  int
	}

	strHeader := (*StringHeader)(unsafe.Pointer(&str))
	sliceHeader := SliceHeader{
		Data: strHeader.Data,
		Len:  strHeader.Len,
		Cap:  strHeader.Len,
	}
	unsafeBytes := *(*[]byte)(unsafe.Pointer(&sliceHeader))
	fmt.Printf("   Unsafe conversion: %v\n", unsafeBytes)
	fmt.Printf("   ⚠️  Warning: Don't modify this slice!\n\n")

	// Example 3: Byte slice to string (zero-copy)
	fmt.Println("3. []byte to string (zero-copy):")
	bytes := []byte("Unsafe string")

	// Normal conversion (copies)
	normalStr := string(bytes)
	fmt.Printf("   Normal: %s\n", normalStr)

	// Unsafe conversion (no copy)
	sliceHdr := (*SliceHeader)(unsafe.Pointer(&bytes))
	strHdr := StringHeader{
		Data: sliceHdr.Data,
		Len:  sliceHdr.Len,
	}
	unsafeStr := *(*string)(unsafe.Pointer(&strHdr))
	fmt.Printf("   Unsafe: %s\n", unsafeStr)
	fmt.Printf("   ⚠️  Warning: Slice must not be modified!\n\n")

	// Example 4: Interface to concrete type
	fmt.Println("4. Interface to concrete type:")
	var i interface{} = int64(42)

	// Type assertion (safe)
	if val, ok := i.(int64); ok {
		fmt.Printf("   Type assertion: %d\n", val)
	}

	// Unsafe conversion (bypasses type check)
	type iface struct {
		typ  uintptr
		data unsafe.Pointer
	}
	ifacePtr := (*iface)(unsafe.Pointer(&i))
	unsafeVal := *(*int64)(ifacePtr.data)
	fmt.Printf("   Unsafe conversion: %d\n", unsafeVal)
	fmt.Printf("   ⚠️  Warning: No type safety!\n\n")

	// Example 5: Struct field access by offset
	fmt.Println("5. Struct field access by offset:")
	type Person struct {
		Name string
		Age  int
		City string
	}

	p := Person{"Alice", 30, "NYC"}
	fmt.Printf("   Person: %+v\n", p)

	// Access Age field by offset
	ageOffset := unsafe.Offsetof(p.Age)
	agePtr := (*int)(unsafe.Pointer(uintptr(unsafe.Pointer(&p)) + ageOffset))
	fmt.Printf("   Age via offset: %d\n", *agePtr)

	// Modify via pointer
	*agePtr = 31
	fmt.Printf("   Modified: %+v\n\n", p)

	fmt.Println("Conversion Safety Rules:")
	fmt.Println("  ✓ Only convert when you know exact memory layout")
	fmt.Println("  ✓ Never modify string bytes")
	fmt.Println("  ✓ Be careful with slice/string zero-copy")
	fmt.Println("  ✓ Understand alignment requirements")
	fmt.Println("  ✓ Test thoroughly on target platforms")
}
