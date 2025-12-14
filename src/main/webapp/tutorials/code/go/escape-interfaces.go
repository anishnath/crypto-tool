package main

import "fmt"

// Interface causes escape
func toInterface() interface{} {
	x := 42
	return x // x escapes: converted to interface{}
}

// Interface parameter causes escape
func acceptInterface(v interface{}) {
	fmt.Println(v)
}

func callWithValue() {
	x := 100
	acceptInterface(x) // x escapes: passed as interface{}
}

// Type assertion - value already escaped
func typeAssertion() {
	var i interface{} = 42 // 42 escapes to heap

	if v, ok := i.(int); ok {
		fmt.Println("Value:", v)
	}
}

// Interface in struct
type Holder struct {
	Value interface{}
}

func structWithInterface() Holder {
	x := 42
	return Holder{Value: x} // x escapes: stored as interface{}
}

// Method on interface
type Stringer interface {
	String() string
}

type Person struct {
	Name string
}

func (p Person) String() string {
	return p.Name
}

func returnStringer() Stringer {
	p := Person{Name: "Alice"}
	return p // p escapes: returned as interface
}

// Empty interface slice
func interfaceSlice() []interface{} {
	a, b, c := 1, "hello", 3.14
	return []interface{}{a, b, c} // All escape
}

func main() {
	fmt.Println("Escape Analysis - Interfaces")
	fmt.Println("=============================\n")

	fmt.Println("1. Convert to interface{}:")
	val := toInterface()
	fmt.Printf("   Value: %v (escaped)\n\n", val)

	fmt.Println("2. Pass as interface{}:")
	callWithValue()
	fmt.Println()

	fmt.Println("3. Type assertion:")
	typeAssertion()
	fmt.Println()

	fmt.Println("4. Interface in struct:")
	holder := structWithInterface()
	fmt.Printf("   Holder: %+v (value escaped)\n\n", holder)

	fmt.Println("5. Return as interface:")
	stringer := returnStringer()
	fmt.Printf("   Stringer: %s (escaped)\n\n", stringer.String())

	fmt.Println("6. Interface slice:")
	slice := interfaceSlice()
	fmt.Printf("   Slice: %v (all escaped)\n\n", slice)

	fmt.Println("Why interfaces cause escape:")
	fmt.Println("  • Interface values are stored on heap")
	fmt.Println("  • Compiler can't know concrete type at compile time")
	fmt.Println("  • Value must outlive function scope")

	fmt.Println("\nEscape analysis:")
	fmt.Println("  go build -gcflags='-m' escape-interfaces.go")
}
