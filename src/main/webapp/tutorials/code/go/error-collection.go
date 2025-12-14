package main

import (
	"fmt"
	"sync"
)

func worker(id int, jobs <-chan int, wg *sync.WaitGroup, errors chan<- error) {
	defer wg.Done()

	for job := range jobs {
		// Simulate error on job 5
		if job == 5 {
			errors <- fmt.Errorf("worker %d failed on job %d", id, job)
			continue
		}

		fmt.Printf("Worker %d completed job %d\n", id, job)
	}
}

func main() {
	const numWorkers = 3
	const numJobs = 10

	jobs := make(chan int, numJobs)
	errors := make(chan error, numJobs)
	var wg sync.WaitGroup

	// Start workers
	for w := 1; w <= numWorkers; w++ {
		wg.Add(1)
		go worker(w, jobs, &wg, errors)
	}

	// Send jobs
	for j := 1; j <= numJobs; j++ {
		jobs <- j
	}
	close(jobs)

	// Wait and close errors channel
	go func() {
		wg.Wait()
		close(errors)
	}()

	// Collect errors
	var errorList []error
	for err := range errors {
		errorList = append(errorList, err)
	}

	// Report results
	if len(errorList) > 0 {
		fmt.Printf("\nEncountered %d errors:\n", len(errorList))
		for _, err := range errorList {
			fmt.Printf("  - %v\n", err)
		}
	} else {
		fmt.Println("\nAll jobs completed successfully!")
	}
}
