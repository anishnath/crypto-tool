package main

import (
	"fmt"
	"sync"
)

// Stage 1: Generate numbers
func generate(nums ...int) <-chan int {
	out := make(chan int)
	go func() {
		defer close(out)
		for _, n := range nums {
			out <- n
		}
	}()
	return out
}

// Stage 2: Square numbers
func square(in <-chan int, wg *sync.WaitGroup) <-chan int {
	out := make(chan int)
	go func() {
		defer close(out)
		defer wg.Done()
		for n := range in {
			out <- n * n
		}
	}()
	return out
}

// Stage 3: Print results
func print(in <-chan int, wg *sync.WaitGroup) {
	defer wg.Done()
	for n := range in {
		fmt.Println(n)
	}
}

func main() {
	var wg sync.WaitGroup

	// Create pipeline
	fmt.Println("Pipeline: generate -> square -> print")

	// Stage 1: Generate
	numbers := generate(1, 2, 3, 4, 5)

	// Stage 2: Square (with WaitGroup)
	wg.Add(1)
	squared := square(numbers, &wg)

	// Stage 3: Print (with WaitGroup)
	wg.Add(1)
	go print(squared, &wg)

	// Wait for pipeline to complete
	wg.Wait()
	fmt.Println("\nPipeline completed!")
}
