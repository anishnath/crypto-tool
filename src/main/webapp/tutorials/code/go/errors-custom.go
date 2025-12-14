package main

import "fmt"

// Custom error type
type ValidationError struct {
	Field   string
	Message string
}

func (e *ValidationError) Error() string {
	return fmt.Sprintf("%s: %s", e.Field, e.Message)
}

func validateAge(age int) error {
	if age < 0 {
		return &ValidationError{
			Field:   "age",
			Message: "must be non-negative",
		}
	}
	if age > 150 {
		return &ValidationError{
			Field:   "age",
			Message: "must be realistic",
		}
	}
	return nil
}

func main() {
	if err := validateAge(-5); err != nil {
		fmt.Println("Error:", err)
	}
	
	if err := validateAge(200); err != nil {
		fmt.Println("Error:", err)
	}
	
	if err := validateAge(25); err != nil {
		fmt.Println("Error:", err)
	} else {
		fmt.Println("Age is valid!")
	}
}
