package main

import "fmt"

// Multiple return values
func divide(a, b float64) (float64, error) {
	if b == 0 {
		return 0, fmt.Errorf("cannot divide by zero")
	}
	return a / b, nil
}

// Named return values
func minMax(numbers []int) (min, max int) {
	if len(numbers) == 0 {
		return 0, 0
	}
	
	min, max = numbers[0], numbers[0]
	for _, num := range numbers {
		if num < min {
			min = num
		}
		if num > max {
			max = num
		}
	}
	return  // Naked return
}

func main() {
	result, err := divide(10, 2)
	if err != nil {
		fmt.Println("Error:", err)
	} else {
		fmt.Println("Result:", result)
	}
	
	numbers := []int{5, 2, 9, 1, 7}
	min, max := minMax(numbers)
	fmt.Printf("Min: %d, Max: %d\n", min, max)
}
