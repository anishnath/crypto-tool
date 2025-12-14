package main

import (
	"fmt"
)

func readConfig() error {
	return fmt.Errorf("config file not found")
}

func initialize() error {
	err := readConfig()
	if err != nil {
		return fmt.Errorf("initialization failed: %w", err)
	}
	return nil
}

func main() {
	err := initialize()
	if err != nil {
		fmt.Println("Error:", err)
	}
}
