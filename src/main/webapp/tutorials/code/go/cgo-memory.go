package main

/*
#include <stdlib.h>
#include <string.h>

// Allocate memory in C
void* allocate_memory(size_t size) {
    return malloc(size);
}

// Free memory in C
void free_memory(void* ptr) {
    free(ptr);
}

// Create a C string
char* create_string(const char* content) {
    char* str = (char*)malloc(strlen(content) + 1);
    strcpy(str, content);
    return str;
}

// Create an integer array
int* create_int_array(int size) {
    return (int*)malloc(size * sizeof(int));
}

// Fill array with values
void fill_array(int* arr, int size) {
    for (int i = 0; i < size; i++) {
        arr[i] = i * 10;
    }
}
*/
import "C"
import (
	"fmt"
	"unsafe"
)

func main() {
	fmt.Println("CGO Memory Management")
	fmt.Println("=====================\n")

	// Example 1: Allocate and free C memory
	fmt.Println("1. Basic C memory allocation:")
	size := C.size_t(100)
	ptr := C.allocate_memory(size)
	fmt.Printf("   Allocated %d bytes at %p\n", size, ptr)
	C.free_memory(ptr)
	fmt.Println("   Memory freed\n")

	// Example 2: C string allocation
	fmt.Println("2. C string allocation:")
	cStr := C.create_string(C.CString("Hello from C"))
	goStr := C.GoString(cStr)
	fmt.Printf("   C string: %s\n", goStr)
	C.free(unsafe.Pointer(cStr))
	fmt.Println("   String freed\n")

	// Example 3: C array allocation
	fmt.Println("3. C array allocation:")
	arraySize := 5
	cArray := C.create_int_array(C.int(arraySize))
	C.fill_array(cArray, C.int(arraySize))

	// Convert C array to Go slice
	goSlice := (*[1 << 30]C.int)(unsafe.Pointer(cArray))[:arraySize:arraySize]
	fmt.Printf("   Array values: ")
	for i := 0; i < arraySize; i++ {
		fmt.Printf("%d ", goSlice[i])
	}
	fmt.Println()

	C.free(unsafe.Pointer(cArray))
	fmt.Println("   Array freed\n")

	// Example 4: Go memory passed to C
	fmt.Println("4. Passing Go memory to C:")
	goData := []byte("Go data")
	cData := C.CBytes(goData)
	fmt.Printf("   Copied %d bytes to C\n", len(goData))
	C.free(cData)
	fmt.Println("   C copy freed\n")

	fmt.Println("Memory Management Rules:")
	fmt.Println("  ✓ C.malloc() allocates C memory")
	fmt.Println("  ✓ C.free() frees C memory")
	fmt.Println("  ✓ C.CString() allocates (must free)")
	fmt.Println("  ✓ C.CBytes() allocates (must free)")
	fmt.Println("  ✓ C.GoString() copies (no free needed)")
	fmt.Println("  ✓ C.GoBytes() copies (no free needed)")

	fmt.Println("\nDanger Zone:")
	fmt.Println("  ⚠ Don't pass Go pointers to C that outlive the call")
	fmt.Println("  ⚠ Don't store Go pointers in C memory")
	fmt.Println("  ⚠ Always free C-allocated memory")
	fmt.Println("  ⚠ Memory leaks are easy with CGO")
}
