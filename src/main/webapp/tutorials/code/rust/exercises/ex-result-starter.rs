// Exercise: Result Handling Practice

fn main() {
    // TODO: Exercise 1 - Safe File Reading
    // Write a function that reads a number from a string
    // Return Result<i32, String> - Ok(number) if valid, Err(message) if invalid
    // Use parse() which returns Result
    
    fn parse_number(s: &str) -> Result<i32, String> {
        // Your code here
        Err(String::from("Not implemented"))
    }
    
    println!("{:?}", parse_number("42"));
    println!("{:?}", parse_number("hello"));
    
    // TODO: Exercise 2 - Safe Division with Result
    // Write a function that divides two numbers
    // Return Result<f64, String> - Ok(result) if successful, Err(message) if division by zero
    
    fn safe_divide(a: f64, b: f64) -> Result<f64, String> {
        // Your code here
        Err(String::from("Not implemented"))
    }
    
    println!("{:?}", safe_divide(10.0, 2.0));
    println!("{:?}", safe_divide(10.0, 0.0));
    
    // TODO: Exercise 3 - Chaining Results
    // Write a function that:
    // 1. Parses a string to i32
    // 2. Divides 100 by that number
    // 3. Returns Result<i32, String>
    // Use and_then to chain the operations
    
    fn parse_and_divide(s: &str) -> Result<i32, String> {
        // Your code here
        Err(String::from("Not implemented"))
    }
    
    println!("{:?}", parse_and_divide("5"));
    println!("{:?}", parse_and_divide("0"));
    println!("{:?}", parse_and_divide("abc"));
}

// Hints:
// 1. For parse_number: use s.parse::<i32>() which returns Result<i32, ParseIntError>
//    Convert ParseIntError to String using map_err
// 2. For safe_divide: check if b == 0.0, return Err if so
// 3. For parse_and_divide: chain parse_number().and_then(|n| safe_divide(100.0, n as f64))

