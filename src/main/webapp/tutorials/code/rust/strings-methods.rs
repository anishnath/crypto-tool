fn main() {
    let mut text = String::from("Rust Programming");
    
    // String methods
    println!("Original: {}", text);
    println!("Length: {}", text.len());
    println!("Is empty: {}", text.is_empty());
    println!("Contains 'Rust': {}", text.contains("Rust"));
    
    // Modifying strings
    text.push('!'); // Add a character
    println!("After push: {}", text);
    
    text.push_str(" Language"); // Add a string slice
    println!("After push_str: {}", text);
    
    // String concatenation
    let hello = String::from("Hello");
    let world = String::from("World");
    let greeting = hello + " " + &world; // hello is moved here
    println!("Concatenated: {}", greeting);
    // println!("{}", hello); // Error: hello was moved
    
    // Using format! macro (doesn't take ownership)
    let s1 = String::from("tic");
    let s2 = String::from("tac");
    let s3 = String::from("toe");
    let combined = format!("{}-{}-{}", s1, s2, s3);
    println!("Formatted: {}", combined);
    println!("s1 still valid: {}", s1); // s1, s2, s3 still valid
    
    // String slicing (be careful with UTF-8!)
    let hello = "Hello, World!";
    let slice = &hello[0..5]; // "Hello"
    println!("Slice: {}", slice);
    
    // Iterating over strings
    println!("\nIterating by chars:");
    for c in "नमस्ते".chars() {
        print!("{} ", c);
    }
    println!();
    
    println!("\nIterating by bytes:");
    for b in "नमस्ते".bytes() {
        print!("{} ", b);
    }
    println!();
}
