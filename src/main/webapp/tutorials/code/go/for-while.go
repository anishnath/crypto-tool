package main

import "fmt"

func main() {
	// Go doesn't have while, use for instead
	
	// While-style loop
	i := 1
	for i <= 5 {
		fmt.Println(i)
		i++
	}
	
	// Do-while style (check condition at end)
	j := 1
	for {
		fmt.Println("Value:", j)
		j++
		if j > 3 {
			break
		}
	}
}
