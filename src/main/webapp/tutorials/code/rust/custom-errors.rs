use std::fmt;

// Custom error type using enum
#[derive(Debug)]
enum MathError {
    DivisionByZero,
    NegativeNumber,
    Overflow,
}

impl fmt::Display for MathError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            MathError::DivisionByZero => write!(f, "Cannot divide by zero"),
            MathError::NegativeNumber => write!(f, "Number cannot be negative"),
            MathError::Overflow => write!(f, "Arithmetic overflow occurred"),
        }
    }
}

impl std::error::Error for MathError {}

// Function using custom error
fn divide(a: i32, b: i32) -> Result<i32, MathError> {
    if b == 0 {
        Err(MathError::DivisionByZero)
    } else {
        Ok(a / b)
    }
}

fn sqrt(n: i32) -> Result<f64, MathError> {
    if n < 0 {
        Err(MathError::NegativeNumber)
    } else {
        Ok((n as f64).sqrt())
    }
}

// Custom error with context
#[derive(Debug)]
struct ValidationError {
    field: String,
    message: String,
}

impl fmt::Display for ValidationError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Validation error in {}: {}", self.field, self.message)
    }
}

impl std::error::Error for ValidationError {}

fn validate_age(age: i32) -> Result<i32, ValidationError> {
    if age < 0 {
        Err(ValidationError {
            field: String::from("age"),
            message: String::from("Age cannot be negative"),
        })
    } else if age > 150 {
        Err(ValidationError {
            field: String::from("age"),
            message: String::from("Age cannot exceed 150"),
        })
    } else {
        Ok(age)
    }
}

fn main() {
    // Using custom error types
    match divide(10, 2) {
        Ok(result) => println!("Result: {}", result),
        Err(e) => println!("Error: {}", e),
    }
    
    match divide(10, 0) {
        Ok(result) => println!("Result: {}", result),
        Err(e) => println!("Error: {}", e),
    }
    
    match sqrt(-4) {
        Ok(result) => println!("Square root: {}", result),
        Err(e) => println!("Error: {}", e),
    }
    
    match validate_age(25) {
        Ok(age) => println!("Valid age: {}", age),
        Err(e) => println!("Error: {}", e),
    }
    
    match validate_age(-5) {
        Ok(age) => println!("Valid age: {}", age),
        Err(e) => println!("Error: {}", e),
    }
}

// Key points:
// - Custom error types provide better error messages
// - Implement Display and Error traits
// - Can use enums for multiple error variants
// - Can use structs for errors with context
// - Makes error handling more structured

