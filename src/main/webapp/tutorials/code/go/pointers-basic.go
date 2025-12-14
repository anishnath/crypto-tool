package main

import "fmt"

func main() {
	// Declare variable
	x := 42
	
	// Pointer to x
	p := &x
	
	fmt.Println("Value of x:", x)
	fmt.Println("Address of x:", p)
	fmt.Println("Value at address:", *p)
	
	// Modify through pointer
	*p = 100
	fmt.Println("New value of x:", x)
	
	// Zero value of pointer is nil
	var ptr *int
	fmt.Println("Nil pointer:", ptr)
	if ptr == nil {
		fmt.Println("Pointer is nil")
	}
}
