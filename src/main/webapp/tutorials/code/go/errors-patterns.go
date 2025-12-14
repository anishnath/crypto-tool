package main

import (
	"fmt"
	"os"
)

func readFile(filename string) error {
	file, err := os.Open(filename)
	if err != nil {
		return fmt.Errorf("failed to open %s: %w", filename, err)
	}
	defer file.Close()
	
	// Process file...
	return nil
}

func main() {
	if err := readFile("nonexistent.txt"); err != nil {
		fmt.Println("Error:", err)
		return
	}
	
	fmt.Println("Success!")
}
