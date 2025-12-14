package main

import "fmt"

type Counter struct {
	Count int
}

// Value receiver - doesn't modify original
func (c Counter) IncrementValue() {
	c.Count++
}

// Pointer receiver - modifies original
func (c *Counter) IncrementPointer() {
	c.Count++
}

func main() {
	counter := Counter{Count: 0}
	
	fmt.Println("Initial:", counter.Count)
	
	counter.IncrementValue()
	fmt.Println("After IncrementValue:", counter.Count)  // Still 0
	
	counter.IncrementPointer()
	fmt.Println("After IncrementPointer:", counter.Count)  // Now 1
	
	counter.IncrementPointer()
	counter.IncrementPointer()
	fmt.Println("Final:", counter.Count)  // Now 3
}
