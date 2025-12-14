package main

import "fmt"

func main() {
	// Short statement in if
	if num := 42; num > 0 {
		fmt.Println(num, "is positive")
	}
	
	// num is not accessible here
	
	if x := 10; x%2 == 0 {
		fmt.Println(x, "is even")
	} else {
		fmt.Println(x, "is odd")
	}
}
