package main

import "fmt"

func main() {
	// Range over map
	ages := map[string]int{
		"Alice": 25,
		"Bob":   30,
		"Carol": 28,
	}
	
	for name, age := range ages {
		fmt.Printf("%s is %d years old\n", name, age)
	}
	
	// Range with only keys
	fmt.Println("\nNames only:")
	for name := range ages {
		fmt.Println(name)
	}
}
