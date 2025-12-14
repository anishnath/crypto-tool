package main

import "fmt"

type Rectangle struct {
	Width  float64
	Height float64
}

// Method with value receiver
func (r Rectangle) Area() float64 {
	return r.Width * r.Height
}

// Method with value receiver
func (r Rectangle) Perimeter() float64 {
	return 2 * (r.Width + r.Height)
}

func main() {
	rect := Rectangle{Width: 10, Height: 5}
	
	fmt.Printf("Rectangle: %+v\n", rect)
	fmt.Println("Area:", rect.Area())
	fmt.Println("Perimeter:", rect.Perimeter())
	
	// Methods can be called on pointers too
	rectPtr := &rect
	fmt.Println("Area (via pointer):", rectPtr.Area())
}
