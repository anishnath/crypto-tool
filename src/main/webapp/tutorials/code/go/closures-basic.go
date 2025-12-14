package main

import "fmt"

// Function that returns a function
func makeGreeter(greeting string) func(string) string {
	return func(name string) string {
		return greeting + ", " + name + "!"
	}
}

func main() {
	// Closures capture variables from outer scope
	englishGreeter := makeGreeter("Hello")
	spanishGreeter := makeGreeter("Hola")
	
	fmt.Println(englishGreeter("Alice"))
	fmt.Println(spanishGreeter("Bob"))
	
	// Anonymous function
	func() {
		fmt.Println("This is an anonymous function")
	}()
	
	// Closure capturing variable
	multiplier := 3
	multiply := func(x int) int {
		return x * multiplier
	}
	
	fmt.Println("5 * 3 =", multiply(5))
}
