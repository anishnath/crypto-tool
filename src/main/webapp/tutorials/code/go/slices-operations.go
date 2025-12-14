package main

import "fmt"

func main() {
	// Slicing operations
	numbers := []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
	
	fmt.Println("Full:", numbers)
	fmt.Println("First 5:", numbers[:5])
	fmt.Println("Last 5:", numbers[5:])
	fmt.Println("Middle:", numbers[3:7])
	
	// Copy slice
	source := []int{1, 2, 3}
	dest := make([]int, len(source))
	n := copy(dest, source)
	fmt.Printf("Copied %d elements: %v\n", n, dest)
	
	// Modifying slice affects original
	original := []int{10, 20, 30, 40, 50}
	slice := original[1:4]
	slice[0] = 999
	fmt.Println("Original after modification:", original)
	
	// 2D slice
	matrix := [][]int{
		{1, 2, 3},
		{4, 5, 6},
		{7, 8, 9},
	}
	fmt.Println("Matrix:", matrix)
}
