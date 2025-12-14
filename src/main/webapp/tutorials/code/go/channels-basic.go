package main

import "fmt"

func main() {
	// Create channel
	ch := make(chan int)
	
	// Send value in goroutine
	go func() {
		ch <- 42
	}()
	
	// Receive value
	value := <-ch
	fmt.Println("Received:", value)
	
	// Buffered channel
	buffered := make(chan string, 2)
	buffered <- "hello"
	buffered <- "world"
	
	fmt.Println(<-buffered)
	fmt.Println(<-buffered)
}
