fn main() {
    // panic! macro - causes the program to panic
    // Uncomment to see panic:
    // panic!("crash and burn");
    
    // Panic from library code
    let v = vec![1, 2, 3];
    // This will panic because index 10 doesn't exist
    // let element = v[10];  // Uncomment to panic
    
    // Using unwrap() - panics on None or Err
    let some_value = Some(5);
    let value = some_value.unwrap();  // OK, returns 5
    println!("Unwrapped value: {}", value);
    
    // This would panic:
    // let none_value: Option<i32> = None;
    // let value = none_value.unwrap();  // Panic!
    
    // Using expect() - similar to unwrap but with custom message
    let result: Result<i32, &str> = Ok(42);
    let value = result.expect("Failed to get value");  // OK, returns 42
    println!("Expected value: {}", value);
    
    // This would panic with custom message:
    // let error: Result<i32, &str> = Err("something went wrong");
    // let value = error.expect("Failed to get value");  // Panic with message
    
    // Safe alternatives to unwrap
    let maybe_value: Option<i32> = Some(10);
    
    // Using match
    match maybe_value {
        Some(v) => println!("Value: {}", v),
        None => println!("No value"),
    }
    
    // Using if let
    if let Some(v) = maybe_value {
        println!("Value: {}", v);
    }
    
    // Using unwrap_or for defaults
    let value = maybe_value.unwrap_or(0);
    println!("Value or default: {}", value);
    
    // Panic in a function
    fn might_panic(should_panic: bool) {
        if should_panic {
            panic!("This function panicked!");
        }
        println!("Function completed successfully");
    }
    
    might_panic(false);  // OK
    // might_panic(true);  // Would panic
    
    println!("Program completed successfully");
}

// Key points:
// - panic! macro stops execution
// - unwrap() and expect() can cause panics
// - Use match, if let, or unwrap_or for safe handling
// - Panics are for unrecoverable errors

