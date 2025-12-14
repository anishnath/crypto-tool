package main

import "fmt"

func main() {
	// Strings are UTF-8 encoded
	message := "Hello, 世界! 🌍"
	
	fmt.Println("String:", message)
	fmt.Println("Byte length:", len(message))
	
	// Iterating over bytes
	fmt.Println("\nBytes:")
	for i := 0; i < len(message) && i < 10; i++ {
		fmt.Printf("%x ", message[i])
	}
	
	// Iterating over runes (characters)
	fmt.Println("\n\nRunes:")
	for i, r := range message {
		fmt.Printf("Position %d: %c (U+%04X)\n", i, r, r)
	}
	
	// Rune count
	runeCount := 0
	for range message {
		runeCount++
	}
	fmt.Println("\nRune count:", runeCount)
}
