package main

import (
	"fmt"
	"sync"
)

var (
	instance *Database
	once     sync.Once
)

type Database struct {
	connection string
}

func GetDatabase() *Database {
	once.Do(func() {
		fmt.Println("Initializing database...")
		instance = &Database{connection: "db://localhost"}
	})
	return instance
}

func main() {
	var wg sync.WaitGroup

	// Multiple goroutines trying to get instance
	for i := 0; i < 5; i++ {
		wg.Add(1)
		go func(id int) {
			defer wg.Done()
			db := GetDatabase()
			fmt.Printf("Goroutine %d got: %s\n", id, db.connection)
		}(i)
	}

	wg.Wait()
	// "Initializing database..." prints only once!
}
