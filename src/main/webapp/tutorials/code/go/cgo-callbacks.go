package main

/*
#include <stdio.h>

// C callback type
typedef void (*callback_func)(int);

// C function that accepts a callback
void process_numbers(int* numbers, int count, callback_func callback) {
    for (int i = 0; i < count; i++) {
        callback(numbers[i]);
    }
}

// C function that calls a callback multiple times
void repeat_callback(callback_func callback, int times) {
    for (int i = 0; i < times; i++) {
        callback(i);
    }
}
*/
import "C"
import (
	"fmt"
	"unsafe"
)

// Go callback function
//
//export goCallback
func goCallback(n C.int) {
	fmt.Printf("  Go callback received: %d\n", n)
}

// Another Go callback
//
//export printSquare
func printSquare(n C.int) {
	square := int(n) * int(n)
	fmt.Printf("  Square of %d = %d\n", n, square)
}

func main() {
	fmt.Println("CGO Callbacks")
	fmt.Println("=============\n")

	// Example 1: Process array with callback
	fmt.Println("1. Processing array with Go callback:")
	numbers := []C.int{1, 2, 3, 4, 5}
	C.process_numbers(
		(*C.int)(unsafe.Pointer(&numbers[0])),
		C.int(len(numbers)),
		(C.callback_func)(unsafe.Pointer(C.goCallback)),
	)
	fmt.Println()

	// Example 2: Repeat callback
	fmt.Println("2. Repeating callback 3 times:")
	C.repeat_callback(
		(C.callback_func)(unsafe.Pointer(C.printSquare)),
		3,
	)
	fmt.Println()

	fmt.Println("Callback Rules:")
	fmt.Println("  • Use //export directive for Go functions")
	fmt.Println("  • Go callbacks must use C types")
	fmt.Println("  • Cast function pointer with unsafe.Pointer")
	fmt.Println("  • Callbacks run on C stack")
	fmt.Println("  • Keep callbacks simple and fast")

	fmt.Println("\nLimitations:")
	fmt.Println("  ⚠ Cannot call Go functions that allocate")
	fmt.Println("  ⚠ Cannot use goroutines in callbacks")
	fmt.Println("  ⚠ Cannot panic in callbacks")
	fmt.Println("  ⚠ Must be careful with Go pointers")
}
