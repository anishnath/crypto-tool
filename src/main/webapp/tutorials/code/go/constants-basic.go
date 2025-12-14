package main

import "fmt"

func main() {
	// Typed constants
	const Pi float64 = 3.14159
	const MaxUsers int = 100
	const AppName string = "GoApp"
	
	fmt.Println("Pi:", Pi)
	fmt.Println("Max Users:", MaxUsers)
	fmt.Println("App Name:", AppName)
	
	// Untyped constants (more flexible)
	const Greeting = "Hello"
	const Answer = 42
	
	// Can be used with different types
	var msg string = Greeting
	var num int = Answer
	var bigNum int64 = Answer
	
	fmt.Println(msg, num, bigNum)
}
