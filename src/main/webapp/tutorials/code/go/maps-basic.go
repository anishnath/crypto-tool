package main

import "fmt"

func main() {
	// Create map with make
	ages := make(map[string]int)
	ages["Alice"] = 25
	ages["Bob"] = 30
	
	fmt.Println("Ages:", ages)
	fmt.Println("Alice's age:", ages["Alice"])
	
	// Map literal
	scores := map[string]int{
		"Math":    95,
		"English": 88,
		"Science": 92,
	}
	fmt.Println("Scores:", scores)
	
	// Check if key exists
	value, exists := scores["History"]
	if exists {
		fmt.Println("History score:", value)
	} else {
		fmt.Println("History score not found")
	}
	
	// Iterate over map
	for subject, score := range scores {
		fmt.Printf("%s: %d\n", subject, score)
	}
}
