package main

import (
	"errors"
	"fmt"
)

var ErrNotFound = errors.New("not found")

func findUser(id int) error {
	if id != 1 {
		return fmt.Errorf("user lookup failed: %w", ErrNotFound)
	}
	return nil
}

func main() {
	err := findUser(2)
	
	// errors.Is checks error chain
	if errors.Is(err, ErrNotFound) {
		fmt.Println("User not found!")
	}
	
	fmt.Println("Error:", err)
}
