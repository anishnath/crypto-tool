package main

import "fmt"

func main() {
	// Short variable declaration with :=
	name := "Gopher"
	age := 13
	height := 1.75
	
	fmt.Printf("%s is %d years old and %.2fm tall\n", name, age, height)
	
	// Multiple declarations
	x, y, z := 1, 2, 3
	fmt.Println("Coordinates:", x, y, z)
	
	// Type inference
	message := "Go infers types!"
	count := 42
	pi := 3.14159
	
	fmt.Printf("message is %T\n", message)
	fmt.Printf("count is %T\n", count)
	fmt.Printf("pi is %T\n", pi)
}
