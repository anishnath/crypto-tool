package main

import "fmt"

func modifyValue(x int) {
	x = 100
}

func modifyPointer(x *int) {
	*x = 100
}

func main() {
	num := 42
	
	fmt.Println("Original:", num)
	
	modifyValue(num)
	fmt.Println("After modifyValue:", num)  // Still 42
	
	modifyPointer(&num)
	fmt.Println("After modifyPointer:", num)  // Now 100
	
	// Slices and maps are reference types
	slice := []int{1, 2, 3}
	modifySlice(slice)
	fmt.Println("Slice after modification:", slice)
}

func modifySlice(s []int) {
	s[0] = 999  // Modifies original
}
