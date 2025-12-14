package main

import "fmt"

func main() {
	numbers := []int{10, 20, 30, 40, 50}
	
	// Range with index and value
	for i, num := range numbers {
		fmt.Printf("Index %d: %d\n", i, num)
	}
	
	// Range with only value
	fmt.Println("\nValues only:")
	for _, num := range numbers {
		fmt.Println(num)
	}
	
	// Range with only index
	fmt.Println("\nIndices only:")
	for i := range numbers {
		fmt.Println("Index:", i)
	}
	
	// Range over string (runes)
	message := "Go!"
	for i, char := range message {
		fmt.Printf("Position %d: %c\n", i, char)
	}
}
