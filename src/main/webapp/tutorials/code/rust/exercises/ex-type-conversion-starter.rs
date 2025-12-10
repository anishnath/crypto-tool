// Exercise: Type Conversion
// Fix the code to make it compile and run correctly

fn main() {
    // TODO: Convert this string to an integer safely
    let age_str = "25";
    let age: i32 = age_str; // Fix this line
    println!("Age: {}", age);
    
    // TODO: Convert this float to an integer (truncate decimal)
    let price: f64 = 19.99;
    let price_int = price; // Fix this line
    println!("Price (integer): {}", price_int);
    
    // TODO: Convert this large number to i8 safely (handle overflow)
    let big_number: i64 = 1000;
    let small_number: i8 = big_number; // Fix this line - should handle error
    println!("Converted: {}", small_number);
    
    // TODO: Parse this string and handle the error
    let input = "not a number";
    let parsed: i32 = input.parse(); // Fix this line - handle Result
    println!("Parsed: {}", parsed);
    
    // TODO: Convert char to its Unicode value
    let letter = 'Z';
    let unicode_value = letter; // Fix this line
    println!("Unicode value of '{}': {}", letter, unicode_value);
    
    // TODO: Create a String from this &str
    let str_slice = "Hello, Rust!";
    let owned_string = str_slice; // Fix this line
    println!("String: {}", owned_string);
    
    // TODO: Convert boolean to integer
    let is_active = true;
    let status_code = is_active; // Fix this line
    println!("Status code: {}", status_code);
}

// Hints:
// 1. Use .parse() for string to number conversion
// 2. Use 'as' keyword for primitive type casting
// 3. Use try_into() or TryFrom for safe conversions
// 4. Use match or unwrap_or() to handle Results
// 5. Use String::from() or .to_string() for &str to String
// 6. Remember: 'as' can truncate, TryFrom/TryInto is safer!
