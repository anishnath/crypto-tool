package main

import "fmt"

// Generic Stack type
type Stack[T any] struct {
	items []T
}

func (s *Stack[T]) Push(item T) {
	s.items = append(s.items, item)
}

func (s *Stack[T]) Pop() (T, bool) {
	if len(s.items) == 0 {
		var zero T
		return zero, false
	}
	item := s.items[len(s.items)-1]
	s.items = s.items[:len(s.items)-1]
	return item, true
}

func (s *Stack[T]) IsEmpty() bool {
	return len(s.items) == 0
}

// Generic Pair type
type Pair[T, U any] struct {
	First  T
	Second U
}

func main() {
	// Stack of integers
	intStack := Stack[int]{}
	intStack.Push(1)
	intStack.Push(2)
	intStack.Push(3)

	fmt.Println("Int Stack:")
	for !intStack.IsEmpty() {
		if val, ok := intStack.Pop(); ok {
			fmt.Println(val)
		}
	}

	// Stack of strings
	strStack := Stack[string]{}
	strStack.Push("Go")
	strStack.Push("Generics")
	strStack.Push("Rock")

	fmt.Println("\nString Stack:")
	for !strStack.IsEmpty() {
		if val, ok := strStack.Pop(); ok {
			fmt.Println(val)
		}
	}

	// Generic Pair
	p1 := Pair[string, int]{"Alice", 25}
	p2 := Pair[int, bool]{42, true}

	fmt.Printf("\nPairs:\n")
	fmt.Printf("p1: %v\n", p1)
	fmt.Printf("p2: %v\n", p2)
}
