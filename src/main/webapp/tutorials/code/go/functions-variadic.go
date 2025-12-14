package main

import "fmt"

// Variadic function (accepts variable number of arguments)
func sum(numbers ...int) int {
	total := 0
	for _, num := range numbers {
		total += num
	}
	return total
}

func printAll(prefix string, values ...interface{}) {
	fmt.Print(prefix, ": ")
	for _, v := range values {
		fmt.Print(v, " ")
	}
	fmt.Println()
}

func main() {
	fmt.Println("Sum:", sum(1, 2, 3))
	fmt.Println("Sum:", sum(10, 20, 30, 40, 50))
	
	// Passing a slice
	numbers := []int{1, 2, 3, 4, 5}
	fmt.Println("Sum:", sum(numbers...))
	
	printAll("Numbers", 1, 2, 3)
	printAll("Mixed", "Go", 42, true, 3.14)
}
