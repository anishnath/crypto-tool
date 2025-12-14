package main

import (
	"fmt"
	"reflect"
)

type Person struct {
	Name  string `json:"name" validate:"required"`
	Age   int    `json:"age" validate:"min=0,max=150"`
	Email string `json:"email"`
}

func main() {
	p := Person{Name: "Alice", Age: 25, Email: "alice@example.com"}

	// Get type information
	t := reflect.TypeOf(p)
	fmt.Printf("Type: %v\n", t)
	fmt.Printf("Kind: %v\n", t.Kind())
	fmt.Printf("Name: %v\n\n", t.Name())

	// Iterate over struct fields
	fmt.Println("Fields:")
	for i := 0; i < t.NumField(); i++ {
		field := t.Field(i)
		fmt.Printf("  %s: %v", field.Name, field.Type)

		// Get struct tags
		if jsonTag := field.Tag.Get("json"); jsonTag != "" {
			fmt.Printf(" [json:%s]", jsonTag)
		}
		if validateTag := field.Tag.Get("validate"); validateTag != "" {
			fmt.Printf(" [validate:%s]", validateTag)
		}
		fmt.Println()
	}

	// Get value information
	v := reflect.ValueOf(p)
	fmt.Println("\nValues:")
	for i := 0; i < v.NumField(); i++ {
		field := v.Field(i)
		fieldName := t.Field(i).Name
		fmt.Printf("  %s = %v\n", fieldName, field.Interface())
	}

	// Check if value is zero
	fmt.Println("\nZero value checks:")
	fmt.Printf("Name is zero: %v\n", reflect.ValueOf(p.Name).IsZero())
	fmt.Printf("Age is zero: %v\n", reflect.ValueOf(p.Age).IsZero())
}
