// Exercise: Custom Errors Practice

use std::fmt;

fn main() {
    // TODO: Exercise 1 - Create a custom error enum
    // Create an enum called CalculationError with variants:
    // - DivisionByZero
    // - NegativeSquareRoot
    // - Overflow
    // Implement Display and Error traits
    
    // Your enum here
    
    // TODO: Exercise 2 - Implement safe_calculate function
    // Write a function that:
    // 1. Divides a by b (return DivisionByZero error if b == 0)
    // 2. Takes square root of result (return NegativeSquareRoot if negative)
    // 3. Returns Result<f64, CalculationError>
    
    fn safe_calculate(a: f64, b: f64) -> Result<f64, /* Your error type */> {
        // Your code here
        Err(/* placeholder */)
    }
    
    println!("{:?}", safe_calculate(100.0, 4.0));
    println!("{:?}", safe_calculate(100.0, 0.0));
    println!("{:?}", safe_calculate(-100.0, 4.0));
    
    // TODO: Exercise 3 - Create a struct-based error
    // Create a struct called ValidationError with fields:
    // - field: String
    // - value: String
    // - message: String
    // Implement Display and Error traits
    
    // Your struct here
    
    // TODO: Exercise 4 - Implement validate_email function
    // Write a function that validates an email address
    // Return ValidationError if email doesn't contain '@'
    // Use the ValidationError struct
    
    fn validate_email(email: &str) -> Result<String, /* Your error type */> {
        // Your code here
        Err(/* placeholder */)
    }
    
    println!("{:?}", validate_email("user@example.com"));
    println!("{:?}", validate_email("invalid-email"));
}

// Hints:
// 1. Use #[derive(Debug)] for your error types
// 2. Implement fmt::Display for user-friendly error messages
// 3. Implement std::error::Error trait (can be empty impl block)
// 4. Use match or if to check conditions and return appropriate errors

