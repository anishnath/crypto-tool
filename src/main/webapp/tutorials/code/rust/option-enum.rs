fn main() {
    // Option<T> - represents a value that might be absent
    let some_number = Some(5);
    let some_string = Some("a string");
    let absent_number: Option<i32> = None;
    
    // Using Option with match
    let x = Some(5);
    let y = 10;
    
    match x {
        None => println!("x is None"),
        Some(i) => println!("x is {}", i),
    }
    
    // Option methods
    let value = Some(42);
    
    // unwrap_or - provide default
    let result = value.unwrap_or(0);
    println!("Result: {}", result);
    
    let none_value: Option<i32> = None;
    let result = none_value.unwrap_or(0);
    println!("Result with None: {}", result);
    
    // is_some and is_none
    if value.is_some() {
        println!("Value exists!");
    }
    
    if none_value.is_none() {
        println!("No value!");
    }
    
    // map - transform the value if it exists
    let doubled = value.map(|x| x * 2);
    println!("Doubled: {:?}", doubled);
    
    // and_then - chain operations
    let result = Some(4)
        .and_then(|x| Some(x * 2))
        .and_then(|x| Some(x + 1));
    println!("Chained: {:?}", result);
    
    // Practical example
    fn divide(numerator: f64, denominator: f64) -> Option<f64> {
        if denominator == 0.0 {
            None
        } else {
            Some(numerator / denominator)
        }
    }
    
    match divide(10.0, 2.0) {
        Some(result) => println!("Result: {}", result),
        None => println!("Cannot divide by zero!"),
    }
    
    match divide(10.0, 0.0) {
        Some(result) => println!("Result: {}", result),
        None => println!("Cannot divide by zero!"),
    }
}

// Option is defined as:
// enum Option<T> {
//     None,
//     Some(T),
// }
