package main

import "fmt"

func main() {
	// Integer types
	var age int = 25
	var population int64 = 7800000000
	
	// Floating-point types
	var price float64 = 19.99
	var temperature float32 = 23.5
	
	// String type
	var greeting string = "Hello, Go!"
	
	// Boolean type
	var isActive bool = true
	
	// Byte and rune
	var initial byte = 'G'      // byte is alias for uint8
	var emoji rune = '😀'        // rune is alias for int32
	
	fmt.Println("Age:", age)
	fmt.Println("Population:", population)
	fmt.Println("Price:", price)
	fmt.Println("Temperature:", temperature)
	fmt.Println("Greeting:", greeting)
	fmt.Println("Active:", isActive)
	fmt.Printf("Initial: %c\n", initial)
	fmt.Printf("Emoji: %c\n", emoji)
}
