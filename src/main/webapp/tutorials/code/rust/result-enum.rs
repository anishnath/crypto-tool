fn main() {
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
    
    // unwrap_or
    println!("Success unwrap_or: {}", success.unwrap_or(0));
    println!("Failure unwrap_or: {}", failure.unwrap_or(0));
    
    // is_ok and is_err
    if success.is_ok() {
        println!("Operation succeeded!");
    }
    
    if failure.is_err() {
        println!("Operation failed!");
    }
    
    // map and map_err
    let doubled = success.map(|x| x * 2);
    println!("Doubled: {:?}", doubled);
    
    // Practical example: File operations
    use std::fs::File;
    use std::io::ErrorKind;
    
    let file_result = File::open("hello.txt");
    
    let file = match file_result {
        Ok(file) => file,
        Err(error) => match error.kind() {
            ErrorKind::NotFound => {
                println!("File not found, would create it");
                return;
            }
            other_error => {
                println!("Problem opening file: {:?}", other_error);
                return;
            }
        },
    };
    
    println!("File opened successfully!");
}

// Result is defined as:
// enum Result<T, E> {
//     Ok(T),
//     Err(E),
// }
