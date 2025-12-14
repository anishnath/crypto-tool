package main

import "fmt"

type Describer interface {
	Describe() string
}

type Person struct {
	Name string
	Age  int
}

func (p Person) Describe() string {
	return fmt.Sprintf("%s, age %d", p.Name, p.Age)
}

func main() {
	var d Describer
	
	// Interface value is nil
	fmt.Printf("Interface: %v, %T\n", d, d)
	
	// Assign concrete type
	d = Person{Name: "Alice", Age: 25}
	fmt.Println(d.Describe())
	
	// Empty interface can hold any value
	var i interface{}
	i = 42
	fmt.Println(i)
	i = "hello"
	fmt.Println(i)
	i = true
	fmt.Println(i)
}
