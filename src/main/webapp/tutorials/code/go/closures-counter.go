package main

import "fmt"

func makeCounter() func() int {
	count := 0
	return func() int {
		count++
		return count
	}
}

func main() {
	counter1 := makeCounter()
	counter2 := makeCounter()
	
	fmt.Println("Counter 1:", counter1())  // 1
	fmt.Println("Counter 1:", counter1())  // 2
	fmt.Println("Counter 1:", counter1())  // 3
	
	fmt.Println("Counter 2:", counter2())  // 1
	fmt.Println("Counter 2:", counter2())  // 2
	
	fmt.Println("Counter 1:", counter1())  // 4
}
