package main

import "fmt"

func main() {
	// Type switch
	var i interface{} = "hello"
	
	switch v := i.(type) {
	case int:
		fmt.Printf("Integer: %d\n", v)
	case string:
		fmt.Printf("String: %s\n", v)
	case bool:
		fmt.Printf("Boolean: %t\n", v)
	default:
		fmt.Printf("Unknown type: %T\n", v)
	}
	
	// Another example
	checkType(42)
	checkType("Go")
	checkType(3.14)
	checkType(true)
}

func checkType(x interface{}) {
	switch x.(type) {
	case int:
		fmt.Println("It's an integer")
	case string:
		fmt.Println("It's a string")
	case float64:
		fmt.Println("It's a float")
	default:
		fmt.Println("Unknown type")
	}
}
