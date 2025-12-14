package main

import (
	"fmt"
	"sync"
)

func producer(id int, out chan<- int) {
	for i := 1; i <= 3; i++ {
		out <- id*10 + i
	}
	close(out)
}

func fanIn(inputs ...<-chan int) <-chan int {
	var wg sync.WaitGroup
	out := make(chan int)

	// Start a goroutine for each input channel
	output := func(c <-chan int) {
		defer wg.Done()
		for n := range c {
			out <- n
		}
	}

	wg.Add(len(inputs))
	for _, c := range inputs {
		go output(c)
	}

	// Close output channel when all inputs are done
	go func() {
		wg.Wait()
		close(out)
	}()

	return out
}

func main() {
	// Create multiple input channels
	ch1 := make(chan int)
	ch2 := make(chan int)
	ch3 := make(chan int)

	// Start producers
	go producer(1, ch1)
	go producer(2, ch2)
	go producer(3, ch3)

	// Fan-in: Merge all channels into one
	fmt.Println("Merging 3 channels (fan-in)...")
	merged := fanIn(ch1, ch2, ch3)

	// Consume merged output
	fmt.Println("Receiving merged results:")
	for value := range merged {
		fmt.Printf("Received: %d\n", value)
	}

	fmt.Println("\nAll channels merged!")
}
