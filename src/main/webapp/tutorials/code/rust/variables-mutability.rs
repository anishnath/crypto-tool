fn main() {
    // Immutable variable (default)
    let x = 5;
    println!("The value of x is: {}", x);
    
    // This would cause an error:
    // x = 6;  // Error: cannot assign twice to immutable variable
    
    // Mutable variable
    let mut y = 10;
    println!("The value of y is: {}", y);
    
    y = 15;  // OK: y is mutable
    println!("Now y is: {}", y);
    
    // Constants
    const MAX_POINTS: u32 = 100_000;
    println!("Maximum points: {}", MAX_POINTS);
}
