fn main() {
    // Basic closure syntax
    let add_one = |x| x + 1;
    println!("5 + 1 = {}", add_one(5));
    
    // Closure with type annotations
    let add_two = |x: i32| -> i32 { x + 2 };
    println!("5 + 2 = {}", add_two(5));
    
    // Closure with multiple parameters
    let multiply = |x, y| x * y;
    println!("3 * 4 = {}", multiply(3, 4));
    
    // Closure with multiple statements
    let complex = |x| {
        let result = x * 2;
        result + 1
    };
    println!("Complex: {}", complex(5));
    
    // Closures can capture environment
    let x = 10;
    let add_x = |y| y + x;  // Captures x from environment
    println!("5 + 10 = {}", add_x(5));
    
    // Using closures with iterators
    let numbers = vec![1, 2, 3, 4, 5];
    
    let doubled: Vec<i32> = numbers.iter()
        .map(|x| x * 2)
        .collect();
    println!("Doubled: {:?}", doubled);
    
    let sum: i32 = numbers.iter()
        .filter(|x| *x % 2 == 0)
        .sum();
    println!("Sum of evens: {}", sum);
    
    // Closure as function parameter
    fn apply_operation<F>(x: i32, f: F) -> i32
    where
        F: Fn(i32) -> i32,
    {
        f(x)
    }
    
    let result = apply_operation(10, |x| x * 3);
    println!("Result: {}", result);
}

// Closures are anonymous functions
// Syntax: |params| expression or |params| { statements }
// Can capture variables from their environment
