package main

import (
	"fmt"
	"time"
)

func sayHello() {
	fmt.Println("Hello from goroutine!")
}

func count(name string) {
	for i := 1; i <= 5; i++ {
		fmt.Printf("%s: %d\n", name, i)
		time.Sleep(100 * time.Millisecond)
	}
}

func main() {
	// Launch goroutine
	go sayHello()
	
	// Launch multiple goroutines
	go count("A")
	go count("B")
	
	// Wait for goroutines
	time.Sleep(1 * time.Second)
	fmt.Println("Done!")
}
