package main

import (
	"errors"
	"fmt"
)

var (
	ErrInvalidInput = errors.New("invalid input")
	ErrNotFound     = errors.New("not found")
	ErrUnauthorized = errors.New("unauthorized")
)

func processRequest(input string) error {
	if input == "" {
		return ErrInvalidInput
	}
	if input == "secret" {
		return ErrUnauthorized
	}
	return nil
}

func main() {
	err := processRequest("")
	if errors.Is(err, ErrInvalidInput) {
		fmt.Println("Please provide valid input")
	}
	
	err = processRequest("secret")
	if errors.Is(err, ErrUnauthorized) {
		fmt.Println("Access denied")
	}
}
