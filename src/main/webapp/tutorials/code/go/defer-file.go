package main

import (
	"fmt"
	"os"
)

func main() {
	// Common use case: closing resources
	file, err := os.Create("/tmp/test.txt")
	if err != nil {
		fmt.Println("Error:", err)
		return
	}
	defer file.Close()  // Ensures file is closed
	
	// Write to file
	file.WriteString("Hello, Go!\n")
	file.WriteString("Defer ensures cleanup.\n")
	
	fmt.Println("File written successfully")
	// file.Close() will be called automatically
}
