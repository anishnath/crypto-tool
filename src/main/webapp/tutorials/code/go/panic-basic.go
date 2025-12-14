package main

import "fmt"

func main() {
	fmt.Println("Starting...")
	
	// panic stops normal execution
	// panic("Something went wrong!")
	
	// More realistic example
	divide(10, 0)
	
	fmt.Println("This won't print")
}

func divide(a, b int) int {
	if b == 0 {
		panic("division by zero")
	}
	return a / b
}
