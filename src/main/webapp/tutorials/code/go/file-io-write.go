package main

import (
	"fmt"
	"os"
)

func main() {
	// Write to file
	content := []byte("Hello, Go!\nFile I/O is easy!")
	err := os.WriteFile("/tmp/output.txt", content, 0644)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}
	fmt.Println("File written successfully!")
}
