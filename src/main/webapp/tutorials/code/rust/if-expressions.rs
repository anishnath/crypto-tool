fn main() {
    // if is an expression - it returns a value!
    let condition = true;
    let number = if condition { 5 } else { 6 };
    println!("The number is: {}", number);
    
    // Using if expression for assignment
    let temperature = 25;
    let weather = if temperature > 30 {
        "hot"
    } else if temperature > 20 {
        "warm"
    } else if temperature > 10 {
        "cool"
    } else {
        "cold"
    };
    println!("The weather is: {}", weather);
    
    // if expression in function return
    fn get_discount(is_member: bool) -> i32 {
        if is_member {
            20  // 20% discount
        } else {
            0   // No discount
        }
    }
    
    println!("Member discount: {}%", get_discount(true));
    println!("Non-member discount: {}%", get_discount(false));
    
    // Ternary-like usage
    let age = 17;
    let status = if age >= 18 { "adult" } else { "minor" };
    println!("Status: {}", status);
    
    // Both branches must return the same type!
    let score = 85;
    let result = if score >= 60 {
        "Pass"
    } else {
        "Fail"
        // "0"  // Error: expected &str, found integer
    };
    println!("Result: {}", result);
    
    // Using if expression in calculations
    let x = 10;
    let y = 20;
    let max = if x > y { x } else { y };
    println!("Max of {} and {}: {}", x, y, max);
    
    // Nested if expressions
    let num = 15;
    let description = if num > 0 {
        if num % 2 == 0 {
            "positive even"
        } else {
            "positive odd"
        }
    } else if num < 0 {
        "negative"
    } else {
        "zero"
    };
    println!("{} is {}", num, description);
}
