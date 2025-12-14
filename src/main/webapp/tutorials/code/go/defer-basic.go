package main

import "fmt"

func main() {
	// defer executes after surrounding function returns
	defer fmt.Println("World")
	fmt.Println("Hello")
	
	// Multiple defers execute in LIFO order
	fmt.Println("\nCounting:")
	for i := 1; i <= 3; i++ {
		defer fmt.Println(i)
	}
	fmt.Println("Done")
	
	// Output:
	// Hello
	// World
	// Counting:
	// Done
	// 3
	// 2
	// 1
}
