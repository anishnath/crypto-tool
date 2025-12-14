package main

/*
#include <stdint.h>

// C types
int c_int = 42;
float c_float = 3.14;
double c_double = 2.718;
char c_char = 'A';

// Type conversion functions
int64_t to_int64(int x) {
    return (int64_t)x;
}

double to_double(float x) {
    return (double)x;
}
*/
import "C"
import (
	"fmt"
	"unsafe"
)

func main() {
	fmt.Println("CGO Type Conversions")
	fmt.Println("====================\n")

	// Go to C conversions
	fmt.Println("1. Go → C conversions:")

	goInt := 100
	cInt := C.int(goInt)
	fmt.Printf("   Go int %d → C int %d\n", goInt, cInt)

	goFloat := 3.14159
	cFloat := C.float(goFloat)
	fmt.Printf("   Go float64 %.5f → C float %.5f\n", goFloat, cFloat)

	goString := "Hello"
	cString := C.CString(goString)
	fmt.Printf("   Go string \"%s\" → C string\n", goString)
	C.free(unsafe.Pointer(cString))
	fmt.Println()

	// C to Go conversions
	fmt.Println("2. C → Go conversions:")

	fmt.Printf("   C int %d → Go int %d\n", C.c_int, int(C.c_int))
	fmt.Printf("   C float %.2f → Go float32 %.2f\n", C.c_float, float32(C.c_float))
	fmt.Printf("   C double %.3f → Go float64 %.3f\n", C.c_double, float64(C.c_double))
	fmt.Printf("   C char '%c' → Go byte '%c'\n", C.c_char, byte(C.c_char))
	fmt.Println()

	// Using C functions for conversion
	fmt.Println("3. Using C conversion functions:")

	result64 := C.to_int64(42)
	fmt.Printf("   C to_int64(42) = %d (type: int64)\n", result64)

	resultDouble := C.to_double(3.14)
	fmt.Printf("   C to_double(3.14) = %.2f (type: double)\n", resultDouble)
	fmt.Println()

	fmt.Println("Type Mapping:")
	fmt.Println("  Go int     ↔ C int")
	fmt.Println("  Go int32   ↔ C int32_t")
	fmt.Println("  Go int64   ↔ C int64_t")
	fmt.Println("  Go float32 ↔ C float")
	fmt.Println("  Go float64 ↔ C double")
	fmt.Println("  Go string  ↔ C char* (via C.CString)")
	fmt.Println("  Go []byte  ↔ C char* (via C.CBytes)")
}
