package main

import "fmt"

// Define a struct
type Person struct {
	Name string
	Age  int
	City string
}

func main() {
	// Create struct instance
	var p1 Person
	p1.Name = "Alice"
	p1.Age = 25
	p1.City = "New York"
	
	fmt.Println("Person 1:", p1)
	
	// Struct literal
	p2 := Person{Name: "Bob", Age: 30, City: "London"}
	fmt.Println("Person 2:", p2)
	
	// Positional initialization
	p3 := Person{"Carol", 28, "Tokyo"}
	fmt.Println("Person 3:", p3)
	
	// Access fields
	fmt.Printf("%s is %d years old and lives in %s\n", 
		p2.Name, p2.Age, p2.City)
	
	// Anonymous struct
	point := struct {
		X, Y int
	}{10, 20}
	fmt.Println("Point:", point)
}
