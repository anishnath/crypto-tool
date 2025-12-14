package main

import "fmt"

func main() {
	// Type conversion is explicit in Go
	var x int = 42
	var y float64 = float64(x)
	var z uint = uint(x)
	
	fmt.Printf("int: %d, float64: %f, uint: %d\n", x, y, z)
	
	// Converting between int and string
	var num int = 65
	var char string = string(rune(num))  // Converts to 'A'
	
	fmt.Printf("Number %d as character: %s\n", num, char)
	
	// Precision loss warning
	var pi float64 = 3.14159
	var approxPi int = int(pi)  // Truncates to 3
	
	fmt.Printf("Original: %f, Truncated: %d\n", pi, approxPi)
}
