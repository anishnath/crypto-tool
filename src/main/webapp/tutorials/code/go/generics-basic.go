package main

import "fmt"

// Generic function (Go 1.18+)
func Print[T any](s []T) {
	for _, v := range s {
		fmt.Println(v)
	}
}

func main() {
	Print([]int{1, 2, 3})
	Print([]string{"a", "b", "c"})
}
