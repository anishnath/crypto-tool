fn main() {
    // Destructuring tuples
    let point = (0, 5);
    
    match point {
        (0, 0) => println!("Origin"),
        (0, y) => println!("On Y-axis at y = {}", y),
        (x, 0) => println!("On X-axis at x = {}", x),
        (x, y) => println!("Point at ({}, {})", x, y),
    }
    
    // Matching with Option<T>
    let some_number = Some(5);
    
    match some_number {
        Some(n) => println!("Got a number: {}", n),
        None => println!("Got nothing"),
    }
    
    // Nested matching
    let pair = (Some(5), Some(10));
    
    match pair {
        (Some(x), Some(y)) => println!("Got {} and {}", x, y),
        (Some(x), None) => println!("Got {} and nothing", x),
        (None, Some(y)) => println!("Got nothing and {}", y),
        (None, None) => println!("Got nothing at all"),
    }
    
    // Match guards - additional conditions
    let number = 4;
    
    match number {
        n if n < 0 => println!("Negative: {}", n),
        n if n == 0 => println!("Zero"),
        n if n % 2 == 0 => println!("Positive even: {}", n),
        n => println!("Positive odd: {}", n),
    }
    
    // Combining patterns with guards
    let pair = (2, -5);
    
    match pair {
        (x, y) if x == y => println!("Equal"),
        (x, y) if x > y => println!("{} is greater", x),
        (x, y) if x < y => println!("{} is greater", y),
        _ => println!("Can't compare"),
    }
    
    // @ bindings - bind and test
    let age = 25;
    
    match age {
        n @ 0..=12 => println!("Child of age {}", n),
        n @ 13..=19 => println!("Teenager of age {}", n),
        n @ 20..=64 => println!("Adult of age {}", n),
        n @ 65.. => println!("Senior of age {}", n),
    }
    
    // Ignoring values with _
    let triple = (5, 10, 15);
    
    match triple {
        (first, _, third) => {
            println!("First: {}, Third: {}", first, third);
            // Second value is ignored
        }
    }
    
    // Ignoring remaining parts with ..
    let numbers = (1, 2, 3, 4, 5);
    
    match numbers {
        (first, .., last) => {
            println!("First: {}, Last: {}", first, last);
        }
    }
}
