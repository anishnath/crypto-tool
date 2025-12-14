package main

import "fmt"

func main() {
	// Traditional for loop
	for i := 0; i < 5; i++ {
		fmt.Println("Count:", i)
	}
	
	// For loop with only condition (like while)
	sum := 0
	n := 1
	for n <= 10 {
		sum += n
		n++
	}
	fmt.Println("Sum 1-10:", sum)
	
	// Infinite loop with break
	count := 0
	for {
		count++
		if count > 3 {
			break
		}
		fmt.Println("Iteration:", count)
	}
	
	// Continue statement
	for i := 0; i < 10; i++ {
		if i%2 == 0 {
			continue  // Skip even numbers
		}
		fmt.Println("Odd:", i)
	}
}
