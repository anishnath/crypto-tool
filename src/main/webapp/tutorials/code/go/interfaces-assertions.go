package main

import "fmt"

func main() {
	var i interface{} = "hello"
	
	// Type assertion
	s := i.(string)
	fmt.Println(s)
	
	// Type assertion with check
	s2, ok := i.(string)
	fmt.Println(s2, ok)
	
	n, ok := i.(int)
	fmt.Println(n, ok)  // 0, false
	
	// This would panic:
	// n := i.(int)
}
