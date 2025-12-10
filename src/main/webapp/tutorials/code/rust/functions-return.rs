fn main() {
    // Early return with return keyword
    let result = check_number(10);
    println!("Result: {}", result);
    
    // Implicit return (last expression)
    let doubled = double(5);
    println!("Doubled: {}", doubled);
}

// Early return example
fn check_number(n: i32) -> &'static str {
    if n < 0 {
        return "negative";  // Early return
    }
    
    if n == 0 {
        return "zero";
    }
    
    "positive"  // Implicit return
}

// Implicit return (most common in Rust)
fn double(x: i32) -> i32 {
    x * 2  // No semicolon - implicit return
}
