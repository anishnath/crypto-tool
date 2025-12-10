fn main() {
    // Creating strings
    let mut s1 = String::new();
    let s2 = "initial contents".to_string();
    let s3 = String::from("initial contents");
    
    println!("s2: {}", s2);
    println!("s3: {}", s3);
    
    // Updating strings
    s1.push_str("hello");
    s1.push(' ');
    s1.push_str("world");
    println!("s1: {}", s1);
    
    // push - add single character
    let mut s = String::from("lo");
    s.push('l');
    println!("s: {}", s);
    
    // Concatenation with +
    let s4 = String::from("Hello, ");
    let s5 = String::from("world!");
    let s6 = s4 + &s5;  // s4 is moved, s5 is borrowed
    // println!("{}", s4);  // Error! s4 was moved
    println!("s6: {}", s6);
    
    // format! macro - doesn't take ownership
    let s7 = String::from("tic");
    let s8 = String::from("tac");
    let s9 = String::from("toe");
    let s10 = format!("{}-{}-{}", s7, s8, s9);
    println!("s10: {}", s10);
    println!("s7 still valid: {}", s7);  // s7 not moved!
    
    // String slicing
    let hello = String::from("Здравствуйте");
    let s = &hello[0..4];  // First 4 bytes
    println!("Slice: {}", s);
    
    // Iterating over strings
    println!("\nIterating by chars:");
    for c in "नमस्ते".chars() {
        println!("{}", c);
    }
    
    println!("\nIterating by bytes:");
    for b in "नमस्ते".bytes() {
        println!("{}", b);
    }
    
    // String methods
    let text = String::from("  hello world  ");
    println!("Original: '{}'", text);
    println!("Trimmed: '{}'", text.trim());
    println!("Uppercase: '{}'", text.to_uppercase());
    println!("Lowercase: '{}'", text.to_lowercase());
    println!("Contains 'world': {}", text.contains("world"));
    println!("Starts with 'hello': {}", text.trim().starts_with("hello"));
    
    // replace
    let replaced = text.replace("world", "Rust");
    println!("Replaced: '{}'", replaced);
}

// Key points:
// - String is UTF-8 encoded
// - Can't index strings directly
// - Use slices carefully with UTF-8
// - format! doesn't take ownership
