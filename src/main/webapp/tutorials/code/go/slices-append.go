package main

import "fmt"

func main() {
	var s []int
	fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
	
	// Append to slice
	s = append(s, 1)
	fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
	
	s = append(s, 2, 3, 4)
	fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
	
	// Append another slice
	s2 := []int{5, 6, 7}
	s = append(s, s2...)
	fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
	
	// Capacity grows automatically
	fmt.Println("\nCapacity growth:")
	nums := make([]int, 0, 1)
	for i := 0; i < 10; i++ {
		nums = append(nums, i)
		fmt.Printf("len=%d cap=%d\n", len(nums), cap(nums))
	}
}
