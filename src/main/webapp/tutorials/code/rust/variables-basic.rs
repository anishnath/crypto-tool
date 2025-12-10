fn main() {
    // Variables in Rust
    let x = 5;
    println!("The value of x is: {}", x);
    
    // Mutable variables
    let mut y = 10;
    println!("The value of y is: {}", y);
    y = 15;
    println!("Now y is: {}", y);
    
    // Constants
    const MAX_POINTS: u32 = 100_000;
    println!("Maximum points: {}", MAX_POINTS);
}
