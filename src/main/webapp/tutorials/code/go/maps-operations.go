package main

import "fmt"

func main() {
	// Create and populate map
	inventory := map[string]int{
		"apples":  10,
		"oranges": 5,
		"bananas": 8,
	}
	
	fmt.Println("Initial inventory:", inventory)
	
	// Add/update elements
	inventory["grapes"] = 15
	inventory["apples"] = 12
	fmt.Println("After updates:", inventory)
	
	// Delete element
	delete(inventory, "oranges")
	fmt.Println("After delete:", inventory)
	
	// Check existence
	if count, ok := inventory["oranges"]; ok {
		fmt.Println("Oranges:", count)
	} else {
		fmt.Println("Oranges not in inventory")
	}
	
	// Map length
	fmt.Println("Items in inventory:", len(inventory))
	
	// Nil map
	var nilMap map[string]int
	fmt.Println("Nil map:", nilMap)
	// nilMap["key"] = 1  // This would panic!
}
