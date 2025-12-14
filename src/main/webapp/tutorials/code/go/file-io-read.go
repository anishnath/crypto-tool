package main

import (
	"fmt"
	"os"
)

func main() {
	// Read entire file
	data, err := os.ReadFile("/tmp/test.txt")
	if err != nil {
		fmt.Println("Error:", err)
		return
	}
	fmt.Println("File contents:", string(data))
}
