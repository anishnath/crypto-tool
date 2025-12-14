package main

import (
	"fmt"
	"io"
	"strings"
)

// Stringer interface
type Person struct {
	Name string
	Age  int
}

func (p Person) String() string {
	return fmt.Sprintf("%s (%d years)", p.Name, p.Age)
}

func main() {
	p := Person{Name: "Alice", Age: 25}
	fmt.Println(p)  // Calls String() automatically
	
	// io.Reader example
	r := strings.NewReader("Hello, Go!")
	buf := make([]byte, 8)
	
	for {
		n, err := r.Read(buf)
		fmt.Printf("Read %d bytes: %s\n", n, buf[:n])
		if err == io.EOF {
			break
		}
	}
}
