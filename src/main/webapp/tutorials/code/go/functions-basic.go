package main

import "fmt"

// Function with no parameters and no return
func sayHello() {
	fmt.Println("Hello, Go!")
}

// Function with parameters
func greet(name string) {
	fmt.Printf("Hello, %s!\n", name)
}

// Function with return value
func add(a int, b int) int {
	return a + b
}

// Function with same type parameters (shorthand)
func multiply(a, b int) int {
	return a * b
}

func main() {
	sayHello()
	greet("Gopher")
	
	result := add(5, 3)
	fmt.Println("5 + 3 =", result)
	
	product := multiply(4, 7)
	fmt.Println("4 * 7 =", product)
}
