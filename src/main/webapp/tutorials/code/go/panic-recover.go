package main

import "fmt"

func main() {
	fmt.Println("Starting...")
	
	safeDivide(10, 0)
	safeDivide(10, 2)
	
	fmt.Println("Program continues...")
}

func safeDivide(a, b int) {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("Recovered from panic:", r)
		}
	}()
	
	result := divide(a, b)
	fmt.Printf("%d / %d = %d\n", a, b, result)
}

func divide(a, b int) int {
	if b == 0 {
		panic("division by zero")
	}
	return a / b
}
