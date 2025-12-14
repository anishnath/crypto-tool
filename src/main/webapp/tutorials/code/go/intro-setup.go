package main

import (
	"fmt"
	"runtime"
)

func main() {
	// Display Go version and system information
	fmt.Println("Go Version:", runtime.Version())
	fmt.Println("Operating System:", runtime.GOOS)
	fmt.Println("Architecture:", runtime.GOARCH)
	fmt.Println("Number of CPUs:", runtime.NumCPU())

	fmt.Println("\n✓ Go is installed and working!")
}
