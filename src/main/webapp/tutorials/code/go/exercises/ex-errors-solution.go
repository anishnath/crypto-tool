package main

import (
	"fmt"
	"strings"
)

type EmailError struct {
	Email  string
	Reason string
}

func (e *EmailError) Error() string {
	return fmt.Sprintf("invalid email '%s': %s", e.Email, e.Reason)
}

func validateEmail(email string) error {
	if !strings.Contains(email, "@") {
		return &EmailError{Email: email, Reason: "missing @ symbol"}
	}
	if len(email) < 5 {
		return &EmailError{Email: email, Reason: "too short"}
	}
	return nil
}

func main() {
	emails := []string{"test@example.com", "invalid", "a@b"}
	
	for _, email := range emails {
		if err := validateEmail(email); err != nil {
			fmt.Println("Error:", err)
		} else {
			fmt.Println("Valid:", email)
		}
	}
}
