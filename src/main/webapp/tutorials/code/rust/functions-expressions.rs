fn main() {
    // Statements don't return values
    let x = 5;  // This is a statement
    
    // Expressions return values
    let y = {
        let x = 3;
        x + 1  // No semicolon - this is an expression
    };
    println!("y = {}", y);  // Prints: y = 4
    
    // Function calls are expressions
    let sum = add(5, 3);
    println!("sum = {}", sum);
    
    // if is an expression
    let number = if true { 5 } else { 6 };
    println!("number = {}", number);
}

fn add(a: i32, b: i32) -> i32 {
    a + b  // Expression (no semicolon)
    // a + b; would be a statement and cause an error!
}
