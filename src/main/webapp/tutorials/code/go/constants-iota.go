package main

import "fmt"

func main() {
	// iota creates enumerated constants
	const (
		Sunday = iota     // 0
		Monday            // 1
		Tuesday           // 2
		Wednesday         // 3
		Thursday          // 4
		Friday            // 5
		Saturday          // 6
	)
	
	fmt.Println("Sunday:", Sunday)
	fmt.Println("Wednesday:", Wednesday)
	fmt.Println("Saturday:", Saturday)
	
	// iota with expressions
	const (
		_  = iota             // Skip 0
		KB = 1 << (10 * iota) // 1024
		MB                     // 1048576
		GB                     // 1073741824
	)
	
	fmt.Printf("1 KB = %d bytes\n", KB)
	fmt.Printf("1 MB = %d bytes\n", MB)
	fmt.Printf("1 GB = %d bytes\n", GB)
}
