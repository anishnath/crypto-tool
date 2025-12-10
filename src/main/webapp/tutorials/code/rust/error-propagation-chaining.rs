use std::fs::File;
use std::io::Read;

// Chaining operations with ?
fn read_file_contents(filename: &str) -> Result<String, std::io::Error> {
    let mut file = File::open(filename)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents)
}

// Multiple operations in one line
fn read_and_parse(filename: &str) -> Result<i32, Box<dyn std::error::Error>> {
    let contents = std::fs::read_to_string(filename)?;
    let number: i32 = contents.trim().parse()?;
    Ok(number)
}

// Custom function that returns Result
fn divide(a: i32, b: i32) -> Result<i32, String> {
    if b == 0 {
        Err(String::from("Division by zero"))
    } else {
        Ok(a / b)
    }
}

// Using ? with custom Result
fn calculate(x: i32, y: i32) -> Result<i32, String> {
    let result = divide(x, y)?;
    Ok(result * 2)
}

fn main() {
    // Example usage
    match read_file_contents("hello.txt") {
        Ok(contents) => println!("File contents: {}", contents),
        Err(e) => println!("Error: {}", e),
    }
    
    match calculate(10, 2) {
        Ok(result) => println!("Result: {}", result),
        Err(e) => println!("Error: {}", e),
    }
}

