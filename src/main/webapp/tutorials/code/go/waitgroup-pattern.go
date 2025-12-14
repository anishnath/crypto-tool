package main

import (
	"fmt"
	"sync"
	"time"
)

func processTask(id int, task int, wg *sync.WaitGroup) {
	defer wg.Done()

	fmt.Printf("Worker %d processing task %d\n", id, task)
	time.Sleep(time.Duration(task%3+1) * 100 * time.Millisecond)
	fmt.Printf("Worker %d completed task %d\n", id, task)
}

func main() {
	var wg sync.WaitGroup
	tasks := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

	fmt.Println("Starting task processing...")

	// Process each task in a separate goroutine
	for i, task := range tasks {
		wg.Add(1)
		go processTask(i+1, task, &wg)
	}

	// Wait for all tasks to complete
	wg.Wait()
	fmt.Println("\nAll tasks completed!")
}
