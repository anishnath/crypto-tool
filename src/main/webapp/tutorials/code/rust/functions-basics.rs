fn main() {
    println!("Hello from main!");
    
    // Call a function
    greet();
    
    // Call function with parameters
    print_number(42);
    
    // Call function with multiple parameters
    print_sum(5, 3);
    
    // Call function that returns a value
    let result = add(10, 20);
    println!("10 + 20 = {}", result);
    
    // Use return value directly
    println!("5 + 7 = {}", add(5, 7));
}

// Function without parameters
fn greet() {
    println!("Hello, Rust!");
}

// Function with one parameter
fn print_number(x: i32) {
    println!("The number is: {}", x);
}

// Function with multiple parameters
fn print_sum(x: i32, y: i32) {
    println!("{} + {} = {}", x, y, x + y);
}

// Function with return value
fn add(x: i32, y: i32) -> i32 {
    x + y  // No semicolon - this is an expression
}
