package main

import "fmt"

func main() {
	age := 18
	
	if age >= 18 {
		fmt.Println("You are an adult")
	}
	
	score := 85
	
	if score >= 90 {
		fmt.Println("Grade: A")
	} else if score >= 80 {
		fmt.Println("Grade: B")
	} else if score >= 70 {
		fmt.Println("Grade: C")
	} else {
		fmt.Println("Grade: F")
	}
}
