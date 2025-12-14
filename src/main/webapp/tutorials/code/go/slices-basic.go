package main

import "fmt"

func main() {
	// Slice from array
	primes := [6]int{2, 3, 5, 7, 11, 13}
	var s []int = primes[1:4]
	fmt.Println("Slice:", s)
	
	// Slice literal
	numbers := []int{10, 20, 30, 40, 50}
	fmt.Println("Numbers:", numbers)
	
	// Create slice with make
	zeros := make([]int, 5)
	fmt.Println("Zeros:", zeros)
	
	// Slice with capacity
	s2 := make([]int, 3, 5)
	fmt.Printf("Len: %d, Cap: %d, Slice: %v\n", len(s2), cap(s2), s2)
	
	// Nil slice
	var nilSlice []int
	fmt.Println("Nil slice:", nilSlice, len(nilSlice), cap(nilSlice))
	if nilSlice == nil {
		fmt.Println("Slice is nil")
	}
}
