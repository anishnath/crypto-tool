// Exercise: Error Propagation Practice

use std::fs::File;
use std::io::Read;

fn main() {
    // TODO: Exercise 1 - Read and Parse
    // Write a function that reads a number from a file and parses it
    // Use ? operator for error propagation
    // Return Result<i32, Box<dyn std::error::Error>>
    
    fn read_number_from_file(filename: &str) -> Result<i32, Box<dyn std::error::Error>> {
        // Your code here
        Err("Not implemented".into())
    }
    
    println!("{:?}", read_number_from_file("number.txt"));
    
    // TODO: Exercise 2 - Chain Operations
    // Write a function that:
    // 1. Reads a file
    // 2. Parses the first line as a number
    // 3. Divides 100 by that number
    // Use ? operator to propagate errors
    // Return Result<f64, Box<dyn std::error::Error>>
    
    fn read_divide(filename: &str) -> Result<f64, Box<dyn std::error::Error>> {
        // Your code here
        Err("Not implemented".into())
    }
    
    println!("{:?}", read_divide("divisor.txt"));
    
    // TODO: Exercise 3 - Custom Error Propagation
    // Write a function that validates a number is positive
    // Then divides 100 by it
    // Use ? operator with custom Result<String, String>
    
    fn validate_and_divide(n: i32) -> Result<f64, String> {
        // Your code here
        Err(String::from("Not implemented"))
    }
    
    println!("{:?}", validate_and_divide(5));
    println!("{:?}", validate_and_divide(-5));
    println!("{:?}", validate_and_divide(0));
}

// Hints:
// 1. Use File::open()? and read_to_string()?
// 2. Use parse()? to convert string to number
// 3. Check for division by zero before dividing
// 4. Use Box<dyn std::error::Error> to handle multiple error types

