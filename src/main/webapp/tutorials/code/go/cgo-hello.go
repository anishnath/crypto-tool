package main

/*
#include <stdio.h>
#include <stdlib.h>

void hello() {
    printf("Hello from C!\n");
}

int add(int a, int b) {
    return a + b;
}

char* greet(const char* name) {
    static char buffer[100];
    sprintf(buffer, "Hello, %s from C!", name);
    return buffer;
}
*/
import "C"
import (
	"fmt"
	"unsafe"
)

func main() {
	fmt.Println("CGO Hello World Demo")
	fmt.Println("====================\n")

	// Call C function with no parameters
	fmt.Println("1. Calling C hello():")
	C.hello()
	fmt.Println()

	// Call C function with parameters
	fmt.Println("2. Calling C add(10, 20):")
	result := C.add(10, 20)
	fmt.Printf("   Result: %d\n\n", result)

	// Call C function with string
	fmt.Println("3. Calling C greet(\"Gopher\"):")
	name := C.CString("Gopher")
	greeting := C.greet(name)
	fmt.Printf("   %s\n\n", C.GoString(greeting))

	// Important: Free C memory
	C.free(unsafe.Pointer(name))

	fmt.Println("CGO Basics:")
	fmt.Println("  • Use import \"C\" to access C code")
	fmt.Println("  • C code goes in comment block above import")
	fmt.Println("  • Prefix C functions with C.")
	fmt.Println("  • Convert between Go and C types")
	fmt.Println("  • Always free C memory!")
}
