package main

/*
#include <stdlib.h>
#include <string.h>

// String manipulation in C
char* concat_strings(const char* a, const char* b) {
    size_t len = strlen(a) + strlen(b) + 1;
    char* result = (char*)malloc(len);
    strcpy(result, a);
    strcat(result, b);
    return result;
}

// String length in C
int string_length(const char* s) {
    return strlen(s);
}

// Convert to uppercase
void to_upper(char* s) {
    for (int i = 0; s[i]; i++) {
        if (s[i] >= 'a' && s[i] <= 'z') {
            s[i] = s[i] - 32;
        }
    }
}
*/
import "C"
import (
	"fmt"
	"unsafe"
)

func main() {
	fmt.Println("CGO String Handling")
	fmt.Println("===================\n")

	// Go string to C string
	fmt.Println("1. Go → C string conversion:")
	goStr := "Hello, CGO!"
	cStr := C.CString(goStr)
	fmt.Printf("   Go string: %s\n", goStr)
	fmt.Printf("   C string created\n")

	// Get length using C function
	length := C.string_length(cStr)
	fmt.Printf("   Length (from C): %d\n\n", length)

	// Free the C string
	C.free(unsafe.Pointer(cStr))

	// Concatenate strings in C
	fmt.Println("2. String concatenation in C:")
	str1 := C.CString("Hello, ")
	str2 := C.CString("World!")

	result := C.concat_strings(str1, str2)
	goResult := C.GoString(result)
	fmt.Printf("   \"%s\" + \"%s\" = \"%s\"\n\n",
		C.GoString(str1), C.GoString(str2), goResult)

	// Free all C memory
	C.free(unsafe.Pointer(str1))
	C.free(unsafe.Pointer(str2))
	C.free(unsafe.Pointer(result))

	// Modify string in place
	fmt.Println("3. In-place string modification:")
	original := "hello world"
	cOriginal := C.CString(original)
	fmt.Printf("   Before: %s\n", C.GoString(cOriginal))

	C.to_upper(cOriginal)
	fmt.Printf("   After:  %s\n\n", C.GoString(cOriginal))

	C.free(unsafe.Pointer(cOriginal))

	// Working with byte slices
	fmt.Println("4. Go []byte to C:")
	goBytes := []byte("Binary data")
	cBytes := C.CBytes(goBytes)
	fmt.Printf("   Go []byte: %v\n", goBytes)
	fmt.Printf("   Converted to C bytes\n")
	C.free(cBytes)
	fmt.Println()

	fmt.Println("String Handling Rules:")
	fmt.Println("  ✓ Use C.CString() to convert Go string → C char*")
	fmt.Println("  ✓ Use C.GoString() to convert C char* → Go string")
	fmt.Println("  ✓ Use C.CBytes() for []byte → C")
	fmt.Println("  ✓ Always C.free() C-allocated memory")
	fmt.Println("  ✓ C strings are null-terminated")
	fmt.Println("  ✓ Go strings are immutable, C strings are not")
}
