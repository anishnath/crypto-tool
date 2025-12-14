package main

import (
	"fmt"
	"sync"
	"time"
)

func worker(id int, jobs <-chan int, results chan<- int, sem chan struct{}, wg *sync.WaitGroup) {
	defer wg.Done()

	for job := range jobs {
		// Acquire semaphore (limit concurrency)
		sem <- struct{}{}

		fmt.Printf("Worker %d processing job %d\n", id, job)
		time.Sleep(500 * time.Millisecond)
		results <- job * 2

		// Release semaphore
		<-sem
	}
}

func main() {
	const maxConcurrent = 3 // Limit to 3 concurrent workers
	const numWorkers = 10
	const numJobs = 10

	jobs := make(chan int, numJobs)
	results := make(chan int, numJobs)
	sem := make(chan struct{}, maxConcurrent) // Semaphore
	var wg sync.WaitGroup

	// Start workers (more than max concurrent)
	fmt.Printf("Starting %d workers (max %d concurrent)...\n", numWorkers, maxConcurrent)
	for w := 1; w <= numWorkers; w++ {
		wg.Add(1)
		go worker(w, jobs, results, sem, &wg)
	}

	// Send jobs
	for j := 1; j <= numJobs; j++ {
		jobs <- j
	}
	close(jobs)

	// Wait and close results
	go func() {
		wg.Wait()
		close(results)
	}()

	// Collect results
	fmt.Println("\nResults:")
	for result := range results {
		fmt.Println(result)
	}

	fmt.Println("\nAll jobs completed with bounded concurrency!")
}
