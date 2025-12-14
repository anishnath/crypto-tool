package main

import "fmt"

func main() {
	// Array declaration
	var numbers [5]int
	numbers[0] = 10
	numbers[1] = 20
	numbers[2] = 30
	
	fmt.Println("Array:", numbers)
	fmt.Println("Length:", len(numbers))
	
	// Array literal
	primes := [5]int{2, 3, 5, 7, 11}
	fmt.Println("Primes:", primes)
	
	// Compiler infers length
	colors := [...]string{"red", "green", "blue"}
	fmt.Println("Colors:", colors)
	
	// Iterate over array
	for i, color := range colors {
		fmt.Printf("Index %d: %s\n", i, color)
	}
}
