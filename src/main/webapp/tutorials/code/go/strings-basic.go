package main

import (
	"fmt"
	"strings"
)

func main() {
	// String literals
	greeting := "Hello, Go!"
	multiline := `This is a
	multi-line
	string`
	
	fmt.Println(greeting)
	fmt.Println(multiline)
	
	// String operations
	fmt.Println("\nString operations:")
	fmt.Println("Length:", len(greeting))
	fmt.Println("Uppercase:", strings.ToUpper(greeting))
	fmt.Println("Lowercase:", strings.ToLower(greeting))
	fmt.Println("Contains 'Go':", strings.Contains(greeting, "Go"))
	fmt.Println("Replace:", strings.Replace(greeting, "Go", "World", 1))
	
	// String concatenation
	first := "Hello"
	second := "World"
	combined := first + " " + second
	fmt.Println("Combined:", combined)
}
