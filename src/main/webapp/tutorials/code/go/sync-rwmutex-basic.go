package main

import (
	"fmt"
	"sync"
	"time"
)

type Cache struct {
	mu   sync.RWMutex
	data map[string]string
}

func (c *Cache) Read(key string) string {
	c.mu.RLock() // Multiple readers OK
	defer c.mu.RUnlock()
	return c.data[key]
}

func (c *Cache) Write(key, value string) {
	c.mu.Lock() // Exclusive write lock
	defer c.mu.Unlock()
	c.data[key] = value
}

func main() {
	cache := Cache{data: make(map[string]string)}
	var wg sync.WaitGroup

	// Writer
	wg.Add(1)
	go func() {
		defer wg.Done()
		cache.Write("name", "Go")
		fmt.Println("Written: name=Go")
	}()

	// Multiple readers
	for i := 0; i < 3; i++ {
		wg.Add(1)
		go func(id int) {
			defer wg.Done()
			time.Sleep(100 * time.Millisecond)
			value := cache.Read("name")
			fmt.Printf("Reader %d: name=%s\n", id, value)
		}(i)
	}

	wg.Wait()
}
