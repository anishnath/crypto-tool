fn main() {
    // Using From and Into traits for safe conversions
    
    // From trait - converting from one type to another
    let my_str = "Hello";
    let my_string = String::from(my_str);
    println!("&str to String: {}", my_string);
    
    // Into trait - the reverse of From
    let num: i32 = 42;
    let num_i64: i64 = num.into(); // i32 implements Into<i64>
    println!("i32 to i64 using into(): {} -> {}", num, num_i64);
    
    // Parsing strings to numbers
    let number_str = "42";
    let number: i32 = number_str.parse().expect("Not a number!");
    println!("String to i32: '{}' -> {}", number_str, number);
    
    // Using turbofish syntax for clarity
    let float_str = "3.14";
    let float_num = float_str.parse::<f64>().expect("Not a float!");
    println!("String to f64: '{}' -> {}", float_str, float_num);
    
    // Handling parse errors with Result
    let invalid = "not a number";
    match invalid.parse::<i32>() {
        Ok(n) => println!("Parsed: {}", n),
        Err(e) => println!("Parse error: {}", e),
    }
    
    // TryFrom and TryInto - for fallible conversions
    use std::convert::TryFrom;
    use std::convert::TryInto;
    
    // TryFrom - safe conversion that can fail
    let big_num: i64 = 1000;
    let small_num: Result<i8, _> = i8::try_from(big_num);
    match small_num {
        Ok(n) => println!("Converted: {}", n),
        Err(e) => println!("Conversion failed: {}", e),
    }
    
    // TryInto - the reverse of TryFrom
    let value: i32 = 100;
    let result: Result<i8, _> = value.try_into();
    match result {
        Ok(n) => println!("i32 to i8: {} -> {}", value, n),
        Err(e) => println!("Conversion failed: {}", e),
    }
    
    // Converting between number types safely
    let x: u32 = 42;
    let y: i32 = x.try_into().unwrap_or(-1);
    println!("u32 to i32: {} -> {}", x, y);
}
