fn main() {
    // Demonstrating Result helper methods
    
    let success: Result<i32, &str> = Ok(42);
    let failure: Result<i32, &str> = Err("error");
    
    // unwrap_or - default value
    println!("unwrap_or: {}", success.unwrap_or(0));
    println!("unwrap_or: {}", failure.unwrap_or(0));
    
    // unwrap_or_else - compute default
    let value = failure.unwrap_or_else(|e| {
        println!("Error occurred: {}", e);
        -1
    });
    println!("unwrap_or_else: {}", value);
    
    // map - transform Ok value
    let doubled = success.map(|x| x * 2);
    println!("map: {:?}", doubled);
    
    // map_err - transform Err value
    let mapped = failure.map_err(|e| format!("Error: {}", e));
    println!("map_err: {:?}", mapped);
    
    // and_then - chain Results
    let chained = success.and_then(|x| {
        if x > 0 {
            Ok(x * 2)
        } else {
            Err("must be positive")
        }
    });
    println!("and_then: {:?}", chained);
    
    // or_else - handle error case
    let recovered = failure.or_else(|e| {
        println!("Recovering from: {}", e);
        Ok(0)
    });
    println!("or_else: {:?}", recovered);
    
    // unwrap - panics on Err (use carefully!)
    // let value = failure.unwrap();  // Would panic
    
    // expect - panics with message
    // let value = failure.expect("Should not fail");  // Would panic
    
    // is_ok / is_err - check without unwrapping
    println!("success.is_ok(): {}", success.is_ok());
    println!("failure.is_err(): {}", failure.is_err());
}

