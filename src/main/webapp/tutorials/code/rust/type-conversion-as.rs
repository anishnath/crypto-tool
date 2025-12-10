fn main() {
    // Using 'as' keyword for primitive type conversions
    
    // Integer to integer
    let x: i32 = 42;
    let y: i64 = x as i64;
    println!("i32 to i64: {} -> {}", x, y);
    
    // Larger to smaller (truncation)
    let large: i64 = 300;
    let small: i8 = large as i8; // Truncates! 300 doesn't fit in i8
    println!("i64 to i8: {} -> {} (truncated!)", large, small);
    
    // Float to integer (truncates decimal part)
    let pi: f64 = 3.14159;
    let pi_int: i32 = pi as i32;
    println!("f64 to i32: {} -> {} (decimal truncated)", pi, pi_int);
    
    // Integer to float
    let num: i32 = 42;
    let num_float: f64 = num as f64;
    println!("i32 to f64: {} -> {}", num, num_float);
    
    // Char to integer (gets Unicode code point)
    let letter: char = 'A';
    let code: u32 = letter as u32;
    println!("char to u32: '{}' -> {} (Unicode)", letter, code);
    
    // Integer to char (from Unicode code point)
    let emoji_code: u32 = 0x1F44B; // 👋
    let emoji: char = char::from_u32(emoji_code).unwrap();
    println!("u32 to char: {} -> '{}'", emoji_code, emoji);
    
    // Boolean to integer
    let flag: bool = true;
    let flag_num: i32 = flag as i32;
    println!("bool to i32: {} -> {}", flag, flag_num);
    
    // Warning: 'as' can be unsafe - it truncates without error!
    let value: u32 = 1000;
    let truncated: u8 = value as u8; // Silently truncates!
    println!("\nWarning - Silent truncation:");
    println!("u32 {} becomes u8 {} (mod 256)", value, truncated);
}
