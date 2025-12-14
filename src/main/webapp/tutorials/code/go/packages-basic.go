package main

import (
	"fmt"
	"math"
	"strings"
)

func main() {
	// Using standard library packages
	fmt.Println("Square root of 16:", math.Sqrt(16))
	fmt.Println("Uppercase:", strings.ToUpper("hello"))
	
	// Exported vs unexported
	// Exported: starts with capital letter
	// Unexported: starts with lowercase letter
}
