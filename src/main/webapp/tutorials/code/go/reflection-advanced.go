package main

import (
	"fmt"
	"reflect"
)

type Calculator struct {
	Value int
}

func (c *Calculator) Add(n int) int {
	c.Value += n
	return c.Value
}

func (c *Calculator) Multiply(n int) int {
	c.Value *= n
	return c.Value
}

func (c Calculator) GetValue() int {
	return c.Value
}

func callMethod(obj interface{}, methodName string, args ...interface{}) {
	// Get value
	v := reflect.ValueOf(obj)

	// Get method
	method := v.MethodByName(methodName)
	if !method.IsValid() {
		fmt.Printf("Method %s not found\n", methodName)
		return
	}

	// Prepare arguments
	in := make([]reflect.Value, len(args))
	for i, arg := range args {
		in[i] = reflect.ValueOf(arg)
	}

	// Call method
	results := method.Call(in)

	// Print results
	fmt.Printf("Called %s: ", methodName)
	for _, result := range results {
		fmt.Printf("%v ", result.Interface())
	}
	fmt.Println()
}

func inspectMethods(obj interface{}) {
	t := reflect.TypeOf(obj)
	fmt.Printf("\nMethods of %v:\n", t)

	for i := 0; i < t.NumMethod(); i++ {
		method := t.Method(i)
		fmt.Printf("  %s: %v\n", method.Name, method.Type)
	}
}

func main() {
	calc := &Calculator{Value: 10}

	fmt.Println("Initial value:", calc.Value)

	// Call methods dynamically
	callMethod(calc, "Add", 5)
	callMethod(calc, "Multiply", 3)
	callMethod(calc, "GetValue")

	// Inspect available methods
	inspectMethods(calc)

	// Modify struct field using reflection
	v := reflect.ValueOf(calc).Elem()
	field := v.FieldByName("Value")
	if field.CanSet() {
		field.SetInt(100)
		fmt.Println("\nValue set to 100 via reflection")
		fmt.Println("New value:", calc.Value)
	}
}
