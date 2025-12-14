package main

import "fmt"

// This demonstrates a basic Go program structure
// Every Go program starts with a package declaration
// The main package is special - it's the entry point

func main() {
	// Variables in Go
	message := "Welcome to Go Modules!"
	version := "1.21"

	fmt.Println(message)
	fmt.Printf("Go version: %s\n", version)

	// Go modules make dependency management easy
	fmt.Println("\nTo create a new module:")
	fmt.Println("  go mod init example.com/myproject")
}
