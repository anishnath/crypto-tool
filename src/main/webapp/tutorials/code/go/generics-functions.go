package main

import "fmt"

// Generic function that works with any slice
func Map[T, U any](slice []T, fn func(T) U) []U {
	result := make([]U, len(slice))
	for i, v := range slice {
		result[i] = fn(v)
	}
	return result
}

// Generic function with multiple type parameters
func Zip[T, U any](a []T, b []U) []struct {
	First  T
	Second U
} {
	length := len(a)
	if len(b) < length {
		length = len(b)
	}

	result := make([]struct {
		First  T
		Second U
	}, length)
	for i := 0; i < length; i++ {
		result[i] = struct {
			First  T
			Second U
		}{a[i], b[i]}
	}
	return result
}

func main() {
	// Map: Transform []int to []string
	numbers := []int{1, 2, 3, 4, 5}
	strings := Map(numbers, func(n int) string {
		return fmt.Sprintf("Number: %d", n)
	})
	fmt.Println("Mapped:", strings)

	// Map: Transform []string to []int (lengths)
	words := []string{"Go", "Generics", "Rock"}
	lengths := Map(words, func(s string) int {
		return len(s)
	})
	fmt.Println("Lengths:", lengths)

	// Zip: Combine two slices
	names := []string{"Alice", "Bob", "Charlie"}
	ages := []int{25, 30, 35}
	combined := Zip(names, ages)

	fmt.Println("\nZipped:")
	for _, pair := range combined {
		fmt.Printf("%s is %d years old\n", pair.First, pair.Second)
	}
}
