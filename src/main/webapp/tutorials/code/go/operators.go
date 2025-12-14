package main

import "fmt"

func main() {
	// Arithmetic operators
	a, b := 10, 3
	fmt.Println("Addition:", a+b)
	fmt.Println("Subtraction:", a-b)
	fmt.Println("Multiplication:", a*b)
	fmt.Println("Division:", a/b)
	fmt.Println("Modulus:", a%b)
	
	// Comparison operators
	fmt.Println("\nComparison:")
	fmt.Println("a == b:", a == b)
	fmt.Println("a != b:", a != b)
	fmt.Println("a > b:", a > b)
	fmt.Println("a < b:", a < b)
	
	// Logical operators
	x, y := true, false
	fmt.Println("\nLogical:")
	fmt.Println("x && y:", x && y)
	fmt.Println("x || y:", x || y)
	fmt.Println("!x:", !x)
	
	// Bitwise operators
	fmt.Println("\nBitwise:")
	fmt.Printf("5 & 3 = %d\n", 5&3)   // AND
	fmt.Printf("5 | 3 = %d\n", 5|3)   // OR
	fmt.Printf("5 ^ 3 = %d\n", 5^3)   // XOR
	fmt.Printf("5 << 1 = %d\n", 5<<1) // Left shift
	fmt.Printf("5 >> 1 = %d\n", 5>>1) // Right shift
}
