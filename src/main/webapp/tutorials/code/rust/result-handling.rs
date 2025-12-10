fn main() {
    use std::fs::File;
    use std::io::ErrorKind;
    
    // Result<T, E> - for operations that can fail
    fn divide(a: i32, b: i32) -> Result<i32, String> {
        if b == 0 {
            Err(String::from("Division by zero"))
        } else {
            Ok(a / b)
        }
    }
    
    // Using Result with match
    match divide(10, 2) {
        Ok(result) => println!("Result: {}", result),
        Err(e) => println!("Error: {}", e),
    }
    
    match divide(10, 0) {
        Ok(result) => println!("Result: {}", result),
        Err(e) => println!("Error: {}", e),
    }
    
    // Result methods
    let success: Result<i32, &str> = Ok(42);
    let failure: Result<i32, &str> = Err("something went wrong");
    
    // unwrap_or - provide default value
    println!("Success unwrap_or: {}", success.unwrap_or(0));
    println!("Failure unwrap_or: {}", failure.unwrap_or(0));
    
    // unwrap_or_else - compute default value
    let value = failure.unwrap_or_else(|e| {
        println!("Error: {}", e);
        0
    });
    println!("Computed default: {}", value);
    
    // is_ok and is_err
    if success.is_ok() {
        println!("Operation succeeded!");
    }
    
    if failure.is_err() {
        println!("Operation failed!");
    }
    
    // map - transform the Ok value
    let doubled = success.map(|x| x * 2);
    println!("Doubled: {:?}", doubled);
    
    // map_err - transform the Err value
    let mapped_error = failure.map_err(|e| format!("Error: {}", e));
    println!("Mapped error: {:?}", mapped_error);
    
    // and_then - chain operations
    let chained = success.and_then(|x| {
        if x > 0 {
            Ok(x * 2)
        } else {
            Err("Value must be positive")
        }
    });
    println!("Chained: {:?}", chained);
    
    // Practical example: File operations
    let file_result = File::open("hello.txt");
    
    let file = match file_result {
        Ok(file) => {
            println!("File opened successfully!");
            file
        }
        Err(error) => match error.kind() {
            ErrorKind::NotFound => {
                println!("File not found, would create it");
                return;
            }
            ErrorKind::PermissionDenied => {
                println!("Permission denied");
                return;
            }
            other_error => {
                println!("Problem opening file: {:?}", other_error);
                return;
            }
        },
    };
    
    println!("File handle: {:?}", file);
}

// Key points:
// - Result<T, E> represents success (Ok) or failure (Err)
// - Use match to handle both cases
// - Many helper methods: unwrap_or, map, and_then, etc.
// - File operations return Result
// - Handle different error kinds appropriately

