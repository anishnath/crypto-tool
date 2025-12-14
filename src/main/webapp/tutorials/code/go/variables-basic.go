package main

import "fmt"

func main() {
	// Variable declaration with var keyword
	var name string = "Go"
	var version int = 1
	var isAwesome bool = true
	
	fmt.Println("Language:", name)
	fmt.Println("Version:", version)
	fmt.Println("Is Awesome:", isAwesome)
	
	// Zero values
	var count int        // 0
	var price float64    // 0.0
	var message string   // ""
	var active bool      // false
	
	fmt.Printf("\nZero values:\n")
	fmt.Printf("int: %d, float64: %f, string: '%s', bool: %t\n", 
		count, price, message, active)
}
