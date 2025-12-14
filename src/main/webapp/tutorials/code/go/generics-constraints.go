package main

import (
	"fmt"

	"golang.org/x/exp/constraints"
)

// Custom constraint using interface
type Number interface {
	int | int64 | float64
}

// Function using custom constraint
func Sum[T Number](numbers []T) T {
	var total T
	for _, n := range numbers {
		total += n
	}
	return total
}

// Using built-in constraints
func Min[T constraints.Ordered](a, b T) T {
	if a < b {
		return a
	}
	return b
}

// Constraint with methods
type Stringer interface {
	String() string
}

func PrintAll[T Stringer](items []T) {
	for _, item := range items {
		fmt.Println(item.String())
	}
}

// Custom type implementing Stringer
type Person struct {
	Name string
	Age  int
}

func (p Person) String() string {
	return fmt.Sprintf("%s (%d years)", p.Name, p.Age)
}

func main() {
	// Using Number constraint
	ints := []int{1, 2, 3, 4, 5}
	fmt.Println("Sum of ints:", Sum(ints))

	floats := []float64{1.1, 2.2, 3.3}
	fmt.Println("Sum of floats:", Sum(floats))

	// Using Ordered constraint
	fmt.Println("\nMin examples:")
	fmt.Println("Min(10, 20):", Min(10, 20))
	fmt.Println("Min(\"apple\", \"banana\"):", Min("apple", "banana"))

	// Using interface constraint
	people := []Person{
		{"Alice", 25},
		{"Bob", 30},
		{"Charlie", 35},
	}

	fmt.Println("\nPeople:")
	PrintAll(people)
}
