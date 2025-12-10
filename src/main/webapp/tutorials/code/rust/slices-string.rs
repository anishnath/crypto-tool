fn main() {
    // String slices
    let s = String::from("hello world");
    
    // Create slices
    let hello = &s[0..5];   // "hello"
    let world = &s[6..11];  // "world"
    
    println!("First word: {}", hello);
    println!("Second word: {}", world);
    
    // Slice syntax shortcuts
    let s = String::from("hello");
    
    let slice1 = &s[0..2];  // "he"
    let slice2 = &s[..2];   // Same as above - start from beginning
    
    let len = s.len();
    let slice3 = &s[3..len];  // "lo"
    let slice4 = &s[3..];     // Same as above - go to end
    
    let slice5 = &s[0..len];  // "hello"
    let slice6 = &s[..];      // Same as above - entire string
    
    println!("{}, {}, {}, {}, {}, {}", slice1, slice2, slice3, slice4, slice5, slice6);
    
    // String literals are slices
    let s = "Hello, world!";  // Type is &str
    println!("String literal: {}", s);
    
    // Slices work with String and &str
    let my_string = String::from("hello world");
    let word = first_word(&my_string[..]);  // Works with String slice
    println!("First word: {}", word);
    
    let my_string_literal = "hello world";
    let word = first_word(my_string_literal);  // Works with &str
    println!("First word: {}", word);
}

fn first_word(s: &str) -> &str {
    let bytes = s.as_bytes();
    
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }
    
    &s[..]
}
