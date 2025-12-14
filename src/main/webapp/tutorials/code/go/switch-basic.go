package main

import (
	"fmt"
	"time"
)

func main() {
	// Basic switch
	day := time.Now().Weekday()
	
	switch day {
	case time.Saturday, time.Sunday:
		fmt.Println("It's the weekend!")
	case time.Monday:
		fmt.Println("It's Monday")
	default:
		fmt.Println("It's a weekday")
	}
	
	// Switch with no condition (like if-else chain)
	hour := time.Now().Hour()
	
	switch {
	case hour < 12:
		fmt.Println("Good morning!")
	case hour < 18:
		fmt.Println("Good afternoon!")
	default:
		fmt.Println("Good evening!")
	}
}
