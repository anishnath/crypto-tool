package main

import "fmt"

type Point struct {
	X, Y int
}

func main() {
	p := Point{10, 20}
	
	// Pointer to struct
	ptr := &p
	
	// Automatic dereferencing
	fmt.Println("X:", ptr.X)  // Same as (*ptr).X
	
	// Modify through pointer
	ptr.X = 100
	fmt.Println("Modified point:", p)
	
	// new() function
	p2 := new(Point)
	p2.X = 5
	p2.Y = 10
	fmt.Println("Point created with new:", *p2)
}
