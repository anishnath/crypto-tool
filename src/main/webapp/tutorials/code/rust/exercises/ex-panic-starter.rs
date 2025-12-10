// Exercise: Panic Handling Practice

fn main() {
    // TODO: Exercise 1 - Safe Division
    // Write a function that divides two numbers safely
    // Return Option<i32> - Some(result) if successful, None if division by zero
    // Don't use unwrap() or expect() - handle the error properly
    
    fn safe_divide(a: i32, b: i32) -> Option<i32> {
        // Your code here
        None
    }
    
    println!("10 / 2 = {:?}", safe_divide(10, 2));
    println!("10 / 0 = {:?}", safe_divide(10, 0));
    
    // TODO: Exercise 2 - Safe Vector Access
    // Write a function that safely gets an element from a vector
    // Return Option<&i32> - Some(&element) if index exists, None otherwise
    // Don't use unwrap() or expect()
    
    fn safe_get(v: &Vec<i32>, index: usize) -> Option<&i32> {
        // Your code here
        None
    }
    
    let numbers = vec![1, 2, 3, 4, 5];
    println!("Element at index 2: {:?}", safe_get(&numbers, 2));
    println!("Element at index 10: {:?}", safe_get(&numbers, 10));
    
    // TODO: Exercise 3 - Error Messages
    // Write a function that validates a username
    // Rules: must be at least 3 characters, no spaces
    // Return Result<String, String> - Ok(username) if valid, Err(message) if invalid
    // Use expect() only for testing, not in production code
    
    fn validate_username(username: &str) -> Result<String, String> {
        // Your code here
        Err(String::from("Not implemented"))
    }
    
    println!("{:?}", validate_username("alice"));
    println!("{:?}", validate_username("ab"));  // Too short
    println!("{:?}", validate_username("al ice"));  // Has space
}

// Hints:
// 1. For safe_divide: check if b == 0, return None if so
// 2. For safe_get: use get() method on Vec
// 3. For validate_username: check length and use contains() for spaces

