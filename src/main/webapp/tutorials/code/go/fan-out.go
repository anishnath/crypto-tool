package main

import (
	"fmt"
	"sync"
	"time"
)

func producer(id int, out chan<- int, wg *sync.WaitGroup) {
	defer wg.Done()

	for i := 1; i <= 3; i++ {
		value := id*10 + i
		fmt.Printf("Producer %d sending: %d\n", id, value)
		out <- value
		time.Sleep(100 * time.Millisecond)
	}
}

func main() {
	output := make(chan int, 10)
	var wg sync.WaitGroup

	// Fan-out: Start multiple producers
	numProducers := 3
	fmt.Printf("Starting %d producers (fan-out)...\n", numProducers)

	for i := 1; i <= numProducers; i++ {
		wg.Add(1)
		go producer(i, output, &wg)
	}

	// Close channel when all producers done
	go func() {
		wg.Wait()
		close(output)
	}()

	// Collect all results
	fmt.Println("\nCollecting results:")
	for value := range output {
		fmt.Printf("Received: %d\n", value)
	}

	fmt.Println("\nAll producers completed!")
}
