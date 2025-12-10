use std::fmt;

// Custom error using struct
#[derive(Debug)]
struct ParseError {
    input: String,
    reason: String,
}

impl fmt::Display for ParseError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Failed to parse '{}': {}", self.input, self.reason)
    }
}

impl std::error::Error for ParseError {}

// Using the custom error
fn parse_positive_number(s: &str) -> Result<i32, ParseError> {
    match s.parse::<i32>() {
        Ok(n) => {
            if n < 0 {
                Err(ParseError {
                    input: s.to_string(),
                    reason: String::from("Number must be positive"),
                })
            } else {
                Ok(n)
            }
        }
        Err(_) => Err(ParseError {
            input: s.to_string(),
            reason: String::from("Not a valid integer"),
        }),
    }
}

// Error with source
#[derive(Debug)]
struct AppError {
    message: String,
    source: Option<Box<dyn std::error::Error>>,
}

impl fmt::Display for AppError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Application error: {}", self.message)
    }
}

impl std::error::Error for AppError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        self.source.as_deref()
    }
}

fn main() {
    match parse_positive_number("42") {
        Ok(n) => println!("Parsed: {}", n),
        Err(e) => println!("Error: {}", e),
    }
    
    match parse_positive_number("-5") {
        Ok(n) => println!("Parsed: {}", n),
        Err(e) => println!("Error: {}", e),
    }
    
    match parse_positive_number("abc") {
        Ok(n) => println!("Parsed: {}", n),
        Err(e) => println!("Error: {}", e),
    }
}

